using AutoMapper;
using WorkOutDTOs;
using WorkOutAPI.Model;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MyModel = WorkOutAPI.Model;

namespace WorkOutAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ExercisesController : ControllerBase
    {
        private readonly DBContext _context;
        private readonly IMapper _mapper;

        public ExercisesController(DBContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        // GET: api/Exercises
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Exercise_GridDTO>>> GetExercises()
        {
            if (_context.Exercises == null)
            {
                return NotFound();
            }
            var result = await _context.Exercises
                .Include(c => c.Category)
                .ToListAsync();

            var mapped = _mapper.Map<IEnumerable<Exercise_GridDTO>>(result);

            return Ok(mapped);
        }

        // GET: api/Exercises/5
        [HttpGet("{id}")]
        public async Task<ActionResult<IEnumerable<Exercise_GridDTO>>> GetExercises(int id)
        {
            if (_context.Exercises == null)
            {
                return NotFound();
            }
            var exercises = await _context.Exercises.FindAsync(id);

            if (exercises == null)
            {
                return NotFound();
            }
            await _context.Entry(exercises).Reference(c => c.Category).LoadAsync();

            var mapped = _mapper.Map<Exercise_GridDTO>(exercises);

            return Ok(mapped);
        }

        // PUT: api/Exercises/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<ActionResult> PutExercises(int id, Exercise_GridDTO dto)
        {
            if (id != dto.Id)
            {
                return BadRequest();
            }

            // Data validation

            if (string.IsNullOrWhiteSpace(dto.Name))
            {
                return BadRequest("Exercise name is required");
            }

            dto.Name.Trim();

            if (await _context.Exercises.AnyAsync(e => e.Name == dto.Name))
            {
                return BadRequest("Specified exercise name already exist");
            }

            if (dto.CategoryId >= 0)
            {
                if (!(await _context.Categories.AnyAsync(c => c.Id == dto.CategoryId)))
                {
                    return BadRequest("Specified category does not exist");
                }
            }

            var entity = _mapper.Map<MyModel.Exercis>(dto);

            _context.Entry(entity).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ExercisesExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/Exercises
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Exercise_GridDTO>> PostExercises(Exercise_GridDTO dto)
        {
            if (_context.Exercises == null)
            {
                return Problem("Entity set 'DBContext.Exercise'  is null.");
            }

            var entity = _mapper.Map<MyModel.Exercis>(dto);

            // Data validation

            if (string.IsNullOrWhiteSpace(dto.Name))
            {
                return BadRequest("Exercise name is required");
            }

            dto.Name.Trim();

            if (await _context.Exercises.AnyAsync(e => e.Name == dto.Name))
            {
                return BadRequest("Specified exercise name already exist");
            }

            if (!string.IsNullOrWhiteSpace(dto.NewCategory))
            {
                var newCat = new Category { Name = dto.NewCategory.Trim() };
                _context.Categories.Add(newCat);

                entity.Category = newCat;
            }
            else
            {
                if (dto.CategoryId == 0)
                {
                    return BadRequest("Exercise must belong to a category");
                }
                else
                {
                    if (!(await _context.Categories.AnyAsync(c => c.Id == dto.CategoryId)))
                    {
                        return BadRequest("Specified category does not exist");
                    }
                }
            }


            _context.Exercises.Add(entity);

            await _context.SaveChangesAsync();

            await _context.Entry(entity).Reference(c => c.Category).LoadAsync();

            var mapped = _mapper.Map<Exercise_GridDTO>(entity);

            return CreatedAtAction("GetExercises", new { id = mapped.Id }, mapped);
        }

        // DELETE: api/Exercises/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteExercises(int id)
        {
            if (_context.Exercises == null)
            {
                return NotFound();
            }
            var exercises = await _context.Exercises.FindAsync(id);
            if (exercises == null)
            {
                return NotFound();
            }

            _context.Exercises.Remove(exercises);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool ExercisesExists(int id)
        {
            return (_context.Exercises?.Any(e => e.Id == id)).GetValueOrDefault();
        }
    }
}

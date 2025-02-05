/*
 *  ---------------
 *  | Erik Cooper |
 *  ---------------
 */


// PARAMETERS ===============================================
// ----Program
final int FRAMERATE = 300;
// ----Color
final color BACKGROUND_COLOR = #FFFFFF; // [#RRGGBB]
final color FOREGROUND_COLOR = #000000; // [#RRGGBB]
final float BACKGROUND_OPACITY = 255; // [0f-255f]
final boolean COUNT_EMPHASIS = true;
final boolean NO_SMOOTH = false;
// ----Visualization
final int TYPE = 0; /*  0 => Prime index, normalized
                     *  1 => Prime, centered
                     *  2 => Prime
                     *  3 => Prime index
                     *  4 => Prime, normalized
                     *  5 => Count Graph
                     *  6 => Alt Count Graph
                     *  7 => Prime index, centered
                     */
final float GRAPH_Y_SCALE = 3f;
final int increment = 1;
// ----Termination
final int STOP_AND_SAVE = 4000;
// END PARAMETERS ===========================================

int[] Primes;
int n = 4;
int step = 0;
int previousCount = 0;


void setup()
{
  size(800, 800); //     <<================================= CHANGE FRAME SIZE HERE
  background(BACKGROUND_COLOR);
  frameRate(FRAMERATE);
  if (NO_SMOOTH) noSmooth();
  Primes = LoadPrimes("prime_numbers_to_10000000.csv");
}

void draw()
{
  loadPixels();
  for (int y = 0; y < height; y++) {
    for (int x = 1; x < width; x++) {
      int index = x + y * width;
      pixels[index - 1] = pixels[index];
    }
  }
  updatePixels();
  
  stroke(BACKGROUND_COLOR, BACKGROUND_OPACITY);
  line(width-1,0,width-1,height);
  
  int2[] addends = GetPrimeAddends(n);
  int nearestPrime = GetPrimeIndexBelow(n);
  
  if (COUNT_EMPHASIS)
  {
    stroke(FOREGROUND_COLOR, (PredictedSum(n) / addends.length) * 255f);
  }
  else
  {
    stroke(FOREGROUND_COLOR);
  }
  
  for (int i = 0; i < addends.length; i++)
  {
    int2 val = addends[i].MappedValues(Primes);
    
    switch (TYPE)
    {
      case 0:
        point(width - 1, (int)map(addends[i].x, 0, nearestPrime, 0, height));
        point(width - 1, (int)map(addends[i].y, 0, nearestPrime, 0, height));
        break;
      case 1:
        point(width - 1, height/2 + (n/2 - val.x));
        point(width - 1, height/2 + (n/2 - val.y));
        break;
      case 2:
        point(width - 1, val.x);
        point(width - 1, val.y);
        break;
      case 3:
        point(width - 1, addends[i].x);
        point(width - 1, addends[i].y);
        break;
      case 4:
        point(width - 1, map(val.x, 0, Primes[nearestPrime], 0, height));
        point(width - 1, map(val.y, 0, Primes[nearestPrime], 0, height));
        break;
      case 5:
        line(width - 1, height, width - 1, height - addends.length * GRAPH_Y_SCALE);
        previousCount = addends.length;
        break;
      case 6:
        int value = previousCount - addends.length;
        line(width - 1, height / 2, width - 1, height / 2 - value * GRAPH_Y_SCALE);
        previousCount = addends.length;
        break;
      case 7:
        point(width - 1, height/2 + (nearestPrime/2 - addends[i].x));
        point(width - 1, height/2 + (nearestPrime/2 - addends[i].y));
        break;
    }
  }
  
  n += 2 * increment;
  step++;
  
  if (STOP_AND_SAVE > 0)
  {
    if (step >= STOP_AND_SAVE)
    {
      noLoop();
      save("img2.png");
    }
  }
}

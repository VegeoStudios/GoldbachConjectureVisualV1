/*
 *  ---------------
 *  | Erik Cooper |
 *  ---------------
 */


import java.util.Arrays;

float PredictedSum(int num)
{
  return num / (2*(float)Math.log(num)*(float)Math.log(num));
}

public int[] LoadPrimes(String filePath) {
  ArrayList<Integer> primesList = new ArrayList<>();
  try (BufferedReader br = createReader(filePath)) {
    String line;
    while ((line = br.readLine()) != null) {
      primesList.add(Integer.parseInt(line.trim()));
    }
  } catch (IOException e) {
    e.printStackTrace();
  }
  
  return primesList.stream().mapToInt(i -> i).toArray();
}

public int GetPrimeIndexBelow(int n)
{
  int index = Arrays.binarySearch(Primes, n);
  
  if (index >= 0)
  {
    return index - 1 >= 0 ? index - 1 : -1;
  }
  else
  {
    int insertionPoint = -(index + 1);
    return insertionPoint - 1 >= 0 ? insertionPoint - 1 : -1;
  }
}

public int GetPrimeIndexAbove(int n)
{
  int index = Arrays.binarySearch(Primes, n);

  if (index >= 0)
  {
    return index + 1 < Primes.length ? index + 1 : -1;
  } else {
    int insertionPoint = -(index + 1);
    return insertionPoint < Primes.length ? insertionPoint : -1;
  }
}

public int2[] GetPrimeAddends(int n)
{
  ArrayList<int2> output = new ArrayList<int2>();
  int2 current = new int2(0, GetPrimeIndexBelow(n));
  while (current.x <= current.y)
  {
    if (Primes[current.x] + Primes[current.y] > n)
    {
      current.y--;
    }
    else if (Primes[current.x] + Primes[current.y] < n)
    {
      current.x++;
    }
    else
    {
      output.add(new int2(current));
      current.x++;
      current.y--;
    }
  }
  
  return output.toArray(new int2[0]);
}

public class int2
{
  public int x;
  public int y;
  
  public int2(int x, int y)
  {
    this.x = x;
    this.y = y;
  }
  
  public int2(int2 o)
  {
    this.x = o.x;
    this.y = o.y;
  }
  
  public int2 MappedValues(int[] arr) {
    return new int2(arr[x], arr[y]);
  }
  
  @Override
  public String toString()
  {
    return "(" + x + ", " + y + ")";
  }
}

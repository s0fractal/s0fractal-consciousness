
// 💎~crystal.ts - Crystal Mutator
// Structures chaotic data into a clear, crystalline form.

import { stringify } from "https://deno.land/std@0.208.0/yaml/mod.ts";

export const _💎 = (input: any) => {
  if (typeof input !== 'object' || input === null) {
    return { error: "Input must be an object." };
  }

  // A simple structuring logic: sort keys and convert to YAML
  const sortedInput = Object.keys(input).sort().reduce(
    (obj, key) => { 
      obj[key] = input[key]; 
      return obj;
    }, 
    {} as any
  );

  return stringify(sortedInput);
};

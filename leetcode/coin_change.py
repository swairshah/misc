from collections import defaultdict

def min_coins(cents):
    remaining = cents
    bank = [25, 10, 5]
    change = defaultdict(int)

    i = 0
    while remaining > 0 and i < len(bank):
        if remaining >= bank[i]:
            num = remaining // bank[i]
            change[bank[i]] += num
            remaining = remaining - num * bank[i]
        else:
            i += 1

    change[1] = remaining
    return sum(change.values())


# DP
def min_coins(cents):
    bank = [25, 10,1]
    mem = {i : 1 for i in bank}
    def helper(cents, mem={}):
        if cents <= 0:
            return 0
        elif cents < min(bank):
            raise Exception("Can't Change")
        elif cents in mem:
            return mem[cents]
        else:
            best = cents
            for coin in bank:
                if cents >= coin:
                    best = min(best, helper(cents - coin, mem) + 1)
            mem[cents] = best
            return best
    return helper(cents, mem)

# %%
# DP with opt
from itertools import combinations
import numpy as np
def min_coins(cents):
    bank = [25, 2, 4, 12, 51, 34, 36, 1]

    mem = {i : 1 for i in bank}

    # opts : all combinations of bank 
    for l in range(1, len(bank)):
        for comb in combinations(bank, l):
            mem[sum(comb)] = min(mem.get(sum(comb),10000), len(comb))

    def helper(cents, mem={}):
        if cents <= 0:
            return 0
        elif cents < min(bank):
            raise Exception("Can't Change")
        elif cents in mem:
            return mem[cents]
        else:
            best = cents
            for coin in bank:
                if cents >= coin:
                    best = min(best, helper(cents - coin, mem) + 1)
            mem[cents] = best
            return best
    return helper(cents, mem)


min_coins(310)

import itertools

# [1,2,3,4]
# for all combinations of [2,3,4] get them with 1 and without 1

def combinations(lst):
    if len(lst) == 0:
        return [[]]

    combs = []
    for c in combinations(lst[1:]):
        combs += [c, c+[lst[0]]]
    return combs

combinations([1,2,3,4])

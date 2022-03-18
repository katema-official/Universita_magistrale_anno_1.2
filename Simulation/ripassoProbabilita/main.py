import itertools

if __name__ == '__main__':
    print("----------------")
    S = list(itertools.permutations(range(5)))
    [print(s) for s in S]
    print("----------------")
    A = list(filter(lambda L: L.index(0) == 0, S))   #horse 0 arrives first
    [print(a) for a in A]
    print("----------------")
    B = list(filter(lambda L: L.index(1) < L.index(0), S)) #horse 1 arrives before horse 0
    AorB = list(set.union(set(A), set(B)))                #union
    [print(s) for s in AorB]
    print("----------------")
    AandB = list(set.intersection(set(A), set(B)))      #intersection
    [print(s) for s in AandB]
    print("----------------")
    notA = list(set.difference(set(S), set(A)))
    [print(s) for s in notA]
    print("----------------")
    print(len(A)/len(S))        #probability that an event will happen
    print("----------------")








import matplotlib.pyplot as plt

# Von Neumann (~ 1946)
def middle_square_generator(seed=1461, n=1):
    if (n == 1):
        return (seed)

    curr_val = seed
    v = []
    for i in range(n):
        v.append(curr_val)
        curr_val = (curr_val**2 % (10**6)) // 100

    return v



def congruential_generator(seed=1, a=7**5, c=0, m=(2**31 - 1), n=1):

    if n == 1: return seed
    curr_val = seed
    v = []
    for i in range(n):
        v.append(curr_val)
        curr_val = (a * curr_val + c) % m
    return v
#  Notes:
#  (a, c, m, seed)
#  GOOD:
#  (7^5, 0, (2^31 - 1), 1)
#  BAD:
#  seed = 623, a= 65, c=1, m=2048, n=1
#  (6, 1, 16, 0),
#  (65, 1, 2048, 0),
#  (1365, 1, 2048, 0),
#  (157, 1, 2048, 0),
#  (45, 0, 2048, 1),
#  (43, 0, 2048, 1))






def ripley_test(v):

    plt.scatter(v, v[1:len(v)] + [v[0]])#, "bo")
    plt.show()
    #plt.plot(v, v[1:len(v)] + [v[0]])#, type="p")


def empirical_cdf(v):
    return lambda y: sum(map(lambda x:  x <= y, v))/len(v)


def e_dist(x, y):
    return ((x**2 + y**2)**0.5);



def compute_pi(iter, s):

    # generate a pair of random coord in [-1,1]
    x = congruential_generator(seed=s, m=(2 ^ 31 - 1), n=iter);
    y = congruential_generator(seed=x[iter], m=(2 ^ 31 - 1), n=iter);
    # da provare!
    # t = congruential_generator(m=(2^31 - 1), n=iter);
    x = (2.0 / (2 ^ 31 - 1)) * x - 1.0;
    y = (2.0 / (2 ^ 31 - 1)) * y - 1.0;
    # compute distances from (0,0)
    q = x ^ 2 + y ^ 2;
    # count how many are <= 1
    #w = sapply(q, function(z)
    #return (z <= 1.0)});

    #return (4 * sum(w) / iter);
    #}

#res = c()
#for (i in 1:1000) res = c(res, compute_pi(1000, i))
#hist(res)
# question: what is the expected shape of the histogram?





if __name__ == "__main__":
    #Try to check:
    v1 = middle_square_generator(n=100)
    v2 = middle_square_generator(seed=1432, n=100)
    v3 = middle_square_generator(seed=10, n=100)
    v4 = middle_square_generator(seed=1001, n=100)  # not a coincidence!

    if False:
        print(v1)
        print(v2)
        print(v3)
        print(v4)
        ripley_test(v1)
        ripley_test(v2)
        ripley_test(v3)
        ripley_test(v4)

        p = list(range(100))
        plt.scatter(p, v1)
        plt.show()
        plt.scatter(p, v2)
        plt.show()
        plt.scatter(p, v3)
        plt.show()
        plt.scatter(p, v4)
        plt.show()




    # Try to check:
    s1 = congruential_generator(n=100)
    s2 = congruential_generator(seed=1432, n=1000)
    s3 = congruential_generator(seed=10, n=1000)
    s4 = congruential_generator(seed=1001, n=1000)  # not a coincidence!

    if True:
        print(s1)
        print(s2)
        print(s3)
        print(s4)
        ripley_test(s1)
        ripley_test(s2)
        ripley_test(s3)
        ripley_test(s4)

    p = list(range(100))
    q = list(range(1000))
    if False:
        plt.scatter(p, s1)
        plt.show()
        plt.scatter(q, s2)
        plt.show()
        plt.scatter(q, s3)
        plt.show()
        plt.scatter(q, s4)
        plt.show()


    dice = [1,2,3,4,5,6]

    for i in range(1,7):
        print(empirical_cdf(dice)(i))

    my_sequence = [1,20,3,22,5,0,7,2,9,4,11,6,13,8,15,10,17,12,19,14,21,16,23,18]
    ripley_test(my_sequence)

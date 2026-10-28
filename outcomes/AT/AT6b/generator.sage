load("outcomes/tbil/library.sage")
TBIL.config_matrix_typesetting()

class Generator(BaseGenerator):
    def data(self):
        # non-standard isomorphism with R^4: the middle standard entries go
        # first and last, and the first and last standard entries go in the
        # middle, each pair in random order
        outer = sample([1,2],2)
        inner = sample([0,3],2)
        order = [outer[0], inner[0], inner[1], outer[1]]
        polynomial = choice([True,False])
        x = var("x")
        def to_space(v):
            e = [0]*4
            for k in range(4):
                e[order[k]] = v[k]
            if polynomial:
                return sum(x^i*e[i] for i in range(4))
            return matrix(QQ,2,e)

        while True:
            number_of_pivots = choice([2,3])
            A = TBIL.simple_random_matrix_of_rank(number_of_pivots,rows=4,columns=4)
            pivots = list(A.pivots())
            coeffs = [randrange(1,5)*choice([-1,1]) for _ in pivots]
            w = sum(coeffs[i]*A.column(p) for i,p in enumerate(pivots))

            # conceptual error: applying the coefficients to the first set
            # vectors rather than the pivot columns (or swapping a pivot
            # column for a non-pivot column when these coincide)
            first = list(range(number_of_pivots))
            if pivots != first:
                incorrect_set = first
            else:
                non_pivots = [j for j in range(4) if j not in pivots]
                incorrect_set = list(pivots)
                incorrect_set[randrange(number_of_pivots)] = choice(non_pivots)
                incorrect_set.sort()
            # arithmetic slip: one coefficient off by one, kept nonzero
            off_by_one = list(coeffs)
            i = randrange(number_of_pivots)
            off_by_one[i] += choice([-1,1])
            if off_by_one[i] == 0:
                off_by_one[i] = 2*coeffs[i]

            # (coefficients, columns) pairs: the correct coefficients, all
            # signs flipped, and the arithmetic slip, each applied to both
            # the correct set and the incorrect set
            coefficient_lists = [coeffs, [-a for a in coeffs], off_by_one]
            pairs = [(cs, pivots) for cs in coefficient_lists] + \
                [(cs, incorrect_set) for cs in coefficient_lists]
            combos = [
                latex(TBIL.LinearCombination(
                    cs,
                    [to_space(A.column(p)) for p in ps],
                    parentheses=polynomial,
                ))
                for cs,ps in pairs
            ]
            sums = [sum(a*A.column(p) for a,p in zip(cs,ps)) for cs,ps in pairs]
            if len(set(combos)) == len(combos) and w not in sums[1:]:
                break

        choices = CheckIt.choices_from_list(
            [{"combo": c} for c in combos]
        )
        # flatten each item into its choice for simpler templating
        for ch in choices:
            ch.update(ch.pop("item"))

        result = {
            "set": TBIL.BracedSet([to_space(v) for v in A.columns()]),
            "choices": choices,
        }
        if polynomial:
            result["polynomial"] = to_space(w)
        else:
            result["matrix"] = to_space(w)
        return result

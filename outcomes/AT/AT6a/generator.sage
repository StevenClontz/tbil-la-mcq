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

        xs = [var("x_"+str(i+1)) for i in range(4)]
        def equation(vecs, target):
            return latex(TBIL.Equation(
                TBIL.LinearCombination(xs, [column_matrix(u) for u in vecs]),
                column_matrix(target),
            ))

        while True:
            number_of_pivots = choice([2,3])
            A = TBIL.simple_random_matrix_of_rank(number_of_pivots,rows=4,columns=4)
            pivots = A.pivots()
            coeffs = [randrange(1,5)*choice([-1,1]) for _ in pivots]
            # known solution to the correct system
            c = zero_vector(QQ,4)
            for i,p in enumerate(pivots):
                c[p] = coeffs[i]
            w = A*c

            # conceptual error: using a set vector as the target and the
            # target as a set vector
            j = randrange(4)
            swapped = list(A.columns())
            swapped[j] = w
            # arithmetic slip: sign flipped on one nonzero entry of the target
            w_slip = copy(w)
            k = choice([i for i in range(4) if w[i] != 0])
            w_slip[k] = -w_slip[k]

            # (vectors, target) pairs: correct, transposed system,
            # homogeneous system, roles swapped, and arithmetic slip
            pairs = [
                (A.columns(), w),
                (A.rows(), w),
                (A.columns(), zero_vector(QQ,4)),
                (swapped, A.column(j)),
                (A.columns(), w_slip),
            ]
            equations = [equation(*p) for p in pairs]
            # a distractor's system is equivalent to the correct one exactly
            # when the known solution solves it and the kernels agree
            def equivalent(vecs, target):
                M = column_matrix(vecs)
                return M*c == target and M.right_kernel() == A.right_kernel()
            if len(set(equations)) == len(equations) and \
                    not any(equivalent(*p) for p in pairs[1:]):
                break

        choices = CheckIt.choices_from_list(
            [{"equation": e} for e in equations]
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

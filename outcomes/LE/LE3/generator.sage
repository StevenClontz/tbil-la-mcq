load("outcomes/tbil/library.sage")
TBIL.config_matrix_typesetting()

class Generator(BaseGenerator):
    def data(self):
        # one solution
        # create a 3x3 invertible matrix
        A = CheckIt.simple_random_matrix_of_rank(3,rows=3,columns=3)
        # add linear combination of rows for fourth row
        combo = sum([randrange(1,4)*vector(r) for r in A.rows()])
        A = A.stack(matrix(QQ,1,combo))
        solution = column_matrix(
            vector(QQ, [randrange(1,4)*choice([-1,1]) for _ in range(3)])
        )
        constants = A*solution
        m = A.augment(constants, subdivide=True)
        if choice([True,False]):
            system_one = CheckIt.latex_system_from_matrix(m)
        else:
            system_one = TBIL.VectorEquation(m)

        # infinitely-many solutions
        # create a 3x3 non-invertible matrix
        A = CheckIt.simple_random_matrix_of_rank(2,rows=3,columns=3)
        # add linear combination of rows for fourth row
        combo = sum([randrange(1,4)*vector(r) for r in A.rows()])
        A = A.stack(matrix(QQ,1,combo))
        image_basis = [A.column(p) for p in A.pivots()]
        coeffs = [
            randrange(1,4)*choice([-1,1])
            for _ in range(2)
        ]
        lin_combo = column_matrix(sum([
            coeffs[p]*image_basis[p]
            for p in range(2)
        ]))
        m = A.augment(lin_combo, subdivide=True)
        if choice([True,False]):
            system_inf = CheckIt.latex_system_from_matrix(m)
        else:
            system_inf = TBIL.VectorEquation(m)

        # no solutions
        # create a 4x4 non-invertible matrix
        A = CheckIt.simple_random_matrix_of_rank(2,rows=3,columns=3)
        # add linear combination of rows for fourth row
        combo = sum([randrange(1,4)*vector(r) for r in A.rows()])
        A = A.stack(matrix(QQ,1,combo))
        image_basis = [A.column(p) for p in A.pivots()]
        coeffs = [
            randrange(1,4)*choice([-1,1])
            for _ in range(2)
        ]
        lin_combo = sum([
            coeffs[p]*image_basis[p]
            for p in range(2)
        ])
        non_lin_combo = lin_combo + vector(QQ, [
            choice([-1,1])
            for _ in range(4)
        ])
        while non_lin_combo in A.column_space():
            non_lin_combo += vector(QQ, [
                choice([-1,1])
                for _ in range(4)
            ])
        m = A.augment(column_matrix(non_lin_combo), subdivide=True)
        if choice([True,False]):
            system_none = CheckIt.latex_system_from_matrix(m)
        else:
            system_none = TBIL.VectorEquation(m)

        systems = [
            {"category": "one", "system": system_one},
            {"category": "inf", "system": system_inf},
            {"category": "none", "system": system_none},
        ]
        shuffle(systems)

        # decoy solution vector for wrong choices, distinct from the real one
        decoy_solution = column_matrix(
            vector(QQ, [randrange(1,4)*choice([-1,1]) for _ in range(3)])
        )
        while decoy_solution == solution:
            decoy_solution = column_matrix(
                vector(QQ, [randrange(1,4)*choice([-1,1]) for _ in range(3)])
            )

        # all 6 ways to assign one/inf/none to System 1/2/3
        labels = ["one", "inf", "none"]
        all_perms = [
            (labels[i], labels[j], labels[k])
            for i in range(3) for j in range(3) for k in range(3)
            if i != j and i != k and j != k
        ]
        true_assignment = tuple(s["category"] for s in systems)
        wrong_perms = [p for p in all_perms if p != true_assignment]

        # three of the five wrong choices get the decoy solution vector instead
        # of the real one; the other two keep the real vector
        decoy_indices = set(sample(range(5), 3))

        def describe(perm, vec_for_one):
            lines = []
            for i in range(3):
                cat = perm[i]
                if cat == "one":
                    lines.append(
                        r"\text{System " + str(i+1) + r" has one solution: }"
                        + r"\left\{" + latex(vec_for_one) + r"\right\}"
                    )
                elif cat == "inf":
                    lines.append(
                        r"\text{System " + str(i+1) + r" has infinitely-many solutions.}"
                    )
                else:
                    lines.append(
                        r"\text{System " + str(i+1) + r" has no solutions.}"
                    )
            return r"\begin{array}{l}" + r" \\ ".join(lines) + r"\end{array}"

        choices = [describe(true_assignment, solution)] + [
            describe(perm, decoy_solution if i in decoy_indices else solution)
            for i, perm in enumerate(wrong_perms)
        ]

        return {
            "system1": systems[0]["system"],
            "system2": systems[1]["system"],
            "system3": systems[2]["system"],
            "choices": CheckIt.choices_from_list(choices),
        }

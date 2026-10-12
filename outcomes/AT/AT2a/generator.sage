load("outcomes/tbil/library.sage")
TBIL.config_matrix_typesetting()

class Generator(BaseGenerator):
    def data(self):
        # T:R^2->R^4, T:R^3->R^3, or T:R^4->R^2, given by a formula
        n, m = choice([(2,4),(3,3),(4,2)])

        # standard matrix with nonzero entries except one, and distinct columns
        while True:
            entries = [randrange(1,7)*choice([-1,1]) for _ in range(m*n)]
            entries[randrange(m*n)] = 0
            A = matrix(QQ,m,entries)
            if len(set(tuple(c) for c in A.columns())) == n:
                break

        # construct variables
        xs=choice([
            column_matrix(vector([var("x_"+str(i+1)) for i in range(0,n)])),
            column_matrix(vector([var("x"),var("y"),var("z"),var("zw",latex_name="w")][0:n])),
        ])

        # ask for a random column, i.e. T of a random standard basis vector
        j = randrange(n)
        correct = A.column(j)

        # conceptual errors: the wrong variable's coefficients, plugging in 1
        # for every variable, and reading the j-th component (when sizes match)
        conceptual = [A.column(k) for k in range(n) if k != j]
        conceptual.append(A*vector([1]*n))
        if m == n:
            conceptual.append(A.row(j))
        shuffle(conceptual)
        # sign slips in the correct column, used only to fill remaining choices
        slips = []
        for i in range(m):
            if correct[i] != 0:
                v = copy(correct)
                v[i] = -v[i]
                slips.append(v)
        shuffle(slips)
        distractors = []
        for v in conceptual + slips:
            if v != correct and v not in distractors:
                distractors.append(v)
        distractors = distractors[:3]

        choices = CheckIt.choices_from_list(
            [column_matrix(correct)] + [column_matrix(v) for v in distractors]
        )

        return {
            "n": n,
            "m": m,
            "varvector": xs,
            "varmap": A*xs,
            "ordinal": ["first","second","third","fourth"][j],
            "choices": choices,
        }

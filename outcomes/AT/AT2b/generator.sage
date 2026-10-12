load("outcomes/tbil/library.sage")
TBIL.config_matrix_typesetting()

class Generator(BaseGenerator):
    def data(self):
        # T:R^2->R^4, T:R^3->R^3, or T:R^4->R^2, given by its standard matrix
        n, m = choice([(2,4),(3,3),(4,2)])

        entries = [randrange(1,7)*choice([-1,1]) for _ in range(m*n)]
        entries[randrange(m*n)] = 0
        B = matrix(QQ,m,entries)

        # give vector to transform
        entries = [randrange(1,7)*choice([-1,1]) for _ in range(n)]
        if n > 2:
            entries[randrange(n)] = 0
        v = vector(QQ,entries)
        correct = B*v

        # conceptual errors: coefficients matched to the wrong columns, ignoring
        # the coefficients, a sign slip in a coefficient, and using rows instead
        # of columns (when sizes match)
        conceptual = [B*vector(list(v)[::-1]), B*vector([1]*n)]
        i = choice([i for i in range(n) if v[i] != 0])
        w = copy(v)
        w[i] = -w[i]
        conceptual.append(B*w)
        if m == n:
            conceptual.append(B.transpose()*v)
        shuffle(conceptual)
        # sign slips in the correct answer, used only to fill remaining choices
        slips = []
        for i in range(m):
            if correct[i] != 0:
                u = copy(correct)
                u[i] = -u[i]
                slips.append(u)
        shuffle(slips)
        distractors = []
        for u in conceptual + slips:
            if u != correct and u not in distractors:
                distractors.append(u)
        distractors = distractors[:3]

        choices = CheckIt.choices_from_list(
            [column_matrix(correct)] + [column_matrix(u) for u in distractors]
        )

        return {
            "n": n,
            "m": m,
            "matrix": B,
            "vector": column_matrix(v),
            "choices": choices,
        }

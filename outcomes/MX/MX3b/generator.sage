load("outcomes/tbil/library.sage")
TBIL.config_matrix_typesetting()

class Generator(BaseGenerator):
    def data(self):
        # coefficients between -9 and 9 with at most one zero
        while True:
            coeffs = [randrange(-9,10) for _ in range(3)]
            if coeffs.count(0) <= 1:
                break

        # 3x3 invertible matrix whose columns form the basis
        A = TBIL.simple_random_matrix_of_rank(3,rows=3,columns=3)
        v = A*vector(QQ, coeffs)

        # basis vector whose coefficient is asked for
        i = randrange(3)

        # correct coefficient, then three distinct random distractors
        lst = [coeffs[i]] + sample([x for x in range(-9,10) if x != coeffs[i]], 3)
        choices = CheckIt.choices_from_list([{"value": x} for x in lst])
        # flatten each item into its choice for simpler templating
        for c in choices:
            c.update(c.pop("item"))

        return {
            "v": column_matrix(v),
            "b_1": column_matrix(A.column(0)),
            "b_2": column_matrix(A.column(1)),
            "b_3": column_matrix(A.column(2)),
            "i": i+1,
            "choices": choices,
        }

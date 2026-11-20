load("outcomes/tbil/library.sage")
TBIL.config_matrix_typesetting()

class Generator(BaseGenerator):
    def data(self):
        while True:
            # three distinct small nonzero integer eigenvalues
            eigenvalues = sample([n for n in range(-5,6) if n != 0],3)
            # unimodular so that A has integer entries
            S = random_matrix(ZZ,3,3,algorithm='unimodular')
            A = S*diagonal_matrix(eigenvalues)*S.inverse()
            # to get roughly consistent difficulty
            if all(abs(a)<=20 for a in A.list()) and A.list().count(0)<=1:
                break

        # the columns of S are eigenvectors of A
        i = randrange(3)
        eigenvector = column_matrix(S.column(i))

        # the eigenvalue, plus random distractors
        candidates = [n for n in range(-7,8) if n not in [0,eigenvalues[i]]]
        values = [eigenvalues[i]] + sample(candidates,3)

        choices = CheckIt.choices_from_list([{"value": v} for v in values])
        # flatten each item into its choice for simpler templating
        for c in choices:
            c.update(c.pop("item"))

        return {
            "matrix": A,
            "eigenvector": eigenvector,
            "choices": choices,
        }

load("outcomes/tbil/library.sage")
TBIL.config_matrix_typesetting()

class Generator(BaseGenerator):
    def data(self):
        l = choice([-1,1])*randrange(2,6)
        dim = choice([2,3])
        A=TBIL.simple_random_matrix_of_rank(4-dim,rows=4,columns=4)
        B = A+l*identity_matrix(4)

        #Find kernel basis
        v = A.right_kernel(basis='pivot').basis()

        if dim == 2:
            s, d = v[0]+v[1], v[0]-v[1]
            sets = [
                [v[0], v[1]],
                # sum and its negative
                [s, -s],
                # sum and difference, plus an original
                [s, d, choice(v)],
                # both originals, plus the sum or difference
                [v[0], v[1], choice([s,d])],
            ]
        else:
            i, j = sample(range(3),2)
            sets = [
                list(v),
                # sum and difference of two vectors, plus one of those vectors
                [v[i]+v[j], v[i]-v[j], choice([v[i],v[j]])],
            ]
            # one vector and one combination of the other two (one short)
            for i in sample(range(3),2):
                j, k = [n for n in range(3) if n != i]
                sets.append([v[i], v[j]+choice([-1,1])*v[k]])

        # don't let vector order give away the answer
        for vecs in sets:
            shuffle(vecs)

        choices = CheckIt.choices_from_list([
            {"basis": TBIL.VectorSet(vecs)} for vecs in sets
        ])
        # flatten each item into its choice for simpler templating
        for c in choices:
            c.update(c.pop("item"))

        return {
            "matrix": B,
            "eigenvalue": l,
            "choices": choices,
        }

load("outcomes/tbil/library.sage")
TBIL.config_matrix_typesetting()

class Generator(BaseGenerator):
    def data(self):
        # T:R^4->R^5 or T:R^5->R^4, with rank != nullity
        n = choice([4,5])
        m = 9-n
        if n == 4:
            rank = choice([1,3])
        else:
            rank = choice([2,3])
        nullity = n-rank
        A = TBIL.simple_random_matrix_of_rank(rank,rows=m,columns=n)

        # bases for the kernel (in R^n) and image (in R^m), in random order
        kernel_basis = TBIL.VectorSet(A.right_kernel(basis='pivot').basis())
        image_basis = TBIL.VectorSet([A.column(j) for j in A.pivots()])
        if choice([True,False]):
            S1, S2 = kernel_basis, image_basis
            ker, im = "S_1", "S_2"
        else:
            S1, S2 = image_basis, kernel_basis
            ker, im = "S_2", "S_1"

        # conceptual errors: mixing up the kernel and image, and comparing
        # rank+nullity with the dimension of the codomain rather than the domain
        def choice_data(swapped, codomain):
            return {
                "ker": im if swapped else ker,
                "im": ker if swapped else im,
                "rank": nullity if swapped else rank,
                "nullity": rank if swapped else nullity,
                "dim": m if codomain else n,
                "equal": not codomain,
            }
        lst = [choice_data(s,c) for s,c in
            [(False,False),(True,False),(False,True),(True,True)]]
        choices = CheckIt.choices_from_list(lst)
        # flatten each item into its choice for simpler templating
        for c in choices:
            c.update(c.pop("item"))

        xs = column_matrix(vector([var("x_"+str(i+1)) for i in range(n)]))

        return {
            "n": n,
            "m": m,
            "varvector": xs,
            "varmap": A*xs,
            "S1": S1,
            "S2": S2,
            "choices": choices,
        }

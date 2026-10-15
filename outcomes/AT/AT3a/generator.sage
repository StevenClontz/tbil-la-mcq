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

        while True:
            A = TBIL.simple_random_matrix_of_rank(rank,rows=m,columns=n)
            R = A.rref()
            pivots = A.pivots()
            free = [j for j in range(n) if j not in pivots]

            # bases for the kernel (in R^n) and image (in R^m)
            kernel_basis = A.right_kernel(basis='pivot').basis()
            image_basis = [A.column(j) for j in pivots]

            # conceptual errors: forgetting to negate the RREF entries when
            # solving for the pivot variables, and using the pivot columns of
            # the RREF rather than of the original matrix
            sign_slip_basis = []
            for j in free:
                v = zero_vector(QQ,n)
                v[j] = 1
                for i,p in enumerate(pivots):
                    v[p] = R[i,j]
                sign_slip_basis.append(v)
            rref_basis = [R.column(j) for j in pivots]

            # arithmetic slips: the correct bases with every entry offset by +-1
            def perturb(basis):
                return [vector(QQ,[x+choice([-1,1]) for x in v]) for v in basis]
            kernel_offset_basis = perturb(kernel_basis)
            image_offset_basis = perturb(image_basis)

            items = [latex(TBIL.VectorSet(b)) for b in
                [kernel_basis, image_basis, sign_slip_basis, rref_basis,
                 kernel_offset_basis, image_offset_basis]]
            if len(set(items)) == len(items):
                break

        # AT3a and AT3b share this generator (and thus these choices),
        # differing only in which item is correct
        order = list(range(len(items)))
        shuffle(order)
        def choices(correct):
            return [
                {"item": items[k], "correct": k == correct, "letter": chr(ord('a')+i)}
                for i,k in enumerate(order)
            ]

        xs = column_matrix(vector([var("x_"+str(i+1)) for i in range(n)]))

        return {
            "n": n,
            "m": m,
            "varvector": xs,
            "varmap": A*xs,
            "kernel_choices": choices(0),
            "image_choices": choices(1),
        }

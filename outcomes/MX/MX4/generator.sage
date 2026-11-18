load("outcomes/tbil/library.sage")
TBIL.config_matrix_typesetting()

class Generator(BaseGenerator):
    def data(self):
        def factor():
            return randrange(2,6)*choice([-1,1])

        # regenerate until only the correct product gives the result
        while True:
            rows = sample(range(3),3)
            # two different factors, so swapping them changes the matrices
            k_replace = factor()
            k_scale = factor()
            if k_replace == k_scale:
                continue

            def ops(k_rep, k_sc):
                # (row operation, elementary matrix) for a swap, a row
                # replacement, and a scaling
                return [
                    (TBIL.RowOp("permutation",rows[0]+1,rows[1]+1),
                        identity_matrix(3).with_swapped_rows(rows[0],rows[1])),
                    (TBIL.RowOp("elementary",rows[1]+1,rows[2]+1,k_rep),
                        identity_matrix(3).with_added_multiple_of_row(rows[1],rows[2],k_rep)),
                    (TBIL.RowOp("diagonal",rows[0]+1,rows[0]+1,k_sc),
                        identity_matrix(3).with_rescaled_row(rows[0],k_sc)),
                ]
            # order in which the operations are applied
            order = sample(range(3),3)
            correct_ops = [ops(k_replace,k_scale)[i] for i in order]
            # wrong matrices: the replacement uses the scaling factor and
            # the scaling uses the replacement factor
            swapped_ops = [ops(k_scale,k_replace)[i] for i in order]
            E = [M for _,M in correct_ops]
            F = [M for _,M in swapped_ops]

            A = TBIL.simple_random_matrix_of_rank(3,rows=3,columns=3)

            # lists of matrices multiplied left-to-right, then by A: correct
            # (last operation leftmost), wrong order, and the same two with
            # the factors swapped
            products = [
                [E[2],E[1],E[0]],
                [E[0],E[1],E[2]],
                [F[2],F[1],F[0]],
                [F[0],F[1],F[2]],
            ]
            values = [prod(Ms)*A for Ms in products]
            if all(val != values[0] for val in values[1:]):
                break

        choices = CheckIt.choices_from_list([
            {"product": LatexExpr("".join(latex(M) for M in Ms)+latex(A))}
            for Ms in products
        ])
        # flatten each item into its choice for simpler templating
        for c in choices:
            c.update(c.pop("item"))

        return {
            "A": A,
            "first_op": correct_ops[0][0],
            "second_op": correct_ops[1][0],
            "third_op": correct_ops[2][0],
            "choices": choices,
        }

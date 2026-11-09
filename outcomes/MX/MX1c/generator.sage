load("outcomes/tbil/library.sage")
TBIL.config_matrix_typesetting()

class Generator(BaseGenerator):
    def data(self):
        # shuffle 2,3,4 to get dimensions
        dims = [2,3,4]
        shuffle(dims)

        # create matrices; only L*R is defined
        L = TBIL.simple_random_matrix_of_rank(min(dims[0],dims[1]),rows=dims[0],columns=dims[1])
        R = TBIL.simple_random_matrix_of_rank(min(dims[1],dims[2]),rows=dims[1],columns=dims[2])
        N = TBIL.simple_random_matrix_of_rank(min(dims[0],dims[2]),rows=dims[0],columns=dims[2])
        matrices = [L,R,N]
        shuffle(matrices)

        product = L*R

        # arithmetic slips: shift every entry by a nonzero amount, also transpose
        shifted = matrix(QQ,product.nrows(),product.ncols(),
            lambda i,j: product[i,j]+choice([-3,-2,-1,1,2,3])).transpose()

        # ordering slip: swap two rows and two columns
        while True:
            swapped = copy(product)
            swapped.swap_rows(*sample(range(swapped.nrows()),2))
            swapped.swap_columns(*sample(range(swapped.ncols()),2))
            if swapped != product:
                break

        choices = CheckIt.choices_from_list([
            {"product": product},
            {"product": product.transpose()},
            {"product": shifted},
            {"product": swapped},
        ])
        # flatten each item into its choice for simpler templating
        for c in choices:
            c.update(c.pop("item"))

        return {
            "A": matrices[0],
            "B": matrices[1],
            "C": matrices[2],
            "choices": choices,
        }

load("outcomes/tbil/library.sage")
TBIL.config_matrix_typesetting()

class Generator(BaseGenerator):
    def data(self):
        # create a homogeneous 4x5 system with 3, 2, or 1 free variables
        rows = 4
        columns = 5
        ranks = [2, 3, 4]

        def random_homogeneous_matrix(rank):
            A = TBIL.simple_random_matrix_of_rank(rank,rows=rows,columns=columns)
            return A.augment(zero_vector(QQ, rows), subdivide=True)

        def basis_latex(m):
            basis = m.subdivision(0,0).right_kernel(basis='pivot').basis()
            return latex(TBIL.VectorSet(basis))

        # correct system: solution space has dimension (columns - correct_rank)
        correct_rank = choice(ranks)
        m = random_homogeneous_matrix(correct_rank)
        correct_basis = basis_latex(m)

        if choice([True,False]):
            system_label = "system"
            system = CheckIt.latex_system_from_matrix(m)
        else:
            system_label = "vec_eq"
            system = TBIL.VectorEquation(m)

        # distractor with the same number of basis vectors as the correct answer
        same_size_basis = correct_basis
        while same_size_basis == correct_basis:
            same_size_basis = basis_latex(random_homogeneous_matrix(correct_rank))

        # two distractors sharing a different, but still positive, number of
        # basis vectors
        wrong_rank = choice([r for r in ranks if r != correct_rank])
        wrong_size_basis_1 = basis_latex(random_homogeneous_matrix(wrong_rank))
        wrong_size_basis_2 = wrong_size_basis_1
        while wrong_size_basis_2 == wrong_size_basis_1:
            wrong_size_basis_2 = basis_latex(random_homogeneous_matrix(wrong_rank))

        choices = CheckIt.choices_from_list([
            correct_basis,
            same_size_basis,
            wrong_size_basis_1,
            wrong_size_basis_2,
        ])

        return {
            system_label: system,
            "choices": choices,
        }

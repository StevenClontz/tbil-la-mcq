load("outcomes/tbil/library.sage")
TBIL.config_matrix_typesetting()

class Generator(BaseGenerator):
    def data(self):

        # create a 3x5 or 4x4 matrix
        rows = randrange(3,5)
        columns = 8-rows

        # construct variables
        xs=[var("x_"+str(i+1)) for i in range(0,columns)]

        #start with nice RREF
        max_number_of_pivots = min(rows,columns-1)
        number_of_pivots = randrange(2,max_number_of_pivots+1)
        A = CheckIt.simple_random_matrix_of_rank(number_of_pivots,rows=rows,columns=columns)
        B = A.transpose()

        incorrect_systems = [
            TBIL.VectorEquation(A),
            TBIL.VectorEquation(B)
        ]

        A.subdivide([],[columns-1])
        B.subdivide([],[rows-1])
        choices = [
            TBIL.VectorEquation(A),
            TBIL.VectorEquation(B)
        ] + incorrect_systems


        return {
            "system": CheckIt.latex_system_from_matrix(A,variable_list=xs),
            "choices": CheckIt.choices_from_list(choices),
        }

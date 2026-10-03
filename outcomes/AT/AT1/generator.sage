load("outcomes/tbil/library.sage")
TBIL.config_matrix_typesetting()

class Generator(BaseGenerator):
    def data(self):
        x,y,z = var("x y z")
        v = column_matrix([x,y,z])

        # make a linear map
        A = TBIL.simple_random_matrix_of_rank(3,rows=3,columns=3)
        Pmap = A*v

        # make a nonlinear map
        B = TBIL.simple_random_matrix_of_rank(2,rows=2,columns=3)
        insert_at = choice(range(3))
        preQmap = B*v
        terms = [x,y,z]
        shuffle(terms)
        Qmap = matrix(preQmap.rows()[:insert_at]+ \
            [(randrange(2,10)*choice([-1,1])*terms[0]*terms[1]+\
            randrange(2,10)*choice([-1,1])*terms[2]^2,)] + \
            preQmap.rows()[insert_at:])

        # choose which is linear randomly
        if choice([True,False]):
            Pmap, Qmap = Qmap, Pmap


        return {
            "Pmap": Pmap,
            "Qmap": Qmap,
        }

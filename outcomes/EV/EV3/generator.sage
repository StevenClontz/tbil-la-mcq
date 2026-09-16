load("outcomes/tbil/library.sage")
TBIL.config_matrix_typesetting()

class Generator(BaseGenerator):
    def data(self):
        x,y,z,w,a,b,c,k = var("x y z w a b c k")

        coeffs = [
            choice([-1,1])*randrange(1,6),
            choice([-1,1])*randrange(1,6),
            choice([-1,1])*randrange(1,6)
        ]
        terms = [coeffs[i]*[x,y,z,w][i] for i in range(3)]
        bad_i = randrange(3)
        if choice([True,False]):
            # squared term
            terms[bad_i] = coeffs[bad_i]*[x,y,z,w][bad_i]^2
            Q_valid = [0,0,0]
            Q_valid[bad_i] = coeffs[(bad_i+1)%3]
            Q_valid[(bad_i+1)%3] = -coeffs[bad_i]*coeffs[(bad_i+1)%3]
            Q_invalid = [2*t for t in Q_valid]
        else:
            # product of terms
            terms[bad_i] = coeffs[bad_i]*[x,y,z,w][bad_i]*[x,y,z,w][(bad_i+1)%3]
            Q_valid = [0,0,0]
            Q_valid[bad_i] = -coeffs[(bad_i+1)%3]/coeffs[bad_i]
            Q_valid[(bad_i+1)%3] = 1
            Q_invalid = [2*t for t in Q_valid]
        Q_eq = CheckIt.shuffled_equation(*terms)

        coeffs = [
            choice([-1,1])*randrange(1,6),
            choice([-1,1])*randrange(1,6),
            choice([-1,1])*randrange(1,6)
        ]
        terms = [coeffs[i]*[x,y,z,w][i] for i in range(3)]
        R_eq = CheckIt.shuffled_equation(*terms)

        Q_eq, R_eq = sample([Q_eq,R_eq],2)


        return {
            "R_eq": R_eq,
            "Q_eq": Q_eq,
        }

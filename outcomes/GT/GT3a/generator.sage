load("outcomes/tbil/library.sage")
TBIL.config_matrix_typesetting()

class Generator(BaseGenerator):
    def data(self):
        while True:
            # eigenvalues will be two distinct small integers with
            # different absolute values
            l1,l2 = sample(range(2,6),2)
            l1,l2 = l1*choice([-1,1]),l2*choice([-1,1])
            S=random_matrix(QQ, 2, 2, algorithm='echelonizable', rank=2, upper_bound=6)
            A=S.inverse()*matrix([[l1,1],[0,l2]])*S
            # to get roughly consistent difficulty
            if all(5<abs(a)<=20 for a in A.list()):
                break

        # one eigenvalue, plus random distractors that are not eigenvalues
        candidates = [n for n in range(-7,8) if n not in [0,l1,l2]]
        values = [choice([l1,l2])] + sample(candidates,3)

        choices = CheckIt.choices_from_list([{"value": v} for v in values])
        # flatten each item into its choice for simpler templating
        for c in choices:
            c.update(c.pop("item"))

        return {
            "matrix": A,
            "choices": choices,
        }

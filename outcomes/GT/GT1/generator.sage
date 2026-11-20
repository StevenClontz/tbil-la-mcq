load("outcomes/tbil/library.sage")
TBIL.config_matrix_typesetting()

class Generator(BaseGenerator):
    def data(self):
        # regenerate until all four choices and operations are distinct
        while True:
            det = randrange(2,8)*choice([-1,1])

            # at least one of each type, plus one more of any type,
            # applied in a random order
            types = ["swap","scale","combo",choice(["swap","scale","combo"])]
            shuffle(types)

            # scale and combination factors all differ from each other
            factors = [
                k*choice([-1,1])
                for k in sample(range(2,6),len([t for t in types if t!="swap"]))
            ]

            ops = []
            scale_prod = 1
            combo_prod = 1
            swaps = 0
            for t in types:
                if t == "swap":
                    rows = sample(range(1,5),2)
                    ops.append(TBIL.RowOp("permutation",rows[0],rows[1]))
                    swaps += 1
                elif t == "scale":
                    k = factors.pop()
                    row = randrange(1,5)
                    ops.append(TBIL.RowOp("diagonal",row,row,k))
                    scale_prod *= k
                else:
                    k = factors.pop()
                    rows = sample(range(1,5),2)
                    ops.append(TBIL.RowOp("elementary",rows[0],rows[1],k))
                    combo_prod *= k

            sign = (-1)^swaps
            correct = det*scale_prod*sign
            # multiplying by every factor, including combinations
            every_factor = correct*combo_prod
            values = [
                correct,
                # sign wrong
                -correct,
                every_factor,
                # both mistakes
                -every_factor,
            ]
            # no repeated row operations (e.g. a swap undoing itself)
            op_strings = [latex(op) for op in ops]
            if len(set(values)) == len(values) and \
                len(set(op_strings)) == len(op_strings):
                break

        choices = CheckIt.choices_from_list([{"value": v} for v in values])
        # flatten each item into its choice for simpler templating
        for c in choices:
            c.update(c.pop("item"))

        return {
            "determinant": det,
            "first_op": ops[0],
            "second_op": ops[1],
            "third_op": ops[2],
            "fourth_op": ops[3],
            "choices": choices,
        }

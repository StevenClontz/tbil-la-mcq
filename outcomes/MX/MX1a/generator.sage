load("outcomes/tbil/library.sage")
TBIL.config_matrix_typesetting()

class Generator(BaseGenerator):
    def data(self):
        # shuffle 2,3,4 to get dimensions
        dims = list(range(2,10))
        dims = sample(dims,3)

        # sizes of three matrices; only L*R is defined
        sizes = {
            "L": (dims[0],dims[1]),
            "R": (dims[1],dims[2]),
            "N": (dims[0],dims[2]),
        }
        roles = ["L","R","N"]
        shuffle(roles)
        letters = ["A","B","C"]
        name = {role: letters[i] for i,role in enumerate(roles)}

        # correct product, its reversal (order error), and two of the
        # other four (also undefined) products
        others = [("L","N"),("N","L"),("R","N"),("N","R")]
        shuffle(others)
        pairs = [("L","R"),("R","L")] + others[:2]
        choices = CheckIt.choices_from_list(
            [{"product": name[x]+name[y]} for x,y in pairs]
        )
        # flatten each item into its choice for simpler templating
        for c in choices:
            c.update(c.pop("item"))

        return {
            "sizeA": r"%s\times %s"%sizes[roles[0]],
            "sizeB": r"%s\times %s"%sizes[roles[1]],
            "sizeC": r"%s\times %s"%sizes[roles[2]],
            "choices": choices,
        }

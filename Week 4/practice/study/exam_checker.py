import numpy as np, pandas as pd
import exam_data as D

def _expected():
    E = {}
    # ---- Part A
    E["q1"] = 35.0
    E["q2"] = 0.0
    E["q3"] = [7, 6]
    E["q4"] = 7
    E["q5"] = [2, 0]
    # ---- Part B
    e = D.employees
    E["q6"] = e.groupby("dept")["salary"].mean().sort_values(ascending=False)
    E["q7"] = (e.salary / e.groupby("dept")["salary"].transform("sum") * 100).round(2)
    r = e.assign(r=e.groupby("dept")["salary"].rank(method="dense", ascending=False))
    E["q8"] = r[r.r == 2][["dept", "name", "salary"]].sort_values("dept").reset_index(drop=True)
    E["q9"] = sorted(e.groupby("dept").filter(lambda x: x.salary.mean() > 65)["name"].tolist())
    E["q10"] = sorted(D.customers[~D.customers.cust_id.isin(D.orders.cust_id)].cname.tolist())
    E["q11"] = sorted(D.orders[~D.orders.cust_id.isin(D.customers.cust_id)].order_id.tolist())
    mm = D.orders.merge(D.customers, on="cust_id", how="left")
    E["q12"] = mm.assign(cname=mm.cname.fillna("Unknown")).groupby("cname")["amount"].sum().sort_values(ascending=False)
    l = (D.logins.assign(date=pd.to_datetime(D.logins.date)).drop_duplicates().sort_values(["user", "date"]))
    ns = l.groupby("user")["date"].diff().dt.days.ne(1)
    l["sid"] = ns.groupby(l["user"]).cumsum()
    E["q13"] = l.groupby(["user", "sid"]).size().groupby("user").max()
    E["q14"] = D.daily["rev"].rolling(3).mean().dropna().round(2).tolist()
    E["q15"] = D.daily["rev"].resample("W").sum().tolist()
    E["q16"] = D.sales.pivot_table(index="region", columns="product", values="units", aggfunc="sum", fill_value=0)
    E["q17"] = D.wide.melt(id_vars="id", var_name="subject", value_name="score").sort_values(["id", "subject"]).reset_index(drop=True)
    # ---- Part C
    x = D.messy
    E["q18"] = sorted(x.name.str.strip().str.title().dropna().unique().tolist())
    E["q19"] = pd.to_numeric(x.salary.str.replace(r"[₹,]", "", regex=True), errors="coerce")
    a = pd.to_numeric(x.age, errors="coerce")
    E["q20"] = a.where(a.between(0, 120))
    iso = pd.to_datetime(x.joined, format="%Y-%m-%d", errors="coerce")
    dmy = pd.to_datetime(x.joined, format="%d/%m/%Y", errors="coerce")
    E["q21"] = int(iso.combine_first(dmy).notna().sum())
    c = x.assign(name=x.name.str.strip().str.title()).dropna(subset=["name"]).drop_duplicates(["name", "salary", "joined"])
    E["q22"] = len(c)
    # ---- Part D
    E["q23"] = D.events.sort_values("ts").drop_duplicates("user", keep="last").sort_values("user").reset_index(drop=True)
    E["q24"] = D.orders.sort_values("order_id").groupby("cust_id")["amount"].cumsum()
    E["q25"] = D.scores.score.fillna(D.scores.groupby("team")["score"].transform("mean"))
    E["q26"] = {"a": 2, "b": 3, "c": 1}
    E["q27"] = pd.cut(D.ages, bins=[0, 17, 64, 200], labels=["child", "adult", "senior"]).astype(str).tolist()
    return E

SECTIONS = {"A: Predict": range(1, 6), "B: Core pandas": range(6, 18),
            "C: Profiling & cleaning": range(18, 23), "D: Interview puzzles": range(23, 28)}

def _same(a, b):
    try:
        if isinstance(b, pd.DataFrame):
            if not isinstance(a, pd.DataFrame): return False
            for aa, bb in [(a, b), (a.reset_index(drop=True), b.reset_index(drop=True))]:
                try:
                    pd.testing.assert_frame_equal(aa, bb, check_dtype=False, check_names=False, rtol=1e-6)
                    return True
                except AssertionError:
                    if not isinstance(b.index, pd.RangeIndex): break
            return False
        if isinstance(b, pd.Series):
            if not isinstance(a, pd.Series): return False
            for aa, bb in [(a, b), (a.reset_index(drop=True), b.reset_index(drop=True))]:
                try:
                    pd.testing.assert_series_equal(aa, bb, check_dtype=False, check_names=False, rtol=1e-6)
                    return True
                except AssertionError:
                    if not isinstance(b.index, pd.RangeIndex): break
            return False
        if isinstance(b, list):
            a = list(a)
            return len(a) == len(b) and all(
                (x == y) or (isinstance(y, float) and isinstance(x, (int, float, np.number)) and np.isclose(x, y))
                for x, y in zip(a, b))
        if isinstance(b, dict):
            return isinstance(a, dict) and {k: int(v) for k, v in a.items()} == b
        return bool(np.isclose(a, b, equal_nan=True))
    except Exception:
        return False

def check(ns):
    E = _expected()
    total = 0
    for sec, rng in SECTIONS.items():
        got = 0
        print(f"\n== {sec} ==")
        for i in rng:
            k = f"q{i}"
            v = ns.get(k, None)
            if v is None:
                print(f"  {k:>4}: not answered"); continue
            ok = _same(v, E[k])
            got += ok
            print(f"  {k:>4}: {'PASS' if ok else 'FAIL'}")
        print(f"  -> {got}/{len(rng)}")
        total += got
    print(f"\nTOTAL: {total}/27")
    print("Send me your notebook (or paste your answers) and I'll explain every FAIL.")

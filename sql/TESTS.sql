SELECT
	gen_random_uuid(),
    	i.ItemID,
    	i.ItemCategoria,
    	i.ItemNome,
	COALESCE(pp.PratoTipoSang, b.BebTipoSangue) as TipSang
FROM cho.ItensMenu i
	LEFT JOIN cho.PratoPadrao pp ON pp.ItemID  = i.ItemID
	LEFT JOIN cho.Bebida b ON b.ItemID = i.ItemID
;

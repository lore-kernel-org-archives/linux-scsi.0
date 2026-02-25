Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9E43B52E3;
	Wed, 25 Feb 2026 13:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772024798; cv=pass; b=W5dpvYqneCjvifsP186RIIb9SDr0P7r5980WHmIbvWRQopzQdURwxi9Gf/yhJo00A5PXo1fiI63kYi4Hr6fbwoZR5VzLJfKp11NE0vcvlfEGVwJb7UydtknSvvTanwS/Mki4WLUuzit0FjJxbGAujvHKLjn/wro4R9LNB4dYS+8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772024798; c=relaxed/simple;
	bh=blTd/7J1nY0j7ontfCbmmz89OEH9h4Mt+dSndhaNA8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YDZmScENfOqs6jCB2RU3Py53MNF9aVcvsPhyKfbGiQrWuavBkDIaj5UotPiJg2z4y36OQEcTkeBtKQsYG4gJ5Xg7LbcDyfv5/MFe7PVdUgx0NMj4P7nyEiXPFaEhZSYUCUDQykn6AoqhUNK7wUGYThyLYZ3Lt9W6c8J2hUiaUag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=BubcYS0q; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="BubcYS0q"
ARC-Seal: i=1; a=rsa-sha256; t=1772024764; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=epdV6sfEGGWgxTUxXR+oqoZSQob5OAuSJo/IxQeoiJmS3pQiIkTVSN9yEH8KC3zG22qWQI35fbW9BNRE7buiWsI/FI+0PDME8v6/GBoyI6n2Uvqmjlh6qxhhpjmQ4BmIdA+k3eaQ40qkHXRbuIhebhDyb5J60OvhNGCRkW5uM/o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1772024764; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=T6dW9tqfhUfNJnxZ03UfE/DW2B+xHA6p+xbQjEx8Pf8=; 
	b=JApQiUWgQPuga1LI9SOPB7AY/Xw6+SCuYlqi+/SEGz0BpUv+HfWIeFoIRkVLndllADmqKbqgaVLWOz1HqTpeGYnSEgw0vupYa0YNhlzdOUWLDhTGqjiIYM5p0VjXndasVjcZ5dgiHAV6ahvbgu9Qe6F2c1HZH48pTaBB1/SpbHE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1772024764;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type:Message-Id:Reply-To;
	bh=T6dW9tqfhUfNJnxZ03UfE/DW2B+xHA6p+xbQjEx8Pf8=;
	b=BubcYS0qqWwRPOl105g64yZkIwEjCDwd8SxMH3oqKAKPNAOTaE2y31QAoj2vOMix
	21qTnSjPngc4EFsfl9Bya0v1qpy65ZjUtS/7Ci0ekBX5zjEiJ0f9/IpBCNHfpwQfemE
	+gdnaM2TFkQbGlrVQtKoHZyT8J8cryvaUzbIM8cI=
Received: by mx.zohomail.com with SMTPS id 1772024762844490.7485741503249;
	Wed, 25 Feb 2026 05:06:02 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
To: "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
 "robh@kernel.org" <robh@kernel.org>,
 Chunfeng Yun =?UTF-8?B?KOS6keaYpeWzsCk=?= <Chunfeng.Yun@mediatek.com>,
 "kishon@kernel.org" <kishon@kernel.org>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@hansenpartnership.com>,
 "bvanassche@acm.org" <bvanassche@acm.org>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 "neil.armstrong@linaro.org" <neil.armstrong@linaro.org>,
 "conor+dt@kernel.org" <conor+dt@kernel.org>,
 Chaotian Jing =?UTF-8?B?KOS6leacneWkqSk=?= <Chaotian.Jing@mediatek.com>,
 "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
 "vkoul@kernel.org" <vkoul@kernel.org>,
 "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
 "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "broonie@kernel.org" <broonie@kernel.org>,
 Peter Wang =?UTF-8?B?KOeOi+S/oeWPiyk=?= <peter.wang@mediatek.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>,
 "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
 Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
 "kernel@collabora.com" <kernel@collabora.com>
Subject: Re: [PATCH v7 16/23] scsi: ufs: mediatek: Clean up logging prints
Date: Wed, 25 Feb 2026 14:05:55 +0100
Message-ID: <2575185.irdbgypaU6@workhorse>
In-Reply-To: <c333898413d249c017430d4ae98bc7be3bf33a64.camel@mediatek.com>
References:
 <20260216-mt8196-ufs-v7-0-b5f2907c6da7@collabora.com>
 <20260216-mt8196-ufs-v7-16-b5f2907c6da7@collabora.com>
 <c333898413d249c017430d4ae98bc7be3bf33a64.camel@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Tuesday, 24 February 2026 13:47:28 Central European Standard Time Peter =
Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> On Mon, 2026-02-16 at 14:37 +0100, Nicolas Frattaroli wrote:
> >  drivers/ufs/host/ufs-mediatek.c | 99 ++++++++++++++++++-------------
> > ----------
> >  1 file changed, 43 insertions(+), 56 deletions(-)
> >=20
> > diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-
> > mediatek.c
> > index ecf16e82a326..2b1f26b55782 100644
> > --- a/drivers/ufs/host/ufs-mediatek.c
> > +++ b/drivers/ufs/host/ufs-mediatek.c
> > [... snip ...]
> > @@ -810,11 +806,11 @@ static void ufs_mtk_mcq_set_irq_affinity(struct
> > ufs_hba *hba, unsigned int cpu)
> >  	_cpu =3D (cpu =3D=3D 0) ? 3 : cpu;
> >  	ret =3D irq_set_affinity(irq, cpumask_of(_cpu));
> >  	if (ret) {
> > -		dev_err(hba->dev, "set irq %d affinity to CPU %d
> > failed\n",
> > +		dev_err(hba->dev, "setting irq %d affinity to CPU %d
> > failed\n",
> >  			irq, _cpu);
> >  		return;
> >  	}
> > -	dev_info(hba->dev, "set irq %d affinity to CPU: %d\n", irq,
> > _cpu);
> > +	dev_dbg(hba->dev, "set irq %d affinity to CPU %d\n", irq,
> > _cpu);
> >=20
>=20
> Is it more appropriate to use dev_info for state changes or for setting
> changes?

Is this information a user would want to see in their bootup log in
every case? My understanding right now is no.

> > [... snip ...]
> > @@ -1571,7 +1559,7 @@ static int ufs_mtk_device_reset(struct ufs_hba
> > *hba)
> >  	/* Some devices may need time to respond to rst_n */
> >  	usleep_range(10000, 15000);
> > =20
> > -	dev_info(hba->dev, "device reset done\n");
> > +	dev_dbg(hba->dev, "device reset done\n");
> > =20
>=20
> Is it more appropriate to use dev_info for state changes or for setting
> changes?

Depends on your view of what's useful information for the user.

I can change both of these back to _info if I have to send out a next
revision, just to get this through though.

>=20
> Thanks
> Peter
>=20





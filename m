Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9C6221546;
	Tue, 23 Dec 2025 16:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766506470; cv=pass; b=cj7I9kZ4WSe+2S6JRwgFsCvFAwhsrsUY+ic/SOOKef3Dc2xuj3khyReIt8B38nbsisV2a9Wp9TBl6ote7tEHOXmJ7ROmVShFfzK2WhJJh97sunHwwCrLuvHMd1SaYZVT4ckT74dPVtZIYqDZ+lLonin8ZKmAIhvQmwyGGT2jHns=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766506470; c=relaxed/simple;
	bh=cQV4r1OcjnxnjBtw9YB7CS90Z9D7xR/nRTb7LOWb+1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DTxtD2tWcu7Bwt4cNZxM8zWQ5J0VVpYeF1QAYg+7RmZUI+uUMeCgQiA6M3APxCHaCC+yKghYo7zdPD2qzvFvtpBkaINEcYj7DBCLtEOZr1MpNH16EZ2kGOsn+U8E0ErDIp2klFJ9skHkrGCBe3EllUK92dpNSFuZ8jbs2tQlpXs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=lU9ueyei; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="lU9ueyei"
ARC-Seal: i=1; a=rsa-sha256; t=1766506430; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=GcLwAerCHEy/SR9JcYm3k6axVMsajNFFuPap2PgzrSCXjh4rWjBHBR68qGTzFmEtN3w7Ltea08lsuyXM5TqbBZ/wEy4Lt0BA0OELULdM6rGXc6Zpm/lcq+V2kll+jr5bGo9G+2hiQRG68jUw/5rriZEB9x1FO9zW043d4D4Ja4w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1766506430; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=MVFVIKq0sBuyCffyYJ/1sD+iO89pe4U1D3i3N6wh6Y4=; 
	b=hgp16a5Gt/bQR/q68E5ve1yIbch7gWUfpYZwrYxqEPYRA7AjCYQWufj7UkH2WtntiJJcClOSpAjT8qbQ6hzQpa922gcQfGHjT2HYoNkxzsljhiHj3NZ1a+yqkgkpT8oA9vDxj8bmrSmjcajiXIH/eZp5StcOj4YLKIkQ6YTq43Y=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1766506430;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type:Message-Id:Reply-To;
	bh=MVFVIKq0sBuyCffyYJ/1sD+iO89pe4U1D3i3N6wh6Y4=;
	b=lU9ueyei4bCn1/G3l4CDl0V7jCJjtHAIWGiYxDcQVWZ69Z0gd87bNml6FjOrSs7q
	Yr35Hpe+PYjszET5s4SQgWJvKVUq7y1hrqqsKtgZ0Dq8O+HDeUXJ73zJ+et/nhTZ5bH
	ZLnMXLNksOm4agx1xpj7JKjvKjzSQjIwePAVYmn4=
Received: by mx.zohomail.com with SMTPS id 1766506427805485.7983551832393;
	Tue, 23 Dec 2025 08:13:47 -0800 (PST)
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
Subject: Re: [PATCH v4 07/25] scsi: ufs: mediatek: Rework 0.9V regulator
Date: Tue, 23 Dec 2025 17:13:39 +0100
Message-ID: <14003986.uLZWGnKmhe@workhorse>
In-Reply-To: <8206d9e715f7ef987b5369d0bda68cce13528112.camel@mediatek.com>
References:
 <20251218-mt8196-ufs-v4-0-ddec7a369dd2@collabora.com>
 <20251218-mt8196-ufs-v4-7-ddec7a369dd2@collabora.com>
 <8206d9e715f7ef987b5369d0bda68cce13528112.camel@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Tuesday, 23 December 2025 10:35:39 Central European Standard Time Peter =
Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> On Thu, 2025-12-18 at 13:54 +0100, Nicolas Frattaroli wrote:
> >=20
> > +static int ufs_mtk_get_supplies(struct ufs_mtk_host *host)
> > +{
> > +       struct device *dev =3D host->hba->dev;
> > +       const struct ufs_mtk_soc_data *data =3D
> > of_device_get_match_data(dev);
> > +
> > +       if (!data || !data->has_avdd09)
> > +               return 0;
> >=20
>=20
>=20
> Hi Nicolas,
>=20
> It seems that has_avdd09 is not necessary, because if the=20
> platform does not support avdd09, it will return an error
> (-ENODEV) and bypass the avdd09 flow, right?
>=20
> Thanks
> Peter
>=20
>=20
>=20
>=20

Hi,

that would allow compatibles that are not allowed to have an avdd09
regulator by the binding (because the SoC doesn't have that pin) to
have one specified in the device tree get picked up. This would then
cause those devices with such a device tree to enter
ufs_mtk_va09_pwr_ctrl(), which is not what we want. While we could
blame this on the DT being wrong in that case, I think it's better
if we avoid such a situation entirely.

Kind regards,
Nicolas Frattaroli



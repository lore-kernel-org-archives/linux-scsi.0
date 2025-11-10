Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7944503B;
	Mon, 10 Nov 2025 09:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762766418; cv=pass; b=JJNFYh9thNCXHtdpm0CvevJAqVhnsG02pSOFSEA3VvmtzybusIfeOKi/egqszi+guk6Q9ofkjyP6QgpVmIPtWaRpxWSCm6UaEdMRDh4aJwcvle2Thplf0XMOVI4qpcLmi4kg/zzrVrZX9uVlC8FdOLjF+SNQmSsGBoIz4kpfPQs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762766418; c=relaxed/simple;
	bh=aiQbFvykbkMPAcRTW3HRuLSEfDYUjHVu9JHorCRdmr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ceeMK/R4/OFPXU2hE9X6UxvU8p3cQ0aZ0p0b+4CVFDzL8Gcf9qVSj8rbSpOIHlDOq7zGFlZtlQvu+kgqqHsjj3lfoyb5UVGNAtBd7wsp8n9jVtOkl/azzYkli4UzMqAXE3rX2YyOv1iRbJVSK+auzcVrswFqYW6Bv1DU8MIMhsc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=FSyKtglp; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="FSyKtglp"
ARC-Seal: i=1; a=rsa-sha256; t=1762766377; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=mQxPVYOATQezqBL5yCJPKwUbX+JgMrUABoUyvim3PFza8c5ZHhZestibHiJFWxXvoUng13jVC8P9S64jLTObD3EpZPUjgof53bxKAflmbD/d78+0IWCG8rNnUURNAQ8Oje3LhaAfmz53emfB473ehmaxkoUhLVNdPpqAiCm1FeU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1762766377; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=hxLXwdvcR73afnWX3+U+TbZmEVnvtJ1WDn3vMJOYfeI=; 
	b=AUtP6OnBexLHP6078mlNSuvrN1eMtg8eyILcYQm+PCUyEel5aO3GjP5o+k/IR2p8jF5aO/vUOfWan+DKf+K6QVxlPMK3JNUqhpcbD2Q6ZQc69QnOsjAw2W5iAuL+QEHBPlJ0aoWglABTbUZzwNG9t4F8qJN4UUICHgiaxNcj24E=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1762766376;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type:Message-Id:Reply-To;
	bh=hxLXwdvcR73afnWX3+U+TbZmEVnvtJ1WDn3vMJOYfeI=;
	b=FSyKtglpf319WU2vjW77dgt25xU6yIInC/sCx6LK4hbKihknuUJcM+Xfc4doAzdm
	TkVp3GcYUsXL3ydIq01zsOAj8rnMcOSkAt6BZ5AUWKkDs6fcC2OqtvmkDzvhvjE66+d
	HJOO9ylHv/KRJd9AOt8FaM/tBgmLyh5foC6PyvK0=
Received: by mx.zohomail.com with SMTPS id 1762766374404175.65977685098846;
	Mon, 10 Nov 2025 01:19:34 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
To: Peter Wang =?UTF-8?B?KOeOi+S/oeWPiyk=?= <peter.wang@mediatek.com>,
 Chunfeng Yun =?UTF-8?B?KOS6keaYpeWzsCk=?= <Chunfeng.Yun@mediatek.com>,
 "kishon@kernel.org" <kishon@kernel.org>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "bvanassche@acm.org" <bvanassche@acm.org>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "broonie@kernel.org" <broonie@kernel.org>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
 "conor+dt@kernel.org" <conor+dt@kernel.org>,
 "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
 "robh@kernel.org" <robh@kernel.org>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@hansenpartnership.com>,
 "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
 "vkoul@kernel.org" <vkoul@kernel.org>,
 "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
 "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Chaotian Jing =?UTF-8?B?KOS6leacneWkqSk=?= <Chaotian.Jing@mediatek.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
 "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
 "kernel@collabora.com" <kernel@collabora.com>,
 Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>
Subject:
 Re: [PATCH v3 09/24] scsi: ufs: mediatek: Rework the crypt-boost stuff
Date: Mon, 10 Nov 2025 10:19:25 +0100
Message-ID: <6210035.lOV4Wx5bFT@workhorse>
In-Reply-To: <9ae7495023a8562566ff57bd2dfa60524194ee30.camel@mediatek.com>
References:
 <20251023-mt8196-ufs-v3-0-0f04b4a795ff@collabora.com>
 <20251023-mt8196-ufs-v3-9-0f04b4a795ff@collabora.com>
 <9ae7495023a8562566ff57bd2dfa60524194ee30.camel@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Tuesday, 4 November 2025 08:28:18 Central European Standard Time Chaotia=
n Jing (=E4=BA=95=E6=9C=9D=E5=A4=A9) wrote:
> On Thu, 2025-10-23 at 21:49 +0200, Nicolas Frattaroli wrote:
> > I don't know whether the crypt-boost functionality as it is currently
> > implemented is even appropriate for mainline. It might be better done
> > in
> > some generic way. But what I do know is that I can rework the code to
> > make it less obtuse.
> >=20
> > Prefix the boost stuff with the appropriate vendor prefix, remove the
> > pointless clock wrappers, and rework the function.
> >=20
> > Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
> > ---
> >  drivers/ufs/host/ufs-mediatek.c | 91 +++++++++++++++--------------
> > ------------
> >  1 file changed, 32 insertions(+), 59 deletions(-)
> >=20
> > diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-
> > mediatek.c
> > index 131f71145a12..9c0ac72d6e43 100644
> > --- a/drivers/ufs/host/ufs-mediatek.c
> > +++ b/drivers/ufs/host/ufs-mediatek.c
> > @@ -562,21 +562,6 @@ static int ufs_mtk_mphy_power_on(struct ufs_hba
> > *hba, bool on)
> >  	return 0;
> >  }
> > =20
> > -static int ufs_mtk_get_host_clk(struct device *dev, const char
> > *name,
> > -				struct clk **clk_out)
> > -{
> > -	struct clk *clk;
> > -	int err =3D 0;
> > -
> > -	clk =3D devm_clk_get(dev, name);
> > -	if (IS_ERR(clk))
> > -		err =3D PTR_ERR(clk);
> > -	else
> > -		*clk_out =3D clk;
> > -
> > -	return err;
> > -}
> > -
> >  static void ufs_mtk_boost_crypt(struct ufs_hba *hba, bool boost)
> >  {
> >  	struct ufs_mtk_host *host =3D ufshcd_get_variant(hba);
> > @@ -633,65 +618,53 @@ static void ufs_mtk_boost_crypt(struct ufs_hba
> > *hba, bool boost)
> >  	clk_disable_unprepare(cfg->clk_crypt_mux);
> >  }
> > =20
> > -static int ufs_mtk_init_host_clk(struct ufs_hba *hba, const char
> > *name,
> > -				 struct clk **clk)
> > -{
> > -	int ret;
> > -
> > -	ret =3D ufs_mtk_get_host_clk(hba->dev, name, clk);
> > -	if (ret) {
> > -		dev_info(hba->dev, "%s: failed to get %s: %d",
> > __func__,
> > -			 name, ret);
> > -	}
> > -
> > -	return ret;
> > -}
> > -
> > -static void ufs_mtk_init_boost_crypt(struct ufs_hba *hba)
> > +static int ufs_mtk_init_boost_crypt(struct ufs_hba *hba)
> You change the return type but never checked the return value when
> calling this function ?

Yeah, I should probably check the return in ufs_mtk_init_host_caps
instead of continuing on silently.

> >  {
> >  	struct ufs_mtk_host *host =3D ufshcd_get_variant(hba);
> >  	struct ufs_mtk_crypt_cfg *cfg;
> >  	struct device *dev =3D hba->dev;
> > -	struct regulator *reg;
> > -	u32 volt;
> > +	int ret;
> > =20
> > -	host->crypt =3D devm_kzalloc(dev, sizeof(*(host->crypt)),
> > -				   GFP_KERNEL);
> > -	if (!host->crypt)
> > -		goto disable_caps;
> > +	cfg =3D devm_kzalloc(dev, sizeof(*cfg), GFP_KERNEL);
> > +	if (!cfg)
> > +		return -ENOMEM;
> > =20
> > -	reg =3D devm_regulator_get_optional(dev, "dvfsrc-vcore");
> > -	if (IS_ERR(reg)) {
> > -		dev_info(dev, "failed to get dvfsrc-vcore: %ld",
> > -			 PTR_ERR(reg));
> > -		goto disable_caps;
> > +	cfg->reg_vcore =3D devm_regulator_get_optional(dev, "dvfsrc-
> > vcore");
> > +	if (IS_ERR(cfg->reg_vcore)) {
> > +		dev_err(dev, "Failed to get dvfsrc-vcore: %pe", cfg-
> > >reg_vcore);
> Since this regulator is optional, why use dev_err ? and why retune an
> error since you never check the return value ?

Because get_optional doesn't mean what you think it means. It means
the function returns -ENODEV if the regulator is absent, instead of
creating a dummy supply. We want to hard error out if the regulator
is absent, because the regulator is needed.

Whether or not the return code is checked makes no functional
difference in this case. If this function exits early,
UFS_MTK_CAP_BOOST_CRYPT_ENGINE isn't added to the host caps,
and the host->crypt member isn't set to cfg.

The return code may be useful for additional logging, which is not
critical to the correctness of the code.

> > +		return PTR_ERR(cfg->reg_vcore);
> >  	}
> > =20
> > -	if (of_property_read_u32(dev->of_node, "boost-crypt-vcore-min",
> > -				 &volt)) {
> > -		dev_info(dev, "failed to get boost-crypt-vcore-min");
> > -		goto disable_caps;
> > +	ret =3D of_property_read_u32(dev->of_node, "mediatek,boost-crypt-
> > vcore-min",
> > +				   &cfg->vcore_volt);
> > +	if (ret) {
> > +		dev_err(dev, "Failed to get mediatek,boost-crypt-vcore-
> > min: %pe\n",
> > +			ERR_PTR(ret));
> > +		return ret;
> >  	}
> > =20
> > -	cfg =3D host->crypt;
> > -	if (ufs_mtk_init_host_clk(hba, "crypt_mux",
> > -				  &cfg->clk_crypt_mux))
> > -		goto disable_caps;
> > +	cfg->clk_crypt_mux =3D devm_clk_get(dev, "crypt_mux");
> > +	if (IS_ERR(cfg->clk_crypt_mux)) {
> > +		dev_err(dev, "Failed to get clock crypt_mux: %pe\n",
> > cfg->clk_crypt_mux);
> > +		return PTR_ERR(cfg->clk_crypt_mux);
> > +	}
> > =20
> > -	if (ufs_mtk_init_host_clk(hba, "crypt_lp",
> > -				  &cfg->clk_crypt_lp))
> > -		goto disable_caps;
> > +	cfg->clk_crypt_lp =3D devm_clk_get(dev, "crypt_lp");
> > +	if (IS_ERR(cfg->clk_crypt_lp)) {
> > +		dev_err(dev, "Failed to get clock crypt_lp: %pe\n",
> > cfg->clk_crypt_lp);
> > +		return PTR_ERR(cfg->clk_crypt_lp);
> > +	}
> > =20
> > -	if (ufs_mtk_init_host_clk(hba, "crypt_perf",
> > -				  &cfg->clk_crypt_perf))
> > -		goto disable_caps;
> > +	cfg->clk_crypt_perf =3D devm_clk_get(dev, "crypt_perf");
> > +	if (IS_ERR(cfg->clk_crypt_perf)) {
> > +		dev_err(dev, "Failed to get clock crypt_perf: %pe\n",
> > cfg->clk_crypt_perf);
> > +		return PTR_ERR(cfg->clk_crypt_perf);
> > +	}
> > =20
> > -	cfg->reg_vcore =3D reg;
> > -	cfg->vcore_volt =3D volt;
> > +	host->crypt =3D cfg;
> >  	host->caps |=3D UFS_MTK_CAP_BOOST_CRYPT_ENGINE;
> > =20
> > -disable_caps:
> > -	return;
> > +	return 0;
> >  }
> > =20
> >  static void ufs_mtk_init_host_caps(struct ufs_hba *hba)
> >=20
>=20





Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDBA47ECC1;
	Tue,  1 Sep 2026 16:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788280350; cv=none; b=GtKmHaMcf6pcjQjW/h5Lv9IZwoJCa2cH5SxiVTYwqYETZ83DArx6fgbpfrHdugohngGbfSgRBLY+axjAo7xsO2DgmyMJJi8gFmFagQs4UcrbqFHzQAzOIV+riMKscv55+7m9lbXtJnZJasGy3rfsCK2zNVAmA8JHfogWtYYtB+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788280350; c=relaxed/simple;
	bh=/zkxMpUggAMf1m7EghNt+ZY9m+DyQrjrU6E72Mj9ZfU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NiGpQvJvfYsnA5+lJtqxlzUfndwZt6djN3aASMnaZPL3oagoND+4vZaV2KBtTu5zt1UZQcJ5su4yJEPKRLmr5rVxr4vutD+WISCS2x+JBGLwdM9igpr8FL8rRw2cO6lSs8PJ/ERN4IqrRslTZKrBMTBSfSwpZdJ72eqz4IEn6jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NEcYq2JY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NEcYq2JY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1E81F000E9;
	Tue,  1 Sep 2026 16:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788280348;
	bh=RVThgaMR7YohtKU+H34GcPG6L+uQ/2tYAFBh5huo7Aw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NEcYq2JYd/dvywBUlY5TZauCY6BC/h3ZQk+q0O8o2ofgu8WAguvE2utBzaLhf2WTZ
	 CBoNatInlvzyrgUR1nZ3dna6okUWkCPJgzGTWXB9S650GbL7efzj//P2LIlI5v4OVe
	 hfIByv2BfvOfQ3C50rzJflWiqXwLOk6YNzgVX6AXy9a+t+aQZ1vef54u4FSrI8CYAR
	 PC4U+VnaEJsc5RwYUGkI8kWwA2PqUOTGG81gei3XnwOV2U+pE+AL+MeIgooLdGPbpH
	 nmSi6Brc+wmPiEOr1q0OftMn6ameRzg6CsQBZTqxm6YYlCG8yn1Nk+BA73GdgUfSFg
	 2knVwUg1N99Ig==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 24/24] scsi: ufs: mediatek: Add MT8196 compatible,
 update copyright
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: olteanv@gmail.com, linux-scsi@vger.kernel.org, linux-phy@lists.infradead.org, devicetree@vger.kernel.org, robh@kernel.org, neil.armstrong@linaro.org, vkoul@kernel.org, conor+dt@kernel.org
In-Reply-To: <20260901-mt8196-ufs-v11-24-dbd007704490@collabora.com>
References: <20260901-mt8196-ufs-v11-0-dbd007704490@collabora.com>
 <20260901-mt8196-ufs-v11-24-dbd007704490@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 16:32:27 +0000
Message-Id: <20260901163228.3C1E81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Inconsistent hardware state on rollback failure in ufs_mtk_09v_off=
() leads to regulator state mismatch and potential crash.
--

commit 532592d1862d942dd09400d688803111fc2d12cb
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

scsi: ufs: mediatek: Add MT8196 compatible, update copyright
   =20
THe MT8196's UFS controller has a new compatible. Add the necessary
struct definitions to support it.
   =20
Also update the copyrights and authors, without tabs following spaces to
avoid checkpatch errors, to list myself as having contributed to this
driver after the preceding rework patches.

> THe MT8196's UFS controller has a new compatible. Add the necessary

This isn't a bug, but there is a typo (THe) in the commit message.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index a894810a83de7..e6a672888d043 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c

[ ... ]

> @@ -2254,10 +2260,18 @@ static const struct ufs_mtk_soc_data mt8192_8195_=
data =3D {
>  	.num_reg_names =3D ARRAY_SIZE(ufs_mtk_regs_avdd12_ckbuf_avdd18),
>  };
> =20
> +static const struct ufs_mtk_soc_data mt8196_data =3D {
> +	.has_avdd09 =3D true,
> +	.has_avdd09_1 =3D true,

[Severity: High]
This is a pre-existing issue, but this commit explicitly exposes a dormant
regulator state mismatch bug because mt8196_data is the first to set
has_avdd09_1 to true.

In ufs_mtk_09v_off(), if host->reg_avdd09 is successfully disabled but
host->reg_avdd09_1 subsequently fails to disable, the function enters an
error rollback path:

drivers/ufs/host/ufs-mediatek.c:ufs_mtk_09v_off() {
...
	if (host->reg_avdd09) {
		ret =3D regulator_disable(host->reg_avdd09);
...
	}

	if (host->reg_avdd09_1) {
		ret =3D regulator_disable(host->reg_avdd09_1);
		if (ret) {
			dev_err(host->hba->dev, "Failed to disable avdd09-1-supply: %pe\n",
				ERR_PTR(ret));
			ufs_mtk_va09_pwr_ctrl(res, 1);
			return ret;
		}
	}
...
}

It restores SMC power with ufs_mtk_va09_pwr_ctrl(res, 1) and returns an
error, but crucially misses calling regulator_enable(host->reg_avdd09) to
revert the previously disabled host->reg_avdd09 regulator.

This leaves the UFS PHY state marked as powered on, but the PHY is
physically disabled and its essential reg_avdd09 regulator is powered off.

Could subsequent accesses to the UFS controller attempt to operate on
unpowered hardware, likely causing a hardware hang or an asynchronous
external abort that crashes the system?

> +	.reg_names =3D ufs_mtk_regs_avdd12_ckbuf,
> +	.num_reg_names =3D ARRAY_SIZE(ufs_mtk_regs_avdd12_ckbuf),
> +};
> +

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901-mt8196-ufs=
-v11-0-dbd007704490@collabora.com?part=3D24

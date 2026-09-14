Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2463F9278;
	Mon, 14 Sep 2026 13:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789393304; cv=none; b=NZr4mxfUxn20f8+l7sOLq8dluAVjdaeDRoJdWA/9LfQbGITXMGEx9R89ozYTbXf0B1+YvE9cs7Bif8cr+Ny63SP9aQJyzVCfyWwr0Q4WvcnCuwnk9oUMlf8JOia5oxQfVzpQR/6WA+wN03swEd5vyhnksYHqRVqHWnppw/SSelU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789393304; c=relaxed/simple;
	bh=+KXaLnoZ7SUFlCuYTKoI68lrvL/7TLFnSYFR1DOQEqQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hHo9zl7UJjG5J4GhkK6pVxBzeP6zrehW4ryF2x/QriQV7uFnsopV4sApJDljBcO/hWthMYv8k9vRplmxFyfSfhV/oEHe93r1hSHqrRydmiFFADXWIhp27qBw9ooFJy+MayxY0zUVDqJrQfT5Qiy0s3G4DyS2vbnU5YDGiChSzfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j9CpBjdV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j9CpBjdV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DBEF1F000FF;
	Mon, 14 Sep 2026 13:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789393303;
	bh=3DI1L5QUmQZVnnmb7U8lWFf2/S2Fs3Arcy571Q/MDVc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j9CpBjdVHcZz7NOq4IlD3WQ0sGdcWlCU8khkSzYlItKl+tFdoIUcT35RG2e55Oqwb
	 CxroUgxhNEH+aTw18Ctg7v5GLjz9pxGQIrt5z2t/iq6RZYveDmALrNfPCmC4TsGSkk
	 AknNAphTCTokbR4JfacGL2eK+RMinq8RmfxprAlWcfqkO/CKHc4ziFGTOkSE3vBS3f
	 IDmdLBT/nuBMOHjqQb8uYu5D19SiQ597I1aeKDzdQ2w12qi7zHmU7EiQZ3sh1k64Ja
	 yKG89bttaFnMk6bJW2wJ4Qg2J6a3F+g9ZUfDAW6WYesHxtEQhSeNIaItRFauBGkb0m
	 cTad5CQLvhg7w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 24/24] scsi: ufs: mediatek: Add MT8196 compatible,
 update copyright
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: vkoul@kernel.org, olteanv@gmail.com, devicetree@vger.kernel.org, robh@kernel.org, conor+dt@kernel.org, neil.armstrong@linaro.org, linux-scsi@vger.kernel.org, linux-phy@lists.infradead.org
In-Reply-To: <20260914-mt8196-ufs-v12-24-9279d7ef814d@collabora.com>
References: <20260914-mt8196-ufs-v12-0-9279d7ef814d@collabora.com>
 <20260914-mt8196-ufs-v12-24-9279d7ef814d@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 13:41:42 +0000
Message-Id: <20260914134142.6DBEF1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Kernel panic in ufs_mtk_09v_on() and ufs_mtk_09v_off() error paths=
 due to missing NULL checks on host->reg_avdd09.
--

commit 3e1ab912b68bb7adad59190a0d213096bb41991c
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

scsi: ufs: mediatek: Add MT8196 compatible, update copyright

The MT8196's UFS controller has a new compatible. Add the necessary
struct definitions to support it.

> THe MT8196's UFS controller has a new compatible. Add the necessary
  ^^^
[Severity: Low]
This isn't a bug, but there's a typo (THe) in the commit message.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index ef8924704c902..ceb52c40d266c 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c

[ ... ]

> @@ -2264,10 +2270,18 @@ static const struct ufs_mtk_soc_data mt8192_8195_=
data =3D {
>  	.num_reg_names =3D ARRAY_SIZE(ufs_mtk_regs_avdd12_ckbuf_avdd18),
>  };
> =20
> +static const struct ufs_mtk_soc_data mt8196_data =3D {
> +	.has_avdd09 =3D true,
> +	.has_avdd09_1 =3D true,

[Severity: High]
Does enabling has_avdd09_1 introduce a NULL pointer dereference in the error
handling paths for ufs_mtk_09v_on() and ufs_mtk_09v_off()?

If a device tree omits avdd09 but provides avdd09-1, host->reg_avdd09 will
be NULL. In ufs_mtk_09v_on(), the code properly checks if host->reg_avdd09
is valid before enabling it. However, if enabling host->reg_avdd09_1
subsequently fails, the error handler blindly executes:

    regulator_disable(host->reg_avdd09);

without checking if host->reg_avdd09 is NULL.

The core regulator subsystem unconditionally dereferences the struct regula=
tor
pointer when CONFIG_REGULATOR is enabled, which would cause a panic.

The exact same issue appears to exist in ufs_mtk_09v_off(), where it calls:

    regulator_enable(host->reg_avdd09);

unconditionally if disabling avdd09-1 fails.

Since the MT8196 compatible is the first to set has_avdd09_1 =3D true, does
this make these error paths reachable?

> +	.reg_names =3D ufs_mtk_regs_avdd12_ckbuf,
> +	.num_reg_names =3D ARRAY_SIZE(ufs_mtk_regs_avdd12_ckbuf),
> +};
> +

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-mt8196-ufs=
-v12-0-9279d7ef814d@collabora.com?part=3D24

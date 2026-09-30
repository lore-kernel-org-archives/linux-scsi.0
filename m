Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29DB22AEEB;
	Wed, 30 Sep 2026 11:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790768046; cv=none; b=TcuQz8LM4LN1vTzoU9LnuHnBK8IsMaHHoteytZognJjWR1lAByFZ0zjG6Lu8HGaXWyoOaDL0gwM3T0bQrgW4h2Htu9G68moXix0xFfkEEjXZQoY7UDaXfJI0lmQX6Hn3Uidlzh7ORnCSAm2teAmHpCZTjRIsHLjXgwQKAskSxOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790768046; c=relaxed/simple;
	bh=CmWysLMga2qvG/l1NVuKy643fhuHle4zYD1qmtCZAC0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s7mCpRhOLkuv0sBAA+wG36sEffw8pUDECM9HHxhG7jiv7scXgKc4ATxblQJhJx0tlf+NUPw6WwCShyBiSauba5SoxgURFhfmk/jxGCiPaE8Z9ddnMsZttq3l5Q41utErSuce0RwTyYDbXPnSCA6AcfPjSqrD6sY69ajMzViJ+EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HJln5r1F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HJln5r1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A781F000FF;
	Wed, 30 Sep 2026 11:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790768044;
	bh=Flr3+GGP3TPmQvHBee/nC5aClMMVtkJOvhVsHYP44Jw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HJln5r1FM98WBeLs7XUSvG/yAXxwvSZTn+E3qku7Fcw7QA70Y5PV2GcYMSGQSJBwq
	 VnysVYjfQjFuvK8+MrEELJkhIlSVBYdS/3CU0+iv9k2Ajlsci/8xGoeojxrQ3xRvfR
	 GvQ90wuGG0SBsySlnyRXaMBJHymxkonwG+b8AbWjMDqCcaAeh+FQSGWfgzlCnpQ6YA
	 WUqlMFRL+jH9zjujPu6F8RxD3ubOphumLBhx0eCaAVAU1G7brwDmWGhUnHdM4YnEOE
	 23YIdYjbItbNFOPUqpSN+1GqIBtP1IO2L9ppWjyZpN92UE9iOI4Nn4MnkLMnLKoEEr
	 wIv2P4K7MUBlA==
Date: Wed, 30 Sep 2026 13:34:02 +0200
From: Thierry Reding <thierry.reding@kernel.org>
To: Kartik Rajput <kkartik@nvidia.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Jonathan Hunter <jonathanh@nvidia.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <mkp@kernel.org>, 
	Philipp Zabel <p.zabel@pengutronix.de>, Thierry Reding <treding@nvidia.com>, linux-scsi@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] scsi: ufs: tegra: Add Tegra264 UFS host
 controller driver
Message-ID: <arzsK8U8Nw39Pwu-@orome>
References: <20260929-tegra264-ufs-v2-0-f0467b9c503e@nvidia.com>
 <20260929-tegra264-ufs-v2-4-f0467b9c503e@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="jp336opcm6u7er2z"
Content-Disposition: inline
In-Reply-To: <20260929-tegra264-ufs-v2-4-f0467b9c503e@nvidia.com>


--jp336opcm6u7er2z
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 4/4] scsi: ufs: tegra: Add Tegra264 UFS host
 controller driver
MIME-Version: 1.0

On Tue, Sep 29, 2026 at 03:15:10PM +0530, Kartik Rajput wrote:
> Add a driver for the UFS host controller found on NVIDIA Tegra264 SoCs.
> The controller has Tegra-specific auxiliary registers, clocks and resets,
> and it drives the four M-PHY lane directions exposed by the Tegra264
> M-PHY driver.
>=20
> Co-developed-by: Thierry Reding <treding@nvidia.com>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> Signed-off-by: Kartik Rajput <kkartik@nvidia.com>
> ---
>  drivers/ufs/host/Kconfig     |  14 +
>  drivers/ufs/host/Makefile    |   1 +
>  drivers/ufs/host/ufs-tegra.c | 686 +++++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 701 insertions(+)
>=20
> diff --git a/drivers/ufs/host/Kconfig b/drivers/ufs/host/Kconfig
> index ff170c0b6da0..7ca317d25251 100644
> --- a/drivers/ufs/host/Kconfig
> +++ b/drivers/ufs/host/Kconfig
> @@ -168,3 +168,17 @@ config SCSI_UFS_AMD_VERSAL2
> =20
>  	  Select this if you have UFS controller on AMD Versal Gen 2 SoC.
>  	  If unsure, say N.
> +
> +config SCSI_UFS_TEGRA
> +	tristate "NVIDIA Tegra264 UFS controller platform driver"
> +	depends on SCSI_UFSHCD_PLATFORM
> +	depends on ARCH_TEGRA_264_SOC || (COMPILE_TEST && 64BIT)

=46rom a quick look I couldn't spot anything specific to 64-bit in the
driver. Did I miss anything?

Also, we really shouldn't depend on ARCH_TEGRA_264_SOC since this
controller exists on prior generations and we will eventually want to
support them, too.

> +	select PHY_TEGRA_MPHY

Maybe to complement what Krzysztof already said: Kconfig dependencies
are primarily build-time dependencies. This driver uses the generic PHY
API to access the M-PHY functionality, so GENERIC_PHY is the correct
build-time dependency. The driver is purposefully agnostic to the
specific implementation of the PHYs that it uses so that it can work
with (potentially) many different PHY implementations.

We use device tree to hook up the runtime dependencies. If the M-PHY
driver is not enabled we get the probe deferred because the PHYs that
were hooked up in DT haven't been registered and hence can't be found
(by the generic PHY framework). On other devices the PHYs might end up
being backed by completely different implementations and they could
still work just fine.

> +	help
> +	  Enable support for the UFS host controller on NVIDIA Tegra264
> +	  SoCs. The driver relies on the Tegra264 M-PHY driver

I would suggest dropping references to Tegra264 here. The driver is not
specific to Tegra264. There are older Tegra SoCs that have (earlier)
generations of this IP and that should still work with this driver
(maybe with some parameterization).

> diff --git a/drivers/ufs/host/ufs-tegra.c b/drivers/ufs/host/ufs-tegra.c
> new file mode 100644
> index 000000000000..f12265432592
> --- /dev/null
> +++ b/drivers/ufs/host/ufs-tegra.c
> @@ -0,0 +1,686 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +// Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserv=
ed.
> +// NVIDIA Tegra264 UFS host controller driver.

Tegra264 can be dropped here as well.

[...]
> +#define UFS_TEGRA_HS_CLK_RATE_HZ		5840000000UL

Do we assume that this will always be the same value? Maybe this should
be turned into SoC data? We could always do that when necessary, of
course.

[...]
> +static int ufs_tegra_mphy_power_on(struct ufs_hba *hba)
> +{
> +	struct ufs_tegra *ufs =3D ufshcd_get_variant(hba);
> +	int err;
> +
> +	err =3D phy_power_on(ufs->mphy_l0_rx);
> +	if (err) {
> +		dev_err(hba->dev, "failed to power on mphy-l0-rx\n");
> +		return err;
> +	}
> +
> +	err =3D phy_power_on(ufs->mphy_l0_tx);
> +	if (err) {
> +		dev_err(hba->dev, "failed to power on mphy-l0-tx\n");
> +		goto out_power_off_l0_rx;
> +	}
> +
> +	err =3D phy_power_on(ufs->mphy_l1_rx);
> +	if (err) {
> +		dev_err(hba->dev, "failed to power on mphy-l1-rx\n");
> +		goto out_power_off_l0_tx;
> +	}
> +
> +	err =3D phy_power_on(ufs->mphy_l1_tx);
> +	if (err) {
> +		dev_err(hba->dev, "failed to power on mphy-l1-tx\n");
> +		goto out_power_off_l1_rx;
> +	}
> +
> +	return 0;
> +
> +out_power_off_l1_rx:
> +	phy_power_off(ufs->mphy_l1_rx);
> +out_power_off_l0_tx:
> +	phy_power_off(ufs->mphy_l0_tx);
> +out_power_off_l0_rx:
> +	phy_power_off(ufs->mphy_l0_rx);
> +
> +	return err;
> +}

Almost seems like we need phy_bulk APIs. Again, doesn't need to be part
of this series, but maybe something to keep in mind.

[...]
> +static int ufs_tegra_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
> +			     enum ufs_notify_change_status status)
> +{
> +	if (status =3D=3D PRE_CHANGE)
> +		return 0;
> +
> +	/* Runtime H8 park keeps the M-PHY powered; only tear it down
> +	 * on the full-teardown paths (system suspend, shutdown, or
> +	 * runtime PM with LINK_OFF).
> +	 */

Comment style needs the first line to be /* on its own, except for the
net subsystem, if I recall correctly. There are other occurrences of
this elsewhere in the file.

Also, I read "H8" as "hate" at first and it took me a little bit to
realize it meant "hibernate" in this case. Looks like the rest of UFS
uses "hibern8". Maybe stick to the convention?

[...]
> +static int ufs_tegra_pwr_change_notify(struct ufs_hba *hba,
> +				       enum ufs_notify_change_status status,
> +				       struct ufs_pa_layer_attr *dev_req_params)
> +{
[...]
> +	if (dev_req_params->hs_rate =3D=3D PA_HS_MODE_A ||
> +	    dev_req_params->hs_rate =3D=3D PA_HS_MODE_B) {
> +		err =3D clk_set_rate(ufs->hs_clk, UFS_TEGRA_HS_CLK_RATE_HZ);

What if hs_rate !=3D PA_HS_MODE_A or PA_HS_MODE_B?

> +static int ufs_tegra_set_dma_mask(struct ufs_hba *hba)
> +{
> +	return dma_set_mask_and_coherent(hba->dev, DMA_BIT_MASK(32));
> +}

I have a feeling like the 32 is here on purpose, but I can't fully
remember why it's not something like 40, which is the standard on recent
Tegra devices.

Maybe we should add a comment explaining why this needs to be so narrow.

Thierry

--jp336opcm6u7er2z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmq886cACgkQ3SOs138+
s6GdQxAAmLZzF9sJFE536oAWmTNQI9D2+UMoQmKCgyANxCKt1hphd8gO9qhAdDtd
WkG7dHXvZqGDpDVwiC/SdQUwySkpHnfM68lqABGScHTBH1mY+8BxufnqOLooJ1AV
in06DLEgN0G3wGNx45CllJmg9plimxKAEFXbv9MYxbg3hyf4jcdEMKdFsXMSBG8b
ka7E3RqWt8nuiK5M1oi7HbdiOeRYay37L/HJ6Cw2p9GPgFCl9/yPuX2X53RguzfJ
0A8fGV3K69skmsFmDcY3AficeHN6hfNNHSDqjPXBinCbMiI+h4WX4ceqhCWnmxE8
j1SJg8u9hv10VXRsTfurJ2iBZxHNmLxdt1MM8PiFlZD8QPAHB9KEBJM0fx2i2UR7
Xhnx2iLCexGxGsFfdt5PWlpsGI84dJ443YSK7GkD4hCqiyDZM0Bf5aL6LOKzvKsA
TOUJjC7p2xD3mXn5wi7FTg91yxhZR7dow6+ibronLCEEmJPlmA89l1D+FhPaeOfl
UGAbBsX2PtztusqkMhR7VGWSAuBD8cF4JICKVSeVC5nH5HnUtgkpzDBySt2WfGY0
4AppFkRnnYQhgmeas6kjwyG8HBBrlJsSdIps6CdhHGgVh9SEvycEbT2Ft1ZFR1xp
qbzMSzMj0DFkKEdVSKC9BjwM4mVBe1OUyQrxqt18sw0gl6tNJL8=
=IQBi
-----END PGP SIGNATURE-----

--jp336opcm6u7er2z--

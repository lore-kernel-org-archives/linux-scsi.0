Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794524950;
	b=DjNtF2EkcGP2aRKiTONZL9AaETMr+pVQSEwN9MfrMAm3xuUIBSavVNs0ofw2yctYbQ7k
	 hS2Dv5tTcFWWW0q2ur99RSan5e+FRUdvtxNyZJbGPHgCLrOdRoLjW1hawyDiwCOqR8LX/
	 jAM132GMpZ1bvOyUQh4yy1r8dP10XQt5HQHG0MExEGiTbD1hkyim4PsQYT7DL/EIl+227
	 90gLDUsZxwufRud2PfBFLMBQH01ZR9FBWJKQD1lSRrhaeffPsMO5kKATK8K6SoTmF5D6g
	 lv1RNNkVF+yWMXAcRQ22gqHBymEs1+Zs56j4nF2ZWLNxlzHe6Ppn7wezdHbggaz/COQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794524950;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=jBIoGmo7JFFX82SEeE73qtD3GyZxn6nVs6zZ0aNe29g=;
	b=kpH7iOsEY3UlFp5lXsP63iku51uyjkU4QSqsknz99R04SeY4sOkoc2zeIiUFi1o7ThkV
	 oaV26CMO19zKNR3d2xKTb4hnC3yubB5VplvYlgo52L3pGRdBXj96axwI6U/XVujN+urxU
	 n/wKY88XrQp2tXlhI8Ca3IQp0/LyMjM2ojTJaotsBHv3GFCr1P2T0pu5ErOxE4c5udwHu
	 njpo7fkRKfdfrKvpgc24oW9K+pWVhZZ6xeKY6fwyP15Tquyh7bbmSrNPvcVUYJuCDRC95
	 8ZmM3PLeKxQjBFD7sFBDkccqI4oAZ+PTdbujAZzRI3CcSOdz1oOCa5J5ll+rkaejNJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RrCYY7Av;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0DB606A888;
	Thu, 12 Nov 2026 23:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RrCYY7Av
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF331F000CE;
	Thu, 12 Nov 2026 23:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794524949;
	bh=jBIoGmo7JFFX82SEeE73qtD3GyZxn6nVs6zZ0aNe29g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RrCYY7AvCuTNFWIH5O2Id7zYUJUHHdKNBLB4B0ewDy78nIRFM8iU3icaKWICzM09r
	 tPnL6PYXYZuPMLp1mGEiBqnKlS7Er1WhjIUA3V/PK9uNGI9TIax986C1f1eb1TFdiP
	 QYXhiy9X3B40TjfCDlh7/DwDinPknx4egM5evupojDtSwzCUJOp25NgMsxHZhdzscq
	 shbU/x/UPxvS7Qi0sBcgPulRH5yvcctA1ZevadIP//0LMT7a6aKOIEdzVMSyPgc0CS
	 NqwWDo48uXYCA9TQdrF5sEGg4V/4n80YBwWU5c8xpSDtkzKgkg4Zo1ThxHl3gb12Ph
	 YuR37/5E6KSBQ==
Message-ID: <sashiko-outbox-211932@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 1/6] soc: qcom: ice: Add OPP-based clock scaling
 support for ICE
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abhinaba Rakshit" <abhinaba.rakshit@oss.qualcomm.com>, "Abel Vesa" <abelvesa@kernel.org>, "Bjorn
 Andersson" <andersson@kernel.org>, "Konrad Dybcio" <konradybcio@kernel.org>, "Manivannan
 Sadhasivam" <mani@kernel.org>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin
 K. Petersen" <mkp@kernel.org>, "Adrian Hunter" <adrian.hunter@intel.com>, "Ulf
 Hansson" <ulfh@kernel.org>, "Rob Herring" <robh@kernel.org>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Conor Dooley" <conor+dt@kernel.org>, "Neeraj
 Soni" <neeraj.soni@oss.qualcomm.com>, "Harshal Dev" <harshal.dev@oss.qualcomm.com>, "Kuldeep
 Singh" <kuldeep.singh@oss.qualcomm.com>
Cc: linux-crypto@vger.kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, "Abel
 Vesa" <abel.vesa@oss.qualcomm.com>
In-Reply-To: <20261113-enable-ice-clock-scaling-v13-1-258dc817bd63@oss.qualcomm.com>
References: <20261113-enable-ice-clock-scaling-v13-0-258dc817bd63@oss.qualcomm.com>
 <20261113-enable-ice-clock-scaling-v13-1-258dc817bd63@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 23:09:08 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] soc: qcom: ice: qcom_ice_probe() fails with -EOPNOTSUPP when
  !CONFIG_PM_OPP
- [Medium] soc: qcom: ice: unreleased OPP power-domain vote in
  qcom_ice_suspend()
--

commit 9800ed91573a2f35826acc3c3e7577fb8636aaef
Author: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>

soc: qcom: ice: Add OPP-based clock scaling support for ICE

This commit registers an optional OPP table for the ICE device during
probe and introduces qcom_ice_scale_clk() to scale the ICE core clock via
the PM OPP framework.

> diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
> index f9ac45505908f..2259dbecb8b51 100644
> --- a/drivers/soc/qcom/ice.c
> +++ b/drivers/soc/qcom/ice.c

[ ... ]

> @@ -560,6 +562,50 @@ int qcom_ice_import_key(struct qcom_ice *ice,
>  }
>  EXPORT_SYMBOL_GPL(qcom_ice_import_key);
> =20
> +/**
> + * qcom_ice_scale_clk() - Scale ICE clock for DVFS-aware operations
> + * @ice: ICE driver data
> + * @target_freq: requested frequency in Hz
> + * @round_ceil: when true, selects nearest freq >=3D @target_freq;
> + *              otherwise, selects nearest freq <=3D @target_freq
> + *
> + * Selects an OPP frequency based on @target_freq and the rounding direc=
tion
> + * specified by @round_ceil, then programs it using dev_pm_opp_set_rate(=
),
> + * including any voltage or power-domain transitions handled by the OPP
> + * framework.
> + *
> + * Return: 0 on success; -EOPNOTSUPP if no OPP table; or errno from
> + *         dev_pm_opp_set_rate()/OPP lookup.
> + */
> +int qcom_ice_scale_clk(struct qcom_ice *ice, unsigned long target_freq,
> +		       bool round_ceil)
> +{
> +	unsigned long ice_freq =3D target_freq;
> +	struct dev_pm_opp *opp;
> +	int ret;
> +
> +	if (!ice->has_opp)
> +		return -EOPNOTSUPP;
> +
> +	if (round_ceil)
> +		opp =3D dev_pm_opp_find_freq_ceil(ice->dev, &ice_freq);
> +	else
> +		opp =3D dev_pm_opp_find_freq_floor(ice->dev, &ice_freq);
> +
> +	if (IS_ERR(opp))
> +		return PTR_ERR(opp);
> +	dev_pm_opp_put(opp);
> +
> +	ret =3D dev_pm_opp_set_rate(ice->dev, ice_freq);
> +	if (ret) {
> +		dev_err(ice->dev, "Unable to scale ICE clock rate\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(qcom_ice_scale_clk);

[Severity: Medium]
Does the performance state vote set here by dev_pm_opp_set_rate() stay
asserted when ICE suspends?

When dev_pm_opp_set_rate() scales up the clock, it sets the required-opps
performance state on ice->dev's power domain (and its parent RPMHPD_CX).
genpd only drops a device's performance state in genpd_runtime_suspend(),
but runtime PM is never enabled on ice->dev, and qcom_ice_suspend() only
disables iface_clk and core_clk without calling
dev_pm_opp_set_rate(ice->dev, 0):

drivers/soc/qcom/ice.c:qcom_ice_suspend() {
	clk_disable_unprepare(ice->iface_clk);
	clk_disable_unprepare(ice->core_clk);
	ice->hwkm_init_complete =3D false;

	return 0;
}

Once a storage consumer scales the ICE clock, the CX rail vote remains
elevated across both runtime suspend and system suspend.

>  static struct qcom_ice *qcom_ice_create(struct device *dev,
>  					void __iomem *base)
>  {
> @@ -738,6 +784,7 @@ static int qcom_ice_probe(struct platform_device *pde=
v)
>  	unsigned long phandle =3D pdev->dev.of_node->phandle;
>  	struct qcom_ice *engine;
>  	void __iomem *base;
> +	int err;
> =20
>  	guard(mutex)(&ice_mutex);
> =20
> @@ -756,6 +803,34 @@ static int qcom_ice_probe(struct platform_device *pd=
ev)
>  		return PTR_ERR(engine);
>  	}
> =20
> +	err =3D devm_pm_opp_set_clkname(&pdev->dev, "core");
> +	if (err && err !=3D -ENOENT) {
> +		dev_err(&pdev->dev, "Unable to set core clkname to OPP-table\n");
> +		/* Store the error pointer for devm_of_qcom_ice_get() */
> +		xa_store(&ice_handles, phandle, ERR_PTR(err), GFP_KERNEL);
> +		return err;
> +	}
> +
> +	/* OPP table is optional */
> +	err =3D devm_pm_opp_of_add_table(&pdev->dev);
> +	if (err && err !=3D -ENODEV) {
> +		dev_err(&pdev->dev, "Invalid OPP table in Device tree\n");
> +		/* Store the error pointer for devm_of_qcom_ice_get() */
> +		xa_store(&ice_handles, phandle, ERR_PTR(err), GFP_KERNEL);
> +		return err;
> +	}
> +
> +	/*
> +	 * The OPP table is optional. devm_pm_opp_of_add_table() returns
> +	 * -ENODEV when no OPP table is present in DT, which is not treated
> +	 * as an error. Therefore, track successful OPP registration only
> +	 * when err is not -ENODEV.
> +	 */
> +	if (err =3D=3D -ENODEV)
> +		dev_dbg(&pdev->dev, "ICE OPP table is not registered, please update yo=
ur DT\n");
> +	else
> +		engine->has_opp =3D true;

[Severity: Medium]
Does qcom_ice_probe() fail with -EOPNOTSUPP when CONFIG_PM_OPP is
disabled?

QCOM_INLINE_CRYPTO_ENGINE does not select or depend on PM_OPP.  When
CONFIG_PM_OPP is disabled, the stubs for devm_pm_opp_set_clkname() and
devm_pm_opp_of_add_table() in include/linux/pm_opp.h both return
-EOPNOTSUPP.  Because the error checks only allow -ENOENT and -ENODEV,
qcom_ice_probe() stores ERR_PTR(-EOPNOTSUPP) in ice_handles and fails,
preventing ufs-qcom and sdhci-msm from using inline crypto.  Also, if
-EOPNOTSUPP is ignored above, the final check needs to test !err before
setting engine->has_opp =3D true so it is not set when CONFIG_PM_OPP is
disabled.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-enable-ice=
-clock-scaling-v13-0-258dc817bd63@oss.qualcomm.com?part=3D1

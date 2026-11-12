Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794524669;
	b=l+itygsd9Ao6w6LrVPnUplCF3wH3OBpoUOLvjzszWzSoE5zP0RLsVCph+C4VCx5cSsK9
	 liBlt6aMLbqlfbipB8n/3pT3UgoV8kY0F+VZSfzWql3lub+d9xF8zOSXU7gEoLvl6JNxC
	 oviySz1bHcNqLBeVXOvBlRE161Oddl0O7dpvOZa6+1xdVm8suozmIcq9lJYGALUL9GqQM
	 BsbPZhDvyeTT20RMp6WiZ4UR1/TBkfKQYYwzVtxgFmvv3Bv1eqzlWIAuqtS6267UDwStr
	 9cDX1mM3jA6CP1Iq3asPu0pw3f0UGbllBJnd+UXF+wE+6GG/ReSd1HoBxhPCfI32pQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794524669;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=LBC5CqaXNjmx4Mk3+qdy585NZSSUhYZZJEC7EgbvyFQ=;
	b=mXeCdNTM/pKAnGRE7Ibbzj3ywrxYnXwHUIKwlYboP+Np9CMnIeKMCJJQQv5XpIa4i/Vp
	 BkDThczDdKrDzZdpKFnTOJXqljfsA9bbJcBiV/qHPJLiP7GO5QPP5U42/Dx1/w899rlcZ
	 VYMb4YCYO571RI/aGSXT39eJcjtwiL91KDctma5BbFU5+AjZrWieoJ4hD8OlXNZ2lFZGh
	 OeD8fsHkKM8kvsO/nwkPYcY14HNuZUQ3V2bsVRNoqtZfVJPP6g+uSZzaeIQx87b1rBqf3
	 cyUqwI+dGXWcuWYjTymkysNMgP5WOE2q0sSO5kMkST4JKbPj7NglFw/G/uGsEJOIwHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XgTbs8Bp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7FA8606A323;
	Thu, 12 Nov 2026 23:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XgTbs8Bp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3BCC1F000C4;
	Thu, 12 Nov 2026 23:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794524669;
	bh=LBC5CqaXNjmx4Mk3+qdy585NZSSUhYZZJEC7EgbvyFQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XgTbs8Bp0pOSGxIF4FdPFLqSLBtyXLhzqKNu7HUHZH4rtgTc+rba/0R/91b2BN8Ne
	 D7I5tSCOTfsWW97aiX0xnQzg0gL3RkzOriXbTeR8pb/QkBEEyPjOSxs2xo8XlN2a3R
	 5anaxLlvThUJeS6fxtax7OYg4Zx+kTzpvi1lWj0WmNREbgLcY2im2+klLRwT5kABqG
	 xQ3TLavy3IU7YwAcaagLKPI0LVAd44Qefc3+vjUCqhwSH3xzd13ets0KXc8BD3zA2K
	 hBJ/rP4YNJnarw80rUEUU6ytDKsLCIOGzR5ZavyB3Q2H+hh7NbSJQ/VsMC3mdouIJv
	 v2mTFjCpowPJg==
Message-ID: <sashiko-outbox-211931@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 3/6] mmc: sdhci-msm: Set ICE clk to TURBO at sdhci
 ICE init
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abhinaba Rakshit" <abhinaba.rakshit@oss.qualcomm.com>, "Abel Vesa" <abelvesa@kernel.org>, "Bjorn
 Andersson" <andersson@kernel.org>, "Konrad Dybcio" <konradybcio@kernel.org>, "Manivannan
 Sadhasivam" <mani@kernel.org>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin
 K. Petersen" <mkp@kernel.org>, "Adrian Hunter" <adrian.hunter@intel.com>, "Ulf
 Hansson" <ulfh@kernel.org>, "Rob Herring" <robh@kernel.org>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Conor Dooley" <conor+dt@kernel.org>, "Neeraj
 Soni" <neeraj.soni@oss.qualcomm.com>, "Harshal Dev" <harshal.dev@oss.qualcomm.com>, "Kuldeep
 Singh" <kuldeep.singh@oss.qualcomm.com>
Cc: linux-crypto@vger.kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, "Konrad
 Dybcio" <konrad.dybcio@oss.qualcomm.com>, "Abel Vesa" <abel.vesa@oss.qualcomm.com>
In-Reply-To: <20261113-enable-ice-clock-scaling-v13-3-258dc817bd63@oss.qualcomm.com>
References: <20261113-enable-ice-clock-scaling-v13-0-258dc817bd63@oss.qualcomm.com>
 <20261113-enable-ice-clock-scaling-v13-3-258dc817bd63@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 23:04:28 +0000
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
- [Medium] mmc: sdhci-msm: unreleased ICE OPP vote in
  sdhci_msm_ice_init()
- [Low] mmc: sdhci-msm: unused !CONFIG_MMC_CRYPTO stub for
  sdhci_msm_ice_scale_clk()
--

commit a5619e66f640a05fe76cc365285b6b0e44623197
Author: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>

mmc: sdhci-msm: Set ICE clk to TURBO at sdhci ICE init

This commit scales the Inline Crypto Engine (ICE) clock to its maximum
frequency via qcom_ice_scale_clk() during sdhci_msm_ice_init() so that it
matches the MMC controller clock rate.

> diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
> index 32b1bcba47d6b..652c5cfc87bcc 100644
> --- a/drivers/mmc/host/sdhci-msm.c
> +++ b/drivers/mmc/host/sdhci-msm.c
> @@ -1902,6 +1902,16 @@ static void sdhci_msm_set_clock(struct sdhci_host =
*host, unsigned int clock)
> =20
>  static const struct blk_crypto_ll_ops sdhci_msm_crypto_ops; /* forward d=
ecl */
> =20
> +static int sdhci_msm_ice_scale_clk(struct sdhci_msm_host *msm_host,
> +				   unsigned long target_freq,
> +				   bool round_ceil)
> +{
> +	if (msm_host->mmc->caps2 & MMC_CAP2_CRYPTO)
> +		return qcom_ice_scale_clk(msm_host->ice, target_freq, round_ceil);
> +
> +	return 0;
> +}
> +
>  static int sdhci_msm_ice_init(struct sdhci_msm_host *msm_host,
>  			      struct cqhci_host *cq_host)
>  {
> @@ -1960,6 +1970,11 @@ static int sdhci_msm_ice_init(struct sdhci_msm_hos=
t *msm_host,
> =20
>  	mmc->caps2 |=3D MMC_CAP2_CRYPTO;
>  	mmc->caps2 |=3D MMC_CAP2_CRYPTO_NO_REPROG;
> +
> +	err =3D sdhci_msm_ice_scale_clk(msm_host, ULONG_MAX, false);
> +	if (err && err !=3D -EOPNOTSUPP)
> +		dev_warn(dev, "Unable to boost ICE clock to TURBO\n");
> +
>  	return 0;
>  }

[Severity: Medium]
As reported by Ulf Hansson on v12 [1], does this leave the OPP and
power-domain performance vote on msm_host->ice->dev permanently asserted?

On platforms with a standalone sdhc_ice device and an OPP table with
required-opps (such as sc7280 and qcs8300), qcom_ice_scale_clk() calls
dev_pm_opp_set_rate(ice->dev, ...), which votes on the shared CX power
domain.  Because qcom_ice_probe() does not enable runtime PM on ice->dev,
genpd never drops this performance state automatically.

In sdhci_msm_runtime_suspend(), the driver drops the controller's own vote
with dev_pm_opp_set_rate(dev, 0), but sdhci_msm_ice_suspend() only calls
qcom_ice_suspend() to gate the ICE clocks.  The vote on ice->dev is also
left active if cqhci_init() or __sdhci_add_host() fails after
sdhci_msm_ice_init(), or when sdhci_msm_remove() unbinds the driver,
keeping the shared CX rail elevated during idle and system suspend.

> @@ -2160,6 +2175,13 @@ sdhci_msm_ice_suspend(struct sdhci_msm_host *msm_h=
ost)
>  static inline void sdhci_msm_ice_restore(struct sdhci_host *host)
>  {
>  }
> +
> +static inline int
> +sdhci_msm_ice_scale_clk(struct sdhci_msm_host *msm_host, unsigned long t=
arget_freq,
> +			bool round_ceil)
> +{
> +	return 0;
> +}
>  #endif /* !CONFIG_MMC_CRYPTO */

[Severity: Low]
This isn't a bug, but sdhci_msm_ice_scale_clk() has no callers outside the
CONFIG_MMC_CRYPTO block.  Its only caller is sdhci_msm_ice_init() right
after setting mmc->caps2 |=3D MMC_CAP2_CRYPTO, so this stub is unused and
sdhci_msm_ice_init() could call qcom_ice_scale_clk() directly.

[1] https://lore.kernel.org/r/CAPx+jO_Ltc6Q+VdUgOs81azTiM5Vx12GH1z+CXt6NW=
=3DM601THQ@mail.gmail.com

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-enable-ice=
-clock-scaling-v13-0-258dc817bd63@oss.qualcomm.com?part=3D3

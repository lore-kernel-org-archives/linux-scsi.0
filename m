Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795599122;
	b=CobFQ1vxsQZxeSG+y6NocHeZT7dlI2qnydBooTQ/A75CVwmCxLiXZgpWzD9f2dwmA+Sd
	 sN2BXQk/naHhSQr/+D7jdSKga7SlVj2rpx3nHpZNbFac5TxuoSMDioYp1SlOrU17afT8n
	 KFnKPvVVNJvNsiZEQn7yYK1lkokstjU6+Rh0xYpS3MdPFBju/LI0w2hyZ6RG4DpqNex7v
	 N6UFt3v0HnzvLKVC7gi+0Zq88hRuPalzwne24wENjmX3sXuRn2DXgTJSHr1mtuaBiHnLK
	 IYHmOx2uZ/Jj0ZjZIEDQnWznw0edFsOMQHROsN9PI2LHgZdHEQ/vPe0XXbsF9iFCeCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795599122;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Gzo91x73SKraat1LEk73cxF6DkIMxJc2+MGb22Us5Is=;
	b=jzhiix5J488D4P07yshKzIMjwoa1OSFWK39cubgmPwcnxzU0aewf0Ygt+TDcwc7leSXH
	 /H1tVaWsItwwDIwoAwHTklrpEr6b53IIn/v2TZ54EOnlFixuLqLa54+sPi+I8vUULS+WG
	 xgDznXjQCnbnC+IbgAWiqBfhruz+lA23cVBcaP4bxRFITWZ2aIKsf1VQy/q1T6pcHzh4P
	 LydgquSVCoXsbw+M6wnuIyUj8l+ml/8co1iEM9Wg/7t74SiUG++tyyMHdK9WnfxLRZA3w
	 odGYQJbsojvzgfNz6wVlpAhZ73FtctHqrg5atI8Ce5/etDctKOz1z2ooo7z1XvIXtFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=koFLr2+u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66557606A323;
	Wed, 25 Nov 2026 09:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=koFLr2+u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E50E31F000C6;
	Wed, 25 Nov 2026 09:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795599122;
	bh=Gzo91x73SKraat1LEk73cxF6DkIMxJc2+MGb22Us5Is=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=koFLr2+uT3JaQb0arVYS4qixD4K59wo8RAtor2UkKI3hoJF3/gWNvvLAUysiM340W
	 idl+2a5UhC7vqWBvGlw/7la23WCyqyKmzURrBeTJllyqwN7dkpwcnIUkbcwtziS8AG
	 jjv/fJWl0OmcnErYDLjP9Fzrw7wpERWzPfn+QZdzdryPwKckj7aXpnN+nUUWy+uOtW
	 WvwTW4f5Ent82qmr8IL7QRtfpe3rXnpQPCWs4Rd6REp3Gi71lGSXQ/Hm+FJSTVCU3n
	 ZN4rmU+Z+dc+8q2Pyum18lXznT2TwHtufoIgGMH8NGAzGIhsDfMxhw6nMQ2seZPmhz
	 1SiwPIzsDUHLA==
Message-ID: <sashiko-outbox-233012@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/2] scsi: ufs: core: Support "ref" clock name
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ajay Neeli" <ajay.neeli@amd.com>
Cc: linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, robh@kernel.org, conor+dt@kernel.org
In-Reply-To: <20261125092351.2807658-2-ajay.neeli@amd.com>
References: <20261125092351.2807658-1-ajay.neeli@amd.com>
 <20261125092351.2807658-2-ajay.neeli@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 09:32:01 +0000
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
- [High] scsi: ufs: missing ref clock name check in ufshcd_init_clocks()
- [Medium] scsi: ufs: missing ref clock name check in
  ufshcd_parse_operating_points()
--

commit 4196a48351e8b590f1bfcc4bbd914e822554236d
Author: Ajay Neeli <ajay.neeli@amd.com>

scsi: ufs: core: Support "ref" clock name

This commit updates ufshcd_parse_clock_info() to also match the "ref"
clock name when setting keep_link_active on the reference clock.

> diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-p=
ltfrm.c
> index 169dbc1a75fe5..947edcd886680 100644
> --- a/drivers/ufs/host/ufshcd-pltfrm.c
> +++ b/drivers/ufs/host/ufshcd-pltfrm.c
> @@ -96,7 +96,7 @@ static int ufshcd_parse_clock_info(struct ufs_hba *hba)
>  			goto out;
>  		}
> =20
> -		if (!strcmp(name, "ref_clk"))
> +		if (!strcmp(name, "ref") || !strcmp(name, "ref_clk"))
>  			clki->keep_link_active =3D true;
>  		dev_dbg(dev, "%s: min %u max %u name %s\n", "freq-table-hz",
>  				clki->min_freq, clki->max_freq, clki->name);

[Severity: High]
Should ufshcd_init_clocks() also check for "ref" when detecting the
device reference clock frequency?

drivers/ufs/core/ufshcd.c:ufshcd_init_clocks() {
    ...
		if (!strcmp(clki->name, "ref_clk"))
			ufshcd_parse_dev_ref_clk_freq(hba, clki->clk);
    ...
}

When the clock is named "ref", ufshcd_parse_dev_ref_clk_freq() is skipped
and hba->dev_ref_clk_freq remains REF_CLK_FREQ_INVAL unless a separate
ref-clk-freq property is present, so ufshcd_set_dev_ref_clk() will not
program the UFS device bRefClkFreq attribute before switching to
High-Speed mode.

[Severity: Medium]
Does ufshcd_parse_operating_points() in this file need the same "ref"
check?

drivers/ufs/host/ufshcd-pltfrm.c:ufshcd_parse_operating_points() {
    ...
		if (!strcmp(clk_names[i], "ref_clk"))
			clki->keep_link_active =3D true;
    ...
}

On platforms that use operating-points-v2 instead of freq-table-hz,
ufshcd_parse_clock_info() exits early and ufshcd_parse_operating_points()
populates hba->clk_list_head, leaving keep_link_active false for a "ref"
clock and allowing __ufshcd_setup_clocks() to disable the reference clock
while the link is active.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125092351.2807=
658-1-ajay.neeli@amd.com?part=3D1

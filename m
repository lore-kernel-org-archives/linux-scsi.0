Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794524213;
	b=Bkw2bELt/W9u8ixtqjTk/VVTwRTL60S4jXOOZryVb/QOEKgR1KF+B5eueI2zG2uJyNZn
	 ncX9iUwGCXbh8jVMyu+pIC3FClSdazCKfdzUGGIkG71qL/U5XLY1XWG3bWu3awRPTRZZG
	 sDOMvwRDBOdkOehXeIhbiGzqPoSlotGjkbK5jwNap+OJh5W1mYdko1DP+YuShMncBQzC9
	 Q9NPRzazqU8Fh13CXvr5IdP9HuYdXox9hlk0YEeXGf+GTjnFCACocx6HB68op72Z0h+59
	 s98+kaPVvdn/q1rXH3fWksJbbcPbo+d7gSk/CTBO2iVJlw5k7MEFaxeYhhC8+L2kvhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794524213;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=eJhWTrmqLRqHBM4fVhRFrfaab4xR8zdIkxlqDM0Yiwc=;
	b=4Rug215eyvpa1TgOCnjdMux83sbol8vm3TVNW5zgKzOPhfGKTdyLNS/gw6HbPNikofTY
	 3QzrH03yUV5qyGXKBDTQLjhajjC5aN6ESahY6HqAQOWl/Z585twWmHMnHfE5wR5oNFrRP
	 SmDoaG0Ux2OuGHRvPlEPwd4txz12vetWj9mG0SKHa+hjVEZPp0+0PO1tNKEUya/0C6SeW
	 j3zXWXAi68H1kNtCP9eKax8E6gHGjeSJL+ji9vYISsJfoFEuBRH96M57/3MwS/nb/gE+c
	 QBKw9hWYo15JQS8CbJXas0hIEcGUjM9n3qoNPqcqv0sfMAOBMPjZJyviHRsIJ//l7Jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lC+hnXEw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17161606A880;
	Thu, 12 Nov 2026 22:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lC+hnXEw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C56591F000C4;
	Thu, 12 Nov 2026 22:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794524212;
	bh=eJhWTrmqLRqHBM4fVhRFrfaab4xR8zdIkxlqDM0Yiwc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lC+hnXEwnAgb8ctl9z7EYZYZpA3LWljHir0uNHCqqQNvO7/GiRwYeH5fP/luqTBSh
	 roxpCn+jL4SEW6bY6hZWSPJAXnB7AYCm9VuQhQJWOmC0rcfmwAQDt6VmOF1Sfu7JT5
	 vrWfGOmwSIsqe9KpwZ43Q93cVbU6xY+BllQ1ZjsD8j4VgPwxl7QzWlkqeW0V2xlZ0m
	 9i+/7/p06n1KobxfInxpcV3oJj595tmatLtqNPBz90Kj7pItxo9os3Tyy3crl3OpS9
	 7sKcLD3bor3Vn/UqbboN8+bi2UA4cLml8btLytpMoqjVdHHAre6Tv1CJyp0cAaHbcZ
	 denjH/o8/PuFw==
Message-ID: <sashiko-outbox-211928@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 2/6] ufs: host: Add ICE clock scaling during UFS
 clock changes
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
In-Reply-To: <20261113-enable-ice-clock-scaling-v13-2-258dc817bd63@oss.qualcomm.com>
References: <20261113-enable-ice-clock-scaling-v13-0-258dc817bd63@oss.qualcomm.com>
 <20261113-enable-ice-clock-scaling-v13-2-258dc817bd63@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 22:56:51 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [High] ufs: ufs-qcom: inverted ICE clock rounding in
  ufs_qcom_clk_scale_notify()
- [Medium] ufs: ufs-qcom: ICE clock scaling skipped when HBA is inactive
  on reset
- [Medium] ufs: ufs-qcom: broken clock rollback on error in
  ufs_qcom_clk_scale_notify()
--

commit 1e3a20c6222c6ad3d20e8e58d3a121e1fa7488c1
Author: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>

ufs: host: Add ICE clock scaling during UFS clock changes

This commit adds Inline Crypto Engine (ICE) clock scaling to
ufs_qcom_clk_scale_notify() so the ICE clock scales alongside the UFS
controller clock.

> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 6afb8498b8c26..5019803a6aba4 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
[ ... ]
> @@ -1987,6 +2002,12 @@ static int ufs_qcom_clk_scale_notify(struct ufs_hb=
a *hba, bool scale_up,
>  			return err;
>  		}
> =20
> +		err =3D ufs_qcom_ice_scale_clk(host, target_freq, !scale_up);
> +		if (err && err !=3D -EOPNOTSUPP) {
> +			ufshcd_uic_hibern8_exit(hba);
> +			return err;
> +		}
> +
>  		ufs_qcom_icc_update_bw(host);
>  		ufshcd_uic_hibern8_exit(hba);
>  	}

[Severity: High]
Is the round_ceil argument (!scale_up) inverted in this
ufs_qcom_ice_scale_clk() call?

qcom_ice_scale_clk() calls dev_pm_opp_find_freq_ceil() when round_ceil
is true and dev_pm_opp_find_freq_floor() when round_ceil is false, while
target_freq is the concrete UFS core_clk frequency in Hz.  On SoCs where
ICE OPP rates are higher than the corresponding UFS core_clk rates for
the same voltage corners (for example on QCS8300 or SM8550, where UFS
core_clk OPPs are 75/150/300 MHz and ICE OPPs are 100/201.5/403 MHz),
passing round_ceil =3D false during scale_up rounds 300 MHz down to
201.5 MHz, so the ICE clock never reaches its 403 MHz nominal OPP.
Scaling up to an intermediate OPP such as 150 MHz also picks 100 MHz
while scaling down to 150 MHz picks 201.5 MHz, and scaling up to a
frequency below the minimum ICE OPP (such as 75 MHz on SM8550) fails with
-ERANGE and aborts UFS clock scaling.

[Severity: Medium]
Does placing ufs_qcom_ice_scale_clk() after the !ufshcd_is_hba_active()
early return in ufs_qcom_clk_scale_notify() skip ICE clock scaling during
host reset and restore?

ufshcd_host_reset_and_restore() stops the HBA before scaling the clocks
back to maximum:

drivers/ufs/core/ufshcd.c:ufshcd_host_reset_and_restore() {
    ...
	ufshcd_hba_stop(hba);
	hba->silence_err_logs =3D true;
	ufshcd_complete_requests(hba, true);
	hba->silence_err_logs =3D false;

	/* scale up clocks to max frequency before full reinitialization */
	if (ufshcd_is_clkscaling_supported(hba))
		ufshcd_scale_clks(hba, ULONG_MAX, true);
    ...
}

Because ufshcd_is_hba_active(hba) is false at that point,
ufs_qcom_clk_scale_notify() returns 0 immediately to avoid sending UIC
Hibern8 commands.  Unlike the UFS timers, UniPro clock control and
interconnect bandwidth, the ICE clock is not reconfigured during the
subsequent ufshcd_hba_enable() and link startup, leaving the ICE clock at
its previous lower OPP while the UFS controller runs at maximum
frequency.

[Severity: Medium]
If ufs_qcom_ice_scale_clk() returns an error here, does the error path
leave the UFS timer and UniPro clock control registers out of sync with
the reverted clock rate?

By the time ufs_qcom_ice_scale_clk() runs in POST_CHANGE,
ufs_qcom_clk_scale_up_pre_change() or
ufs_qcom_clk_scale_down_post_change() has already programmed
REG_UFS_SYS1CLK_1US, DME_VS_CORE_CLK_CTRL and PA_VS_CORE_CLK_40NS_CYCLES
for target_freq.  On error, ufs_qcom_clk_scale_notify() exits Hibern8 and
returns err, causing ufshcd_scale_clks() to roll the UFS clocks back to
previous_freq while the link is active and without restoring those
hardware registers to match previous_freq.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-enable-ice=
-clock-scaling-v13-0-258dc817bd63@oss.qualcomm.com?part=3D2

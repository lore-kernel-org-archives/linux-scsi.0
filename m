Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795102003;
	b=hkl7wa1sr35jxtFERO1ms2cRB+pTNSifaKtO8maiA7Vbg1+EY2vrlNIr3Ng/2LDNzeo/
	 BhewT4tFtV0YPozvTvWqwrUX3x/SWGkJMG0VXgfLs6jutt/IGhFukFJwWZU3W/mzxXEwt
	 uyRDAez0xa60+x7UqTFRA7ysZYdAD3DGxYQ/FSdb8u4zDtROKWQY9tAXjmsr+PLGbPARr
	 /jJUTz/gXcZcsbkraNnGMoy6YNzw351fRAhJ2Jvx8a3o6jHQhFfPpgj5FnRwowJbx7x8j
	 4BRDjWOnUtThxjW/FQ+qJPoeAGIFYOdT4RF0cKFm8X4qGdeC8nU4HmwyNJKZ80539Xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795102003;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=w5xpY7nzvsPGQqyIoOdUke8GvoCz7BF4Gu6054u1XQc=;
	b=YFe5NkKC4QGEvbKI2xcWrUVy9vLXDHEs/9jTLMjCJXeRNxVtm74XRItPtsJkp2lgxDce
	 7bb/TDZQb90u3Isock8BujzRIbVD+fvTcqJYPbdx2f2zAoJJV9MQPPLH3nYrNYUynEVhA
	 /VGd4cU59UXEpK6CwRyiNyU6yX8VVG9BW8ruc2JtUkTyoHmiwH1jf63WjuTd6vEfRm5/a
	 PQ5Dfisx106TLN4HVy3ojR4DWfLlMV4zUPBI/yN6MerHg3VYeIWUOeQYI0HhszIwlsrOQ
	 w2NccQuiiXx4m/VVuVXRpRvw9vWOe0VjPfSLvpYJj6pHwTKvmv7uCm1uqjdGEj3oTlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YCAELgZL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20794606A320;
	Thu, 19 Nov 2026 15:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YCAELgZL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301C91F000C4;
	Thu, 19 Nov 2026 15:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795102002;
	bh=w5xpY7nzvsPGQqyIoOdUke8GvoCz7BF4Gu6054u1XQc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YCAELgZLnyccb+gqD/QJgU2oBXlle/EsPEtwMYZxow1Mkv+RQ/0penhOKQCnQcJOZ
	 RvjRW8uBgm3mO8mHp0buX9RKvHPAbtncJYRcZxHFYDBHjnjvoGjFzSYRvxyczLPCJJ
	 yMW79LUytWT/LzP05FRDSmJew0bOpqm9y4lDeZf75qg92eX5GGGe5lNNJ3DNosV72m
	 Qnbrq8fV1s3ca1pDcu3D2I5OXd/JWxvNuYWPdVNiAv1UB47A6Y2P9QHGw3XrNsyVtT
	 J1+DHlsef9P9qcIY2UNBCpnD7Z3i2q2xI1uEp9CJ/DXeArw5Ywwo9/i3eWL3rmqhoA
	 HwopVspC2Fe3Q==
Message-ID: <sashiko-outbox-223382@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v15 14/23] scsi: ufs: mediatek: Use the common PHY
 framework
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis-Alexis Eyraud" <louisalexis.eyraud@collabora.com>
Cc: linux-phy@lists.infradead.org, devicetree@vger.kernel.org, linux-scsi@vger.kernel.org, robh@kernel.org, conor+dt@kernel.org, vkoul@kernel.org, neil.armstrong@linaro.org, olteanv@gmail.com
In-Reply-To: <20261119-mt8196-ufs-v15-14-aae1eb0382e8@collabora.com>
References: <20261119-mt8196-ufs-v15-0-aae1eb0382e8@collabora.com>
 <20261119-mt8196-ufs-v15-14-aae1eb0382e8@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 15:26:41 +0000
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
- [High] scsi: ufs: mediatek: premature phy_exit() and power leak in
  ufs_mtk_exit()
- [High] scsi: ufs: mediatek: missing error rollback in
  ufs_mtk_runtime_suspend()
- [Medium] scsi: ufs: mediatek: PHY power leak and error in
  ufs_mtk_runtime_resume()
--

commit dd9f3229e4978dc4fda07cd42dec5399df0226ee
Author: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

scsi: ufs: mediatek: Use the common PHY framework

This commit switches the MediaTek UFS driver from manual OF PHY device
handling in probe and runtime PM to acquiring and managing the PHY via
the common PHY framework in the ufshcd variant callbacks.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-media=
tek.c
> index fec0fb24e7a2c..a78e015e329a5 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c

[ ... ]

> @@ -1321,11 +1291,22 @@ static int ufs_mtk_init(struct ufs_hba *hba)
> =20
>  	return 0;
> =20
> +out_phy_exit:
> +	phy_exit(host->mphy);
>  out_variant_clear:
>  	ufshcd_set_variant(hba, NULL);
>  	return err;
>  }
> =20
> +static void ufs_mtk_exit(struct ufs_hba *hba)
> +{
> +	struct ufs_mtk_host *host =3D ufshcd_get_variant(hba);
> +
> +	ufs_mtk_mphy_power_on(hba, false);
> +
> +	phy_exit(host->mphy);
> +}

[Severity: High]
Does ufs_mtk_exit() call phy_exit(host->mphy) while a second
phy_power_on() reference is still held?

ufs_mtk_init() acquires two phy_power_on() references on host->mphy: one
in ufs_mtk_mphy_power_on(hba, true) and another in
ufs_mtk_setup_clocks(hba, true, POST_CHANGE) via
ufs_mtk_pwr_ctrl(hba, true).  During teardown, ufshcd_hba_exit() invokes
ufshcd_vops_exit(hba) before ufshcd_setup_clocks(hba, false):

drivers/ufs/core/ufshcd.c:ufshcd_hba_exit() {
	...
		ufshcd_exit_clk_gating(hba);
		if (hba->eh_wq)
			destroy_workqueue(hba->eh_wq);
		ufs_debugfs_hba_exit(hba);
		ufshcd_vops_exit(hba);
		ufshcd_setup_vreg(hba, false);
		ufshcd_setup_clocks(hba, false);
	...
}

In ufs_mtk_exit(), ufs_mtk_mphy_power_on(hba, false) drops only one
phy_power_on() reference (leaving mphy->power_count at 1) and turns off
the 0.9V supply before phy_exit(host->mphy) runs.

On driver removal, ufshcd_remove() leaves hba->uic_link_state as
UIC_LINK_ACTIVE_STATE, so the subsequent ufshcd_setup_clocks(hba, false)
skips ufs_mtk_pwr_ctrl(hba, false) and permanently leaks the remaining
phy_power_on() reference, PHY clocks, and runtime PM reference.  On an
early ufshcd_init() failure while the link is still off,
ufshcd_setup_clocks(hba, false) instead calls phy_power_off(host->mphy)
and accesses M-PHY registers after phy_exit() has run and the 0.9V supply
has been disabled.

[ ... ]

> @@ -2522,9 +2467,8 @@ static int ufs_mtk_system_resume(struct device *dev)
>  static int ufs_mtk_runtime_suspend(struct device *dev)
>  {
>  	struct ufs_hba *hba =3D dev_get_drvdata(dev);
> -	struct ufs_mtk_host *host =3D ufshcd_get_variant(hba);
>  	struct arm_smccc_res res;
> -	int ret =3D 0;
> +	int ret;
> =20
>  	ret =3D ufshcd_runtime_suspend(dev);
>  	if (ret)
> @@ -2535,8 +2479,13 @@ static int ufs_mtk_runtime_suspend(struct device *=
dev)
>  	if (ufs_mtk_is_rtff_mtcmos(hba))
>  		ufs_mtk_mtcmos_ctrl(false, res);
> =20
> -	if (host->phy_dev)
> -		pm_runtime_put_sync(host->phy_dev);
> +	if (!ufshcd_is_link_active(hba)) {
> +		ret =3D ufs_mtk_mphy_power_on(hba, false);
> +		if (ret) {
> +			dev_err(dev, "Failed to power off PHY: %pe\n", ERR_PTR(ret));
> +			return ret;
> +		}
> +	}
> =20
>  	return 0;
>  }

[Severity: High]
If ufs_mtk_mphy_power_on(hba, false) fails here, does returning an error
without rolling back leave the controller powered down while runtime PM
considers dev active?

At this point ufshcd_runtime_suspend(dev), ufs_mtk_dev_vreg_set_lpm(hba,
true), and ufs_mtk_mtcmos_ctrl(false, res) have already gated clocks,
disabled interrupts, placed device regulators into LPM, and turned off
MTCMOS.  When a runtime_suspend callback returns an error, rpm_suspend()
aborts the suspend and leaves the device in RPM_ACTIVE, so subsequent I/O
or register accesses will touch unpowered hardware without running
ufs_mtk_runtime_resume().  Also, powering off the PHY after
ufs_mtk_mtcmos_ctrl(false, res) runs in the same order as
ufs_mtk_runtime_resume() rather than the reverse order.

> @@ -2544,14 +2493,17 @@ static int ufs_mtk_runtime_suspend(struct device =
*dev)
>  static int ufs_mtk_runtime_resume(struct device *dev)
>  {
>  	struct ufs_hba *hba =3D dev_get_drvdata(dev);
> -	struct ufs_mtk_host *host =3D ufshcd_get_variant(hba);
>  	struct arm_smccc_res res;
> +	int ret;
> =20
>  	if (ufs_mtk_is_rtff_mtcmos(hba))
>  		ufs_mtk_mtcmos_ctrl(true, res);
> =20
> -	if (host->phy_dev)
> -		pm_runtime_get_sync(host->phy_dev);
> +	ret =3D ufs_mtk_mphy_power_on(hba, true);
> +	if (ret) {
> +		dev_err(dev, "Failed to power on PHY: %pe\n", ERR_PTR(ret));
> +		return ret;
> +	}
> =20
>  	ufs_mtk_dev_vreg_set_lpm(hba, false);
> =20

[Severity: Medium]
Can powering on the M-PHY in ufs_mtk_runtime_resume() leave the PHY and
0.9V supply enabled across system suspend?

If hba->dev runtime-resumes while the ufs_device_wlun child remains
runtime-suspended, ufs_mtk_runtime_resume() sets host->mphy_powered_on
and enables the PHY.  If system suspend then runs before hba->dev
autosuspends (when ufshcd_rpm_ok_for_spm() is true), ufshcd_wl_suspend()
skips ufs_mtk_suspend(), and ufs_mtk_system_suspend() does not call
ufs_mtk_mphy_power_on(hba, false):

drivers/ufs/host/ufs-mediatek.c:ufs_mtk_system_suspend() {
	...
	ret =3D ufshcd_system_suspend(dev);
	if (ret)
		goto out;

	if (pm_runtime_suspended(hba->dev))
		goto out;

	ufs_mtk_dev_vreg_set_lpm(hba, true);

	if (ufs_mtk_is_rtff_mtcmos(hba))
		ufs_mtk_mtcmos_ctrl(false, res);
	...
}

This leaves the M-PHY and 0.9V regulator powered on during system sleep
while MTCMOS and clocks are off.  In addition, if
ufs_mtk_mphy_power_on(hba, true) or ufshcd_runtime_resume(dev) fails in
ufs_mtk_runtime_resume(), the preceding MTCMOS, PHY, and regulator state
changes are not unwound while dev remains RPM_SUSPENDED.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119-mt8196-ufs=
-v15-0-aae1eb0382e8@collabora.com?part=3D14

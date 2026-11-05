Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793853654;
	b=v5FRQxH7mJ7lrRNiyx0lDOqxEYfDmK8idcfcrhQaU+0aS2oIu/0rrwEegweBzPW7LSCn
	 WECy1eV410XcOWyW0ROqodmV7povLbQp5nGAHFQGSrmzA1HUIbpV0/8Ojg/9JKQcYQNlc
	 Wmf3j9g0Yl2Sh/Fbff80Tmdmc1kLFgQH2yPXkyy6JdgpmFu0778Q8muNTmsxGtoMMen09
	 Ru+EW4pa5x8+XYn4rRqaGOy9BN+cppiETQTu9jatg/TAZabb0Aby6EXKT+wXTkvkwDdxj
	 b9WJNGsB57lcm0D7dZN5+F3J2fByUXcdObCaq6rmWcOV9J+/uetrY2VFypFQMIs2feA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793853654;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=8aj/OTXK6mfSDZHsGQDxhL38sFRSrOIcRiYO0l4GYDM=;
	b=VfvnGAdkFzoMmU2je03Kaux1nSLcPjXppmECI/8TESVzywQcoNTR9A2V8r3rutDZPqL3
	 pbH2Ya4stQWEkHEVud7XBYrS0R333MPsiGNti0UcFnapsMuyI+HCjOlfZyC3UGi2BkZMG
	 YLeHhv8bRfAfXkg4GYBwaCzaGEug8doiszWDlhHfv8kZXFwgqaDbHaANwI04fnjirY7uO
	 ZTbOpvYumR0NKZ28mMcU9vU4b3MEXezLTJXw38TMdqB4M6bFOZ6Zfq6NyrSdaLODbxpD0
	 r+R6oUlbjpFhtGvDV1fCQfArS9fkUa2RNumrRor/Lnm+hxMtTnGnpuB53GQmSSeXIeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oZPzGHGM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F29606A32D
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 04:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oZPzGHGM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2271F00A1A;
	Thu,  5 Nov 2026 04:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793853653;
	bh=8aj/OTXK6mfSDZHsGQDxhL38sFRSrOIcRiYO0l4GYDM=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=oZPzGHGMVh/A1p5U38dgzWg/u2dA2o6eRCiBuitzCORrbzd9RqONOTh/3+OdlCzuT
	 S5Ms+BsideEBZ9T95s2N42xdKLNBhBUUBnMlUf1QBeWDoDcMfZpuQ02WxM1+LLLyzC
	 opLte/NikxwTPWu8Kl24YDtYVUfrbUYQ2zLtTzmy7UHYyyUqmbdetllnRsE0GwckCS
	 UQzsvdhY2cuwgw9qWbTUjmPKVIl8xLyVnOtgzG8bbuJgetZH0xF3PP3J9GsLYYkMxj
	 hbQUNR+fNCSvsM73a/lUxqtsOjOxxx5cw3iU5HpodDHb8O+zGG+DmZa9Bsxe9OJ1HH
	 Hn4dH81mAbILA==
Message-ID: <sashiko-outbox-198555@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 2/2] scsi: ufs: core: Limit early link recovery in
 the error handler to runtime PM
Reply-To: sashiko-reviews@lists.linux.dev
To: "HOYOUNG SEO" <hy50.seo@samsung.com>, linux-scsi@vger.kernel.org
In-Reply-To: <a5f3b13e7c2ae3cb39dfd078e637fd6c4424356e.1793851432.git.hy50.seo@samsung.com>
References: <cover.1793851432.git.hy50.seo@samsung.com>
 <CGME20261105042043epcas2p2b8a95dde8509fcf59aebad3be2116bce@epcas2p2.samsung.com>
 <a5f3b13e7c2ae3cb39dfd078e637fd6c4424356e.1793851432.git.hy50.seo@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 04:40:52 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: ufs: core: concurrent error recovery during ufshcd_wl_powero=
ff()
--

commit 6f60eb14bc24b472557f86d1f4db1435491fade7
Author: HOYOUNG SEO <hy50.seo@samsung.com>

scsi: ufs: core: Limit early link recovery in the error handler to runtime =
PM

This commit restricts the early link recovery path in ufshcd_err_handler()
to runtime PM operations by introducing hba->runtime_pm_in_progress, so
that system PM and shutdown use the regular error handling path instead of
resetting the link concurrently.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 3b5580ac390cb..e3908d6af3ae4 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -7089,11 +7089,15 @@ static void ufshcd_err_handler(struct work_struct=
 *work)
>  		 * Use ufshcd_rpm_get_noresume() here to safely perform link
>  		 * recovery even if an error occurs during runtime suspend or
>  		 * runtime resume. This avoids potential deadlocks that could
> -		 * happen if we tried to resume the device while a PM operation
> -		 * is already in progress.
> +		 * happen if we tried to resume the device while a runtime PM
> +		 * operation is already in progress.
> +		 *
> +		 * Do not do this for system PM and shutdown. The system PM
> +		 * callbacks hold host_sem, so the regular path below runs
> +		 * after them instead of resetting the link concurrently.
>  		 */
>  		ufshcd_rpm_get_noresume(hba);
> -		if (hba->pm_op_in_progress) {
> +		if (hba->runtime_pm_in_progress) {
>  			ufshcd_link_recovery(hba);
>  			ufshcd_rpm_put(hba);
>  			return;

[Severity: High]
Can this allow ufshcd_err_handler() to run regular error recovery
concurrently with hibernation poweroff in ufshcd_wl_poweroff()?

During hibernation, the PM core runs .freeze (ufshcd_wl_suspend(), which
takes hba->host_sem) followed by .thaw (ufshcd_wl_resume(), which releases
hba->host_sem) before writing the hibernation image, and then invokes
.poweroff:

drivers/ufs/core/ufshcd.c:ufshcd_wl_poweroff() {
	struct scsi_device *sdev =3D to_scsi_device(dev);
	struct ufs_hba *hba =3D shost_priv(sdev->host);

	__ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM);
	return 0;
}

When ufshcd_wl_poweroff() calls __ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM),
hba->runtime_pm_in_progress is set to false. However, unlike
ufshcd_wl_suspend(), ufshcd_wl_poweroff() does not hold hba->host_sem, and
unlike ufshcd_wl_shutdown(), it does not set hba->shutting_down =3D true.

If an error interrupt schedules hba->eh_work while ufshcd_wl_poweroff() is
running, ufshcd_err_handler() will skip the early return because
hba->runtime_pm_in_progress is false, acquire the uncontended
hba->host_sem, see ufshcd_err_handling_should_stop(hba) return false, and
proceed with ufshcd_err_handling_prepare() and ufshcd_reset_and_restore()
at the same time __ufshcd_wl_suspend() is powering down the device and
link.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1793851432.gi=
t.hy50.seo@samsung.com?part=3D2

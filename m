Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792756804;
	b=zsNrmX4Niu1L4pb9h8xx1oJCzMRghCsnxPigG7Ul5ynVx4rUTk4L7kvKwYcPRVqU2p7P
	 EeZik+IBHoWV5VQQV0aht0DOD4ea1bhiCbMta+H7fTdCJKuyoFDx0yDpefaUOtOzlcZxb
	 TYPiolsTb8bIg/ln5n7qYUb3IDX8vImQvw/lkUb2MH6TfKdv5NY+1KnEeWcTE22Ahw16s
	 u11Ul/uA+wBIUIAC45q3ytD5HG7+brcohKekEpubj2RDZFs9VynYvNGaYBAxFbHHEbrRs
	 sUeZTJV2kngq2WRma+cXJ1o/tDp9m12B9LimBYAeQuquLqPnsftY4Z0T4qCChhzKp3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792756804;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=D7LP8J3tHYKN5i8+EMOCpwo4nHHCnVjhbEVBGnkavOE=;
	b=NLtZ3BIbqRNduWELQJbm8uDPq+bP/Npz0kH+PRXyfzyLl9hber6SCx9V/LvuiS15BcQr
	 KVsmboVC9R4C/4AwN0LzmT6sgy/0f6oEJBko6i6LCXU6vwXI2PPlKLgICCRD3c+bo6v0h
	 7Hv5ROJXHj6KaC2VWXOT0/CUxQLzQjghQbP4KEJvX4ePkTqktQ9BQf6hw2ZWv+JPRlXkx
	 gVYYsOqjirrSB9KD6qW5RG7DIZmlJIqSstbPOzdk6vxn/mr1lIpkskeOXyOiYzsZ/DENH
	 uoIL7N4DJut1m3Ot189IwLaXf1jI2dPsnSUiBBwcKA2IaMIWC3StUcafhiN12c7jdRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AGdMAs08;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CC6606A31A
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 12:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AGdMAs08
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5801F01825;
	Fri, 23 Oct 2026 12:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792756803;
	bh=D7LP8J3tHYKN5i8+EMOCpwo4nHHCnVjhbEVBGnkavOE=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=AGdMAs08h/5MzQXXXaM78oQ7uIcqRdL5jDwa38d6VIbxvd7Ij13Z8qkmEgIuGzxeg
	 gGT7lnKACeLfmek9Vp8wDJicIAq4FmDzTQf+6YM6sQ8tNR3Ezy6aMAMeBFHkhORWo2
	 qC8EFlTSFlGszmA6oFJkBUPxQ4GLpV7woYEVU0dVxN70/NxUCDBGwNcv8z0Hgdw2wr
	 Y0EETfzNBABb4itbSAFgtlowos5VyVuuBpCNHBQKhn67BF25KtGo1wDAqi0BKrNJs/
	 Brkju7XL9wqDz4VEGl9qtROYH5KKBii4dJWmNG5yZdk68ju9g2NkLOt4nruudU7Dux
	 WIkq9aBoLVPdw==
Message-ID: <sashiko-outbox-182747@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] scsi: ufs: core: add is_sys_suspended state
 before recovery
Reply-To: sashiko-reviews@lists.linux.dev
To: "HOYOUNG SEO" <hy50.seo@samsung.com>, linux-scsi@vger.kernel.org
In-Reply-To: <4eabe38e93631579a0cacda137a98053526fe030.1792755091.git.hy50.seo@samsung.com>
References: <cover.1792755091.git.hy50.seo@samsung.com>
 <CGME20261023113911epcas2p44c986c4542ca8bae511086ef4b2ad850@epcas2p4.samsung.com>
 <4eabe38e93631579a0cacda137a98053526fe030.1792755091.git.hy50.seo@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 12:00:01 +0000
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
- [High] scsi: ufs: core: ufshcd_err_handler() skips recovery after failed =
resume
--

commit c53108b377c62c7e01a8b52d302e15dfdce25f17
Author: HOYOUNG SEO <hy50.seo@samsung.com>

scsi: ufs: core: add is_sys_suspended state before recovery

This commit skips the early link recovery in ufshcd_err_handler() when
hba->is_sys_suspended is set so that error recovery waits on hba->host_sem
instead of racing with __ufshcd_wl_resume() during system resume.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 0e6e593c24cfd..4b4d473530b16 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -7052,9 +7052,14 @@ static void ufshcd_err_handler(struct work_struct =
*work)
>  		 * runtime resume. This avoids potential deadlocks that could
>  		 * happen if we tried to resume the device while a PM operation
>  		 * is already in progress.
> +		 *
> +		 * During system resume, host_sem is held from
> +		 * ufshcd_wl_suspend() until ufshcd_wl_resume() returns, so wait
> +		 * for it below instead of recovering the link concurrently with
> +		 * the resume path.
>  		 */
>  		ufshcd_rpm_get_noresume(hba);
> -		if (hba->pm_op_in_progress) {
> +		if (hba->pm_op_in_progress && !hba->is_sys_suspended) {

[Severity: High]
The commit message notes that if system resume fails, hba->is_sys_suspended
stays set and ufshcd_err_handler() performs a full recovery as usual.
However, when ufshcd_err_handler() wakes from down(&hba->host_sem) after
ufshcd_wl_resume() -> __ufshcd_wl_resume() fails, it immediately checks
ufshcd_err_handling_should_stop():

drivers/ufs/core/ufshcd.c:ufshcd_err_handler() {
	down(&hba->host_sem);
	spin_lock_irqsave(&hba->host->host_lock, flags);
	if (ufshcd_err_handling_should_stop(hba)) {
		if (hba->ufshcd_state !=3D UFSHCD_STATE_ERROR)
			hba->ufshcd_state =3D UFSHCD_STATE_OPERATIONAL;
		spin_unlock_irqrestore(&hba->host->host_lock, flags);
		up(&hba->host_sem);
		return;
	}
}

where ufshcd_err_handling_should_stop() is defined as:

drivers/ufs/core/ufshcd.c:ufshcd_err_handling_should_stop() {
	return (!hba->is_powered || hba->shutting_down ||
		!hba->ufs_device_wlun ||
		hba->ufshcd_state =3D=3D UFSHCD_STATE_ERROR ||
		(!(hba->saved_err || hba->saved_uic_err || hba->force_reset ||
		   ufshcd_is_link_broken(hba))));
}

If ufshcd_uic_hibern8_exit() fails in __ufshcd_wl_resume() and the subseque=
nt
call to ufshcd_link_recovery() also fails, ufshcd_link_recovery() sets
hba->ufshcd_state =3D UFSHCD_STATE_ERROR even though it restores hba->saved=
_err
and hba->saved_uic_err:

drivers/ufs/core/ufshcd.c:ufshcd_link_recovery() {
	...
	spin_lock_irqsave(&hba->host->host_lock, flags);
	if (ret) {
		hba->ufshcd_state =3D UFSHCD_STATE_ERROR;
		hba->saved_err |=3D saved_err;
		hba->saved_uic_err |=3D saved_uic_err;
	}
	ufshcd_clear_eh_in_progress(hba);
	spin_unlock_irqrestore(&hba->host->host_lock, flags);
}

Alternatively, if ufshcd_link_recovery() succeeds in __ufshcd_wl_resume()
(clearing hba->saved_err, hba->saved_uic_err, and hba->force_reset) and a
later step in __ufshcd_wl_resume() such as ufshcd_set_dev_pwr_mode() fails,
the saved error flags remain zero.

In both cases, doesn't ufshcd_err_handling_should_stop() evaluate to true a=
nd
cause ufshcd_err_handler() to return immediately after acquiring
hba->host_sem, skipping full recovery and ufshcd_recover_pm_error() while
leaving the HBA in UFSHCD_STATE_ERROR or stuck with hba->is_sys_suspended
set?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792755091.gi=
t.hy50.seo@samsung.com?part=3D2

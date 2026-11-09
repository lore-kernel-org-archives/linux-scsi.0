Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794201689;
	b=qL8tRRrcgldGIAbEv68KDFE0cWQq42WAV9Jk9/MAlrWl2w/mdaM2zAzs3dxhNrUD+zHw
	 lzYhEAkxCZKsrbDCwgbnknDDoRdjL1WlG0YJ7VNnW9hNHmuLCS/ktmuzNl7t5/0TffKMB
	 11NYDvw2kuVl03E0I+v4G2o1R9PtJd5CLOtBdwD3Vdvm4KcXMAYYg8e9iKJHygusdlQbt
	 WhoF6ePbO3lAQ1yA5OpSNGOzZXhxMLaCMX/tfEkPKvMVrXcH4EKIVmOTzRbyc2fUZE3du
	 qhSFTlGHYLGxXgZwYMVEWfijLRoBU/Z68/AQVOQDc9FhPML+/qTD85YmALmnkyVyARQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794201689;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=8ZRn7U6LbXLrkeFcE23kRiYP3n6k52W7uC06jPGezt0=;
	b=DgrqJwou0vrlbWXLgXWBmC2cUDfcEmhqjrkprb9yZU9/E1t+KfjdO+RsHHkiHDaiDxHo
	 yBGJpT66IngJ8A6B80WW4aqzbs5KypHbg6BWd2sRFXNmLF2kGpl6wPqe5iXwHH5EhBs7q
	 jU4C/9kDX7QEgKJCkDpXNns2fPjKbE4IfnFxHDCkyJ2oDfg+8mR0bXHaAMM/FZTWMXLy4
	 JZxD8lDardF/bPJdc7j3xsE/Ax1XxRRmiXPU/e4rXJ7uCTpLfLazQci90pcsoKWkC3X/g
	 CfKZ0yj61IY5ZbOmkNgyh6Qovwnks6rKhccg9BOBc770tOXgV/hRV5nPQ+ht+NE/7iA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FIw95C5e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9AAD606A322
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 05:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FIw95C5e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D511F008A1;
	Mon,  9 Nov 2026 05:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794201688;
	bh=8ZRn7U6LbXLrkeFcE23kRiYP3n6k52W7uC06jPGezt0=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=FIw95C5eT0icfD1LWg+q1Gt9whg+6TbsBZTl37PMrnhytCIaKziTCpkhJ8y2N65+n
	 y0OwzSaK4k8yfrD1aBqOqVDwMqEuAhr+c4swfAoXMKc5Fgvj1xopOReSzmuW4ts1bV
	 fmRqejxSLVsW4AZjdV4glEkRnHwMy8LR1AaOQ2V6u2KC2+lkaf7rm8BSaOUvVdogjG
	 +23dw4BLomx6OPapGaCa7C2RP8CHKhbmZUDlL+lEUP6Z2rX8oF5i8xMLkEUas32D78
	 HahZxuIx9DZpNI9aA6xmOyA4aW2sPq05Gib0pIpc7jwXIINoxRjphlQasJcioD1HKJ
	 AChP/waRfiLbA==
Message-ID: <sashiko-outbox-204431@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 3/3] scsi: ufs: core: Limit early link recovery in
 the error handler to runtime PM
Reply-To: sashiko-reviews@lists.linux.dev
To: "HOYOUNG SEO" <hy50.seo@samsung.com>, linux-scsi@vger.kernel.org
In-Reply-To: <2052256418.81794200283664.JavaMail.epsvc@epcpadp2new>
References: <cover.1794196863.git.hy50.seo@samsung.com>
 <CGME20261109041348epcas2p1a8518c19bea8a58c57e8538809d2a947@epcas2p1.samsung.com>
 <2052256418.81794200283664.JavaMail.epsvc@epcpadp2new>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 05:21:28 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] scsi: ufs: core: unsynchronized link recovery in
  ufshcd_err_handler()
--

commit bf85ee52f6ee7c2e7ab3e9f87aa7985d6566f949
Author: HOYOUNG SEO <hy50.seo@samsung.com>

scsi: ufs: core: Limit early link recovery in the error handler to runtime =
PM

This commit replaces the hba->pm_op_in_progress check in
ufshcd_err_handler() with ufshcd_rpm_transition_in_progress() so that early
link recovery without hba->host_sem only runs when the WLUN runtime PM
status is RPM_SUSPENDING or RPM_RESUMING.

> diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-pri=
v.h
> index 99f654b79035f..c576f648f242d 100644
> --- a/drivers/ufs/core/ufshcd-priv.h
> +++ b/drivers/ufs/core/ufshcd-priv.h
> @@ -418,6 +418,19 @@ static inline void ufshcd_rpm_put(struct ufs_hba *hb=
a)
>  	pm_runtime_put(&hba->ufs_device_wlun->sdev_gendev);
>  }
> =20
> +/* Whether a runtime suspend or resume of the WLUN is in progress. */
> +static inline bool ufshcd_rpm_transition_in_progress(struct ufs_hba *hba)
> +{
> +#ifdef CONFIG_PM
> +	enum rpm_status status =3D
> +		READ_ONCE(hba->ufs_device_wlun->sdev_gendev.power.runtime_status);
> +
> +	return status =3D=3D RPM_SUSPENDING || status =3D=3D RPM_RESUMING;
> +#else
> +	return false;
> +#endif
> +}
> +
>  /**
>   * ufs_is_valid_unit_desc_lun - checks if the given LUN has a unit descr=
iptor
>   * @dev_info: pointer of instance of struct ufs_dev_info
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index c2c34b044c3ec..1608a856cac71 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -7094,9 +7094,14 @@ static void ufshcd_err_handler(struct work_struct =
*work)
>  		 * runtime resume. This avoids potential deadlocks that could
>  		 * happen if we tried to resume the device while a PM operation
>  		 * is already in progress.
> +		 *
> +		 * Do this only while a runtime PM operation is in progress. The
> +		 * system PM and poweroff callbacks hold host_sem, and
> +		 * shutting_down makes the regular path below stop, so it does
> +		 * not reset the link concurrently with them.
>  		 */
>  		ufshcd_rpm_get_noresume(hba);
> -		if (hba->pm_op_in_progress) {
> +		if (ufshcd_rpm_transition_in_progress(hba)) {
>  			ufshcd_link_recovery(hba);
>  			ufshcd_rpm_put(hba);
>  			return;

[Severity: High]
Does checking runtime_status here widen the window for unsynchronized
ufshcd_link_recovery() outside the ufshcd_hold() region of
__ufshcd_wl_suspend() and __ufshcd_wl_resume()?

The runtime PM core sets runtime_status to RPM_SUSPENDING before
sdev_runtime_suspend() runs blk_pre_runtime_suspend(), and keeps
RPM_SUSPENDING or RPM_RESUMING until after sdev_runtime_suspend() or
sdev_runtime_resume() returns.  That window spans before
__ufshcd_wl_suspend() calls ufshcd_hold() and after __ufshcd_wl_suspend() or
__ufshcd_wl_resume() calls ufshcd_release() and clears
hba->pm_op_in_progress:

CPU0                                  CPU1 (eh_wq)
rpm_suspend()
  runtime_status =3D RPM_SUSPENDING
  ...
  __ufshcd_wl_suspend()
    ufshcd_hold(hba)
    ufshcd_link_state_transition()
      /* fails */
    ufshcd_force_error_recovery(hba)
      queue_work(..., &hba->eh_work)
    ...
    ufshcd_release(hba)
    hba->pm_op_in_progress =3D false
                                      ufshcd_err_handler()
                                        ufshcd_rpm_transition_in_progress()
                                          /* still RPM_SUSPENDING */
                                        ufshcd_link_recovery(hba)
                                          /* runs without ufshcd_hold() */
  blk_post_runtime_suspend()
  runtime_status =3D RPM_ACTIVE

Because ufshcd_link_recovery() runs in this window without ufshcd_hold(),
hba->host_sem, or ufshcd_err_handling_prepare(), it can access controller
MMIO registers while clocks are gated off (for example, during
blk_pre_runtime_suspend() or after ufshcd_release()), or reset and activate
the host and link after a successful __ufshcd_wl_suspend() right before
rpm_suspend() marks the WLUN RPM_SUSPENDED.

Also, during runtime PM itself, if a UIC error schedules eh_work while
__ufshcd_wl_resume() fails ufshcd_uic_hibern8_exit(), or while
__ufshcd_wl_suspend() rolls back at set_dev_active, ufshcd_err_handler() and
the runtime PM callback still run ufshcd_link_recovery() concurrently.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/728258269.417942002=
83102.JavaMail.epsvc@epcpadp2new?part=3D3

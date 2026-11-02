Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793581084;
	b=2vlxejP/i2MeIQt7A+0eaynaAvzNzbQGghCnrGpe+56X07tjSRbZoINimZJrCMpBG9n7
	 YJKtVFM7ZEm7C7deDj8Zgx7Rf8JJdxRU2gcJaHCNStyMGj7rGwFD3qi0nVg3vmb/3nVUm
	 QttmGz3iPhOwjIr9crP4Ej8o+2j7/Ixhe+uAORQddP8SqfxuLWRXE/K2Pl/EM/FvbV6jS
	 oqv2xeLngBeOGXagi/Vr+FIOibvEscfJeLusdWQH9pXT8HmTQ/bjQ/sNPdV1xlyWTUaTd
	 ZbG0l6hRTL3ayqsUNU+tQIxmuvoDE69F8reJxglze10phm22xa3hA8heNriDWKrkNYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793581084;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=KTJfYeVJ5LaF5BEBpz3XjrjNAX4krtkISRF8+AkUDXM=;
	b=W7He88/H02maUrbIETgtKSEkaqR+0AFWaf9HGgvyYD54j2yfW7V9oYK9yoFfEY0FzR5w
	 0pZn31RX1a5khLquyWaoGmxCacG4LgHyvlQwdY3riwJdDKNnmXGbA9YDYpWU4yYKs+Ii5
	 TlKxOxRrqJu/u8TLc3DAvemoUR0/cZdjrKuu6cWwI+Sp5l9/4GVWWTEwuTN/0spQLV7Ly
	 hLeH6R4NeR4ebIeG9wTybkxtniSCl7NDFMzfY7uSe05knxMCZFZTWFPXEUmYMdq0wEfIe
	 8f+6OGyhqcp9c3cJZthq9sdOEKspWnVosnX7njRnrGlYjz1W2C9KyUeyJMcpCM3cBwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GqLeNiTR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DF9606A324
	for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2026 00:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GqLeNiTR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DAF81F000C1;
	Mon,  2 Nov 2026 00:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793581083;
	bh=KTJfYeVJ5LaF5BEBpz3XjrjNAX4krtkISRF8+AkUDXM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GqLeNiTR70NrvU4kmKUJDAvPGyYAwQDd7PZun8CpUSVK7rKuppNdUjapztcda3UPv
	 hKSQKRQLyZE4RTRmzKRSMX3gQxJtifBY9R0J9bkx3pCOVcutvGskQkJWE660ofE1fs
	 2WURXaC29EcP3ck9x1hHP9v4JvtCseDBdw7MuV+A6uQGJSIC1uAU5UzaQdbExDQnmo
	 /i8lQVcuqKv/6F7yisXpYc05nLehN6iNbw2BYjmhobxqqcxDFyfA/qhbezOMyc6xhW
	 054aZQI+xdwgHOnhBqrjURYGmd7uMLvzhpeAX5aCWnFdYezFxacVmx4ls1cNf5PWyY
	 KW/GrI4/8tmhA==
Message-ID: <sashiko-outbox-192798@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH] scsi: ufs: core: Allow error recovery before the
 device W-LUN exists
Reply-To: sashiko-reviews@lists.linux.dev
To: "Asdlerto Korry" <korryasdlerto@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261102003607.341651-1-korryasdlerto@gmail.com>
References: <20261102003607.341651-1-korryasdlerto@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 00:58:02 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] scsi: ufs: core: unserialized ufshcd_err_handler() race with ufshc=
d_init()
- [High] scsi: ufs: core: use-after-free in ufshcd_err_handler() during tea=
rdown
- [High] scsi: ufs: core: ufs_device_wlun race in ufshcd_err_handling_prepa=
re()
- [High] scsi: ufs: core: missing ufs_device_wlun check in ufshcd_rpm_put_s=
ync()
--

commit c2d444d6fca4852f29bbcb2d985d743a2e3be799
Author: Asdlerto Korry <korryasdlerto@gmail.com>

scsi: ufs: core: Allow error recovery before the device W-LUN exists

This commit removes the hba->ufs_device_wlun check from
ufshcd_err_handling_should_stop() so that the UFS error handler can reset a=
nd
restore the host and link if an error occurs before the device W-LUN is
added. It also adds hba->ufs_device_wlun checks to ufshcd_rpm_get_sync(),
ufshcd_rpm_put(), ufshcd_err_handling_prepare(), and
ufshcd_recover_pm_error().

> diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-pri=
v.h
> index e55c2a02c1f50..2cb0d542d1147 100644
> --- a/drivers/ufs/core/ufshcd-priv.h
> +++ b/drivers/ufs/core/ufshcd-priv.h
> @@ -385,6 +385,8 @@ static inline int ufshcd_update_ee_usr_mask(struct uf=
s_hba *hba,
> =20
>  static inline int ufshcd_rpm_get_sync(struct ufs_hba *hba)
>  {
> +	if (!hba->ufs_device_wlun)
> +		return 0;
>  	return pm_runtime_get_sync(&hba->ufs_device_wlun->sdev_gendev);
>  }

[Severity: High]
Should ufshcd_rpm_put_sync() and the other runtime power management helpers=
 in
drivers/ufs/core/ufshcd-priv.h also check hba->ufs_device_wlun?

Right below ufshcd_rpm_get_sync(), ufshcd_rpm_put_sync() still dereferences
hba->ufs_device_wlun unconditionally:

drivers/ufs/core/ufshcd-priv.h:ufshcd_rpm_put_sync() {
	return pm_runtime_put_sync(&hba->ufs_device_wlun->sdev_gendev);
}

Both ufs_debugfs_hba_init() (called in ufshcd_hba_init()) and
ufs_sysfs_add_nodes() (called in ufshcd_init()) register attributes before
ufshcd_async_scan()->ufshcd_add_lus()->ufshcd_scsi_add_wlus() creates
hba->ufs_device_wlun, and those attributes remain registered if probing or
adding the W-LUN fails.

Callers such as ufshcd_read_hci_reg() in drivers/ufs/core/ufs-sysfs.c and
ufs_debugfs_get_user_access() / ufs_debugfs_put_user_access() in
drivers/ufs/core/ufs-debugfs.c pair ufshcd_rpm_get_sync() with
ufshcd_rpm_put_sync():

drivers/ufs/core/ufs-sysfs.c:ufshcd_read_hci_reg() {
	ufshcd_rpm_get_sync(hba);
	ufshcd_hold(hba);
	*val =3D ufshcd_readl(hba, reg);
	ufshcd_release(hba);
	ufshcd_rpm_put_sync(hba);
	return 0;
}

When hba->ufs_device_wlun is not set yet, ufshcd_rpm_get_sync() now succeeds
and returns 0, after which ufshcd_rpm_put_sync() dereferences a null
hba->ufs_device_wlun pointer.

> @@ -410,6 +412,8 @@ static inline int ufshcd_rpm_resume(struct ufs_hba *h=
ba)
> =20
>  static inline void ufshcd_rpm_put(struct ufs_hba *hba)
>  {
> +	if (!hba->ufs_device_wlun)
> +		return;
>  	pm_runtime_put(&hba->ufs_device_wlun->sdev_gendev);
>  }
> =20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index fd52deb72d21c..9767fbc7b870b 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -6876,8 +6876,9 @@ static void ufshcd_err_handling_prepare(struct ufs_=
hba *hba)
>  	 */
>  	pm_runtime_get_sync(hba->dev);
>  	ufshcd_rpm_get_sync(hba);
> -	if (pm_runtime_status_suspended(&hba->ufs_device_wlun->sdev_gendev) ||
> -	    hba->is_sys_suspended) {
> +	if (hba->ufs_device_wlun &&
> +	    (pm_runtime_status_suspended(&hba->ufs_device_wlun->sdev_gendev) ||
> +	     hba->is_sys_suspended)) {

[Severity: High]
Can ufshcd_err_handler() race with ufshcd_scsi_add_wlus() while
hba->ufs_device_wlun is being populated?

In ufshcd_async_scan(), hba->host_sem is released before calling
ufshcd_add_lus()->ufshcd_scsi_add_wlus():

drivers/ufs/core/ufshcd.c:ufshcd_async_scan() {
	down(&hba->host_sem);
	/* Initialize hba, detect and initialize UFS device */
	probe_start =3D ktime_get();
	ret =3D ufshcd_probe_hba(hba, true);
	ufshcd_process_probe_result(hba, probe_start, ret);
	up(&hba->host_sem);
	if (ret)
		goto out;

	/* Probe and add UFS logical units  */
	ret =3D ufshcd_add_lus(hba);
}

And ufshcd_scsi_add_wlus() assigns the result of __scsi_add_device() direct=
ly
to hba->ufs_device_wlun before checking for an error pointer:

drivers/ufs/core/ufshcd.c:ufshcd_scsi_add_wlus() {
	hba->ufs_device_wlun =3D __scsi_add_device(hba->host, 0, 0,
		ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_UFS_DEVICE_WLUN), NULL);
	if (IS_ERR(hba->ufs_device_wlun)) {
		ret =3D PTR_ERR(hba->ufs_device_wlun);
		hba->ufs_device_wlun =3D NULL;
		goto out;
	}
	...
}

Because ufshcd_err_handler() can now run before the W-LUN exists, it can run
concurrently with ufshcd_scsi_add_wlus(). Does this open two races?

First, if ufshcd_err_handling_prepare() runs while hba->ufs_device_wlun is
still null, ufshcd_rpm_get_sync() returns 0 without incrementing the W-LUN
runtime power management usage count. If __scsi_add_device() finishes and
sets hba->ufs_device_wlun before ufshcd_err_handling_unprepare() runs,
ufshcd_rpm_put() will see a non-null hba->ufs_device_wlun and call
pm_runtime_put(), dropping a reference that ufshcd_err_handling_prepare()
never acquired (and conversely leaking a reference if adding sdev_rpmb fails
and removes ufs_device_wlun while error handling is running).

Second, if __scsi_add_device() fails, hba->ufs_device_wlun transiently holds
an error pointer before being reset to null, which the non-null checks in
ufshcd_rpm_get_sync(), ufshcd_err_handling_prepare(),
ufshcd_recover_pm_error(), and ufshcd_rpm_put() will dereference.

[ ... ]

> @@ -6926,7 +6927,6 @@ static void ufshcd_err_handling_unprepare(struct uf=
s_hba *hba)
>  static inline bool ufshcd_err_handling_should_stop(struct ufs_hba *hba)
>  {
>  	return (!hba->is_powered || hba->shutting_down ||
> -		!hba->ufs_device_wlun ||
>  		hba->ufshcd_state =3D=3D UFSHCD_STATE_ERROR ||
>  		(!(hba->saved_err || hba->saved_uic_err || hba->force_reset ||
>  		   ufshcd_is_link_broken(hba))));

[Severity: High]
What serializes ufshcd_err_handler() against ufshcd_init() once this check =
is
removed?

In ufshcd_init(), ufshcd_link_startup()->ufshcd_make_hba_operational() enab=
les
controller interrupts, and ufshcd_init() then runs ufshcd_verify_dev_init(),
ufshcd_complete_dev_init(), ufshcd_device_params_init(), and
ufshcd_post_device_init() without holding hba->host_sem:

drivers/ufs/core/ufshcd.c:ufshcd_init() {
	...
	hba->ufshcd_state =3D UFSHCD_STATE_RESET;

	err =3D ufshcd_link_startup(hba);
	if (err)
		goto out_release;
	...
	/* Verify device initialization by sending NOP OUT UPIU */
	err =3D ufshcd_verify_dev_init(hba);
	if (err)
		goto out_release;

	err =3D ufshcd_complete_dev_init(hba);
	if (err)
		goto out_release;

	/* Init check for device descriptor sizes */
	err =3D ufshcd_device_params_init(hba);
	if (err)
		goto out_release;

	/* Let the variant know that the UFS device has been initialized */
	err =3D ufshcd_post_device_init(hba);
	if (err)
		goto out_put_Desc;
	...
}

When an error interrupt schedules hba->eh_work during this initial bring-up,
ufshcd_err_handler() acquires hba->host_sem on hba->eh_wq and runs in paral=
lel
with ufshcd_init():

1. In ufshcd_verify_dev_init(), the probe thread holds ufshcd_dev_man_lock()
(which acquires mutex_lock(&hba->dev_cmd.lock) and
down_read(&hba->clk_scaling_lock)) across all retry iterations:

drivers/ufs/core/ufshcd.c:ufshcd_verify_dev_init() {
	ufshcd_dev_man_lock(hba);

	for (retries =3D NOP_OUT_RETRIES; retries > 0; retries--) {
		err =3D ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_NOP,
					  hba->nop_out_timeout);

		if (!err || err =3D=3D -ETIMEDOUT)
			break;

		dev_dbg(hba->dev, "%s: error %d retrying\n", __func__, err);
	}
	ufshcd_dev_man_unlock(hba);
	...
}

Concurrently, ufshcd_err_handler()->ufshcd_err_handling_prepare() calls
ufshcd_clk_scaling_allow(hba, false), which blocks on
down_write(&hba->clk_scaling_lock). If an in-flight command times out and
ufshcd_abort()->ufshcd_clear_cmd() fails to clear the doorbell, the error
handler thread invokes ufshcd_eh_host_reset_handler()->flush_work(&hba->eh_=
work),
deadlocking because ufshcd_verify_dev_init() holds clk_scaling_lock while
waiting in blk_execute_rq() for error handling, error handling waits in
flush_work(&hba->eh_work), and ufshcd_err_handler() waits for clk_scaling_l=
ock.
Even without a timeout, ufshcd_verify_dev_init() only releases clk_scaling_=
lock
after failing and returning to ufshcd_init(), which immediately aborts via
goto out_release before ufshcd_err_handler() can reset and restore the link.

2. If ufshcd_err_handling_prepare() acquires clk_scaling_lock before
ufshcd_init() (or between queries in ufshcd_complete_dev_init() and
ufshcd_device_params_init()), ufshcd_err_handler() runs
ufshcd_reset_and_restore()->ufshcd_host_reset_and_restore() concurrently wi=
th
ufshcd_init():

drivers/ufs/core/ufshcd.c:ufshcd_host_reset_and_restore() {
	...
	err =3D ufshcd_hba_enable(hba);

	/* Establish the link again and restore the device */
	if (!err) {
		err =3D ufshcd_device_init(hba, /*init_dev_params=3D*/false);
		if (!err)
			err =3D ufshcd_probe_hba(hba, false);
	}
	...
}

Because init_dev_params is false and ufshcd_device_params_init() in
ufshcd_init() has not completed yet, ufshcd_probe_hba(hba, false) runs with
uninitialized hba->dev_info, hba->dev_quirks, and hba->max_pwr_info, and on
controllers with UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH it calls
ufs_put_device_desc(hba) and frees hba->dev_info.model while ufshcd_init()
is still running.

[Severity: High]
Can removing !hba->ufs_device_wlun from ufshcd_err_handling_should_stop() a=
lso
cause a use-after-free during driver removal or probe failure teardown?

In ufshcd_remove(), scsi_remove_host() is called before interrupts are
disabled and before ufshcd_hba_exit() destroys hba->eh_wq, while
hba->is_powered is still true and hba->shutting_down is false:

drivers/ufs/core/ufshcd.c:ufshcd_remove() {
	if (hba->bsg_queue)
		ufshcd_bsg_remove(hba);
	ufs_hwmon_remove(hba);
	ufs_sysfs_remove_nodes(hba->dev);
	cancel_delayed_work_sync(&hba->ufs_rtc_update_work);
	blk_mq_destroy_queue(hba->tmf_queue);
	blk_put_queue(hba->tmf_queue);
	blk_mq_free_tag_set(&hba->tmf_tag_set);
	if (hba->scsi_host_added)
		scsi_remove_host(hba->host);
	/* disable interrupts */
	ufshcd_disable_intr(hba, hba->intr_mask);
	ufshcd_hba_stop(hba);
	ufshcd_hba_exit(hba);
}

And in ufshcd_hba_exit() (which is also called on the out_release failure p=
ath
of ufshcd_init()), clock scaling and clock gating are torn down before
destroy_workqueue(hba->eh_wq) flushes pending eh_work, while hba->is_powered
is still true:

drivers/ufs/core/ufshcd.c:ufshcd_hba_exit() {
	if (hba->is_powered) {
		ufshcd_pm_qos_exit(hba);
		ufshcd_exit_clk_scaling(hba);
		ufshcd_exit_clk_gating(hba);
		if (hba->eh_wq)
			destroy_workqueue(hba->eh_wq);
		...
		hba->is_powered =3D false;
	}
}

Previously, scsi_remove_host() destroyed the W-LUN device and cleared
hba->ufs_device_wlun to null (and on the ufshcd_init() failure path
hba->ufs_device_wlun was already null), so ufshcd_err_handling_should_stop()
returned true and any pending eh_work exited immediately.

Without that check, if eh_work runs after scsi_remove_host() (which frees
hba->host->pseudo_sdev and hba->host->tag_set) or when flushed by
destroy_workqueue(hba->eh_wq) in ufshcd_hba_exit(),
ufshcd_err_handling_should_stop() returns false and
ufshcd_err_handling_prepare() accesses the torn-down clock-gating/scaling
state, freed hba->host->tag_set, and freed
hba->host->pseudo_sdev->request_queue.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102003607.3416=
51-1-korryasdlerto@gmail.com?part=3D1

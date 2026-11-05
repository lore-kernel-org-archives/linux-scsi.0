Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793864586;
	b=pm0zkt35HsjPV7AxuriBE+aIrBjy2iFe6JP4hBvM6+dK9w3TwbvXY+j9VxEcGGOPV7cv
	 4XoOaJbrHj+wUp55ADgqyVRR9sGtXWiw8LWnjvhTImfk9UaxDmY2XAdxTi8MeQ9VnKUXB
	 ntSTbwDUKcaSCyZx8v/t0Dqm07gNWR06/AHMhmVhTbsBQI0UUsmyoiQbxIM1VT4jBlPjd
	 g6ns4MZj0AwMVwCORVgWZyKlGDRJyZGzqkY2Q/nBQyUNOH5973PAwOvqTRziiPF+cu7g3
	 +QKpvc8OVHcQgAFgMHqW7jyNiJAK+0+JnFb7Z3d7miI8OmAUlfgxlbdbDsWTQz6S3/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793864586;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=H7aPK5Izl4U+dKF0mRKZsK7SRnCtcJ1crUDecKtvgmk=;
	b=GhVuYBDhESjeU7oSiuGfPcHYXuGnR9wChunRDOUbPuEsmX4yjLi9seJ8ThMBNAEZdBdS
	 E2Y3hgN+Jg7aUBT56Vs2hIPW7Wcd1d9Sq7mRwNn3K/Az6HVIMBwv7xSvxqKm08FzxWMuH
	 72Kc7nb48b2b4KaERH6QhTaYVtDXoCs3W0RpHqrjwv+K68pcATu5VIHH7hKdIuMdbYnCk
	 s7XZq1F8r6kSA8HryWgK3sxKZNjAG1bf0JFrlqQI7rHyqhjv1HH67YjEJMz9tRGpN3PtL
	 YuaeVCtlbEfYOFL8f3k+XZPaGc1uswvcjOTjnz/Bpd7B1iCv4X1u2Lmm88wFnlLnENQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LassE5+X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FBD606A330
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 07:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LassE5+X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32221F00919;
	Thu,  5 Nov 2026 07:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793864585;
	bh=H7aPK5Izl4U+dKF0mRKZsK7SRnCtcJ1crUDecKtvgmk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LassE5+XFa/giQXWPX8+IOGIAiDzRzlc899wotI5jhOYpNVXjUyRWlDpnywM8Ciga
	 IoSwuxDPt+hpqTgH2AZ7veZVEbsItFEFHvQeJk1PqE8OhPc4r5DE6tD079JNco9Bvt
	 8aJy7Y72Lz95/2IIO8AK2YHAvtdzIMHhmRPXMsXra7JPs338uLyTocqixdIeJMJIwp
	 M8g6FIGcJhicui0WB3l39++1TcWR3qgc0SiCPmfqiNT7RzLvUVh/lW5NEmR0Olc33L
	 zhPITGBSyJ7UKM1tArtmgyNgPly5f9JXYsJWn/qHsUMF449VMmYRoTeTPH8oK1RGtJ
	 ysDzADZulWVOg==
Message-ID: <sashiko-outbox-198693@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] scsi: ufs: core: Wake consumer queues on suspended
 W-LUN recovery
Reply-To: sashiko-reviews@lists.linux.dev
To: "Stanley Jhu" <stanleyjhu@google.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261105071518.1458428-3-stanleyjhu@google.com>
References: <20261105071518.1458428-1-stanleyjhu@google.com>
 <20261105071518.1458428-3-stanleyjhu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 07:43:05 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: ufs: core: premature HBA runtime suspend in ufshcd_recover_p=
m_error()
- [High] scsi: ufs: core: missed queue wake in ufshcd_recover_pm_error() af=
ter prepare
--

commit ea7f240ee0c25a5e5c4a46de9b52655deaa5da4e
Author: Stanley Jhu <stanleyjhu@google.com>

scsi: ufs: core: Wake consumer queues on suspended W-LUN recovery

This commit updates ufshcd_recover_pm_error() to set resume_sdev_queues
when ufs_device_wlun is runtime-suspended, so consumer queues blocked in
__bio_queue_enter() after a failed W-LUN runtime resume are woken via
pm_request_resume().

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index fd52deb72d21c..0701ec408736d 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -6953,7 +6953,9 @@ static void ufshcd_recover_pm_error(struct ufs_hba =
*hba)
>  		resume_sdev_queues =3D true;
>  	}
> =20
> -	if (hba->ufs_device_wlun->sdev_gendev.power.runtime_error) {
> +	if (pm_runtime_status_suspended(&hba->ufs_device_wlun->sdev_gendev)) {
> +		resume_sdev_queues =3D true;

[Severity: High]
Can leaving ufs_device_wlun in RPM_SUSPENDED here cause hba->dev to
prematurely runtime-suspend before the asynchronous consumer resume work ru=
ns?

When W-LUN runtime resume fails, rpm_resume() leaves ufs_device_wlun in
RPM_SUSPENDED with power.runtime_error =3D=3D 0 and drops the reference on =
its
parent starget->dev, allowing starget->dev and shost->shost_gendev to remain
RPM_SUSPENDED with hba->dev->power.child_count =3D=3D 0.

In ufshcd_err_handler(), ufshcd_err_handling_prepare() takes
pm_runtime_get_sync(hba->dev), powers on regulators/clocks/IRQs, and calls
ufshcd_vops_resume(), and then ufshcd_reset_and_restore() resets the host a=
nd
restores hba->curr_dev_pwr_mode =3D UFS_ACTIVE_PWR_MODE and
hba->uic_link_state =3D UIC_LINK_ACTIVE_STATE.

Unlike the power.runtime_error branch below:

drivers/ufs/core/ufshcd.c:ufshcd_recover_pm_error() {
	...
	} else if (hba->ufs_device_wlun->sdev_gendev.power.runtime_error) {
		pm_runtime_get_sync(&starget->dev);
		pm_runtime_set_active(&hba->ufs_device_wlun->sdev_gendev);
		pm_runtime_put_sync(&starget->dev);
		resume_sdev_queues =3D true;
	}
}

which synchronously resumes starget->dev and sets ufs_device_wlun active (so
starget->dev, shost->shost_gendev, and hba->dev all have power.child_count =
=3D=3D
1), this new branch only sets resume_sdev_queues =3D true and queues
asynchronous pm_request_resume(q->dev) work on pm_wq (or queues nothing if =
no
consumer LUN has q->rpm_status in RPM_SUSPENDED or RPM_SUSPENDING).

Immediately after ufshcd_recover_pm_error() returns,
ufshcd_err_handling_unprepare() runs:

drivers/ufs/core/ufshcd.c:ufshcd_err_handling_unprepare() {
	...
	if (ufshcd_is_clkscaling_supported(hba))
		ufshcd_clk_scaling_suspend(hba, false);
	ufshcd_rpm_put(hba);
	pm_runtime_put(hba->dev);
}

Because ufs_device_wlun, starget->dev, and shost->shost_gendev are still
RPM_SUSPENDED, pm_runtime_put(hba->dev) drops hba->dev->power.usage_count t=
o 0
while hba->dev->power.child_count is 0. Wouldn't that allow
ufshcd_runtime_suspend() -> ufshcd_suspend() to disable host IRQs, gate clo=
cks
to CLKS_OFF, and put vreg and vdd_hba into LPM while the UFS device and Uni=
Pro
link are still in UFS_ACTIVE_PWR_MODE and UIC_LINK_ACTIVE_STATE (without
__ufshcd_wl_suspend() or ufshcd_vops_suspend() having run), and then cause a
subsequent __ufshcd_wl_resume() to skip controller/link reinitialization
because both ufshcd_is_link_hibern8(hba) and ufshcd_is_link_off(hba) are
false?

> +	} else if (hba->ufs_device_wlun->sdev_gendev.power.runtime_error) {

[Severity: High]
What happens if ufshcd_rpm_get_sync(hba) in ufshcd_err_handling_prepare()
already transitioned ufs_device_wlun to RPM_ACTIVE before
ufshcd_recover_pm_error() is reached?

When a consumer-initiated runtime resume of ufs_device_wlun fails, commit
eef1d74bf88f leaves ufs_device_wlun in RPM_SUSPENDED with
power.runtime_error =3D=3D 0, while the consumer queue remains blocked in
__bio_queue_enter() with q->pm_only set and q->rpm_status =3D=3D RPM_SUSPEN=
DED.

When ufshcd_err_handler() subsequently runs, it calls
ufshcd_err_handling_prepare() before ufshcd_set_eh_in_progress():

drivers/ufs/core/ufshcd.c:ufshcd_err_handling_prepare() {
	pm_runtime_get_sync(hba->dev);
	ufshcd_rpm_get_sync(hba);
	if (pm_runtime_status_suspended(&hba->ufs_device_wlun->sdev_gendev) ||
	...
}

Because power.runtime_error is 0, ufshcd_rpm_get_sync(hba) invokes
__ufshcd_wl_resume() a second time instead of failing immediately with
-EINVAL. That second __ufshcd_wl_resume() call can succeed and transition
ufs_device_wlun to RPM_ACTIVE: for example, when hba->ufshcd_state is
UFSHCD_STATE_EH_SCHEDULED_NON_FATAL (which ufshcd_queuecommand() allows bef=
ore
ufshcd_set_eh_in_progress() and which later triggers needs_reset =3D true in
ufshcd_err_handler()), or when __ufshcd_wl_resume() recovers the link via
ufshcd_link_recovery() or ufshcd_reset_and_restore():

drivers/ufs/core/ufshcd.c:__ufshcd_wl_resume() {
	...
			ret =3D ufshcd_link_recovery(hba);
			if (ret)
				goto vendor_suspend;
		}
	} else if (ufshcd_is_link_off(hba)) {
		ret =3D ufshcd_reset_and_restore(hba);
	...
}

Once ufshcd_rpm_get_sync(hba) in ufshcd_err_handling_prepare() sets
ufs_device_wlun to RPM_ACTIVE, both
pm_runtime_status_suspended(&hba->ufs_device_wlun->sdev_gendev) and
hba->ufs_device_wlun->sdev_gendev.power.runtime_error will be false in
ufshcd_recover_pm_error() (or ufshcd_err_handling_should_stop() will skip t=
he
do_reset path altogether if __ufshcd_wl_resume() already ran
ufshcd_reset_and_restore()). Wouldn't that leave resume_sdev_queues false a=
nd
leave the consumer queue stuck in __bio_queue_enter()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105071518.1458=
428-1-stanleyjhu@google.com?part=3D2

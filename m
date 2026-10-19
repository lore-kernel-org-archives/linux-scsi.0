Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792449079;
	b=i9GNtgZzu0BXQgSKS4f32hD4fgsEyWkG0vrlNtafd105zjYQwcZ7Qdx7FUlRgVnbMoly
	 PexcI3cme1EyMWYli7xXvqkiwSLcGX2y3rUxI6fekNPnYSNtDSwZpG6BC5lw4x8ptnrAl
	 lYOBkWp3JSXPAgb0eU2ZjZp3xaoR1Hpgech2Yaj/UgzTuLhsFQQ/pu1fN5ptZPs7eWwoK
	 6lZf7LGCiBeb2TOphujwvqS/b4XHOM34wzJ/oDqqACNkxm38pqxiVLRC729ZGZFK1aiqB
	 o4YWhbp/yc6G95ofsU+qePnwdiZwUxGMliukxfEjhNOXAwUeOdBb0Eb/CJ9ygz/n/HA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792449079;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=e21l+czp1jF2CPIUIpYwcJ/SqpC7fAcqU3CF7fvwOcs=;
	b=sCpHjNCl0g4baAJEhTy/G1G79/VBgqk/KH4V4M04dDMTwsmOGqoIYxIuP6+/Emcbd3JM
	 04UKCrOKt7vFkshy9iLZg7Rm3Ghcw5B45i48km+Ymd40r91ZDNj+nbY+0S8iF8HmK+PMo
	 F06d2Y4UIJg296eO0pxi+sbq3Dx3Ou5RxToI54+PQRIqRM+L6uWyaajWgyk2M5K30clPE
	 a2rv6B2puQawEj6/00qsJq7mIAFkitNXfWBnM8w4waSt7zX+CK2qU+d8hQAsj4RSvtYzD
	 EaGdvfgbd2Hvl/n/A+glFyUopZCUs6ZZA5HQP8qe1lG0Yxv17oBoWcdYJGSVsTeoMsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iMHu+b83;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A49606A31F
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 22:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iMHu+b83
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90ABA1F000C6;
	Mon, 19 Oct 2026 22:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792449078;
	bh=e21l+czp1jF2CPIUIpYwcJ/SqpC7fAcqU3CF7fvwOcs=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=iMHu+b8302evi7k2jISr5eag/J5NTXO+VJF4LODR9Dq2fBgSSf+pOO0MDsUhK3Cwy
	 uaEz4CO2YwrdQoGAEMYFvtPAl1H7G1Gck3LXdDicfzze4jk4b1M030eQV88i+J1Ju1
	 3Jg39zueSUP7hmkSAS+lupW6Xi2nCXK2wtGjpnUCImWHjHM9DOukOdLcDxbpltoQ+L
	 cqRtjKfGywicDnumLGdZ1Y77mMHnquLlDNCEwFnacSK+yXX4zsxH0S8gM31nf6ISB3
	 W4ufe87PB/uc0tnbU/jEl255OpFwRbx823aJ9mlJG31NuYt79W8ccq/grqyruL3W/X
	 Qoq3RSyEIW1bw==
Message-ID: <sashiko-outbox-178322@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 4/5] scsi: core: Add device reprobe support to
 scsi_rescan_device()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Brian Bunker" <brian@purestorage.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20261019221405.40614-5-brian@purestorage.com>
References: <20261019221405.40614-1-brian@purestorage.com>
 <20261019221405.40614-5-brian@purestorage.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 22:31:18 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] scsi: core: broken device_reprobe() error check in scsi_rescan_dev=
ice()
- [High] scsi: core: NULL deref in scsi_rescan_device() before device_add()
- [Medium] scsi: core: scsi_probe_lun() misuses sdev->inquiry_len on rescan
--

commit 09090dd4acc8a64408156c003c7bd95cb8781601
Author: Brian Bunker <brian@purestorage.com>

scsi: core: Add device reprobe support to scsi_rescan_device()

This commit adds INQUIRY data refresh and device reprobe support to
scsi_rescan_device() when the peripheral qualifier or device type changes.

> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 93a8719fcf265..87fd3ba5c3cc0 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c

[ ... ]

> @@ -1658,9 +1674,54 @@ int scsi_resume_device(struct scsi_device *sdev)
>  }
>  EXPORT_SYMBOL(scsi_resume_device);
> =20
> +/**
> + * scsi_refresh_inquiry - Fetch fresh standard INQUIRY data for a device
> + * @sdev: The SCSI device to refresh
> + *
> + * Failures are logged and otherwise ignored, so that the caller carries=
 on
> + * with the rest of the rescan using the INQUIRY data it already has.
> + *
> + * Returns true if the peripheral qualifier or device type changed and t=
he
> + * device needs to be reprobed.
> + */
> +static bool scsi_refresh_inquiry(struct scsi_device *sdev)
> +{
> +	unsigned char *inq_result;
> +	blist_flags_t bflags;
> +	int ret =3D -ENOMEM;
> +
> +	inq_result =3D kmalloc(256, GFP_KERNEL);
> +	if (inq_result) {
> +		ret =3D scsi_probe_lun(sdev, inq_result, 256, &bflags, true);

[Severity: Medium]
Does calling scsi_probe_lun() on a live sdev cause it to misinterpret
sdev->inquiry_len?

During initial probing in scsi_probe_and_add_lun(), sdev->inquiry_len is 0
unless shost->hostt->sdev_init() configured a maximum INQUIRY transfer
length. Once probed, scsi_probe_and_add_lun() and scsi_update_inquiry_data()
overwrite sdev->inquiry_len with the valid INQUIRY response length (at least
36 bytes).

When scsi_refresh_inquiry() calls scsi_probe_lun() on a live device,
sdev->inquiry_len holds the previous response length rather than 0 or a
low-level driver limit. In scsi_probe_lun():

	first_inquiry_len =3D sdev->inquiry_len ? sdev->inquiry_len : 36;
	try_inquiry_len =3D first_inquiry_len;
	pass =3D 1;
	...
		if (pass =3D=3D 1) {
			if (BLIST_INQUIRY_36 & *bflags)
				next_inquiry_len =3D 36;
			else if (sdev->inquiry_len &&
				 response_len > sdev->inquiry_len &&
				 (inq_result[2] & 0x7) < 6) /* SPC-4 */
				next_inquiry_len =3D sdev->inquiry_len;

If a pre-SPC-4 device initially returned a short INQUIRY (for example, 36
bytes while in PQ=3D1 / ALUA unavailable state) and later reports a larger
response_len on rescan, sdev->inquiry_len is non-zero, so next_inquiry_len =
is
capped at the old sdev->inquiry_len and pass 2 is skipped.

Conversely, if the device previously returned more than 36 bytes, pass 1
starts at that larger sdev->inquiry_len instead of 36 bytes, and if that
transfer fails after a state change, scsi_probe_lun() returns -EIO without
falling back to a 36-byte inquiry.

> +		if (ret >=3D 0)
> +			ret =3D scsi_update_inquiry_data(sdev, inq_result, ret);
> +		kfree(inq_result);
> +	}
> +
> +	if (ret < 0) {
> +		sdev_printk(KERN_WARNING, sdev,
> +			    "failed to refresh INQUIRY data: %d\n", ret);
> +		return false;
> +	}
> +
> +	return ret =3D=3D SCSI_INQ_REPROBE_NEEDED;
> +}
> +
> +/**
> + * scsi_rescan_device - Rescan a SCSI device
> + * @sdev: The SCSI device to rescan
> + *
> + * Refreshes the INQUIRY data and VPD pages of @sdev and lets the device
> + * handler and the upper-level driver update their view of the device. If
> + * the peripheral qualifier or device type changed, the device is reprob=
ed
> + * so that the right upper-level driver, if any, is bound to it.
> + *
> + * The caller must hold a reference to @sdev.
> + */
>  int scsi_rescan_device(struct scsi_device *sdev)
>  {
>  	struct device *dev =3D &sdev->sdev_gendev;
> +	bool need_reprobe;
>  	int ret =3D 0;
> =20
>  	device_lock(dev);
> @@ -1677,12 +1738,49 @@ int scsi_rescan_device(struct scsi_device *sdev)
>  		goto unlock;
>  	}
> =20
> +	need_reprobe =3D scsi_refresh_inquiry(sdev);
> +
>  	scsi_attach_vpd(sdev);
>  	scsi_cdl_check(sdev);
> =20
>  	if (sdev->handler && sdev->handler->rescan)
>  		sdev->handler->rescan(sdev);
> =20
> +	if (need_reprobe) {
> +		/*
> +		 * The peripheral qualifier or device type changed, so the
> +		 * driver binding has to be re-evaluated. device_reprobe()
> +		 * takes the device lock itself. sdev stays valid while the
> +		 * lock is dropped because the caller holds a reference;
> +		 * scsi_evt_thread() is covered by the cancel_work_sync() in
> +		 * scsi_device_dev_release().
> +		 */
> +		device_unlock(dev);
> +		ret =3D device_reprobe(dev);
> +		device_lock(dev);

[Severity: High]
Can device_reprobe(dev) be called here before device_add(dev) has initializ=
ed
dev->p, leading to a NULL pointer dereference in __device_attach()?

In scsi_add_lun(), sdev->sdev_state is transitioned to SDEV_RUNNING before
sdev_configure(), scsi_attach_vpd(), scsi_cdl_check(), and
scsi_sysfs_add_sdev() run (and during async scans, scsi_sysfs_add_sdev() is
deferred until scsi_finish_async_scan()):

drivers/scsi/scsi_scan.c:scsi_add_lun() {
	...
	mutex_lock(&sdev->state_mutex);
	ret =3D scsi_device_set_state(sdev, SDEV_RUNNING);
	if (ret)
		ret =3D scsi_device_set_state(sdev, SDEV_BLOCK);
	mutex_unlock(&sdev->state_mutex);
	...
	if (!async && scsi_sysfs_add_sdev(sdev) !=3D 0)
		return SCSI_SCAN_NO_RESPONSE;
}

If a command issued during this window receives a UNIT_ATTENTION with
INQUIRY_DATA_HAS_CHANGED (scheduling sdev->event_work -> scsi_evt_thread() =
->
scsi_rescan_device()), or a caller invokes scsi_rescan_device() while sdev =
is
in SDEV_RUNNING before device_add() has been called, scsi_rescan_device()
only checks sdev->sdev_state =3D=3D SDEV_RUNNING without checking
device_is_registered(dev) or sdev->is_visible.

When need_reprobe is true, device_reprobe() -> bus_rescan_devices_helper() =
->
device_attach() -> __device_attach() dereferences dev->p->dead while dev->p
is still NULL.

> +
> +		/*
> +		 * state_mutex serializes against __scsi_remove_device(), so
> +		 * a device that is being removed cannot be moved from
> +		 * SDEV_CANCEL or SDEV_DEL to SDEV_OFFLINE.
> +		 */
> +		mutex_lock(&sdev->state_mutex);
> +		if (sdev->sdev_state =3D=3D SDEV_CANCEL ||
> +		    sdev->sdev_state =3D=3D SDEV_DEL) {
> +			ret =3D -ENODEV;
> +		} else if (ret < 0) {
> +			if (scsi_device_set_state(sdev, SDEV_OFFLINE) =3D=3D 0)

[Severity: High]
Will checking ret < 0 here ever catch upper-level driver probe failures from
device_reprobe()?

Following the call chain device_reprobe() -> bus_rescan_devices_helper() ->
device_attach() -> __device_attach() -> __device_attach_driver() ->
driver_probe_device() -> __driver_probe_device() -> really_probe():

drivers/base/dd.c:really_probe() {
	...
	ret =3D call_driver_probe(dev, drv);
	if (ret) {
		if (link_ret =3D=3D -EAGAIN)
			ret =3D -EPROBE_DEFER;

		/*
		 * Return probe errors as positive values so that the callers
		 * can distinguish them from other errors.
		 */
		ret =3D -ret;
		goto probe_failed;
	}
}

And in __device_attach_driver():

drivers/base/dd.c:__device_attach_driver() {
	...
	ret =3D driver_probe_device(drv, dev);
	if (ret < 0)
		return ret;
	return ret =3D=3D 0;
}

Because really_probe() negates driver probe errors into positive values and
__device_attach_driver() converts positive returns into 0, device_reprobe()
returns 0 when a SCSI driver's probe callback fails, leaving the device in
SDEV_RUNNING without a driver instead of marking it SDEV_OFFLINE.

Conversely, when probing is deferred (such as when defer_all_probes is set
during system suspend/hibernation), really_probe() returns -EPROBE_DEFER
(negative) and queues dev on deferred_probe_pending_list, which causes the
ret < 0 check to mark the device SDEV_OFFLINE while its probe is deferred.

> +				sdev_printk(KERN_WARNING, sdev,
> +					    "device reprobe failed (%d), marked offline\n",
> +					    ret);
> +			else
> +				sdev_printk(KERN_WARNING, sdev,
> +					    "device reprobe failed (%d)\n", ret);
> +		}
> +		mutex_unlock(&sdev->state_mutex);
> +		goto unlock;
> +	}

[ ... ]

>
>=20

=E5=AE=8C=E7=BE=8E=E7=BB=93=E6=9D=9F=E3=80=82

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019221405.4061=
4-1-brian@purestorage.com?part=3D4

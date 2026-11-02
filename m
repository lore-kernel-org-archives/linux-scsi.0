Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793628364;
	b=1bc8uB144UiYrxKU48xHROUkRU/oEK/adAqMf3VThciGS6FUv0iDs24GI9f4Cr1xuVWZ
	 dcd36bAVtdgb2AFRVOdUQI9mKxZA3MpeL+Q5zPJEac8u+12FWY/CI4cpY0Sjp6ih2FYbc
	 tvIGi6K3KGzFOGptzdyCw96izvX8yIwoj3RIAjYIWOo2PoyUYq+3OSdN+DK5ZtxFRshG8
	 sHyvqQHaFyfQBPGulX4NgeNTKy57ZnAplffLduY90e4D6l+5AY3qD2mfqCcpCxxxnHb1E
	 SMQzi7AVwhJaLocOD3xQIpp29DnKYLV6DYew5FdQ5FV5NI7/1hqV/EPl3C4uSXuSlcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793628364;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=+fg6Ehoh0iTyWfObODRkCugp/L7wnz8F1QclqvaiFBo=;
	b=ws/ARyg4Vquk7zmczB4moIUkyI3PgLmCVs9QjXHgfJSz6QhZ7Mxpwu50W1wyTsyZ/X/u
	 cBy6Eat8KRBFGvS9EsVPnZuRhrsEd4toBgMKkCYlwljYIWbQShGBFPz+6DJdNoy8K0qmQ
	 ZACeN0XgZirT4TiGh+Jsds+hy8eoGQ/2SMV2U8Sli86tOtrAWjjdh8pWJCWbgIIuPXy3u
	 e86iRRMKzRHkZy3mPgfsGy7cd4W/t8Mk1S14gQz91X1lrN1pgASAs43j9q3x+N50/Kfn/
	 ffuuTODYJondPGHuwcB8Hu2FPD0e5rkPLKJkXx+T/oQfyCV6Z5DOpAG7/O5I+hcMeHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="KhXfp9+/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE875606A329
	for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2026 14:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KhXfp9+/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33BC11F00A16;
	Mon,  2 Nov 2026 14:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793628363;
	bh=+fg6Ehoh0iTyWfObODRkCugp/L7wnz8F1QclqvaiFBo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KhXfp9+/+D4AuaRiEp+6vpA12XoPBAjwbVz7mPBAtqEAlYKNFnFnIfDFmGKrkun3g
	 Amm2YYRBKS3c9scGg0lmcc7mjIqMU15gGZiI16swecbgyYFOaGXN+cnXhJxIiww91o
	 uYWnLcp/R4Q1WS9oqbl+9Kqv7wwisT7duIAcqGndrese5o9Uc3mVq1r1LT624qClKh
	 Ml5o1nZRwusvVsXKhrPwyWzIssm5N4An6IbSrOQIYcZpn59hvE5djduiDvu7s3wkXt
	 BDqEQ3ae1vwf/oNO5ElcgfAfmzcvraaUQ1634KNVrth9mt+RKRdtndEIS77r+Ctzaz
	 UNt16VIOrJfcQ==
Message-ID: <sashiko-outbox-193523@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] scsi: mpt3sas: Time out delayed not-responding
 device blocks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jeff Layton" <jlayton@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261102-sas-abba-v2-2-b3b9ba874b5a@kernel.org>
References: <20261102-sas-abba-v2-0-b3b9ba874b5a@kernel.org>
 <20261102-sas-abba-v2-2-b3b9ba874b5a@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 14:06:02 +0000
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
- [High] scsi: mpt3sas: race between _scsih_dnr_unblock_work() and unlocked=
 unblock paths
- [High] scsi: mpt3sas: _scsih_clear_block_deadline() races and misses bloc=
ked sdevs
- [Medium] scsi: mpt3sas: _scsih_dnr_unblock_work() unblocks devices during=
 host recovery
--

commit 3086ca833022a9345fb0fd3cc229d91c87b61323
Author: Jeff Layton <jlayton@kernel.org>

scsi: mpt3sas: Time out delayed not-responding device blocks

This commit adds a delayed work item to time out and release device blocks
triggered by DELAY_NOT_RESPONDING events if the device missing delay expires
without a subsequent firmware event unblocking the device. This avoids a
deadlock where a sysfs SCSI scan holds sas_host->lock while waiting on a
blocked sdev and prevents the firmware event worker from acquiring
sas_host->lock.

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/=
mpt3sas_scsih.c
> index c7886a12d3088..af2666f9576e5 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c

[ ... ]

> @@ -3934,6 +3936,26 @@ _scsih_internal_device_unblock(struct scsi_device =
*sdev,
>  	}
>  }
> =20
> +/**
> + * _scsih_clear_block_deadline - keep dnr_unblock_work off a blocked sdev
> + * @ioc: per adapter object
> + * @sas_device_priv_data: per device driver private data
> + *
> + * Called by the firmware event worker before it polls a blocked device
> + * with TURs.  The worker unblocks the device when polling ends, and
> + * must not have dnr_unblock_work send I/O to it in the meantime.
> + */
> +static void
> +_scsih_clear_block_deadline(struct MPT3SAS_ADAPTER *ioc,
> +			    struct MPT3SAS_DEVICE *sas_device_priv_data)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&ioc->block_lock, flags);
> +	sas_device_priv_data->block_deadline =3D 0;
> +	spin_unlock_irqrestore(&ioc->block_lock, flags);
> +}
> +
>  /**
>   * _scsih_ublock_io_all_device - unblock every device
>   * @ioc: per adapter object
> @@ -3974,6 +3996,7 @@ _scsih_ublock_io_all_device(struct MPT3SAS_ADAPTER =
*ioc, u8 no_turs)
>  			continue;
>  		}
> =20
> +		_scsih_clear_block_deadline(ioc, sas_device_priv_data);
>  		do {
>  			pcie_device =3D mpt3sas_get_pdev_by_handle(ioc, sas_target->handle);
>  			if (pcie_device && (!ioc->tm_custom_handling) &&
> @@ -4089,6 +4112,7 @@ _scsih_ublock_io_device_wait(struct MPT3SAS_ADAPTER=
 *ioc, u64 sas_address,
>  		if (!sas_device_priv_data->block)
>  			continue;
> =20
> +		_scsih_clear_block_deadline(ioc, sas_device_priv_data);

[Severity: High]
As reported by Sashiko on v1 [1], can _scsih_dnr_unblock_work() still race
with the firmware event worker or unblock remaining sdevs while the worker =
is
polling devices?

First, in both _scsih_ublock_io_all_device() and
_scsih_ublock_io_device_wait(), sdev->hostdata and
sas_device_priv_data->block are checked without holding ioc->block_lock
before passing sas_device_priv_data to _scsih_clear_block_deadline(). If
__scsi_remove_device() -> scsih_sdev_destroy() runs concurrently, it clears
sdev->hostdata under ioc->block_lock and frees sas_device_priv_data before
_scsih_clear_block_deadline() takes ioc->block_lock and writes to
sas_device_priv_data->block_deadline. Even if the sdev is not being removed,
_scsih_dnr_unblock_sdev() can run between the unlocked
sas_device_priv_data->block check and _scsih_clear_block_deadline(), leaving
the worker to poll an already-unblocked running sdev with TURs.

Second, _scsih_clear_block_deadline() is called inside the
shost_for_each_device() loop for one sdev at a time right before
_scsih_wait_for_device_to_become_ready(), which sleeps across up to
command_retry_count retries. While the worker sleeps polling the first
blocked sdev (such as LUN 0 of a multi-LUN target in
_scsih_ublock_io_device_wait(), or the first blocked device in
_scsih_ublock_io_all_device()), block_deadline remains active on all subseq=
ent
blocked sdevs. If their deadline expires during that sleep,
_scsih_dnr_unblock_work() will unblock those sdevs prematurely and cause the
polling loop to skip them when it later checks sas_device_priv_data->block.

Third, when _scsih_sas_broadcast_primitive_event() calls
_scsih_block_io_all_device() to keep all devices blocked during broadcast
primitive task management, any sdev already blocked by an earlier
DELAY_NOT_RESPONDING event is skipped without clearing block_deadline:

drivers/scsi/mpt3sas/mpt3sas_scsih.c:_scsih_block_io_all_device()
	shost_for_each_device(sdev, ioc->shost) {
		sas_device_priv_data =3D sdev->hostdata;
		if (!sas_device_priv_data)
			continue;
		if (sas_device_priv_data->block)
			continue;

If that earlier deadline expires while _scsih_sas_broadcast_primitive_event=
()
is still running, wouldn't _scsih_dnr_unblock_work() unblock the device in
the middle of task management?

>  		do {
>  			host_reset_completion_count =3D 0;
>  			pcie_device =3D mpt3sas_get_pdev_by_handle(ioc, sas_target->handle);
> @@ -4225,6 +4249,92 @@ _scsih_block_io_all_device(struct MPT3SAS_ADAPTER =
*ioc)
>  	}
>  }
> =20
> +/*
> + * Margin on top of the firmware's report device missing delay before
> + * _scsih_dnr_unblock_work() releases a delayed not-responding block.
> + */
> +#define MPT3SAS_DNR_BLOCK_SLACK	30
> +
> +static unsigned long
> +_scsih_dnr_block_timeout(struct MPT3SAS_ADAPTER *ioc)
> +{
> +	return (max(ioc->device_missing_delay, ioc->pcie_device_missing_delay) +
> +	    MPT3SAS_DNR_BLOCK_SLACK) * HZ;
> +}
> +
> +/**
> + * _scsih_dnr_unblock_sdev - release an expired delayed not-responding b=
lock
> + * @ioc: per adapter object
> + * @sdev: scsi device struct
> + *
> + * Return: the deadline of an unexpired block on @sdev, or 0 if none.
> + */
> +static unsigned long
> +_scsih_dnr_unblock_sdev(struct MPT3SAS_ADAPTER *ioc, struct scsi_device =
*sdev)
> +{
> +	struct MPT3SAS_DEVICE *sas_device_priv_data;
> +	unsigned long flags, deadline =3D 0;
> +
> +	spin_lock_irqsave(&ioc->block_lock, flags);
> +	sas_device_priv_data =3D sdev->hostdata;
> +	if (!sas_device_priv_data || !sas_device_priv_data->block ||
> +	    !sas_device_priv_data->block_deadline)
> +		goto out;
> +	if (time_before(jiffies, sas_device_priv_data->block_deadline)) {
> +		deadline =3D sas_device_priv_data->block_deadline;
> +		goto out;
> +	}
> +	sdev_printk(KERN_WARNING, sdev,
> +	    "delayed not-responding block expired, handle(0x%04x)\n",
> +	    sas_device_priv_data->sas_target->handle);
> +	_scsih_internal_device_unblock(sdev, sas_device_priv_data);
> +out:
> +	spin_unlock_irqrestore(&ioc->block_lock, flags);
> +	return deadline;
> +}

[Severity: High]
Does _scsih_dnr_unblock_sdev() race with the other unblock paths that do not
acquire ioc->block_lock?

While _scsih_dnr_unblock_sdev() runs on system_dfl_wq under ioc->block_lock,
_scsih_ublock_io_device() (called from interrupt context in
mpt3sas_scsih_event_callback() -> _scsih_tm_tr_send() on
MPI2_EVENT_SAS_TOPO_RC_TARG_NOT_RESPONDING and from worker context in
_scsih_check_device() and _scsih_remove_device()),
_scsih_ublock_io_all_device(), and _scsih_ublock_io_device_wait() inspect a=
nd
clear sas_device_priv_data->block and call _scsih_internal_device_unblock()
or scsi_internal_device_unblock_nowait() without holding ioc->block_lock:

drivers/scsi/mpt3sas/mpt3sas_scsih.c:_scsih_ublock_io_device()
	shost_for_each_device(sdev, ioc->shost) {
		...
		if (sas_device_priv_data->block)
			_scsih_internal_device_unblock(sdev,
				sas_device_priv_data);
	}

If _scsih_dnr_unblock_sdev() and _scsih_ublock_io_device() (or
_scsih_ublock_io_all_device()) both see sas_device_priv_data->block =3D=3D =
1 and
call _scsih_internal_device_unblock() concurrently, the first call transiti=
ons
sdev->sdev_state from SDEV_BLOCK to SDEV_RUNNING (or from SDEV_CREATED_BLOCK
to SDEV_CREATED). The second caller's scsi_internal_device_unblock_nowait()
then returns -EINVAL and enters the fallback path in
_scsih_internal_device_unblock():

drivers/scsi/mpt3sas/mpt3sas_scsih.c:_scsih_internal_device_unblock()
	r =3D scsi_internal_device_unblock_nowait(sdev, SDEV_RUNNING);
	if (r =3D=3D -EINVAL) {
		...
		sas_device_priv_data->block =3D 1;
		r =3D scsi_internal_device_block_nowait(sdev);
		...
		sas_device_priv_data->block =3D 0;
		r =3D scsi_internal_device_unblock_nowait(sdev, SDEV_RUNNING);
	}

That re-blocks the already-unblocked sdev, and if the sdev was in
SDEV_CREATED during a scan, scsi_internal_device_block_nowait() puts it back
into SDEV_CREATED_BLOCK where the subsequent unblock transitions it only to
SDEV_CREATED, racing with scsi_sysfs_add_sdev().

In addition, when _scsih_ublock_io_device(), _scsih_ublock_io_all_device(),=
 or
_scsih_ublock_io_device_wait() clears sas_device_priv_data->block =3D 0 wit=
hout
holding ioc->block_lock before calling scsi_internal_device_unblock_nowait(=
),
a concurrent DELAY_NOT_RESPONDING interrupt in _scsih_block_io_device() can
take ioc->block_lock, observe block =3D=3D 0, set block =3D 1 and block_dea=
dline,
and call scsi_internal_device_block_nowait(). The unblocking thread then ru=
ns
scsi_internal_device_unblock_nowait(sdev, SDEV_RUNNING), leaving sdev in
SDEV_RUNNING with its request queue started while sas_device_priv_data->blo=
ck
is still 1 (causing scsih_qcmd() to return SCSI_MLQUEUE_DEVICE_BUSY for all
commands).

Should all unblock paths synchronize using ioc->block_lock?

> +
> +/**
> + * _scsih_dnr_unblock_work - release expired delayed not-responding bloc=
ks
> + * @work: the dnr_unblock_work of the adapter
> + *
> + * Within the device missing delay, the firmware either reports the devi=
ce
> + * as not responding, and the event callback unblocks it, or the device
> + * comes back, and only the firmware event worker unblocks it.  The work=
er
> + * may first need shost->scan_mutex or the SAS transport's host lock, and
> + * a scan holding those can have a command queued on the blocked sdev.
> + * Past the delay the block has no further use, so release it here.
> + */
> +static void
> +_scsih_dnr_unblock_work(struct work_struct *work)
> +{
> +	struct MPT3SAS_ADAPTER *ioc =3D container_of(to_delayed_work(work),
> +	    struct MPT3SAS_ADAPTER, dnr_unblock_work);
> +	struct scsi_device *sdev;
> +	unsigned long deadline, next =3D 0;
> +
> +	if (ioc->remove_host)
> +		return;
> +	if (ioc->shost_recovery || ioc->pci_error_recovery) {
> +		queue_delayed_work(system_dfl_wq, &ioc->dnr_unblock_work, HZ);
> +		return;
> +	}

[Severity: Medium]
Should _scsih_dnr_unblock_work() also check scsi_host_in_recovery(ioc->shos=
t)
and avoid unblocking targets marked sas_target->deleted, and use
mod_delayed_work() here?

When a host reset finishes in mpt3sas_base_hard_reset_handler(),
mpt3sas_scsih_reset_done_handler() marks unresponding targets with
sas_target->deleted =3D 1 and queues MPT3SAS_REMOVE_UNRESPONDING_DEVICES, a=
nd
ioc->shost_recovery is cleared to 0 while scsi_host_in_recovery(ioc->shost)
can remain true until SCSI EH finishes. During SHOST_RECOVERY, scsih_qcmd()
relies on sas_device_priv_data->block remaining set so TEST_UNIT_READY
commands complete immediately with UNIT_ATTENTION / I_T_NEXUS_LOSS_OCCURRED,
which is why _mpt3sas_fw_work() waits for both scsi_host_in_recovery() and
ioc->shost_recovery before running _scsih_remove_unresponding_devices():

drivers/scsi/mpt3sas/mpt3sas_scsih.c:_mpt3sas_fw_work()
	case MPT3SAS_REMOVE_UNRESPONDING_DEVICES:
		while (scsi_host_in_recovery(ioc->shost) ||
					 ioc->shost_recovery) {
			if (ioc->remove_host || ioc->fw_events_cleanup)
				goto out;
			ssleep(1);
		}
		_scsih_remove_unresponding_devices(ioc);

Because _scsih_dnr_unblock_work() only checks ioc->shost_recovery and
_scsih_dnr_unblock_sdev() does not check sas_target->deleted (unlike
_scsih_ublock_io_all_device()), a block deadline expiring after
ioc->shost_recovery clears can unblock pre-reset or deleted devices while
SHOST_RECOVERY or post-reset device removal is still pending.

Also, if _scsih_block_io_device() queues dnr_unblock_work with a full timeo=
ut
at the same time _scsih_dnr_unblock_work() enters the recovery deferral
branch, queue_delayed_work(..., HZ) will be a no-op because the work item is
already pending, pushing the 1-second retry out to the full timeout unless
mod_delayed_work() is used.

[1] https://lore.kernel.org/r/20261030-sas-abba-v1-1-b8cdd714a37c@kernel.org

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-sas-abba-v=
2-0-b3b9ba874b5a@kernel.org?part=3D2

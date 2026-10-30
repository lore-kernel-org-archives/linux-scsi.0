Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793373110;
	b=GO/Vw7GV8bt4d/ayRcGUesKPDn+bslQwDFZk8Pkun8GVc1KDlDemLMfcQ9TgR9raxVfX
	 gtva6ff1pAlf14+4VI0DX9/RJqkzW52xlV8BuR7O1akotjhJtUKkxcpDuhTnMmR8nc68u
	 UYqUDUXeKEvB2hRlfLhCHbSUJ8MLStOeXxgkKsTe2Ag0QF3DBc/Nl7bvrtBfQv1S0NUy8
	 n9l/iQ88zFn4WaUl3eXu03c51xyj5yQ/172UMM3b0DcWozw/jddeM4sopKn4u6fou+tPk
	 4R1jBBQbwqRD0di+G+ArIDVcEEmigRODoYqqxGb3JlVgD4+SdutR4SrDxWE50Sm14oA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793373110;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ofW/E7+P4QejBOVA/fyLWR0z3UaG5FhQMjEI2pXGqik=;
	b=Q+MBJ9lRlpysXatugixaNfL7PxfOZCvRl+6DpMTVJUC/pH2qGRE4ifq9BZxmEFp60xYU
	 0itOjtas8n/7LUFbDfB9QsDVrK+RAJqyZUFGGaD/pdYT/zkdI1bkwzHLN4ct2VBi8y1DY
	 5RwEBgp+qXtgni/Vv0BKtHz847K0vtSsIvL1oZoREYJUbzkO0y1djFmaLGf6uyo7+EgFA
	 ZJGzywAjhjfzO3r/X3J4JRi12romH7Kzgv6+m3IDF2u5/WHJvmzc5hdsb4ZCmRtgj29VZ
	 u8vQ0aygDwvR6pew8vm4jWqyoanNZrF65pha+Wd8a3uZQSd1MWFT3BIIF6m0tiIssDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Iqr3A3oO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50EA2606A31A
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2026 15:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Iqr3A3oO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B89591F000C1;
	Fri, 30 Oct 2026 15:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793373109;
	bh=ofW/E7+P4QejBOVA/fyLWR0z3UaG5FhQMjEI2pXGqik=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Iqr3A3oOuSv4V+L+9+q0feIfKIhFQxDIOiwRDld6chAwXF3RKCcQoJNT8QKI0Dkl/
	 OQAXbbEfiJLtwA38KAMU88VcMHr5N/xqtjqigg0wLW3kVFWZOreJUEGlREiIS4kvBs
	 Evj30t1VFFuRG3N8opqqeLMR6qFFQkng+mc2LHNi32nImUwWfSqB+CPQrG5UsWTgio
	 NvQT5zkGByNxgHoFrWwEtxqJhsCxp0IeQzFMFEIOsDbIwQYb9edINxsUHocSz0nPy4
	 W4jDIlUXaA2w7blh5B7IxpgUk4cPCbDtGNCgaLkdRv3/TwuzTGabB0NMLf/Sw5Jf5N
	 1UWfQiL2v9dNA==
Message-ID: <sashiko-outbox-191144@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: mpt3sas: Time out delayed not-responding device
 blocks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jeff Layton" <jlayton@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261030-sas-abba-v1-1-b8cdd714a37c@kernel.org>
References: <20261030-sas-abba-v1-1-b8cdd714a37c@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 15:11:49 +0000
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
- [High] scsi: mpt3sas: use-after-free of sdev->hostdata in _scsih_dnr_unbl=
ock_work()
- [High] scsi: mpt3sas: race on block state in _scsih_dnr_unblock_work()
--

commit e9db80ae705cdf5de784aed30440e0d8af678dd9
Author: Jeff Layton <jlayton@kernel.org>

scsi: mpt3sas: Time out delayed not-responding device blocks

This commit adds a delayed work item (dnr_unblock_work) to time out and
release delayed not-responding SDEV_BLOCK states on SCSI devices after the
firmware's report device missing delay plus a 30-second margin, preventing
deadlocks during concurrent sysfs scans.

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/=
mpt3sas_scsih.c
> index 085d4672db854..dda5a429a9173 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -3878,6 +3878,7 @@ _scsih_internal_device_block(struct scsi_device *sd=
ev,
>  	sdev_printk(KERN_INFO, sdev, "device_block, handle(0x%04x)\n",
>  	    sas_device_priv_data->sas_target->handle);
>  	sas_device_priv_data->block =3D 1;
> +	sas_device_priv_data->block_deadline =3D 0;
> =20
>  	r =3D scsi_internal_device_block_nowait(sdev);
>  	if (r =3D=3D -EINVAL)
> @@ -3903,6 +3904,7 @@ _scsih_internal_device_unblock(struct scsi_device *=
sdev,
>  	sdev_printk(KERN_WARNING, sdev, "device_unblock and setting to running,=
 "
>  	    "handle(0x%04x)\n", sas_device_priv_data->sas_target->handle);
>  	sas_device_priv_data->block =3D 0;
> +	sas_device_priv_data->block_deadline =3D 0;
>  	r =3D scsi_internal_device_unblock_nowait(sdev, SDEV_RUNNING);
>  	if (r =3D=3D -EINVAL) {
>  		/* The device has been set to SDEV_RUNNING by SD layer during
> @@ -4121,6 +4123,7 @@ _scsih_ublock_io_device_wait(struct MPT3SAS_ADAPTER=
 *ioc, u64 sas_address,
>  			&& count++ <=3D command_retry_count);
> =20
>  		sas_device_priv_data->block =3D 0;
> +		sas_device_priv_data->block_deadline =3D 0;
>  		if (rc !=3D DEVICE_READY)
>  			sas_device_priv_data->deleted =3D 1;
>  		scsi_internal_device_unblock_nowait(sdev, SDEV_RUNNING);
> @@ -4221,6 +4224,74 @@ _scsih_block_io_all_device(struct MPT3SAS_ADAPTER =
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
> +	struct MPT3SAS_DEVICE *sas_device_priv_data;
> +	struct scsi_device *sdev;
> +	unsigned long deadline, next =3D 0;
> +
> +	if (ioc->remove_host)
> +		return;
> +	if (ioc->shost_recovery || ioc->pci_error_recovery) {
> +		queue_delayed_work(system_dfl_wq, &ioc->dnr_unblock_work, HZ);
> +		return;
> +	}
> +
> +	shost_for_each_device(sdev, ioc->shost) {
> +		sas_device_priv_data =3D sdev->hostdata;
> +		if (!sas_device_priv_data || !sas_device_priv_data->block)
> +			continue;
> +		deadline =3D sas_device_priv_data->block_deadline;
> +		if (!deadline)
> +			continue;
> +		if (time_before(jiffies, deadline)) {
> +			if (!next || time_before(deadline, next))
> +				next =3D deadline;
> +			continue;
> +		}
> +		sdev_printk(KERN_WARNING, sdev,
> +		    "delayed not-responding block expired, handle(0x%04x)\n",
> +		    sas_device_priv_data->sas_target->handle);
> +		_scsih_internal_device_unblock(sdev, sas_device_priv_data);
> +	}

[Severity: High]
Can _scsih_dnr_unblock_work() trigger a use-after-free on sdev->hostdata
(struct MPT3SAS_DEVICE) and sas_device_priv_data->sas_target (struct
MPT3SAS_TARGET)?

_scsih_dnr_unblock_work() runs on system_dfl_wq without holding
shost->scan_mutex, shost->host_lock, or any adapter lock. Inside
shost_for_each_device(), __scsi_iterate_devices() only holds
shost->host_lock while calling scsi_device_get(sdev) to take a reference on
sdev->sdev_gendev, then drops shost->host_lock before returning sdev to the
loop body.

Concurrently on another CPU, __scsi_remove_device(sdev) can run (for
example, when scsi_probe_and_add_lun() fails on a newly allocated sdev
after TARG_NOT_RESPONDING unblocks it, when ioc->firmware_event_thread
removes the target via scsi_remove_target(), or via sysfs delete).
__scsi_remove_device() synchronously invokes scsih_sdev_destroy() before
put_device(&sdev->sdev_gendev):

drivers/scsi/mpt3sas/mpt3sas_scsih.c:scsih_sdev_destroy() {
    ...
	kfree(sdev->hostdata);
	sdev->hostdata =3D NULL;
}

and scsi_target_reap() invokes scsih_target_destroy(), freeing
starget->hostdata (sas_target).

Because holding a reference on sdev->sdev_gendev does not prevent
__scsi_remove_device() from calling ->sdev_destroy(),
_scsih_dnr_unblock_work() and _scsih_internal_device_unblock() can read and
write freed sas_device_priv_data (block and block_deadline) and dereference
freed sas_device_priv_data->sas_target->handle.

> +
> +	/*
> +	 * A block made while this ran may have queued the work already,
> +	 * with its own later deadline.  Pull the timer in to the earliest
> +	 * one seen here; the next run reschedules for the rest.
> +	 */
> +	if (next)
> +		mod_delayed_work(system_dfl_wq, &ioc->dnr_unblock_work,
> +		    max_t(long, next - jiffies, 1));
> +}
> +
>  /**
>   * _scsih_block_io_device - set the device state to SDEV_BLOCK
>   * @ioc: per adapter object
> @@ -4234,6 +4305,8 @@ _scsih_block_io_device(struct MPT3SAS_ADAPTER *ioc,=
 u16 handle)
>  	struct MPT3SAS_DEVICE *sas_device_priv_data;
>  	struct scsi_device *sdev;
>  	struct _sas_device *sas_device;
> +	unsigned long timeout =3D _scsih_dnr_block_timeout(ioc);
> +	bool blocked =3D false;
> =20
>  	sas_device =3D mpt3sas_get_sdev_by_handle(ioc, handle);
> =20
> @@ -4254,10 +4327,16 @@ _scsih_block_io_device(struct MPT3SAS_ADAPTER *io=
c, u16 handle)
>  			continue;
>  		}
>  		_scsih_internal_device_block(sdev, sas_device_priv_data);
> +		sas_device_priv_data->block_deadline =3D (jiffies + timeout) ?: 1;
> +		blocked =3D true;
>  	}

[Severity: High]
Does running _scsih_dnr_unblock_work() on system_dfl_wq without
synchronization race with _scsih_block_io_device() in interrupt context and
_scsih_ublock_io_device_wait() on firmware_event_thread?

There appear to be two races on sas_device_priv_data->block,
sas_device_priv_data->block_deadline, and sdev->sdev_state:

1. _scsih_dnr_unblock_work() runs in process context with interrupts
enabled and calls _scsih_internal_device_unblock():

drivers/scsi/mpt3sas/mpt3sas_scsih.c:_scsih_internal_device_unblock() {
    ...
	sas_device_priv_data->block =3D 0;
	sas_device_priv_data->block_deadline =3D 0;
	r =3D scsi_internal_device_unblock_nowait(sdev, SDEV_RUNNING);
    ...
}

If an interrupt for a new DELAY_NOT_RESPONDING event fires right after
sas_device_priv_data->block =3D 0 is written,
mpt3sas_scsih_event_callback()->_scsih_block_io_device() sees
sas_device_priv_data->block =3D=3D 0, calls _scsih_internal_device_block()
(setting sas_device_priv_data->block =3D 1 and sdev->sdev_state =3D SDEV_BL=
OCK),
and sets a new non-zero sas_device_priv_data->block_deadline.

When _scsih_internal_device_unblock() resumes, it overwrites
sas_device_priv_data->block_deadline =3D 0 and calls
scsi_internal_device_unblock_nowait(sdev, SDEV_RUNNING). That leaves sdev
in SDEV_RUNNING with sas_device_priv_data->block =3D=3D 1 and
block_deadline =3D=3D 0, causing scsih_qcmd() to reject all commands with
SCSI_MLQUEUE_DEVICE_BUSY indefinitely while _scsih_dnr_unblock_work()
ignores the device because block_deadline is 0.

2. In _scsih_ublock_io_device_wait() (and _scsih_ublock_io_all_device()),
sas_device_priv_data->block_deadline remains armed throughout the
_scsih_wait_for_device_to_become_ready() retry loop (up to
command_retry_count =3D 144 retries). If block_deadline expires while
_scsih_ublock_io_device_wait() is still polling the returning device or
offlining a failed device, _scsih_dnr_unblock_work() will concurrently call
_scsih_internal_device_unblock() and transition the device to SDEV_RUNNING.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030-sas-abba-v=
1-1-b8cdd714a37c@kernel.org?part=3D1

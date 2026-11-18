Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044478;
	b=c4GYWUDBveI2dh9YanRzSJ5icG+wyllnLObhI01xIc9T2vr1p4cIWkKBTcquTQcWG1v5
	 dGQOSv5gjiOX9VBEHnUr5gUBuitEEP+DZG3oaYn4XOwsIjHCeMoDfP0FKO0nm7m0UDhER
	 gHwY4Oo4i2ztG1wj6RMloobCMFzwbYHifc/icJpZhgqN2eW3THHiArr3RKjWRtIegwOvW
	 qri3c0UbdhBXUZoziCsPT/WDjt8ONKRDZoY3bbAxK1ketEnwWv5b5F4xyBslo36K/DScr
	 rSliP6oV8eK0KrNpu8kgUVHYWNeNVmUfRhQs7CAMj02IAioJjfhIKukvBWy8kppc8SA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044478;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=e/BREAmab+o4SfvXB42+GoJqFt9bgryejJB0QYqIJhA=;
	b=FliQgcUhCOIuhpOiAJFX6ovlXGwIXVr3XcF4DlQCpMh5OBHCYztQpVqD2n0uCEkdVL8O
	 ZsSWRXlsd33GFxHKlcbg/T+U0WfdvBm9xZ45GWPfENcohiJY1aqdzBVx14AkzunxLOE+V
	 vLJMVNz6Cnh+6DwdKf7WvXrdZijzW3TE3yPWrovFHtrt8jquLoM2p5YyMihh9Y7RxBx7E
	 +ZgbKhPXKyhonnsG7whzxic9ixh33vyfJ30KAJALA3MOPEgR7E6NgxPmzbvd3srULCept
	 wPU19DuhLpgb+sCTh3gkl0BrDvv2U/XDEyFljlkwWCPwl859vaCBFA0++ks3C73kygQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UC1rKtE4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0883606A325
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UC1rKtE4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C70A1F000C4;
	Wed, 18 Nov 2026 23:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795044477;
	bh=e/BREAmab+o4SfvXB42+GoJqFt9bgryejJB0QYqIJhA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UC1rKtE4JEAuxbh445WPWFFC+S56QZVyY+Vbg1QeJDQPr3MibDVDQsSvl7G6pg7ok
	 BzrilLzvLOF0IJmb2xaGaewpaBy9BOA1MC1QoltgBd9Gu4469/FTSPdHlf0s3pUV1l
	 EynAgY75sjQ+2YRgQXrpvYUUtyvpLia94rF88Pg5Ydy1wsbca0/d2YUD+hDZCShi1w
	 SGEi7Ow/Tabm5aGn2xQwMOM6+BoD8UTp1Tvh3P4f9naqQBxunyVYKHoSUSg6XKF4+O
	 lgUjzfhksSkdWGP6VKATk7RG+bI4q+Z/IQEKQiZeL0HRvdYYT+MWq2BeGaUnRme3Rq
	 Dfrxufe60fkdg==
Message-ID: <sashiko-outbox-222179@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 06/11] scsi: mpt3sas: Stop polling devices when the
 unresponding scan is cancelled
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jeff Layton" <jlayton@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261118-sas-abba-v3-6-5562d690cf61@kernel.org>
References: <20261118-sas-abba-v3-0-5562d690cf61@kernel.org>
 <20261118-sas-abba-v3-6-5562d690cf61@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 23:27:57 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] scsi: mpt3sas: _mpt3sas_fw_work() continues scan after
  cancellation
- [High] scsi: mpt3sas: _scsih_unresponding_scan_cancelled() ignores
  shost_recovery
--

commit 35d95180d221b7f75fd9660f0fc687ebab407910
Author: Jeff Layton <jlayton@kernel.org>

scsi: mpt3sas: Stop polling devices when the unresponding scan is cancelled

This commit stops the device readiness polling loop in
_scsih_ublock_io_all_device() and returns early when ioc->remove_host or
ioc->fw_events_cleanup is set.

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/=
mpt3sas_scsih.c
> index 5d494ad12c542..5657bda241f77 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -4057,6 +4057,22 @@ _scsih_internal_device_unblock(struct scsi_device =
*sdev,
>  	}
>  }
> =20
> +/**
> + * _scsih_unresponding_scan_cancelled - should polling devices stop
> + * @ioc: per adapter object
> + *
> + * While the MPT3SAS_REMOVE_UNRESPONDING_DEVICES event polls devices, a
> + * hard reset or the removal of the host waits for it to finish, and the
> + * readiness check doesn't test devices during a reset.
> + *
> + * Return: true if the event is being cancelled, false otherwise.
> + */
> +static bool
> +_scsih_unresponding_scan_cancelled(struct MPT3SAS_ADAPTER *ioc)
> +{
> +	return READ_ONCE(ioc->remove_host) || READ_ONCE(ioc->fw_events_cleanup);
> +}

[Severity: High]
Can a device still exhaust its retries and be offlined untested while
ioc->shost_recovery is set before ioc->fw_events_cleanup is set?

mpt3sas_base_hard_reset_handler() sets ioc->shost_recovery =3D 1 before
running mpt3sas_wait_for_commands_to_complete() (up to 10 seconds) and
mpt3sas_base_make_ioc_ready() (15 to 45+ seconds), whereas
ioc->fw_events_cleanup is only set later inside
_base_clear_outstanding_commands() -> ... ->
_scsih_fw_event_cleanup_queue().  During that initial reset window,
_scsih_wait_for_device_to_become_ready() immediately returns DEVICE_RETRY
without testing the device, while _scsih_unresponding_scan_cancelled()
still returns false.  If count reaches command_retry_count before
_scsih_fw_event_cleanup_queue() runs (or if mpt3sas_base_make_ioc_ready()
fails and skips _base_clear_outstanding_commands()), the loop still marks
the untested device deleted and SDEV_OFFLINE.

>  /**
>   * _scsih_ublock_io_all_device - unblock every device
>   * @ioc: per adapter object
> @@ -4114,7 +4130,13 @@ _scsih_ublock_io_all_device(struct MPT3SAS_ADAPTER=
 *ioc, u8 no_turs)
>  				pcie_device_put(pcie_device);
>  		} while ((rc =3D=3D DEVICE_RETRY || rc =3D=3D DEVICE_START_UNIT ||
>  		    rc =3D=3D DEVICE_STOP_UNIT || rc =3D=3D DEVICE_RETRY_UA)
> -			&& count++ < command_retry_count);
> +			&& count++ < command_retry_count &&
> +			!_scsih_unresponding_scan_cancelled(ioc));
> +		if (_scsih_unresponding_scan_cancelled(ioc)) {
> +			/* a reset queues a new scan, which polls the rest */
> +			scsi_device_put(sdev);
> +			return;
> +		}

[Severity: High]
When this returns early, doesn't _mpt3sas_fw_work() continue running the
rest of the MPT3SAS_REMOVE_UNRESPONDING_DEVICES handler while the reset or
removal is waiting in cancel_work_sync()?

drivers/scsi/mpt3sas/mpt3sas_scsih.c:_mpt3sas_fw_work() {
	...
	case MPT3SAS_REMOVE_UNRESPONDING_DEVICES:
		...
		_scsih_remove_unresponding_devices(ioc);
		_scsih_del_dirty_vphy(ioc);
		_scsih_del_dirty_port_entries(ioc);
		if (ioc->is_gen35_ioc)
			_scsih_update_device_qdepth(ioc);
		_scsih_scan_for_devices_after_reset(ioc);
		...
		if (ioc->is_driver_loading)
			_scsih_complete_devices_scanning(ioc);
		_scsih_set_nvme_max_shutdown_latency(ioc);
		break;
}

When cancelled by a hard reset, the reset thread holds
ioc->reset_in_progress_mutex with the controller in MPI2_IOC_STATE_READY
and blocks in _scsih_fw_event_cleanup_queue() -> cancel_work_sync() before
_base_make_ioc_operational() is reached.  _scsih_scan_for_devices_after_res=
et()
then issues config requests that wait for MPI2_IOC_STATE_OPERATIONAL in
mpt3sas_wait_for_ioc(): if ioc->is_driver_loading is set,
mpt3sas_wait_for_ioc() returns -ETIME and _config_request() calls
mpt3sas_base_hard_reset_handler(), deadlocking on
ioc->reset_in_progress_mutex; otherwise each config request stalls the
reset for its 15-second timeout.  Should _mpt3sas_fw_work() also bail out
to out after _scsih_remove_unresponding_devices() when
_scsih_unresponding_scan_cancelled(ioc) is true?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118-sas-abba-v=
3-0-5562d690cf61@kernel.org?part=3D6

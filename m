Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794999708;
	b=DTUaO7BXISqUw1j08Dv8dg9OXn/roNsWG0AObOz8vihJ20s97Jw+M2z3BVzDQbPmNFBE
	 ez7d7yr/mgxnOafsobAZyfD5ehpRGPxlRsMDW3T3djKXhdl76AKrJhfv/nkgVeiBhCfR2
	 CSiyVk5/nXUvFweIvte5XxgR3cQP2PM0elxbxpzPswBPGjSxwBywMuItE7/cN0B3raxXn
	 OhSaNz+NknSa5VXqqpHXwT5bBniT8OgTxWX0cjLkohWCI9539C4SXy0PMmVJb7k5WYOSC
	 ttsK6e5NM13cwUkfAS6IKyVIChXr/6p4/U+UEqGj9DmAxi5jO6mRwzgbge3CcnHKOEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794999708;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=vPBFD+iDfgkNc4Oy2mZiaU6ZQAYJvU14cNP/aa9IyVw=;
	b=RU2NqYXFQhX5xwUDSUaJFYVLi+X+pjf4Pz8r6vDFRh/FcTu7X6JpidpGUVuDM4/mXtqB
	 E0HAML1MVmsEYX75iXVs8QfMbeRzsSIWlbSwYctl+pz/g35s0qNZn1I1puv4OY6UoOYLg
	 sJ/OVF6WFmy0KjP6sHy1VMVhD7l771S5aVZJjrnD+9K9x2YpOc37BmkrGdmUUoSyRkiXS
	 vm4nC7w+hJwcHb4IyI+HA/NHykK9NBQqDFXA2MJV01GiEEQrKFUWzApL/yw0E6qcjlOht
	 /MtYM+xacDrlHcKMfs0hqRvqZOsukAclN2euRzy+eAjDm+KMJjCV8mhBo5hdSmyU8wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qv+7Tfqw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645F5606A320
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 11:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qv+7Tfqw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D91361F000C4;
	Wed, 18 Nov 2026 11:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794999708;
	bh=vPBFD+iDfgkNc4Oy2mZiaU6ZQAYJvU14cNP/aa9IyVw=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=Qv+7TfqwgNZ/TuELCeq7ncJM85P17H7uQMhsBoXkHUVN5MPgChJiagcc9oN/f1kos
	 as4xtDoGLyTVxPWqU5z714U0PVBMv/jbrWHHaVINO7VQeR+BG2XlNe8rQJWFsMnBiQ
	 xdHb/Jm6ZPNT1iQ92RUW2ehR1KLdkB/zW35oxA37lwSOhWjPRaOFzYECOO8tQSSu0Q
	 O9L+WENlrvirpcoFNHUv6pHGdx8fGDbvtEBt5bEl4tLKPqPI9ItZy6hShB/Fn/qUOT
	 145RFmOYcykyITFEUjLWDxHXejrNCjxeZGoVzgfVmmrVd+8189L7x7Bo2Q8G/AnCuO
	 4QCWhgG2O59bg==
Message-ID: <sashiko-outbox-220782@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 16/37] scsi: mpt3sas: Fix page fault from stale
 ioc->chip after PCI error recovery
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1794995806-5835-17-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1794995806-5835-17-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 11:01:47 +0000
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
- [High] scsi: mpt3sas: NULL ioc->chip dereference in
  mpt3sas_scsih_issue_tm()
- [Medium] scsi: mpt3sas: NULL ioc->chip dereference in
  _ctl_ioctl_main() paths
- [Medium] scsi: mpt3sas: race on ioc->chip unmap in hard reset and
  config paths
--

commit a0d3f2d15f67ea6a7bb531279de17b869e022f10
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

scsi: mpt3sas: Fix page fault from stale ioc->chip after PCI error recovery

This commit clears ioc->chip when unmapping controller resources and adds
NULL checks on ioc->chip across interrupt masking, IOC state queries, reset
handling, config requests, and shutdown paths.

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/m=
pt3sas_base.c
> index 24b74760d6816..cf7861a4068fc 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
[ ... ]
> @@ -3579,6 +3583,7 @@ mpt3sas_base_unmap_resources(struct MPT3SAS_ADAPTER=
 *ioc)
> =20
>  	if (ioc->chip_phys) {
>  		iounmap(ioc->chip);
> +		ioc->chip =3D NULL;
>  		ioc->chip_phys =3D 0;
>  	}
> =20

[Severity: Medium]
Can _ctl_ioctl_main() still reach ioc->put_smid_default() and dereference a
NULL ioc->chip when controller registers are unmapped?

In scsih_pci_slot_reset(), ioc->pci_error_recovery is cleared to 0 before
calling mpt3sas_base_map_resources(ioc); if mapping fails (or if the
adapter is suspended via scsih_suspend()), ioc->chip remains NULL while
ioc->pci_error_recovery, ioc->shost_recovery, ioc->is_driver_loading, and
ioc->remove_host are all 0.  _ctl_ioctl_main() only checks those four flags,
so ioctls such as MPT3EVENTENABLE (_ctl_eventenable() ->
mpt3sas_base_validate_event_type() -> _base_event_notification()) and
MPT3DIAGREADBUFFER with MPT3_FLAGS_REREGISTER (_ctl_diag_read_buffer())
proceed without checking ioc->chip or IOC state and call
ioc->put_smid_default(), which writes to ioc->chip registers.

[ ... ]
> @@ -6739,6 +6746,15 @@ mpt3sas_base_get_iocstate(struct MPT3SAS_ADAPTER *=
ioc, int cooked)
>  {
>  	u32 s, sc;
> =20
> +	/*
> +	 * Registers are unmapped (e.g. after PCI error recovery/suspend).
> +	 * Return a state value that matches no real IOC state, so callers
> +	 * neither treat the IOC as FAULT (and try a register-based diag
> +	 * reset) nor as READY/OPERATIONAL.
> +	 */
> +	if (!ioc->chip)
> +		return MPI2_IOC_STATE_MASK;
> +
>  	s =3D ioc->base_readl_ext_retry(&ioc->chip->Doorbell);
>  	sc =3D s & MPI2_IOC_STATE_MASK;
>  	return cooked ? sc : s;

[Severity: High]
Does returning MPI2_IOC_STATE_MASK here cause mpt3sas_scsih_issue_tm() to
fall through and dereference a NULL ioc->chip during SCSI error recovery?

When in-flight SCSI commands time out after scsih_pci_slot_reset() clears
ioc->pci_error_recovery =3D 0 and fails in mpt3sas_base_map_resources(ioc),
the SCSI error handler runs eh_abort_handler, eh_device_reset_handler, and
eh_target_reset_handler before escalating to eh_host_reset_handler.  Those
callbacks invoke mpt3sas_scsih_issue_tm(), which only checks for
MPI2_DOORBELL_USED, MPI2_IOC_STATE_FAULT, and MPI2_IOC_STATE_COREDUMP:

drivers/scsi/mpt3sas/mpt3sas_scsih.c:mpt3sas_scsih_issue_tm() {
    ...
	ioc_state =3D mpt3sas_base_get_iocstate(ioc, 0);
	if (ioc_state & MPI2_DOORBELL_USED) {
		...
	}

	if ((ioc_state & MPI2_IOC_STATE_MASK) =3D=3D MPI2_IOC_STATE_FAULT) {
		...
	} else if ((ioc_state & MPI2_IOC_STATE_MASK) =3D=3D
	    MPI2_IOC_STATE_COREDUMP) {
		...
	}

	smid =3D mpt3sas_base_get_smid_hpr(ioc, ioc->tm_cb_idx);
	...
	ioc->put_smid_hi_priority(ioc, smid, msix_task);
    ...
}

Because MPI2_IOC_STATE_MASK matches none of those conditions,
mpt3sas_scsih_issue_tm() falls through and calls
ioc->put_smid_hi_priority(), dereferencing NULL ioc->chip (and scsih_abort()
also calls mpt3sas_halt_firmware(ioc) before checking ioc->chip).

> @@ -8136,7 +8152,7 @@ mpt3sas_base_make_ioc_ready(struct MPT3SAS_ADAPTER =
*ioc, enum reset_type type)
> =20
>  	dinitprintk(ioc, ioc_info(ioc, "%s\n", __func__));
> =20
> -	if (ioc->pci_error_recovery)
> +	if (ioc->pci_error_recovery || !ioc->chip)
>  		return 0;
> =20
>  	ioc_state =3D mpt3sas_base_get_iocstate(ioc, 0);
> @@ -8969,6 +8985,13 @@ mpt3sas_base_hard_reset_handler(struct MPT3SAS_ADA=
PTER *ioc,
>  		goto out_unlocked;
>  	}
> =20
> +	if (!ioc->chip) {
> +		ioc_err(ioc, "%s: controller registers are not mapped\n",
> +			__func__);
> +		r =3D -ENODEV;
> +		goto out_unlocked;
> +	}
> +
>  	if (mpt3sas_fwfault_debug)
>  		mpt3sas_halt_firmware(ioc);
> =20
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas=
/mpt3sas_config.c
> index eb51ce3610c8a..2609b298af0b2 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_config.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
> @@ -304,6 +304,10 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2Con=
figRequest_t
>  	struct config_request mem;
>  	u32 ioc_status =3D UINT_MAX;
> =20
> +	/* registers are unmapped (e.g. after PCI error recovery/suspend) */
> +	if (!ioc->chip)
> +		return -ENODEV;
> +
>  	mutex_lock(&ioc->config_cmds.mutex);
>  	if (ioc->config_cmds.status !=3D MPT3_CMD_NOT_USED) {
>  		ioc_err(ioc, "%s: config_cmd in use\n", __func__);

[Severity: Medium]
Can mpt3sas_base_free_resources() unmap and clear ioc->chip after the
!ioc->chip checks in mpt3sas_base_hard_reset_handler() and
_config_request()?

CPU0                                  CPU1
mpt3sas_base_hard_reset_handler()
  if (!ioc->chip)
  mutex_lock(&ioc->reset_in_progress_mutex)
  ...
  mpt3sas_wait_for_commands_to_complete()
                                      scsih_pci_error_detected()
                                        mpt3sas_base_free_resources()
                                          mutex_lock(&ioc->pci_access_mutex)
                                          mpt3sas_base_unmap_resources()
                                            iounmap(ioc->chip)
                                            ioc->chip =3D NULL
                                          mutex_unlock(&ioc->pci_access_mut=
ex)
  mpt3sas_base_make_ioc_ready()
    if (... || !ioc->chip)
      return 0;
  _base_get_ioc_facts()
    _base_handshake_req_reply_wait()
      ioc->base_readl(&ioc->chip->Doorbell)
        <-- NULL pointer dereference

mpt3sas_base_free_resources() serializes only with ioc->pci_access_mutex,
which neither mpt3sas_base_hard_reset_handler() nor _config_request() holds.
When mpt3sas_base_make_ioc_ready() returns 0 for !ioc->chip,
mpt3sas_base_hard_reset_handler() treats the controller as ready and
proceeds into _base_get_ioc_facts(), dereferencing NULL ioc->chip.
Similarly, _config_request() checks !ioc->chip before acquiring
ioc->config_cmds.mutex and can race with mpt3sas_base_free_resources()
before calling ioc->put_smid_default().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1794995806-5835-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D16

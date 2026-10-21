Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792579405;
	b=cftS//pVDCp5RftTDbjvTOY7q+wQiq2xEZgiBr+zSl8SJ9WNiM+R2IH+SUGPG9zoVhrT
	 wuXpGAJwzNR1ytDqYMBzWGOZvkuXyzLO90Yd47MvtOXpIPmev/M+hjPvFzJQ0SMZb6oSa
	 sesIb55+jH8GY8nqBEcXdRc+l1P/Vu2q3u5ero1Lr5u3gGDqJBEIBZ8ok728SvXwAi6Oe
	 1mY74uF2khDplnbuCMkBHYJ5k73adeeB/xWe1DjWa4jCparSbmMmdudZOl3XEKQQVdalb
	 R5E7wXpYVUPrtIY4Er7ZPay9p3S4n/Rx+zznvmbkACd6OYPvceLWdZHmT3HV4VkGG2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792579405;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=QLNnRAYgoC6gqcpObtlWMx1aEt4xkih7W2cqIt6tw90=;
	b=UXZkvdZPKBco5PZuCd2xAx3aPtF09qDcBdpG2nHa9jRHmcCOwFeo1GPcpPvNs6JSr2LF
	 t4mMt+TM1IQWFWTfYYsUDrY7cahJdLCadwZt687axPe1M1GzMlfXnUS4TanQwCUTjlvJo
	 Y6IBSFFBKuaD1p4+tKTAuUbDZai6UmfvVAnFlK4TMxxPEkxFIwH9LHZnY/h/Y8G34Lbre
	 9HDcFzKJzA5s2TEueSEvmvu2wUBMBRIZTuCXp93uOueOXZfDIN3kMWJdGSO4zDHHnKEcQ
	 4r23sW+SGga69ju6KmaV3UMd/N+peftOkzpC3j6XZbxAEAyfTbwuIu6sFD3v31VvWWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zw4HqsMi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9428606A31E
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 10:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zw4HqsMi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B0E1F000CA;
	Wed, 21 Oct 2026 10:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792579404;
	bh=QLNnRAYgoC6gqcpObtlWMx1aEt4xkih7W2cqIt6tw90=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Zw4HqsMif49fG7funYoXBwuVXxi/8iQEZSTJfdsjEZ+jzDcM0oF8t6c7LbhWJWWx4
	 JdIBolli7ykRcfLiYNROEDT1Js+hi2QWvQ2wQPFwEuAOMAIfPNKqP0Q76/sOzEacP2
	 uEtfINWd5rZ3WkT85e7wa54cxetPf5s8uCIP0pLMmMedtOruqhb1jfMEEclVtNYevh
	 YJWz/Oz12x/TFd5XXP0If/jOZYyX492d78VFPnXzqXYQypgeDGmmBx2JPUVx7rms57
	 526qxHsk2ihW3pmrKTyFlig8UMW9IvtCVMYW/s8P1QawP+oAMcCCcN6hTZONXd+UFh
	 BNkpox+dHT0Xw==
Message-ID: <sashiko-outbox-180113@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 05/14] scsi: qla2xxx: Fix double addition of fcport to
 gnl.fcport list
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261021102310.3854868-6-njavali@marvell.com>
References: <20261021102310.3854868-1-njavali@marvell.com>
 <20261021102310.3854868-6-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 10:43:23 +0000
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
- [High] scsi: qla2xxx: FCF_ASYNC_ACTIVE leak on early return in qla24xx_as=
ync_gnl()
- [High] scsi: qla2xxx: incomplete fix for gnl_entry double add in qla24xx_=
async_gnl()
--

commit 26e3803dac33bf8507fb3ff3170def3e0261a1f3
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Fix double addition of fcport to gnl.fcport list

This commit moves the FCF_ASYNC_SENT check in qla24xx_async_gnl() under
vha->hw->tgt.sess_lock so that testing and setting FCF_ASYNC_SENT is
serialized with adding fcport->gnl_entry to vha->gnl.fcports.

> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index bb0cc71de37b8..515a7ea4299db 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -1158,13 +1158,17 @@ int qla24xx_async_gnl(struct scsi_qla_host *vha, =
fc_port_t *fcport)
>  	unsigned long flags;
>  	u16 *mb;
> =20
> -	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
> +	if (!vha->flags.online)
>  		goto done;
> =20
>  	ql_dbg(ql_dbg_disc, vha, 0x20d9,
>  	    "Async-gnlist WWPN %8phC \n", fcport->port_name);
> =20
>  	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
> +	if (fcport->flags & FCF_ASYNC_SENT) {
> +		spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
> +		return QLA_SUCCESS;
> +	}

[Severity: High]
Could returning QLA_SUCCESS directly here instead of jumping to done leak
FCF_ASYNC_ACTIVE on fcport->flags and cause a session relogin hang?

When qla24xx_post_gnl_work() queues a QLA_EVT_GNL work item, it sets
FCF_ASYNC_ACTIVE on fcport:

drivers/scsi/qla2xxx/qla_init.c:qla24xx_post_gnl_work() {
	...
	e->u.fcport.fcport =3D fcport;
	fcport->flags |=3D FCF_ASYNC_ACTIVE;
	return qla2x00_post_work(vha, e);
}

Previously, commit 39d22740712c ("scsi: qla2xxx: Fix session hang in gnl")
made the FCF_ASYNC_SENT check in qla24xx_async_gnl() jump to done so that
FCF_ASYNC_ACTIVE would be cleared when bailing out:

drivers/scsi/qla2xxx/qla_init.c:qla24xx_async_gnl() {
	...
done:
	fcport->flags &=3D ~(FCF_ASYNC_ACTIVE);
	return rval;
}

Because FCF_ASYNC_SENT is also set by non-GNL paths that do not clear
FCF_ASYNC_ACTIVE upon completion, such as qlt_unreg_sess() ->
qlt_free_session_done() in drivers/scsi/qla2xxx/qla_target.c:

	spin_lock_irqsave(&vha->work_lock, flags);
	sess->flags &=3D ~FCF_ASYNC_SENT;
	sess->deleted =3D QLA_SESS_DELETED;
	sess->free_pending =3D 0;
	spin_unlock_irqrestore(&vha->work_lock, flags);

as well as qla24xx_async_prli() -> qla2x00_async_prli_sp_done(),
qla24xx_async_notify_ack() -> qla2x00_async_nack_sp_done(), and
qla2x00_abort_isp_cleanup(), returning early without clearing
FCF_ASYNC_ACTIVE or adding fcport to vha->gnl.fcports leaves
FCF_ASYNC_ACTIVE permanently set once the other operation finishes.

When FCF_ASYNC_ACTIVE remains set, both qla24xx_fcport_handle_login() and
qla2x00_relogin() defer login indefinitely:

drivers/scsi/qla2xxx/qla_init.c:qla24xx_fcport_handle_login() {
	...
	if (fcport->flags & (FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE)) {
		set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
		return 0;
	}
	...
}

>  	fcport->flags |=3D FCF_ASYNC_SENT;
>  	qla2x00_set_fcport_disc_state(fcport, DSC_GNL);
>  	fcport->last_rscn_gen =3D fcport->rscn_gen;

[Severity: High]
Is checking FCF_ASYNC_SENT under sess_lock sufficient to prevent adding an
already-linked fcport->gnl_entry to vha->gnl.fcports?

All QLA_EVT_GNL work items for a vha are dispatched from the single per-vha
work item vha->iocb_work via qla2x00_iocb_work_fn() -> qla2x00_do_work(), so
two calls to qla24xx_async_gnl() on the same vha do not run concurrently.

Instead, fcport->flags can have FCF_ASYNC_SENT cleared while
fcport->gnl_entry is still linked on vha->gnl.fcports:

1. In drivers/scsi/qla2xxx/qla_init.c, qla24xx_async_gnl_sp_done() clears
FCF_ASYNC_SENT on sp->fcport without holding sess_lock and before splicing
and unlinking entries from vha->gnl.fcports:

	sp->fcport->flags &=3D ~(FCF_ASYNC_SENT|FCF_ASYNC_ACTIVE);
	...
	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);

	INIT_LIST_HEAD(&h);
	fcport =3D tf =3D NULL;
	if (!list_empty(&vha->gnl.fcports))
		list_splice_init(&vha->gnl.fcports, &h);
	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);

2. During ISP abort cleanup, qla2x00_abort_isp_cleanup() in
drivers/scsi/qla2xxx/qla_init.c clears FCF_ASYNC_SENT across vp_fcports
without holding sess_lock or unlinking fcport->gnl_entry:

	list_for_each_entry(fcport, &vha->vp_fcports, list) {
		fcport->flags &=3D ~(FCF_LOGIN_NEEDED | FCF_ASYNC_SENT);
		fcport->scan_state =3D 0;
	}

The same happens in qla2x00_async_iocb_timeout() (before the asynchronous
abort completes), qlt_free_session_done(), and qla2x00_update_fcport().

3. If qla2x00_get_sp() fails in qla24xx_async_gnl() after
list_add_tail(&fcport->gnl_entry, &vha->gnl.fcports), jumping to done leaves
fcport->gnl_entry linked on vha->gnl.fcports with vha->gnl.sent =3D=3D 1, a=
nd in
qla24xx_async_gnl_sp_done(), the retrigger loop only unlinks the first entry
before breaking with vha->gnl.sent =3D 0:

	vha->gnl.sent =3D 0;
	if (!list_empty(&vha->gnl.fcports)) {
		/* retrigger gnl */
		list_for_each_entry_safe(fcport, tf, &vha->gnl.fcports,
		    gnl_entry) {
			list_del_init(&fcport->gnl_entry);
			fcport->flags &=3D ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
			if (qla24xx_post_gnl_work(vha, fcport) =3D=3D QLA_SUCCESS)
				break;
		}
	}

In any of those cases, when a subsequent QLA_EVT_GNL runs
qla24xx_async_gnl(), FCF_ASYNC_SENT is clear even under sess_lock, so
list_add_tail(&fcport->gnl_entry, &vha->gnl.fcports) will still be called on
an already-linked gnl_entry. Should qla24xx_async_gnl() also guard against
!list_empty(&fcport->gnl_entry) under sess_lock and ensure gnl_entry is
unlinked on failure and reset paths?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021102310.3854=
868-1-njavali@marvell.com?part=3D5

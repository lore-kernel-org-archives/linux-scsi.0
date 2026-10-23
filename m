Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792751934;
	b=VIyrnjqyGQ3RZOloF/iAGt4syncVBQr3dzIC3dcDBoQPo0LKdJb9KtcOJBoVmO5/6Iz6
	 36rLsq1+kP9J0Sfc18brTB8jY2SRHA3Tu9/KHG2ZX05isIHJpR/DMYyvVUc8K394RmByX
	 LYmiM3rYNz8Ng7HXP5j2jiADm8/r5n6MAi1ezN5XYiH7kqPwfM6arSOCXGER8yTwUw6fT
	 r/MA4ReK7Ss2hLKPwFO7U0BIWu0vBxO+DVpL1/vXxhmoja4Z77yzJoTKcEF++gicQou62
	 WVR/N2zZ8xCRHb4Je3Ml0aJDT3Wml5m9pd5hu9u11orCkXwziHLLguGOt2jhjLpECkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792751934;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Prfhnw7WrakoBu7ZpAQoADKrcAM6pKobtCpNu3OHc4E=;
	b=wEd/RZkDerrIYyNB+A6y1KH6g4ak7oG1eGFOgqDjKXmWczHHJ5JwOd1eWdnhB1OFEUz5
	 5XSIap9M9TezSvvA8dvT2u1RXLeZIFWbBvSomSy25TsdZW8vnXWFaQZCLy82/h0S2oRgR
	 CbN0BSIa/BQXzspaL8BHyqRvbCkqWFDv9irxQI5ayVG4VQv9mdLMZ9wvlWDZcThr5R3jF
	 4jA5XZpxWxSMKacEWJUehpCf/mycalr/88ZwLwN8OchuI7/Ok7uku9tR9htgj+ic4QAHf
	 u3SVK3RYPCctH5sdsOalexq6/iHPZdhIrgl0UDEtpVRkpvAIQ1BBOTL711LIxtMqbbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L2G4Rvtm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3F3606A31A
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 10:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L2G4Rvtm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4E71F01825;
	Fri, 23 Oct 2026 10:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792751934;
	bh=Prfhnw7WrakoBu7ZpAQoADKrcAM6pKobtCpNu3OHc4E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=L2G4Rvtm6+ZVYDbOu17zw2QAbL5Ome792CXMJzPIgrJuSpokMAYg1GITYtgN/Mt2W
	 onZH5IcxLTvDMSZGYjByKgqyBuomQkORDdOuzOeLQe+jyssM8PvBtA13FLQtODM2/f
	 lPcNhhSuYsK66raMzxeX2S+GNUWoL112G6toRf+M1zTDLl3LHRjsKG6UI6tRLOFJ7o
	 N36aV/ZNDBej+8n9m132M8RtDccy5tkrrl38OkeeEpILkWNDt5pnLYfDd+mqxMMhK4
	 BWUR3sQO7V3zu93AxtdRVdtycIeZEo8GhScJoLJ06wVsE0nNsznb3eI74c6qCF5WoF
	 Ks/Nb9rTgbuZg==
Message-ID: <sashiko-outbox-182698@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 05/13] scsi: qla2xxx: Fix double addition of fcport
 to gnl.fcport list
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261023101600.1431179-6-njavali@marvell.com>
References: <20261023101600.1431179-1-njavali@marvell.com>
 <20261023101600.1431179-6-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 10:38:53 +0000
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
- [High] scsi: qla2xxx: incomplete gnl_entry double-add fix in qla24xx_asyn=
c_gnl()
--

commit 92c98a5a2f2d104f2b6d47badef1b553bffd531c
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Fix double addition of fcport to gnl.fcport list

This commit moves the FCF_ASYNC_SENT check in qla24xx_async_gnl() under
vha->hw->tgt.sess_lock to prevent adding fcport->gnl_entry to
vha->gnl.fcports twice.

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
Does returning QLA_SUCCESS directly here leak the FCF_ASYNC_ACTIVE flag on
fcport->flags and cause a permanent session relogin hang?

Every caller that schedules qla24xx_async_gnl() posts a QLA_EVT_GNL work
item via qla24xx_post_gnl_work(), which sets FCF_ASYNC_ACTIVE:

drivers/scsi/qla2xxx/qla_init.c:qla24xx_post_gnl_work() {
	...
	e->u.fcport.fcport =3D fcport;
	fcport->flags |=3D FCF_ASYNC_ACTIVE;
	return qla2x00_post_work(vha, e);
}

Previously, when FCF_ASYNC_SENT was set on entry to qla24xx_async_gnl(), it
branched to the done label, which cleared FCF_ASYNC_ACTIVE:

drivers/scsi/qla2xxx/qla_init.c:qla24xx_async_gnl() {
	...
done:
	fcport->flags &=3D ~(FCF_ASYNC_ACTIVE);
	return rval;
}

With this change, qla24xx_async_gnl() returns QLA_SUCCESS without clearing
FCF_ASYNC_ACTIVE and without adding fcport->gnl_entry to vha->gnl.fcports.

FCF_ASYNC_SENT is a shared per-fcport flag that is also set by other session
management and discovery paths whose completion or cleanup routines only
clear FCF_ASYNC_SENT and never clear FCF_ASYNC_ACTIVE. For example, during
session deletion in drivers/scsi/qla2xxx/qla_target.c, qlt_unreg_sess() sets
FCF_ASYNC_SENT to block discovery commands while a QLA_EVT_GNL work item may
already be queued, and qlt_free_session_done() only clears FCF_ASYNC_SENT:

drivers/scsi/qla2xxx/qla_target.c:qlt_unreg_sess() {
	...
	sess->flags |=3D FCF_ASYNC_SENT;
	...
}

drivers/scsi/qla2xxx/qla_target.c:qlt_free_session_done() {
	...
	spin_lock_irqsave(&vha->work_lock, flags);
	sess->flags &=3D ~FCF_ASYNC_SENT;
	sess->deleted =3D QLA_SESS_DELETED;
	sess->free_pending =3D 0;
	spin_unlock_irqrestore(&vha->work_lock, flags);
	...
}

Similarly, qla24xx_async_notify_ack() / qla2x00_async_nack_sp_done() in
drivers/scsi/qla2xxx/qla_target.c, qla24xx_async_prli() /
qla2x00_async_prli_sp_done() in drivers/scsi/qla2xxx/qla_init.c, and ISP
reset cleanup in qla2x00_abort_isp_cleanup() and qla_pci_error_cleanup()
only clear FCF_ASYNC_SENT.

When qla24xx_async_gnl() hits this early return while FCF_ASYNC_SENT is set
by any of those paths (or if an in-flight GNL is aborted by chip reset
before qla24xx_async_gnl_sp_done() runs), FCF_ASYNC_ACTIVE remains stuck on
fcport->flags. Both qla24xx_fcport_handle_login() in
drivers/scsi/qla2xxx/qla_init.c and qla2x00_relogin() in
drivers/scsi/qla2xxx/qla_os.c check for FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE
and will defer relogin for that fcport indefinitely, reintroducing the
session hang previously fixed by commit 39d22740712c ("scsi: qla2xxx: Fix
session hang in gnl").

Should this path clear FCF_ASYNC_ACTIVE (or jump to done after unlocking
sess_lock) before returning?

>  	fcport->flags |=3D FCF_ASYNC_SENT;
>  	qla2x00_set_fcport_disc_state(fcport, DSC_GNL);
>  	fcport->last_rscn_gen =3D fcport->rscn_gen;

[Severity: High]
Can fcport->gnl_entry still be added twice to vha->gnl.fcports even with the
FCF_ASYNC_SENT check under sess_lock?

First, regarding the race described in the commit message,
qla24xx_async_gnl() is only called from qla2x00_do_work() via
qla2x00_iocb_work_fn() in drivers/scsi/qla2xxx/qla_os.c, which runs on the
single per-vha work item vha->iocb_work (and is further serialized by
IOCB_WORK_ACTIVE in vha->dpc_flags). Because a single work_struct does not
execute concurrently with itself, two QLA_EVT_GNL work items for the same
vha are processed sequentially rather than racing at the entry of
qla24xx_async_gnl().

Instead, FCF_ASYNC_SENT can be cleared to 0 while fcport->gnl_entry is still
linked on vha->gnl.fcports (or on the local list in
qla24xx_async_gnl_sp_done()):

1. In drivers/scsi/qla2xxx/qla_init.c, qla24xx_async_gnl_sp_done() clears
FCF_ASYNC_SENT locklessly before acquiring sess_lock and before unlinking
fcport->gnl_entry (dropping sess_lock around qla24xx_handle_gnl_done_event()
for each entry):

drivers/scsi/qla2xxx/qla_init.c:qla24xx_async_gnl_sp_done() {
	...
	sp->fcport->flags &=3D ~(FCF_ASYNC_SENT|FCF_ASYNC_ACTIVE);
	...
	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
	...
	list_splice_init(&vha->gnl.fcports, &h);
	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);

	while (!list_empty(&h)) {
		spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
		fcport =3D list_first_entry(&h, struct fc_port, gnl_entry);
		list_del_init(&fcport->gnl_entry);
		spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
		qla24xx_handle_gnl_done_event(vha, fcport, ...);
	}
	...
}

If qla24xx_async_gnl() runs on qla2xxx_wq for sp->fcport during this window,
FCF_ASYNC_SENT is already 0 under sess_lock while sp->fcport->gnl_entry has
not been deleted from the list yet.

2. At the end of qla24xx_async_gnl_sp_done(), when multiple fcports were
queued onto vha->gnl.fcports while vha->gnl.sent was 1, the retrigger loop
only unlinks the first fcport and breaks out, leaving the remaining fcports
linked on vha->gnl.fcports with vha->gnl.sent set to 0:

drivers/scsi/qla2xxx/qla_init.c:qla24xx_async_gnl_sp_done() {
	...
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
	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
}

3. Several paths clear FCF_ASYNC_SENT without unlinking fcport->gnl_entry
from vha->gnl.fcports, including ISP reset cleanup in
qla2x00_abort_isp_cleanup() and qla_pci_error_cleanup(), command timeout in
qla2x00_async_iocb_timeout(), session deletion completion in
qlt_free_session_done(), and qla2x00_update_fcport():

drivers/scsi/qla2xxx/qla_init.c:qla2x00_abort_isp_cleanup() {
	...
	list_for_each_entry(fcport, &vha->vp_fcports, list) {
		fcport->flags &=3D ~(FCF_LOGIN_NEEDED | FCF_ASYNC_SENT);
		fcport->scan_state =3D 0;
	}
	...
}

drivers/scsi/qla2xxx/qla_init.c:qla2x00_async_iocb_timeout() {
	...
	case SRB_MB_IOCB:
		fcport->flags &=3D ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
	...
}

When a subsequent QLA_EVT_GNL work item runs qla24xx_async_gnl() for that
fcport, FCF_ASYNC_SENT is 0 under sess_lock while fcport->gnl_entry is still
linked on vha->gnl.fcports, so list_add_tail() will still trigger the
__list_add_valid_or_report() bug.

Would checking !list_empty(&fcport->gnl_entry) (or using list_move_tail())
under sess_lock before adding fcport->gnl_entry to vha->gnl.fcports avoid
this list corruption?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023101600.1431=
179-1-njavali@marvell.com?part=3D5

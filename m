Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792579431;
	b=T5bitwQBsgRAnoey8VJ1N1M4fGum0KESAu39VmE1PwaOVRGvZ31A3Ll1CwGg1tTqCpdr
	 KAF8fehvQAVyHPtRtmnVri/JioRrafzrW4uYwj7gOkM27xIJtQwDNPoEbwlpBnF42M5UA
	 z3fPkCWruHPk2LybAaLxge5zjf53eBw/ONJqylwY+zpQdhLShH1+84KLBKcCMN+PhbeNi
	 9+mMHZHSMaKYTgs488YtiQC+dfbL3j2yTbz0VBI8fkixd0jt1aCwnTpHO2yll7Mbe1fm6
	 /aDeClFi1NULzDFL3v9YKBBFXUkaQ4dJwMoLkwmj0/UQB12ATboMT9H2dyQa4YLhi6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792579431;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=tghE7yNncJ7kYyjiKhXEXPUuEanSXSHX3YRF3xPABHg=;
	b=KRWuKQ3TcRSRKVV2kCydW+6R41n7uynk+m2CvwPakfY93cUN1p70EQqwGpjB9SLnl79A
	 p0heARrBrKYEJk7GVj5cR2t8tb7gu6MYDwmMi3NBG22dger03bKrhfQjTFeViUK6P4eCz
	 5InRTQBKXWOUoVbJuvMgMn9zCN9XZQ5w27YrD0OSXgIzImgCjpeelRq845s3j34Aik413
	 GnGvqeUgVIKGWpwgVZCK2ubotU2oVHccqOa4gh0MetdS5jeywgXnJ4f0JxbKLzXOTPmth
	 7iXzOqVN//hDOE3FCYo2wchmA+uLMHt2Efz5uteS2FOM/xN9WWpCxcFhIYoceb6kCIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jMj1aAaz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B965B606A319
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 10:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jMj1aAaz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289821F000C9;
	Wed, 21 Oct 2026 10:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792579430;
	bh=tghE7yNncJ7kYyjiKhXEXPUuEanSXSHX3YRF3xPABHg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jMj1aAazUmSOQbS7actn3hWObvNJRN3hx7sggQrRXl4Trzpy+cBS2mgFAvQh74F6n
	 Pfbisvuf5c7zXA/nzGiihFExnp+HioONk7OfoYzZLW7b2MH1+MSDgxsPB7+HhOrqzb
	 IXPfVRZuHPWnlI85hui+MG3HKjt+J2TAVacXNWmifpfvzbbM+RcoNMgW9sVBpilvtU
	 JtE+Lg0vek+ickVw0vF3777ZyJ3qCaEUcbcQoXBoxrRP4/5xuOagKnM1SI7pSY9adI
	 NO+aC48hO28vcjN/Z5efe7vSsdeAb2wvxcawUDiAu25k034/uNuPU5bdZCINhu20bG
	 v0NawsImMHLwA==
Message-ID: <sashiko-outbox-180114@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 08/14] scsi: qla2xxx: Add validation check for base
 vport index during delete
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261021102310.3854868-9-njavali@marvell.com>
References: <20261021102310.3854868-1-njavali@marvell.com>
 <20261021102310.3854868-9-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 10:43:49 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: qla2xxx: qla24xx_vport_delete() returns 0 on invalid vp_idx =
error
--

commit aea6ddb54a72c0125eb9b7df256e6e4ec1eed447
Author: Manish Rangankar <mrangankar@marvell.com>

scsi: qla2xxx: Add validation check for base vport index during delete

This commit adds a check in qla24xx_vport_delete() to log an error and retu=
rn
early if vha->vp_idx is zero.

> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_a=
ttr.c
> index a4ca22024edeb..e6fc47c3f87f8 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -3276,6 +3276,12 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
>  	struct qla_hw_data *ha =3D vha->hw;
>  	uint16_t id =3D vha->vp_idx;
> =20
> +	if (!vha->vp_idx) {
> +		ql_log(ql_log_fatal, vha, 0x700f,
> +		       "failed to delete Vport idx [%d]\n", vha->vp_idx);
> +		return 0;
> +	}

[Severity: High]
Should qla24xx_vport_delete() in drivers/scsi/qla2xxx/qla_attr.c return a
non-zero error code here instead of 0 when !vha->vp_idx?

qla24xx_vport_delete() is the .vport_delete callback invoked by
fc_vport_terminate() in drivers/scsi/scsi_transport_fc.c:

	if (i->f->vport_delete)
		stat =3D i->f->vport_delete(vport);
	else
		stat =3D -ENOENT;

	spin_lock_irqsave(shost->host_lock, flags);
	vport->flags &=3D ~FC_VPORT_DELETING;
	if (!stat) {
		vport->flags |=3D FC_VPORT_DELETED;
		list_del(&vport->peers);
		fc_host->npiv_vports_inuse--;
		scsi_host_put(shost);		/* for fc_host->vport list */
	}
	spin_unlock_irqrestore(shost->host_lock, flags);

	if (stat)
		return stat;
	...
	device_del(dev);
	transport_destroy_device(dev);

	put_device(dev);			/* for self-reference */

When qla24xx_vport_delete() returns 0, fc_vport_terminate() treats the
deletion as successful and unregisters and frees struct fc_vport, even thou=
gh
qla24xx_vport_delete() skipped tearing down vha, removing vha->host, stoppi=
ng
the vport timer, freeing vha->gnl.l and vha->scan.l, removing vha from
ha->vp_list in qla24xx_deallocate_vp_id(), and decrementing
ha->cur_vport_count.

Does this leave vha active on ha->vp_list with a dangling vha->fc_vport
pointer, and cause qla2x00_delete_all_vps() in drivers/scsi/qla2xxx/qla_os.c
to loop infinitely on the freed vha->fc_vport during driver unload:

	while (ha->cur_vport_count) {
		spin_lock_irqsave(&ha->vport_slock, flags);

		BUG_ON(base_vha->list.next =3D=3D &ha->vp_list);
		/* This assumes first entry in ha->vp_list is always base vha */
		vha =3D list_first_entry(&base_vha->list, scsi_qla_host_t, list);
		scsi_host_get(vha->host);

		spin_unlock_irqrestore(&ha->vport_slock, flags);
		mutex_unlock(&ha->vport_lock);

		qla_nvme_delete(vha);

		fc_vport_terminate(vha->fc_vport);
		scsi_host_put(vha->host);

		mutex_lock(&ha->vport_lock);
	}

because vha is never removed from base_vha->list and ha->cur_vport_count is
never decremented?

> +
>  	set_bit(VPORT_DELETE, &vha->dpc_flags);
> =20
>  	while (test_bit(LOOP_RESYNC_ACTIVE, &vha->dpc_flags))

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021102310.3854=
868-1-njavali@marvell.com?part=3D8

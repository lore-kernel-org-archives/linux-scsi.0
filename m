Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793031857;
	b=cSBfVO2Ur9ZsqmkZpGbu/jPpKUSBterfpQqgsn8pys/1c4sqK/cJsmbpFl4rcGT/EHCC
	 66ABM990lelIVO5ReT6zwEp2hONEtMeyMFa/Fks/GnTZ550r2M+nI5egtzyeh+cTH1WIT
	 khhMWhFbNpcJMftFcAEDKL300s8BRav6oVsmwZzsVztGB4FBRHhi6fR6D6IFm8msWiVJ3
	 6vinMQQEE4J0MBpV/usoh0wtTuhp1VVRXV8wx0N+ct8oVWB3474rFYQ1NpO0z15rJ4t/a
	 e0OwkCmOwAm03v4cYIilBdBWGyvZu+gJTicaAuBoJ1P0mEw++1JjKOBUZrI/wX+yBOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031857;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=FZ6ZYIUi92IT62PNLYZB5Hkbs1gzD0Ivg/ow3FIgOv0=;
	b=N00Dl3KhPlsJ2frZRmesB1TpboBQqVK+2Dp1YgXzWQECs1Q3YeYKgCVy10jUqKxVQl1d
	 hZH9vD84w8WD88tcOd95Qnp6FKA7pgQqyYrlmyWqICfi/T59ge3T0cnBKsGFX3X7vk4cq
	 PoNn07oao+unUNU6WodO+1c1r7BrnZOVDsOPm8Y8iZWeFAmA/ZEZLAaE9eRBeE7Sa0LCq
	 +2u50VBtyKVw/atlHqwhEw8Gxa225lgniZU4it3aAM8vzOaBJEG8IH1Ii3LOkHT7iJTo4
	 6SOM3E8/BslXtCPGBGY9W5O5KeEyNpXDc2lzw7pg3Ub8Me7QGWGcGRf7R+k8vK7XjQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RLU38MPu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CC1606A31A
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 16:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RLU38MPu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93B11F01825;
	Mon, 26 Oct 2026 16:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793031856;
	bh=FZ6ZYIUi92IT62PNLYZB5Hkbs1gzD0Ivg/ow3FIgOv0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RLU38MPusX8eno27ns10MZjIlli8rfwYxTv1a5tlHo5CbYAgAswU7HmDBNbNhtZcT
	 /ZAfbavnggUk0hNbPjJq9MzRsrUbTwx5zD6CPH3KPDcNHPmypUx+lvpku9U22Ozfea
	 VY+k39qR5Ms6OXN3vQH1Ki7INsBRUcdozMhFsYRfbshhY7pAEzSa0fzR83qWvMTLjG
	 tdWIUcFHHqEGvYqiAznVxCZsf8qxuAoIbN0Y7i8HcIOAPeG+56E0nSUImMypKIpyvk
	 lDGH9jflZSAFh/L5zJN+PqSLGEyG8s2QCdMqnxEaF22uIyE4a8CUm2ifjk4eXKaxrw
	 iNLX3TaObxHCg==
Message-ID: <sashiko-outbox-185515@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v16 09/12] scsi: ibmvfc: add interrupt routine for
 asynchronous sub CRQ
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261026-ibmvfc-fpin-support-v16-9-a900aa657ed5@linux.ibm.com>
References: <20261026-ibmvfc-fpin-support-v16-0-a900aa657ed5@linux.ibm.com>
 <20261026-ibmvfc-fpin-support-v16-9-a900aa657ed5@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 16:24:16 +0000
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
- [High] scsi: ibmvfc: same-class q_lock nesting in ibmvfc_drain_async_subq=
()
--

commit d3f6ce8f09b129387eea8b24d92aacbad8e6f279
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: add interrupt routine for asynchronous sub CRQ

This commit adds ibmvfc_interrupt_async_subq(), ibmvfc_drain_async_subq(),
and ibmvfc_next_async_scrq() to handle and drain asynchronous sub-CRQ events
from the adapter.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 64981a5a39fbf..2cb38757333a4 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -4387,6 +4387,72 @@ static struct ibmvfc_crq *ibmvfc_next_scrq(struct =
ibmvfc_queue *scrq)
>  	return crq;
>  }
> =20
> +static struct ibmvfc_async_sub_crq *ibmvfc_next_async_scrq(struct ibmvfc=
_queue *scrq)
> +{
> +	struct ibmvfc_async_sub_crq *crq;
> +
> +	crq =3D &scrq->msgs.async_scrq[scrq->cur];
> +	if (crq->valid & 0x80) {
> +		if (++scrq->cur =3D=3D scrq->size)
> +			scrq->cur =3D 0;
> +		rmb();
> +	} else
> +		crq =3D NULL;
> +
> +	return crq;
> +}
> +
> +static void ibmvfc_drain_async_subq(struct ibmvfc_queue *scrq)
> +{
> +	struct ibmvfc_host *vhost =3D scrq->vhost;
> +	struct ibmvfc_async_crq_event ae =3D {
> +		.type =3D IBMVFC_ASYNC_CRQ_SUB,
> +	};
> +	struct ibmvfc_async_sub_crq *crq;
> +	unsigned long flags;
> +	int done =3D 0;
> +
> +	spin_lock_irqsave(&vhost->host->host_lock, flags);
> +	spin_lock(scrq->q_lock);
> +	while (!done) {
> +		while ((crq =3D ibmvfc_next_async_scrq(scrq)) !=3D NULL) {
> +			ae.subq =3D *crq;
> +			ibmvfc_handle_async(&ae, scrq->vhost);

[Severity: High]
Can calling ibmvfc_handle_async() while holding scrq->q_lock trigger a
lockdep recursive locking warning?

Every struct ibmvfc_queue (including async_scrqs, scsi_scrqs, and nvme_scrq=
s)
initializes queue->_lock at the same call site in ibmvfc_alloc_queue():

	spin_lock_init(&queue->_lock);
	queue->q_lock =3D &queue->_lock;

This places scrq->q_lock, scsi_q[i].q_lock, and nvme_q[i].q_lock into the
same lockdep class.

When ibmvfc_drain_async_subq() processes a reset-triggering async event
(such as IBMVFC_AE_RESUME, IBMVFC_AE_LINK_UP, IBMVFC_AE_SCN_FABRIC, or
IBMVFC_AE_SCN_DOMAIN) while vhost->action is IBMVFC_HOST_ACTION_LOGO_WAIT
(for example, if a second async event arrives while NPIV logout is in flight
with vhost->using_channels set) or vhost->state is IBMVFC_HOST_OFFLINE, the
call chain reaches ibmvfc_purge_requests():

  ibmvfc_drain_async_subq()
    spin_lock(scrq->q_lock)
    ibmvfc_handle_async()
      __ibmvfc_reset_host()
        ibmvfc_hard_reset_host()
          ibmvfc_purge_requests()

In ibmvfc_purge_requests(), the loops over active SCSI and NVMe sub-queues
acquire scsi_q[i].q_lock and nvme_q[i].q_lock at subclass 0 while
scrq->q_lock of the same lockdep class is still held:

	for (i =3D 0; i < shwqs; i++) {
		spin_lock_irqsave(scsi_q[i].q_lock, flags);
		spin_lock(&scsi_q[i].l_lock);
		...
	}

	for (i =3D 0; i < nhwqs; i++) {
		spin_lock_irqsave(nvme_q[i].q_lock, flags);
		spin_lock(&nvme_q[i].l_lock);
		...
	}

Should async sub-queue locks use a separate lockdep class or subclass, or
should ibmvfc_handle_async() be called without holding scrq->q_lock?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026-ibmvfc-fpi=
n-support-v16-0-a900aa657ed5@linux.ibm.com?part=3D9

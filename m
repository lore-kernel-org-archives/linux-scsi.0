Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792449321;
	b=PmGZpqJTHX6sY6Xa1hRwbkgvAnCroBbxW7xyQ/lsk1v0DxltBTim27Rs2OL28TS4hcfm
	 EcihiEBkwx8pkG+5Uw6ITZ/Fija68X7Em9fHcBQyDUzOi/mnzQqpRClsiQvAtQ7EKoxf+
	 W0Gl3cPXfl6x8yvPQM+xvKBfl0cabqkhe6MNc7fjTBYbxUwi/YSjkhU8cyDqvUPppuEqc
	 U4TmLMxK8TRLc66q8PD4zi2AVvkk2Amew8WWiyxCJ8MbSNTWolKrvIN4ysYQeu/aQ+MuI
	 r2EFdzJJaEpNSvL8h2lWjOkePhkxZ/0LItZJgPTj/Yj8H9UYqsXxKaRpOfv44ZbaURg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792449321;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=XydK2wq1ApF2pk/yIaqcOnDfIvEFCrNOyIa7loDKyiI=;
	b=JvqXNbYL++ZJ3weR4688H4JKH+zqoY3MsQp/QyRw+/M84+fddTDxCeMOzFJWvwstPZx5
	 lSPwm+wT03MLY2YBEwIhyNClbbFVpNET9nlUqSHQ6q0ALhJImYy4FoZJD2XYm4TOcoN0o
	 o1tIS0uw9L18LFMujAr2IXzKZm0KrEEcpqazQYFQTJUFokVM9AnMcqmSfc75mE0UA1kQE
	 A+D2C08CcI5KehR4ZmhPBsy8RBmWmY50CqMrrY7pynX+NV/fxj5WvLjnjk517dlsmAi+R
	 zR5YHo0onjiXAxocCZqarDlb+WozF6hpdC4Mw4gvhYAT6NiuCNP7l6sNdaqsmQl655g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XyfeW44b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A83606A319
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 22:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XyfeW44b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D8C41F000C4;
	Mon, 19 Oct 2026 22:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792449320;
	bh=XydK2wq1ApF2pk/yIaqcOnDfIvEFCrNOyIa7loDKyiI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XyfeW44bKWtuItAEWSAiKXFpkU+GFJGC5Zsv4bce8X32QrpUAFycIEPpxHOdPiVGN
	 +I10KGZv5O1fevB5eQlPYM/4XjWjJNe/2p54Y9xjcCeK95AMe4DwMxExvoCmz6zmS6
	 RvGQibgQRjwt+3UFr8sK/mtl8GGl/mb8iAoOCAJRvKIyJWSxMRjmta1Phqd4kEjUxH
	 l98JftTLGd5LJGYqmT0VdtKMmZecaI3o57pwi0i2/BGqSg9eCjSakjffRLazRN8p9W
	 9c2bBANLfT83bIMURQaUy1qfpoS+iW313yYLgZdx7UlYTwxUIh7+fAcZXVnFKW3wG3
	 +BDy7gJJPJWeQ==
Message-ID: <sashiko-outbox-178325@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v15 04/11] scsi: ibmvfc: add basic FPIN support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261019-ibmvfc-fpin-support-v15-4-a858726e178a@linux.ibm.com>
References: <20261019-ibmvfc-fpin-support-v15-0-a858726e178a@linux.ibm.com>
 <20261019-ibmvfc-fpin-support-v15-4-a858726e178a@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 22:35:19 +0000
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
- [High] scsi: ibmvfc: wrong fpin_workq teardown order in ibmvfc_probe() er=
ror path
--

commit f3dce48358b69cb9e305579053b02a88579e0f88
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: add basic FPIN support

This commit adds basic Fabric Performance Impact Notification (FPIN)
support to the ibmvfc driver by offloading IBMVFC_AE_FPIN async events to
a per-adapter ordered workqueue, converting VIOS FPIN messages into
fc_els_fpin structures for fc_host_fpin_rcv(), and adding KUnit test
coverage.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 0fe6b6f4260ba..0750e722c46c5 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c

[ ... ]

> @@ -6898,9 +7169,15 @@ static int ibmvfc_probe(struct vio_dev *vdev, cons=
t struct vio_device_id *id)
>  	INIT_WORK(&vhost->rport_add_work_q, ibmvfc_rport_add_thread);
>  	mutex_init(&vhost->passthru_mutex);
> =20
> -	if ((rc =3D ibmvfc_alloc_mem(vhost)))
> +	vhost->fpin_workq =3D alloc_ordered_workqueue("%s-fpin-workq-%u", 0,
> +						    IBMVFC_NAME, shost->host_no);
> +	if (!vhost->fpin_workq)
>  		goto free_scsi_host;
> =20
> +	rc =3D ibmvfc_alloc_mem(vhost);
> +	if (rc)
> +		goto free_workq;
> +
>  	vhost->work_thread =3D kthread_run(ibmvfc_work, vhost, "%s_%d", IBMVFC_=
NAME,
>  					 shost->host_no);
> =20
> @@ -6946,6 +7223,8 @@ static int ibmvfc_probe(struct vio_dev *vdev, const=
 struct vio_device_id *id)
>  	kthread_stop(vhost->work_thread);
>  free_host_mem:
>  	ibmvfc_free_mem(vhost);
> +free_workq:
> +	destroy_workqueue(vhost->fpin_workq);
>  free_scsi_host:
>  	scsi_host_put(shost);
>  out:

[Severity: High]
Can the error unwind order in ibmvfc_probe() cause a use-after-free of
vhost->tgt_pool?

In ibmvfc_remove(), destroy_workqueue(vhost->fpin_workq) is called after
ibmvfc_release_crq_queue(vhost) and before ibmvfc_free_mem(vhost):

    ibmvfc_release_crq_queue(vhost);
    destroy_workqueue(vhost->fpin_workq);

    ibmvfc_free_mem(vhost);

As described in the commit message, this ordering ensures that queued FPIN
work items are drained before ibmvfc_free_mem() destroys vhost->tgt_pool.

In ibmvfc_probe(), however, vhost->fpin_workq is allocated before
ibmvfc_alloc_mem(vhost), so the error unwind path runs ibmvfc_free_mem()
before destroy_workqueue(vhost->fpin_workq):

    release_crq:
        ibmvfc_release_crq_queue(vhost);
    kill_kthread:
        kthread_stop(vhost->work_thread);
    free_host_mem:
        ibmvfc_free_mem(vhost);
    free_workq:
        destroy_workqueue(vhost->fpin_workq);

Because vhost->work_thread is started and ibmvfc_init_crq() registers the
CRQ and enables interrupts before scsi_add_host() and
ibmvfc_create_trace_file() are called, a partner-initiated CRQ handshake
and subsequent IBMVFC_AE_FPIN event can queue ibmvfc_process_async_work()
on vhost->fpin_workq before scsi_add_host() or ibmvfc_create_trace_file()
fails.

If that happens, ibmvfc_free_mem() will call
mempool_destroy(vhost->tgt_pool) while ibmvfc_process_async_work() is
still running or pending, and ibmvfc_process_async_work() ->
kref_put(&tgt->kref, ibmvfc_release_tgt) ->
mempool_free(tgt, tgt->vhost->tgt_pool) will access the destroyed
tgt_pool.

Should vhost->fpin_workq be allocated after ibmvfc_alloc_mem(vhost) (or
destroyed before ibmvfc_free_mem(vhost) on the error path) to match the
teardown order in ibmvfc_remove()?

[ ... ]

> @@ -6986,6 +7265,7 @@ static void ibmvfc_remove(struct vio_dev *vdev)
>  	ibmvfc_complete_purge(&purge);
>  	ibmvfc_release_sub_crqs(vhost);
>  	ibmvfc_release_crq_queue(vhost);
> +	destroy_workqueue(vhost->fpin_workq);
> =20
>  	ibmvfc_free_mem(vhost);
>  	spin_lock(&ibmvfc_driver_lock);

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019-ibmvfc-fpi=
n-support-v15-0-a858726e178a@linux.ibm.com?part=3D4

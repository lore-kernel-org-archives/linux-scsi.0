Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793031852;
	b=FO1jtihy2VetEcFKL3J/kgYNJM+bNqsN4sptYZcGads5/TOaMuD9KzNLHaHR6/GwBWnj
	 RItS+yBoBuyQ0hu4DW65ENYwS3BGfeprlh1H0tE9wBfmST8uvF2W8M1o1kaf8PyHx4aJg
	 5fVYyQyPMT37S03Jx7fGlFARq7wK83R06QD6HLvA6w0fb/vdjMT8nNPNMXvBKc39DeU63
	 OLEB7R0GXxMRmGqLZm+M92D8KA+LRkl6yW81S4rwCA96xPqN6UUqEDsMxh8u0jJxxXDWD
	 PDgyfJf30409XMqKNGqpea84kta8HnhTQLoIEfQUELl4157FcGQrS+tXgadprje2bxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031852;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Fncs+CZ5RaLeepvNdvhfc4FPeZ7nzsPA2fPyrW6qOtw=;
	b=AahSBdTFix6LIC42zzuWceJlUn19J9Ca+k457USpcyYM1RHIvBdCocSRaPs0JgSd7M8F
	 MTnidV6nUFmRJ+Ni0B2WfEcmnL9gK9sZhYBzBgpFvdZAtNULgJPYC6gEgVBZOEQf4qRnw
	 g9820b/fQyytGghysq1lcr/JAYqARay0a98i2SBfT/e+Jyk2dCE8nan0sdyMzIuyvI9Q5
	 ErYkah6u0W2w1io7vDBui7ZYQApbg7Zy+ilq8fjKjH1B9CBPt6f6V0fcGHHTLejndHV5z
	 QjxOfP89iILZdaHvhM4YNuR2ryCSvX1/sx0/b8d25cfTSn7g97xw7cjdEBRWksKAIqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BB4O09x4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BC4606A326
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 16:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BB4O09x4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D181F01825;
	Mon, 26 Oct 2026 16:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793031851;
	bh=Fncs+CZ5RaLeepvNdvhfc4FPeZ7nzsPA2fPyrW6qOtw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BB4O09x4b9LVdqNbTPEv1/2BuEucXDUJWGFEEnmb/ouoV6EtfsPnby1TdBgx99u3W
	 TgJbE3Nhqezw6N+KS/dlLYGkfLKp+J7mMYJIDTZL0yEpDecnwTSXt8/bI+R713m+AL
	 woS8kSIn4Tbe+fHG7wxa3kXSHn9+9vZBffNI9KSkiSbLBBZtjBixxqV/KOjVAKzn3j
	 iV+NbreQGWx7j3hic9m+ICLc3qapHomB9iEmx2x/Fg9faj3592bN3v4AmXHx88cNei
	 t//Yq3HWVegooyHjfWBCuVc5HAWN/VnK6KW45Oz4n+IXf56YwJvD5wHASCuJAN1DhX
	 kxTvuuhjoboVA==
Message-ID: <sashiko-outbox-185513@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v16 05/12] scsi: ibmvfc: add basic FPIN support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261026-ibmvfc-fpin-support-v16-5-a900aa657ed5@linux.ibm.com>
References: <20261026-ibmvfc-fpin-support-v16-0-a900aa657ed5@linux.ibm.com>
 <20261026-ibmvfc-fpin-support-v16-5-a900aa657ed5@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 16:24:10 +0000
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
- [High] scsi: ibmvfc: double free in ibmvfc_probe() when ibmvfc_alloc_mem(=
) fails
--

commit 1bc41de0e60f763f9d00e952aa43dcb15b71cefb
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: add basic FPIN support

This commit adds basic Fabric Performance Impact Notification (FPIN) support
to the ibmvfc driver by offloading IBMVFC_AE_FPIN async events to a
per-adapter ordered workqueue and passing converted descriptors to
fc_host_fpin_rcv(). It also adds KUnit tests for FPIN event handling.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index b63b341efb074..1cd39d36edf5c 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c

[ ... ]

> @@ -6900,9 +7171,15 @@ static int ibmvfc_probe(struct vio_dev *vdev, cons=
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
> @@ -6910,7 +7187,7 @@ static int ibmvfc_probe(struct vio_dev *vdev, const=
 struct vio_device_id *id)
>  		dev_err(dev, "Couldn't create kernel thread: %ld\n",
>  			PTR_ERR(vhost->work_thread));
>  		rc =3D PTR_ERR(vhost->work_thread);
> -		goto free_host_mem;
> +		goto free_workq;
>  	}
> =20
>  	if ((rc =3D ibmvfc_init_crq(vhost))) {
> @@ -6946,7 +7223,8 @@ static int ibmvfc_probe(struct vio_dev *vdev, const=
 struct vio_device_id *id)
>  	ibmvfc_release_crq_queue(vhost);
>  kill_kthread:
>  	kthread_stop(vhost->work_thread);
> -free_host_mem:
> +free_workq:
> +	destroy_workqueue(vhost->fpin_workq);
>  	ibmvfc_free_mem(vhost);

[Severity: High]
Does jumping to free_workq when ibmvfc_alloc_mem(vhost) fails in
ibmvfc_probe() cause a double free in ibmvfc_free_mem(vhost)?

When an allocation fails inside ibmvfc_alloc_mem(), it already unwinds and
frees everything allocated up to that point before returning -ENOMEM, leavi=
ng
non-NULL dangling pointers in vhost:

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_alloc_mem() {
	...
free_tgt_pool:
	mempool_destroy(vhost->tgt_pool);
free_trace:
	kfree(vhost->trace);
free_nvme_disc_buffer:
	ibmvfc_free_disc_buf(dev, &vhost->nvme_scrqs);
free_scsi_disc_buffer:
	ibmvfc_free_disc_buf(dev, &vhost->scsi_scrqs);
free_login_buffer:
	dma_free_coherent(dev, sizeof(*vhost->login_buf),
			  vhost->login_buf, vhost->login_buf_dma);
free_sg_pool:
	dma_pool_destroy(vhost->sg_pool);
unmap_async_crq:
	ibmvfc_free_queue(vhost, async_q);
nomem:
	LEAVE;
	return -ENOMEM;
}

In ibmvfc_probe(), jumping to free_workq when ibmvfc_alloc_mem() fails
destroys vhost->fpin_workq and then falls through into ibmvfc_free_mem(vhos=
t),
which frees all of those host resources a second time and calls
dma_free_coherent() on NULL pointers such as vhost->channel_setup_buf.

Should ibmvfc_alloc_mem(vhost) be called before alloc_ordered_workqueue()
(or use separate error labels for freeing host memory and destroying
vhost->fpin_workq) so that an ibmvfc_alloc_mem() failure skips
ibmvfc_free_mem()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026-ibmvfc-fpi=
n-support-v16-0-a900aa657ed5@linux.ibm.com?part=3D5

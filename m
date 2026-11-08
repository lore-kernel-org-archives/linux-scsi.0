Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794172193;
	b=IyUcPrIIcp0V47ppHAbyS/7vdc7XHAkr1vpTi/oN8UHv47zE312T5pT37B+8mnYIVXPJ
	 FbQyZ0gMbiQS7YUUZFsRr8rFefFyLaVIPROwNIiTVDpe74ELiCdDJ8gGW7xISQ7PxWWWz
	 fYxIYbaxwb5+OoZOCtEuX745X7K36l+WfpA7x41H9PZAY6ATXT1RiA4C7cH4T5ulA1PHe
	 fz09treJbWOpoBYbHfniAJVKCaijonhNO4+Ad5owaZ0oLI1kSYooXESFk8kvz4pRW1h2q
	 AUnV5jFreVh79t7yJbDt3VfZYnUEa/7wrzFNDghUrxsaMbuZQoL1KUnl2hcI3q0vh4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794172193;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=sWwPqXhlmntuXUkmWAS3xXf73mGRjYTurrM/bmufH18=;
	b=oMTP8vTo59E5dJ59KXcVxBEojpOPAC45P7Kx9/70cFIXJbV/lJBNJTuavwmoeEWgQNY4
	 ZxsTnnmZKc9bTAAKDAlTrt/02m9v33RsI24zDdWDMhy9vp1zLqD0LYnw8TtN5RjNSC/X+
	 wFbkWYdl9z+is++cKq04M42RR2i17ngtpFXeWu+4bXaKHVjkRebLgSA/7nlu10LNUKXDq
	 crT9IcBV8PamSzYadbWC1jPUTJdPxzyHSnA8z0CHuQw6jkk6gaEVpP6q7/RfLesOEIHT0
	 NEdvKdkQd6bsGQaBt7DM7dFsj0ylLAsXaf4wJoTx8rreAemtlk/AudpljuOUFUOumEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VYwhhnIh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3387C606A31C;
	Sun,  8 Nov 2026 21:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VYwhhnIh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B005A1F0089F;
	Sun,  8 Nov 2026 21:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794172192;
	bh=sWwPqXhlmntuXUkmWAS3xXf73mGRjYTurrM/bmufH18=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VYwhhnIhUDVzC+Us+jgoJW6E6aB17f64W6EpdC5Uuk5ivqUNUwHlWdZEdmJOtgWFn
	 GksLjtfrh6ndctFAOYF7uZxqwfmV9wKFuEDXkv6PnLbTBr/BgEK34V0vVMYmGIuZ7K
	 5IVH4TJSarMcgafusFIdBsUtqSl82psWiK+NcVe/T1wFqb+AX1RaPciP9ONKCdEfKH
	 Sv4Hlr0zNpg1p7WDdxMGVUjGEa9xwuGFKLt+Ycbuqkp+9QhRXyUG+p/z0Oz6nix6pV
	 NSLSnET0py2lcpBrgKKogotacm4o0wV7BJYCH0c4Kdz6/n81fyjR/mpzYlnFBBEwGv
	 3+vi09A7PB+qA==
Message-ID: <sashiko-outbox-204064@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 22/29] scsi-multipath: update request for terminal
 request queuing error
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.garry@linux.dev>, james.bottomley@hansenpartnership.com, mkp@kernel.org
Cc: hare@suse.com, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, snitzer@kernel.org, jmeneghi@redhat.com, bmarzins@redhat.com, dm-devel@lists.linux.dev, hch@lst.de, michael.christie@oracle.com
In-Reply-To: <20261108204733.557995-23-john.garry@linux.dev>
References: <20261108204733.557995-1-john.garry@linux.dev>
 <20261108204733.557995-23-john.garry@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 21:09:51 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] scsi-multipath: NULL dereference on bio-less request in
  scsi_mpath_end_request_no_update()
--

commit 6015c0421ae4c77548304e8f223ec4e93492aa00
Author: John Garry <john.garry@linux.dev>

scsi-multipath: update request for terminal request queuing error

This commit adds scsi_mpath_end_request_no_update() and calls it from
scsi_queue_rq() when a multipath request fails with a terminal queueing
error, updating active request counts and I/O statistics.

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index 93a4545f1dbf7..bec6dd94f3be8 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
> @@ -614,6 +614,41 @@ bool scsi_mpath_end_request(struct request *req, blk=
_status_t error,
>  	return false;
>  }
> =20
> +void scsi_mpath_end_request_no_update(struct request *req, blk_status_t =
error)
> +{
> +	struct scsi_cmnd *scmd =3D blk_mq_rq_to_pdu(req);
> +	struct scsi_device *sdev =3D scmd->device;
> +	struct bio *clone =3D req->bio, *master =3D clone->bi_private;
> +	struct block_device *bi_bdev =3D master->bi_bdev;
> +	unsigned int nr_bytes;
> +
> +	/* Don't generate error logs if we are going to try another path */
> +	if (blk_path_error(error))
> +		req->rq_flags |=3D RQF_QUIET;
> +
> +	if (scmd->flags & SCMD_MPATH_CNT_ACTIVE) {
> +		struct Scsi_Host *shost =3D sdev->host;
> +
> +		atomic_dec_if_positive(&shost->mpath_nr_active);
> +	}
> +
> +	if (!(scmd->flags & SCMD_MPATH_IO_STATS))
> +		return;

[Severity: High]
Can clone->bi_private cause a NULL pointer dereference when req->bio is
NULL?

blk_kick_flush() initializes fq->flush_rq with flush_rq->bio set to NULL
and copies REQ_DRV (which REQ_MPATH aliases) into flush_rq->cmd_flags:

block/blk-flush.c:blk_kick_flush() {
    ...
	flush_rq->cmd_flags =3D REQ_OP_FLUSH | REQ_PREFLUSH;
	flush_rq->cmd_flags |=3D (flags & REQ_DRV) | (flags & REQ_FAILFAST_MASK);
    ...
}

Unlike scsi_mpath_start_request() and scsi_mpath_end_request(), which
only dereference req->bio when SCMD_MPATH_IO_STATS is set,
scsi_mpath_end_request_no_update() dereferences req->bio unconditionally
at function entry before checking SCMD_MPATH_IO_STATS.  If a flush
request hits a terminal queueing error in scsi_queue_rq() (such as when a
path is transport offline), this crashes.  Deferring the req->bio and
clone->bi_private dereferences until after the SCMD_MPATH_IO_STATS check
would avoid this.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261108204733.5579=
95-1-john.garry@linux.dev?part=3D22

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795250484;
	b=5sLkiE5dpPgg6hgsO9ug/9RW56zeQHORxHHGn3mFTvS2Xo757mgt96npsz4UP1QaWxwR
	 1JAKz54NVrPuuFT95cUVYHJpWujjyZ6YJJoztiy9N612EXtt+xpHbc5OXE6cdKIBEF6gY
	 aJ/3XcT6CqaiCGZdHFX0oUclH/UaSjLZ0BQZsrPiny76FISJqa8rSlboMxEKdlj12N1fa
	 G29nAnvKgdSGDtndyVfGl8LwCnejKax7ynMp9IrCcEXt6EMd0vviyq4oAE3ZHkY7rMtjr
	 0xVYeT52MK97tEbukAOyX6azpYo9KKbx6SELn5mHMnFlHUmOSFvNDAk6OL0ZbCWq/pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795250484;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=FP1QIEamdI+V+TRgzazp/Bfe1WLcBIDMJbqM4v80Ocs=;
	b=nKUw4f+JRRvTn1kfGh5XoYxrLl7iPuMH76Bq2U0H+4CerGyYirr7bt6ul5YaPZG/A70n
	 xDJ2Nr9Afeu6/Uqa6h5eX1s8V5hkThBsDSw3eJdDFn0EdV0A7re43N1mbOQBN6LepGt/0
	 4yEK4a1jgQU54bXfwjEPucYaKwYFcQjnNrkfGQvs2NSK4yCJnSYk4UyyvKTQO5xx1g+aZ
	 jgrPmLEBYBNIStWIJ2uVKhJ/Oew2YZgdeWkh2zUKF2m48hvgLNom04pmwdF4gzrrOsWTG
	 e5jtcHwJyO8gZ5ky1gKRaLVGCcbiUzNe28GxnDmznQVt2PdKYcj3xDAOIeDyElxEkiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HWiIQ8py;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C45606A320
	for <linux-scsi@vger.kernel.org>; Sat, 21 Nov 2026 08:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HWiIQ8py
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E8A1F000C4;
	Sat, 21 Nov 2026 08:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795250484;
	bh=FP1QIEamdI+V+TRgzazp/Bfe1WLcBIDMJbqM4v80Ocs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HWiIQ8py+GLR499BsCFVI+hZRAur/hdu1lh/9vmylo5ySOHZgWOeGi6PVTTvSkP91
	 tAYMymZhuNZBGcU4I450Pl/klbXJmWcvZT5ahPgKSrXek8198bxEGQSz3tbD00a/zs
	 gMm6mpjkIsOQLAz9LpqdKceb87NWNHb56wX5zn9eqZnu53A6WEx9KIet84lKq6UuBJ
	 2hY2v4tU6zF17PrWx3w0c0MWPxkNMv7lCGQwi2Oad3VkylQWJHtg96EilgNrGl6DyJ
	 1pB2/h5I5NDKTSC2PreKhTWsGeJY7iK8aTkXiGsVYT4rM5pilOugMJDwIdAFVRjvVE
	 qMYhjtf/tCIKw==
Message-ID: <sashiko-outbox-226841@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 2/2] scsi: bsg: Release io_uring requests from
 end-I/O
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yingjie Wang" <x-professor@outlook.com>
Cc: =?utf-8?b?bGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmc=?= <linux-scsi@vger.kernel.org>
In-Reply-To: <scsi-pool-v5.1795249365940711260.2.x-professor@outlook.com>
References: <scsi-pool-v5.1795249365940711260.0.x-professor@outlook.com>
 <scsi-pool-v5.1795249365940711260.2.x-professor@outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 08:41:23 +0000
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
- [Medium] scsi: bsg: per-device spinlock contention on sense buffer
  pool per I/O
- [Medium] scsi: bsg: in-flight uring_cmd depth clamped to 64 with late
  pool check
--

commit 5e758c01d49b423d6603c6f22a4f49d0ad99b0ff
Author: Yingjie Wang <x-professor@outlook.com>

scsi: bsg: Release io_uring requests from end-I/O

This commit snapshots SCSI completion status and sense data in the request
end-I/O callback using the BSG completion buffer pool so the block request
can be freed before io_uring task work runs.

> diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
> index c17cad7983260..d1ad956df9d6f 100644
> --- a/drivers/scsi/scsi_bsg.c
> +++ b/drivers/scsi/scsi_bsg.c

[ ... ]

> @@ -78,9 +82,34 @@ static enum rq_end_io_ret scsi_bsg_uring_cmd_done(stru=
ct request *req,
>  						  const struct io_comp_batch *iocb)
>  {
>  	struct io_uring_cmd *ioucmd =3D req->end_io_data;
> +	struct scsi_bsg_uring_cmd_pdu *pdu =3D scsi_bsg_uring_cmd_pdu(ioucmd);
> +	struct scsi_cmnd *scmd =3D blk_mq_rq_to_pdu(req);
> +	u8 driver_status =3D 0;
> +	u8 sense_len =3D 0;
> +
> +	if (scsi_status_is_check_condition(scmd->result)) {
> +		driver_status =3D DRIVER_SENSE;
> +		if (pdu->sense_buffer) {
> +			sense_len =3D min_t(unsigned int, pdu->max_response_len,
> +					  scmd->sense_len);
> +			if (sense_len)
> +				memcpy(pdu->sense_buffer, scmd->sense_buffer,
> +				       sense_len);
> +		}
> +	}
> +
> +	pdu->res2 =3D bsg_scsi_res2_build(status_byte(scmd->result),
> +					driver_status, host_byte(scmd->result),
> +					sense_len, scmd->resid_len);
> +
> +	/* Return the buffer now if there is no sense data to copy. */
> +	if (!sense_len && pdu->sense_buffer) {
> +		bsg_uring_cmd_put_completion_buf(ioucmd, pdu->sense_buffer);
> +		pdu->sense_buffer =3D NULL;
> +	}

[Severity: Medium]
Does checking out and returning a sense buffer on every command serialize
submissions and completions on the per-device pool->lock?

Because scsi_bsg_uring_cmd() calls bsg_uring_cmd_get_completion_buf() up
front whenever the caller provides a response buffer, every I/O acquires
spin_lock_irqsave(&pool->lock, flags) and modifies pool->checked_out twice
(once on submission and once here or in task work), even when the command
succeeds with SAM_STAT_GOOD and produces no sense data:

block/bsg.c:bsg_uring_cmd_get_completion_buf() {
    ...
	spin_lock_irqsave(&pool->lock, flags);
	index =3D find_first_zero_bit(pool->checked_out, BSG_DEFAULT_CMDS);
	if (index < BSG_DEFAULT_CMDS) {
		__set_bit(index, pool->checked_out);
		buf =3D pool->bufs + index * SCSI_SENSE_BUFFERSIZE;
	}
	spin_unlock_irqrestore(&pool->lock, flags);
    ...
}

Allocating the completion buffer in scsi_bsg_uring_cmd_done() only on
SAM_STAT_CHECK_CONDITION would keep the normal completion path lockless.

[ ... ]

> @@ -168,8 +200,25 @@ static int scsi_bsg_uring_cmd(struct request_queue *=
q, struct io_uring_cmd *iouc
>  		goto out_free_req;
>  	}
> =20
> -	pdu->response_addr =3D cmd->response;
> -	pdu->max_response_len =3D cmd->max_response_len;
> +	pdu->response_addr =3D response_addr;
> +	pdu->max_response_len =3D max_response_len;
> +
> +	/*
> +	 * Take a sense buffer before mapping data: unmapping a bounced READ
> +	 * copies back even if no I/O ran, so rejecting it afterwards would
> +	 * overwrite the caller's data. No response buffer means no sense copy.
> +	 */
> +	if (response_addr && max_response_len) {
> +		pdu->sense_buffer =3D
> +			bsg_uring_cmd_get_completion_buf(ioucmd,
> +							 SCSI_SENSE_BUFFERSIZE);
> +		if (!pdu->sense_buffer) {
> +			ret =3D -EAGAIN;
> +			goto out_free_req;
> +		}
> +	} else {
> +		pdu->sense_buffer =3D NULL;
> +	}

[Severity: Medium]
Does reserving a slot from bd->completion_pool at submission time clamp
concurrent in-flight commands with a sense buffer to BSG_DEFAULT_CMDS (64)
per device, regardless of the device's blk-mq queue depth?

In addition, bsg_uring_cmd_get_completion_buf() is called after
scsi_alloc_request() and copy_from_user().  When all 64 slots are in use,
inline submission with IO_URING_F_NONBLOCK allocates and frees a blk-mq
request, returns -EAGAIN, and causes io_uring to punt the SQE to an io-wq
worker, which allocates and frees a request a second time before failing
again with -EAGAIN.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/scsi-pool-v5.179524=
9365940711260.0.x-professor@outlook.com?part=3D2

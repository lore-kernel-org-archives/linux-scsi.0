Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059897;
	b=i4jFfLpks0LB2dGlh/Hu5Fjd4xnpnZii2v6xZO6JVniG2FCaFoNB96dvIRNqBszFx7M2
	 t3C+KKfM5LNwS1guRY7DK7ZKDxXzdlSPzfRERdj8/TeV+l/a2cIEgnXFa4HPzqsKY6thc
	 MUNRDhYvC9ZNHfa+oZ/kqgmB3wue29u0QCAnE1vi/a6W/fpkfsHkINC9c4VCrNfRb/h1P
	 rROR+BMPhaqBV85hEzDv+ctOAoKClRWFxSxins6OdQ4ollJ8fLczIWjbJhklC4JOShOKu
	 0wrCrZEGB8mIF9lD44oB4gT6TJdSP0gdIyPsl5zJKHvAonu5rlzoZQxpdEPAIYNya0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059897;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ddAKCepQXFSfsZLvHAwye/s9Mxp0dcp1KCVhQjbYQck=;
	b=vfOShIO9FpB9Yw1zX0xx/8HaQM9VmvR3IrZzoPjKGbe9WXj73YGmf/ozHEYYfpAYgVZr
	 12chHQ3cqaQ0T9OnThEbTnEh7rbhZStv65WPGNiR1w4nmotKXN6CSNbNRd4HgjkjKBwlc
	 oc+cbYK87tcyCQfvj4i6DmO/fJ2l1bSBEGFON9rFodx6/HQFEiRy0WNfUzwssT/SHyB2Y
	 JpKctwkZgdYUk/l9/UcD5dwBXbapEEGBmrM95yiCHsMupHk2z2L1rxJQV4G16pX+n7s0F
	 HKyQW7rltf+KEG3xlPHZauyifwD2g7szxAq8GthR4SXcTnlrzr2lp9IeemHA5ymNv2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZVGRsAmR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC41E606A325
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 03:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZVGRsAmR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6181F1F000C5;
	Thu, 19 Nov 2026 03:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795059897;
	bh=ddAKCepQXFSfsZLvHAwye/s9Mxp0dcp1KCVhQjbYQck=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZVGRsAmRGSdf93rM+14DYHbcDoUf78uKqoiymgu/c5ZA+RAIUxPhLJvTHCZBRMMza
	 d7zCSFXy7Yq73By+gnQ+OB3waMy1jWNH0dhXRoBRnf8C+IXUhFGg5EJnQn/bQ66ZJz
	 A58y64PJuh4w2Vu7V8TmIespY4Bt4cQUEcqwCop39cVh7EOqav1rU1c7UqBKLiTwyU
	 Q/t5RmKDhbEh2FMW6rZZldQlGv/lli7lOEsXHx4I30Auy74Mk2PDL/iI76A5k8eaU4
	 /pox49Y8etNJqU3xMFQl07pE4I5lEfZvede7MuujNQK0F1EwmY/KLHQq7UYE7uFvoY
	 3by7g2/StmlIw==
Message-ID: <sashiko-outbox-222409@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] scsi: bsg: release io_uring requests from end-I/O
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yang Xiuwei" <yangxiuwei@kylinos.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261119031751.3471968-3-yangxiuwei@kylinos.cn>
References: <cover.1795016239.git.x-professor@outlook.com>
 <20261119031751.3471968-1-yangxiuwei@kylinos.cn>
 <20261119031751.3471968-3-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 03:44:57 +0000
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
- [High] scsi: bsg: IRQ-unsafe pool->lock in scsi_bsg_uring_cmd_done()
--

commit 90faa38e4aa3fb704f223fae5379944821b9aa28
Author: Yang Xiuwei <yangxiuwei@kylinos.cn>

scsi: bsg: release io_uring requests from end-I/O

This commit snapshots the SCSI completion status and sense data in the
request end-I/O callback using the per-device BSG completion buffer pool
and returns RQ_END_IO_FREE so the request tag is released before task work
runs.

> diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
> index e4a65d7a23742..739778244f420 100644
> --- a/drivers/scsi/scsi_bsg.c
> +++ b/drivers/scsi/scsi_bsg.c
[ ... ]
> @@ -70,9 +83,38 @@ static enum rq_end_io_ret scsi_bsg_uring_cmd_done(stru=
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
> +		if (pdu->response_addr) {
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
> +	/*
> +	 * No sense to deliver: return the pool buffer now so other commands
> +	 * can use it while this one waits for task work.  Task work only puts
> +	 * when sense_buffer is still set.
> +	 */
> +	if (!sense_len && pdu->sense_buffer) {
> +		bsg_uring_cmd_put_completion_buf(ioucmd, pdu->sense_buffer);
> +		pdu->sense_buffer =3D NULL;
> +	}

[Severity: High]
Can calling bsg_uring_cmd_put_completion_buf() from
scsi_bsg_uring_cmd_done() self-deadlock on pool->lock?

Both bsg_uring_cmd_get_completion_buf() and
bsg_uring_cmd_put_completion_buf() acquire pool->lock with plain
spin_lock().  scsi_bsg_uring_cmd() and scsi_bsg_uring_task_cb() call
them from process context with interrupts and softirqs enabled, while
scsi_bsg_uring_cmd_done() is the req->end_io callback and runs in
hardirq or BLOCK_SOFTIRQ context:

scsi_bsg_uring_cmd()
  bsg_uring_cmd_get_completion_buf()
    spin_lock(&pool->lock)
    <softirq / hardirq>
      ...
        scsi_bsg_uring_cmd_done()
          bsg_uring_cmd_put_completion_buf()
            spin_lock(&pool->lock)  <-- spins forever

If a command that provided a response buffer completes without check
condition on the same CPU while process context holds pool->lock, the
CPU deadlocks.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119031751.3471=
968-2-yangxiuwei@kylinos.cn?part=3D2

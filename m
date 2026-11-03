Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793710166;
	b=as3GGj9T71lmAuN20rsDt6lHL5f82tc7ZL+hiDys8xZBom3MNB2I4hx7TAfDYxf08oEQ
	 297JKG6vEokls6QadklefgA/6oyx2P/MnJygXOisaBjlbEd8Ca/yMaI/yJX63MHRPDLab
	 pib7Uv0DvTAFT0QIqz8r652QNGKclq3ffFImtzqhxS4OxnnVaZzhixzG5/tL57QZ1oRyA
	 pcPm2lczjymKyFh8pOB1L7vFCvNNEmJ5/DCqrya09j4XWZu2i8MQWyX2jxV5OBL3YKIyR
	 a44O6qEltyVhzesaXmWOkz4kqpmHiqWYJTe+spleKnStb3ETLw7tFYkR1faoitxKXmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793710166;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=2p79EDPC3K6ppL4EmkBe12qsgZR2+QvvMtQfpHh7jQQ=;
	b=oSzHgTK2G+xC9u+iu2KaW1VgJzIiwuoYhQt3t3IKwVloRcgDjTw1COEB5Q3CxXoMkeU0
	 9fTauvKpzm366toSZx10HrrFY8jckAJInuS2ld1NlIlbbJpRTjTm94J3Ofw2D387GL3sa
	 /AL/WRGZk2GAOcHfRDXiDc7pTxZl2aVAF09D9VFWL67TIdzzEDDvsS8e8BnLMLEaEwRpE
	 vgp3PQSfZs8PCvdnVok0iSWrGesxzc8iTtc0v9gfpR71nXcuVOYomGNN7stTmFzoEziyd
	 Zj3dmBYEzXzJz2sKoNJO7vlD95ypRJbID8LD8HVobNpVNhPSm4iQYRICNYToSEZFlwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EuanwMe3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA22606A326
	for <linux-scsi@vger.kernel.org>; Tue,  3 Nov 2026 12:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EuanwMe3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57C91F000C1;
	Tue,  3 Nov 2026 12:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793710166;
	bh=2p79EDPC3K6ppL4EmkBe12qsgZR2+QvvMtQfpHh7jQQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EuanwMe3CNnWS7BQl+3XdjMgBCDFB1nZNA+BjsjpOUS9qfXamWZEW71VS0o0xzdJj
	 f7wnnxAJOyfwLrRg026CxWWrF91nJZePSbbbfWhMn1k40GD3rLWni3RPcCLIPiPGBs
	 PtiHZ5IZs3hlXeg6+bXuqXm7MIpwRqgGbu201HIDTtiW0l+xJ2BrWO9dyHoFf01BQ4
	 eUQwFriqQmKkkLW0QM0FU5tKHQY7YFAuP0qxQpmQiLU/AyeSSzp6og0NhC7RC0xy0I
	 QduYZmm6andxeGZRM1IBbSDfR0j7o68w3uMxs1QM2r9fkBI2ZCNeYMKoC185yD9agG
	 kWvX4UX9cEHIw==
Message-ID: <sashiko-outbox-195282@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: mpi3mr: Fix integer overflow in reply frame size
 calculation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Milan P. Gandhi" <mgandhi@redhat.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261103123316.223917-1-mgandhi@redhat.com>
References: <20261103123316.223917-1-mgandhi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 12:49:25 +0000
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
- [Critical] scsi: mpi3mr: missing minimum reply_frame_size check in mpi3mr=
_issue_iocfacts()
--

commit b19e0f1b924cd80d0da53959c0e35b88d0537a9a
Author: Milan P. Gandhi <mgandhi@redhat.com>

scsi: mpi3mr: Fix integer overflow in reply frame size calculation

This commit validates reply_frame_size in mpi3mr_issue_iocfacts() to prevent
a u16 integer overflow when multiplying by 4 to compute mrioc->facts.reply_=
sz,
and rejects a zero reply_frame_size.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> index f0d3cd398dd00..2b72218e79fb3 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -3261,6 +3261,7 @@ static int mpi3mr_issue_iocfacts(struct mpi3mr_ioc =
*mrioc,
>  	struct mpi3_ioc_facts_data *facts_data)
>  {
>  	struct mpi3_ioc_facts_request iocfacts_req;
> +	u16 reply_frame_size;
>  	void *data =3D NULL;
>  	dma_addr_t data_dma;
>  	u32 data_len =3D sizeof(*facts_data);
> @@ -3318,6 +3319,19 @@ static int mpi3mr_issue_iocfacts(struct mpi3mr_ioc=
 *mrioc,
>  		goto out_unlock;
>  	}
>  	memcpy(facts_data, (u8 *)data, data_len);
> +
> +	reply_frame_size =3D le16_to_cpu(facts_data->reply_frame_size);
> +	/*
> +	 * Validate reply_frame_size to prevent integer overflow when
> +	 * converting dwords to bytes (reply_frame_size * 4).
> +	 */
> +	if (!reply_frame_size || reply_frame_size > (U16_MAX / 4)) {
> +		ioc_err(mrioc, "Invalid reply_frame_size %u from firmware\n",
> +			reply_frame_size);
> +		retval =3D -EINVAL;
> +		goto out_unlock;
> +	}

[Severity: Critical]
Is rejecting only reply_frame_size =3D=3D 0 at the lower bound sufficient w=
hen
validating firmware-provided facts data?

If buggy or malicious firmware reports reply_frame_size between 1 and 15
dwords (setting mrioc->facts.reply_sz and mrioc->reply_sz to 4..60 bytes),
several downstream consumers fail:

1. In drivers/scsi/mpi3mr/mpi3mr_app.c:mpi3mr_enable_logdata(),
   mrioc->logdata_entry_sz (u16) is computed as:

	mrioc->logdata_entry_sz =3D
	    (mrioc->reply_sz - (sizeof(struct mpi3_event_notification_reply) - 4))
	    + MPI3MR_BSG_LOGDATA_ENTRY_HEADER_SZ;
	mrioc->logdata_buf_idx =3D 0;
	mrioc->logdata_buf =3D kcalloc(MPI3MR_BSG_LOGDATA_MAX_ENTRIES,
	    mrioc->logdata_entry_sz, GFP_KERNEL);

   Since sizeof(struct mpi3_event_notification_reply) is 28 and
   MPI3MR_BSG_LOGDATA_ENTRY_HEADER_SZ is 4, this evaluates to
   mrioc->reply_sz - 20. When reply_frame_size =3D=3D 5 (mrioc->reply_sz =
=3D=3D 20),
   mrioc->logdata_entry_sz becomes 0 and kcalloc() returns ZERO_SIZE_PTR,
   which then causes a division by zero in mpi3mr_get_logdata():

	entry_sz =3D mrioc->logdata_entry_sz;
	num_entries =3D job->request_payload.payload_len / entry_sz;

   and a ZERO_SIZE_PTR dereference in mpi3mr_app_save_logdata_th(). When
   reply_frame_size is 1..4 (mrioc->reply_sz is 4..16),
   mrioc->logdata_entry_sz underflows u16 to 65520..65532.

2. In drivers/scsi/mpi3mr/mpi3mr_app.c:mpi3mr_bsg_process_mpt_cmds(),
   bsg_reply_buf is allocated with sizeof(*bsg_reply_buf) + mrioc->reply_sz
   bytes. When MPI3MR_CMD_REPLY_VALID is not set, bsg_reply_buf->reply_buf
   is cast to struct mpi3_status_reply_descriptor * (8 bytes):

	status_desc =3D (struct mpi3_status_reply_descriptor *)
	    bsg_reply_buf->reply_buf;
	status_desc->ioc_status =3D mrioc->bsg_cmds.ioc_status;
	status_desc->ioc_log_info =3D mrioc->bsg_cmds.ioc_loginfo;

   When reply_frame_size =3D=3D 1 (mrioc->reply_sz =3D=3D 4), writing
   status_desc->ioc_log_info writes 4 bytes past the end of bsg_reply_buf.

3. In drivers/scsi/mpi3mr/mpi3mr_fw.c:mpi3mr_alloc_reply_sense_bufs(),
   internal command reply buffers (such as mrioc->transport_cmds.reply,
   mrioc->pel_cmds.reply, and mrioc->host_tm_cmds.reply) are allocated with
   kzalloc(mrioc->reply_sz, GFP_KERNEL), and mrioc->reply_buf slots are
   sized to mrioc->reply_sz bytes. However, downstream completion paths read
   fixed-size reply structures up to 64 bytes without checking
   mrioc->reply_sz:

   - drivers/scsi/mpi3mr/mpi3mr_transport.c:mpi3mr_post_transport_req()
     copies reply_sz (up to sizeof(struct mpi3_iounit_control_reply), 64
     bytes) from mrioc->transport_cmds.reply:

	if ((reply) && (mrioc->transport_cmds.state & MPI3MR_CMD_REPLY_VALID))
		memcpy((u8 *)reply, mrioc->transport_cmds.reply, reply_sz);

   - drivers/scsi/mpi3mr/mpi3mr_os.c:mpi3mr_process_op_reply_desc() reads
     struct mpi3_scsi_io_reply (56 bytes) from mrioc->reply_buf:

	sense_buf =3D mpi3mr_get_sensebuf_virt_addr(mrioc,
	    le64_to_cpu(scsi_reply->sense_data_buffer_address));

   - drivers/scsi/mpi3mr/mpi3mr_fw.c:mpi3mr_process_admin_reply_desc(),
     PEL completion handlers, and task management handlers dereference
     struct mpi3_default_reply (16 bytes), struct mpi3_pel_reply (28 bytes),
     and struct mpi3_scsi_task_mgmt_reply (28 bytes).

Should mpi3mr_issue_iocfacts() enforce a minimum reply_frame_size of at lea=
st
16 dwords (64 bytes, covering struct mpi3_iounit_control_reply and all other
fixed reply structures) instead of only checking for zero?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103123316.2239=
17-1-mgandhi@redhat.com?part=3D1

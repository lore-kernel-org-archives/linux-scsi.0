Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793882741;
	b=r5Clqb2mC1L6ZDPv916EPTqSpvd1G5+89hm2JsoNQPttonyBYip+GHStdWCcoBZ76rDU
	 J5gYYKr2GwW4KLsaQYGjXz0xbNLUr2WYGXs/9GKvZ0q5u1s2utQwqYPlurwDcJ0S0shOf
	 ueI/Q3W7en6aiLZ+esBlQB91octxIIBbWYMRpxdFSSimHzxIAJC4aNysx5DOwmgIivHUP
	 IgvU9DgObCqXG4RfIbvWRfSnHrbOwjV/HSClYzoIQdvRqxinFO60qJEF/sAyO3vpQmlNc
	 8KAXeAyxV4TDVCo/ZP7DnjOT2fQl6XOcqRr1N3JrQOV6onWS0RvMyeU/PfbVhKk78Qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793882741;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1jRkRvfkrF5d6iUlRfiexdt9rYgsoBZUv6KEqzmjqoI=;
	b=xbQFksDfaNd2PG+xTxfR+j00FJ47wXWtTGWKfWH7vaR8dl3VxK3WahuLSJQrsNWa1Byx
	 v3ya2ErIY3PkIVYy51I0Ex63dhUaY5KkUf8K3F3p7wV3HWl0dejSBHRx/QzOJujqFREPY
	 22znhva0hnzXHSwyQ+ev84ZVANs/oaKZ7BU0pt2a7fKP+6RF8e2KOgrlVQWRmzN1BxG22
	 +wpPMp0qvR0stZxK+0y2S4NK8M+IGoRyTAZ3gOTwoWTRf0Gspk3TZM65c/CIHXZxrZhaQ
	 AaEGAwxzDWDEkMkBxbza8PlDJ1scS2C6/0tgqkYzI4HzyzYRyVZfs6nSp9DRjac4cBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jtY5EAvl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD851606A329
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 12:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jtY5EAvl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9F71F000C1;
	Thu,  5 Nov 2026 12:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793882740;
	bh=1jRkRvfkrF5d6iUlRfiexdt9rYgsoBZUv6KEqzmjqoI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jtY5EAvlLXX/ckRqLJxQ6EXms731Owxepv2vJAM9DaYj3tbBGPtsRop3sV/PpRK8l
	 mF94jSJRv7pYuMTJOWq9s+GQrdpuX9Rz99LZ8J6eP0uarAwpia0hkArUwfL1UCDwZR
	 KfEIBWihzNcDyFyglKpfPEaoJnG6apvzvRuziID9Mtwws4AM9WQlmDPCejWAXI46zt
	 GhEaUAm1GoDmNwZuIElJNxABdXQ3IFVmJoQsZvkUaFHS+4qrgQoyrzm3pYR3DNA+ib
	 2nQ8CAPEOd6BbC+UcUitdiRVmui662Zj3E4iXrbEizGcVy68SK2mTPrrxes7tyg9dR
	 LZwoNGSTe3ySQ==
Message-ID: <sashiko-outbox-199052@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: mpi3mr: Validate reply frame size bounds
Reply-To: sashiko-reviews@lists.linux.dev
To: "Milan P. Gandhi" <mgandhi@redhat.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261105122401.266559-1-mgandhi@redhat.com>
References: <20261103123316.223917-1-mgandhi@redhat.com>
 <20261105122401.266559-1-mgandhi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 12:45:39 +0000
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
- [High] scsi: mpi3mr: MPI3MR_MIN_REPLY_FRAME_SZ_DWORDS too small for devic=
e events
--

commit d0d39880e8d702685fdb1265ca4630cc2c3c1e34
Author: Milan P. Gandhi <mgandhi@redhat.com>

scsi: mpi3mr: Validate reply frame size bounds

This commit validates that the firmware-reported reply_frame_size in
mpi3mr_issue_iocfacts() falls within [16, U16_MAX / 4] dwords to prevent
integer overflow when computing facts.reply_sz and underflow when sizing
logdata entries.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index d6e16707fd97c..e78383df619c3 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -83,6 +83,7 @@ extern atomic64_t event_counter;
>  #define MPI3MR_ADMIN_REPLY_Q_SIZE	(8 * MPI3MR_PAGE_SIZE_4K)
>  #define MPI3MR_ADMIN_REQ_FRAME_SZ	128
>  #define MPI3MR_ADMIN_REPLY_FRAME_SZ	16
> +#define MPI3MR_MIN_REPLY_FRAME_SZ_DWORDS	16	/* 64 bytes */
> =20
>  /* Operational queue management definitions */
>  #define MPI3MR_OP_REQ_Q_QD		512
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> index f0d3cd398dd00..60a92366e5904 100644
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
> @@ -3318,6 +3319,23 @@ static int mpi3mr_issue_iocfacts(struct mpi3mr_ioc=
 *mrioc,
>  		goto out_unlock;
>  	}
>  	memcpy(facts_data, (u8 *)data, data_len);
> +
> +	reply_frame_size =3D le16_to_cpu(facts_data->reply_frame_size);
> +	/*
> +	 * Validate reply_frame_size:
> +	 * - Must be at least 16 dwords (64 bytes) to accommodate fixed reply
> +	 *   structures and avoid underflow/divide-by-zero in logdata sizing.
> +	 * - Must not exceed U16_MAX / 4 to prevent integer overflow.
> +	 */
> +	if (reply_frame_size < MPI3MR_MIN_REPLY_FRAME_SZ_DWORDS ||
> +	    reply_frame_size > (U16_MAX / 4)) {
> +		ioc_err(mrioc, "Invalid reply_frame_size %u (must be %u..%u dwords)\n",
> +			reply_frame_size, MPI3MR_MIN_REPLY_FRAME_SZ_DWORDS,
> +			(unsigned int)(U16_MAX / 4));
> +		retval =3D -EINVAL;
> +		goto out_unlock;
> +	}

[Severity: High]
Is a minimum of 16 dwords (64 bytes) for MPI3MR_MIN_REPLY_FRAME_SZ_DWORDS
sufficient for event notification replies that carry struct
mpi3_device_page0?

Event notification replies (struct mpi3_event_notification_reply) are
delivered in the mrioc->reply_buf frames of size mrioc->reply_sz
(reply_frame_size * 4), where the event_data payload starts at byte offset
24 (6 dwords). For MPI3_EVENT_DEVICE_ADDED, the event_data payload is
struct mpi3_device_page0 (64 bytes / 16 dwords), which requires a reply
frame of at least 24 + 64 =3D 88 bytes (22 dwords).

When reply_frame_size is between 16 and 21 dwords (64 to 84 bytes),
mpi3mr_issue_iocfacts() accepts it, and an incoming MPI3_EVENT_DEVICE_ADDED
event in drivers/scsi/mpi3mr/mpi3mr_os.c:mpi3mr_os_handle_events() casts
event_reply->event_data to struct mpi3_device_page0:

	case MPI3_EVENT_DEVICE_ADDED:
	{
		struct mpi3_device_page0 *dev_pg0 =3D
		    (struct mpi3_device_page0 *)event_reply->event_data;
		if (mpi3mr_create_tgtdev(mrioc, dev_pg0))
			...

mpi3mr_create_tgtdev() -> mpi3mr_update_tgtdev() then reads dev_pg0->
device_specific fields up to offset 59 of dev_pg0 (offset 83 of
event_reply), reading past a 64..84 byte reply frame and past the end of
mrioc->reply_buf when using the last frame in the pool.

In addition, when mpi3mr_os_handle_events() allocates fwevt for the bottom
half, it clamps the event_data allocation size sz to avail_reply_room
(mrioc->reply_sz - 24, which is 40..48 bytes for 16..18 dwords):

	if (mrioc->reply_sz > offsetof(struct mpi3_event_notification_reply, event=
_data))
		avail_reply_room =3D mrioc->reply_sz -
		    offsetof(struct mpi3_event_notification_reply, event_data);
	else
		avail_reply_room =3D 0;
	sz =3D min_t(u16, event_reply->event_data_length * 4, avail_reply_room);
	fwevt =3D mpi3mr_alloc_fwevt(sz);

When drivers/scsi/mpi3mr/mpi3mr_os.c:mpi3mr_fwevt_bh() later processes
MPI3_EVENT_DEVICE_ADDED with persistent_id =3D=3D
MPI3_DEVICE0_PERSISTENTID_INVALID and sas_transport_enabled set for a
SAS/SATA device:

	dev_pg0 =3D (struct mpi3_device_page0 *)fwevt->event_data;
	perst_id =3D le16_to_cpu(dev_pg0->persistent_id);
	handle =3D le16_to_cpu(dev_pg0->dev_handle);
	if (perst_id !=3D MPI3_DEVICE0_PERSISTENTID_INVALID)
		mpi3mr_report_tgtdev_to_host(mrioc, perst_id);
	else if (mrioc->sas_transport_enabled &&
	    (dev_pg0->device_form =3D=3D MPI3_DEVICE_DEVFORM_SAS_SATA)) {
		sasinf =3D &dev_pg0->device_specific.sas_sata_format;
		dev_info =3D le16_to_cpu(sasinf->device_info);

can reading sasinf->device_info at offset 50..51 of fwevt->event_data read
out of bounds of the slab object when only 40..48 bytes were allocated?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105122401.2665=
59-1-mgandhi@redhat.com?part=3D1

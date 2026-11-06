Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793928281;
	b=U3Of4fE4eYNlKNQCtlEIE0AHSUf7EgjuCe4Psh1aD4NWQhZQWpLQG4frjPpTtAGPzgI7
	 Oc56RreB+BAPGgulyrdpMVAG+MeTwAvtfreBEOvTXajY/2lBtojVZQtm730NX8Qy0nsr2
	 BTrtcbtwdbMtJe0RBz+qD+eXXD1Y4NPACUXmmuBY34tqTJ1WyqPNIyI8qKn8d86O42cF+
	 QvCImni9qWBhzrtjemHdrioNY8fQoT/GY8SQ6k2BCJ2eODMCmWdyiluNB9nnVrJbAjya8
	 islqb99VC5e4EpOwuWhceS+TaKiF0zw4S3xyrihudljLUhZG3hZtBzrPkb+FotOJN6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793928281;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=jdn2pxdwkluuRAAeA/MBVW6TXU/ae8GB/9Bz6FaEiAg=;
	b=TfiIdCDT5W2EeM6dlQ8bdV6V3G4eSsnkuP4YvyPQjtewKDteg0zJ5lZwBE/3u3NZF7to
	 d1oUzPCaIIZacIE7KJsW/RPsSO86U1rZKPTwJzuKB/G8Mj8e0oi8WGWT+2uvC2wloMaAN
	 oSIzRrqXZE7Za64UGoM1BAUfGobSZcNngEFK1qg9OicGWy0sKL2OOjYeV/ZpySruRbQX4
	 7aRSlr+/SBKVkxYstu4GfCmrn/dK1DIz9mS8WrJ7aIKalGp0GqsYVKe5ZMEzztDBFaB6d
	 kjmP4FlZYphUPMoKdOuFPlxtMNhqrW/NHbNZVGbx2BZeAUpOEh+h7lSQ0xDbijdFJCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ecudvydK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACEA8606A31B
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 01:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ecudvydK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D8E1F0089F;
	Fri,  6 Nov 2026 01:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793928280;
	bh=jdn2pxdwkluuRAAeA/MBVW6TXU/ae8GB/9Bz6FaEiAg=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=ecudvydKb1db7dZ5UQg0dvlifnfJp4POJmPxFoUJsQ0c0RPmphuxQQalyZBQ2cuB/
	 gFwAA0OvpJJR2va136fo9Mp25iO9S1wpHCA035FE5j1oJNZw1rsEolIW5CFWYoKLUC
	 FWYLlzPHOesUFIOgMkhZVZEY7EtLx6VbnSWLEmCRQf5FJn7KweVZxMc5Wn4D/q3Lvd
	 PglSSTdv53B5AEyZn0CpmtrPJrwj0UHw47SvbXvpOgQzfQcG2zNK6vZrSg9edjwJr3
	 Lk994tgeYCpq7c5PYpRrBpbmMhx68quoc3v3TlzO+mZNMgiJWdj2hKdZF+loOZEJq4
	 4Bl2oJlobz+Aw==
Message-ID: <sashiko-outbox-200512@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 26/37] scsi: mpt3sas: Enforce minimum reply frame size
 and validate chain segment size
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1793925772-1303-27-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1793925772-1303-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1793925772-1303-27-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 01:24:39 +0000
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
- [High] scsi: mpt3sas: minimum reply_sz check in _base_allocate_memory_poo=
ls() too small
- [Medium] scsi: mpt3sas: chain_sz bound in _base_allocate_memory_pools() t=
runcates u8
--

commit a651558740938275a089ff4ceac26e9d6bedfb39
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

scsi: mpt3sas: Enforce minimum reply frame size and validate chain segment =
size

This commit adds validation in _base_allocate_memory_pools() to enforce a
minimum reply frame size based on MPI2DefaultReply_t and to bounds-check
IOCMaxChainSegmentSize when calculating chain_segment_sz.

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/m=
pt3sas_base.c
> index 3622d8a42725b..1af9dc241666c 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -6395,21 +6395,46 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTE=
R *ioc)
>  	/* reply frame size */
>  	ioc->reply_sz =3D facts->ReplyFrameSize * 4;
> =20
> +	/* Enforce minimum reply frame size */
> +	if (ioc->reply_sz < sizeof(MPI2DefaultReply_t)) {
> +		ioc_err(ioc,
> +			"Firmware reported an invalid ReplyFrameSize (%d bytes). Cannot safel=
y attach.\n",
> +			ioc->reply_sz);
> +		return -EINVAL;
> +	}

[Severity: High]
Is sizeof(MPI2DefaultReply_t) (20 bytes) large enough to prevent out-of-bou=
nds
reads and writes on the reply buffers when ReplyFrameSize is between 5 and =
12
dwords (20 to 48 bytes)?

In mpt3sas_base_attach(), the internal command reply buffers and DMA reply
frames are allocated using ioc->reply_sz:

drivers/scsi/mpt3sas/mpt3sas_base.c:mpt3sas_base_attach() {
	...
	ioc->base_cmds.reply =3D kzalloc(ioc->reply_sz, GFP_KERNEL);
	ioc->port_enable_cmds.reply =3D kzalloc(ioc->reply_sz, GFP_KERNEL);
	ioc->transport_cmds.reply =3D kzalloc(ioc->reply_sz, GFP_KERNEL);
	ioc->scsih_cmds.reply =3D kzalloc(ioc->reply_sz, GFP_KERNEL);
	ioc->tm_cmds.reply =3D kzalloc(ioc->reply_sz, GFP_KERNEL);
	ioc->config_cmds.reply =3D kzalloc(ioc->reply_sz, GFP_KERNEL);
	ioc->ctl_cmds.reply =3D kzalloc(ioc->reply_sz, GFP_KERNEL);
	...
}

However, command submission and completion paths unconditionally zero, copy,
or dereference larger reply structures from these buffers without checking
ioc->reply_sz. For example, during mpt3sas_base_attach() ->
_base_make_ioc_operational(), _base_display_fwpkg_version() copies 24 bytes
(sizeof(Mpi2FWUploadReply_t)) from ioc->base_cmds.reply:

drivers/scsi/mpt3sas/mpt3sas_base.c:_base_display_fwpkg_version() {
	...
			memcpy(&mpi_reply, ioc->base_cmds.reply,
					sizeof(Mpi2FWUploadReply_t));
	...
}

And _base_static_config_pages() -> _config_request() writes 24 bytes
(sizeof(Mpi2ConfigReply_t)) into ioc->config_cmds.reply:

drivers/scsi/mpt3sas/mpt3sas_config.c:_config_request() {
	...
	memset(ioc->config_cmds.reply, 0, sizeof(Mpi2ConfigReply_t));
	...
}

Other paths access even larger reply structures, such as
mpt3sas_scsih_issue_tm() writing sizeof(Mpi2SCSITaskManagementReply_t) (28
bytes) to ioc->tm_cmds.reply, _transport_smp_handler() copying
sizeof(Mpi2SmpPassthroughReply_t) (28 bytes) from ioc->transport_cmds.reply,
mpt3sas_base_scsi_enclosure_processor() copying sizeof(Mpi2SepReply_t) (32
bytes) from ioc->base_cmds.reply, and _scsi_send_scsi_io(), _scsih_io_done(=
),
and mpt3sas_ctl_done() casting reply buffers to Mpi2SCSIIOReply_t (52 bytes=
):

drivers/scsi/mpt3sas/mpt3sas_scsih.c:_scsi_send_scsi_io() {
	...
		mpi_reply =3D ioc->scsih_cmds.reply;
		transfer_packet->sense_length =3D
		   min_t(u32, le32_to_cpu(mpi_reply->SenseCount),
			 sizeof(transfer_packet->sense));
	...
}

Should the minimum ioc->reply_sz check require at least enough space for the
largest reply structure accessed by the driver, such as Mpi2SCSIIOReply_t?

> +
> +	/* calculate the max scatter element size */
> +	sge_size =3D max_t(u16, ioc->sge_size, ioc->sge_size_ieee);
> +
>  	/* chain segment size */
>  	if (ioc->hba_mpi_version_belonged !=3D MPI2_VERSION) {
> -		if (facts->IOCMaxChainSegmentSize)
> -			ioc->chain_segment_sz =3D
> -					facts->IOCMaxChainSegmentSize *
> +		if (facts->IOCMaxChainSegmentSize) {
> +			/* compute in 32 bits so the product cannot wrap the u16 field */
> +			u32 chain_sz =3D (u32)facts->IOCMaxChainSegmentSize *
>  					MAX_CHAIN_ELEMT_SZ;
> -		else
> -		/* set to 128 bytes size if IOCMaxChainSegmentSize is zero */
> +
> +			/* reject values that wrap or leave < 2 SGEs per chain */
> +			if (chain_sz < 2 * sge_size || chain_sz > 0xFFFF) {

[Severity: Medium]
Can allowing chain_sz up to 0xFFFF truncate chain_offset when building
multi-chain IEEE scatter-gather lists in _base_build_sg_scmd_ieee()?

If facts->IOCMaxChainSegmentSize is between 257 and 4095, chain_sz is betwe=
en
4112 and 65520 bytes, which passes this check and sets
ioc->max_sges_in_chain_message to facts->IOCMaxChainSegmentSize - 1 (256 to
4094).

When _base_build_sg_scmd_ieee() constructs an SGL that spans multiple chain
segments (sges_left > ioc->max_sges_in_chain_message), it sets chain_offset=
 to
ioc->max_sges_in_chain_message and passes it to _base_add_sg_single_ieee():

drivers/scsi/mpt3sas/mpt3sas_base.c:_base_build_sg_scmd_ieee() {
	...
		sges_in_segment =3D (sges_left <=3D
		    ioc->max_sges_in_chain_message) ? sges_left :
		    ioc->max_sges_in_chain_message;
		chain_offset =3D (sges_left =3D=3D sges_in_segment) ?
		    0 : sges_in_segment;
		chain_length =3D sges_in_segment * ioc->sge_size_ieee;
		if (chain_offset)
			chain_length +=3D ioc->sge_size_ieee;
		_base_add_sg_single_ieee(sg_local, chain_sgl_flags,
		    chain_offset, chain_length, chain_dma);
	...
}

In _base_add_sg_single_ieee(), chain_offset is a u8 parameter written into
Mpi25IeeeSgeChain64_t::NextChainOffset (an 8-bit field in 16-byte SGE units,
with a maximum value of 255):

drivers/scsi/mpt3sas/mpt3sas_base.c:_base_add_sg_single_ieee() {
	Mpi25IeeeSgeChain64_t *sgel =3D paddr;

	sgel->Flags =3D flags;
	sgel->NextChainOffset =3D chain_offset;
	...
}

Should IOCMaxChainSegmentSize (or ioc->max_sges_in_chain_message) be bounded
so that chain_offset fits in the u8 NextChainOffset field?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1793925772-1303-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D26

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793927850;
	b=FB9z+AQvi/hkRgUkOu7xPcPIIu6vsmcEg8nRTGjwf8VUGHqGeKTQWSxi4lKY/9FactK9
	 UMDNqLH5Ji6J6yx8IYuZ/3i2Kw1WL5g6F9Kelj0HVNRV0dCKAmrE87qOdhsVfITQzQ80s
	 UVdfhkMnwsxbAE7UMVQjN8SBvPv6jN9BU/tbb47Aocl7/t8qTx4YUoG1IDPTSWUBNwhL3
	 cSdiHnOwEkkeSyqXIDS8n0xF4Ux0UuwPwnA/gdRY9mda68J0tbt1Qj/t64nvprzO5S1DC
	 a5QWJwbi82NgSYSnzOQa48LvKi58qQLTlgKTKPojAEXWA1bRfVRCIuFbN0W6HWvPwMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793927850;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=GlGRboalFMwXFbIwhIZdGgD57g5LSeRBxr8v7hZl1l4=;
	b=D1FDSzo3jOIfmLBB/HUhYqnVc+EjRQWmMnq0yWjDJV1Nqwjt5i+fJ7T8wglszkd3s1Hr
	 g/+PFeKb7fFgigQG8I1ahTHoqDjHkojilFcwoKO6B6GcpFC1THwxl/WQBAyXh+4/t4A4+
	 GD9mT3LjnaJTb+7bAYxIRkiCoSnYCs9FOo/TXVjO7jf4KBNI41OSV/08pndXaumint1Ny
	 ah/mkrtO3G7LwRCF/EjW/GB6Vik5vBOoaEH188cj/WkvP4g85mJrXux44Tu9j+OzZIEuv
	 eruP79wfYDQekPpWkiSQb2k4HOXmxSZJ5CXy86D7tHnQqxzDp9RI07u+jgU3Hpf0zdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BUncCdD9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BD1606A31B
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 01:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BUncCdD9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 648331F0089F;
	Fri,  6 Nov 2026 01:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793927849;
	bh=GlGRboalFMwXFbIwhIZdGgD57g5LSeRBxr8v7hZl1l4=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=BUncCdD9FjwWZBzV+pUFmDOb5QoR6jP2GwxWSnsuh4vzNG6wdUH1nvuwMZGwdsf3z
	 2h1xK/si7BTuHvFgfglIhQOYGwiRhudRCNhtDJr08ROfLwBpK5oSecDS3GEUdUdpsB
	 mYA7rY/0FpTMbeK8kvnubB6l1EKJV/459To5ez0n5TABRNc/3xw1lhEiDVbbd5eoqa
	 ckln5Qizi7mjS0smwh5d7wTZK3h4KtP7fE/1c/lgRDIBpauBx9wJVYe8za0H9dj+aR
	 amVh7I5XGojORAizkKgklIxxXg0UYJzh0I+oMyxxFdJY5srt6A8kJbFDWXlsnENU9E
	 P4hPW0WHN5h9A==
Message-ID: <sashiko-outbox-200500@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 01/37] scsi: mpt3sas: Validate firmware-reported
 IOCRequestFrameSize
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1793925772-1303-2-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1793925772-1303-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1793925772-1303-2-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 01:17:28 +0000
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
- [High] scsi: mpt3sas: incomplete request_sz check in _base_allocate_memor=
y_pools()
--

commit 015ed87d797e7b26a7948ede1e5410c663e3fefb
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

scsi: mpt3sas: Validate firmware-reported IOCRequestFrameSize

This patch validates the IOCFacts-reported request frame size in
_base_allocate_memory_pools() and rejects values smaller than
sizeof(Mpi25SCSIIORequest_t) to prevent adjacent memory corruption.

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/m=
pt3sas_base.c
> index 1af25a22611a1..9bf92c4a14b7a 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -6373,6 +6373,12 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER=
 *ioc)
> =20
>  	/* request frame size */
>  	ioc->request_sz =3D facts->IOCRequestFrameSize * 4;
> +	if (ioc->request_sz < sizeof(Mpi25SCSIIORequest_t)) {
> +		ioc_err(ioc,
> +			"IOCFacts reported invalid RequestFrameSize (%u bytes)\n",
> +			ioc->request_sz);
> +		return -EINVAL;
> +	}

[Severity: High]
Is checking against sizeof(Mpi25SCSIIORequest_t) sufficient to prevent
out-of-bounds writes into adjacent request frames?

In drivers/scsi/mpt3sas/mpi/mpi2_init.h, Mpi25SCSIIORequest_t has a 96-byte
header followed by a single 16-byte SGE union (MPI25_SGE_IO_UNION), so
sizeof(Mpi25SCSIIORequest_t) is 112 bytes rather than 128 bytes. If IOCFacts
reports IOCRequestFrameSize between 28 and 31 dwords (or a value >=3D 0x4000
where the u16 multiplication facts->IOCRequestFrameSize * 4 wraps modulo
65536 to >=3D 112), ioc->request_sz is 112..124 bytes and passes this check.

Just below in _base_allocate_memory_pools(), the driver reserves one SGE
slot in the main frame for a chain element:

drivers/scsi/mpt3sas/mpt3sas_base.c:_base_allocate_memory_pools() {
	...
	max_sge_elements =3D ioc->request_sz - ((sizeof(Mpi2SCSIIORequest_t) -
	    sizeof(Mpi2SGEIOUnion_t)) + sge_size);
	ioc->max_sges_in_main_message =3D max_sge_elements/sge_size;
	...
}

When ioc->request_sz is 112..124 bytes and sge_size is 16, max_sge_elements
is less than sge_size, leaving ioc->max_sges_in_main_message =3D=3D 0.

Furthermore, several paths unconditionally write up to 128 bytes (two SGE
slots after the 96-byte header, or sizeof(Mpi2DiagBufferPostRequest_t)) into
a request frame allocated from ioc->request:

1. base_make_prp_nvme() places the chain element in the second SGE entry at
bytes 112..127:

drivers/scsi/mpt3sas/mpt3sas_base.c:base_make_prp_nvme() {
	...
	main_chain_element =3D (pMpi25IeeeSgeChain64_t)&mpi_request->SGL;
	/*
	 * For NVMe the chain element needs to be the 2nd SG entry in the main
	 * message.
	 */
	main_chain_element =3D (Mpi25IeeeSgeChain64_t *)
		((u8 *)main_chain_element + sizeof(MPI25_IEEE_SGE_CHAIN64));
	...
}

2. _base_build_sg_ieee() and _base_build_sg() write two SGEs starting at
&mpi_request->SGL (up to byte 128 for 16-byte IEEE SGEs, or byte 120 for
12-byte 64-bit MPI SGEs) when both data_out_sz and data_in_sz are non-zero:

drivers/scsi/mpt3sas/mpt3sas_base.c:_base_build_sg_ieee() {
	...
	if (data_out_sz && data_in_sz) {
		/* WRITE sgel first */
		sgl_flags =3D MPI2_IEEE_SGE_FLAGS_SIMPLE_ELEMENT |
		    MPI2_IEEE_SGE_FLAGS_SYSTEM_ADDR;
		_base_add_sg_single_ieee(psge, sgl_flags, 0, data_out_sz,
		    data_out_dma);

		/* incr sgel */
		psge +=3D ioc->sge_size_ieee;

		/* READ sgel last */
		sgl_flags |=3D MPI25_IEEE_SGE_FLAGS_END_OF_LIST;
		_base_add_sg_single_ieee(psge, sgl_flags, 0, data_in_sz,
		    data_in_dma);
	...
}

3. _ctl_diag_register_2() and _ctl_diag_read_buffer() populate a
128-byte Mpi2DiagBufferPostRequest_t in a frame from
mpt3sas_base_get_msg_frame():

drivers/scsi/mpt3sas/mpt3sas_ctl.c:_ctl_diag_register_2() {
	...
	for (i =3D 0; i < MPT3_PRODUCT_SPECIFIC_DWORDS; i++)
		mpi_request->ProductSpecific[i] =3D
			cpu_to_le32(ioc->product_specific[buffer_type][i]);
	...
}

Should this validate that ioc->request_sz is at least 128 bytes (ensuring at
least two SGE slots in the main message frame and covering
Mpi2DiagBufferPostRequest_t) while also guarding against u16 overflow in
facts->IOCRequestFrameSize * 4?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1793925772-1303-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D1

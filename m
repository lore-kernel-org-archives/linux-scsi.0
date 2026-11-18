Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794998772;
	b=M8EkNrqCVRIHqRgmsyUsCgwvQnvO2ePRKKoneFF9oPwbTQ0XC3prMv/I9EVkdgkW3dNs
	 X39xRLjvKnehkAOBgfGbSw+chOceoBz70xJjXLQcoFG2vtJSVV6slEIm1iCe34nNyzTQI
	 UZ7dDlVXJhFYN+gjYpelY1uTPL/F7LZjtN4WkyHUHc6faQznMWMsbumIwhWlE8KTLYO3S
	 Kuc0H3BPAJE+XFhdCL9kngOqf48eccJes11RHZFGKRYMM/hp2NQBQsV2hk0bFfmIrBW7i
	 mS7aot22G4c2C2vRbBGzCqJ9DL44BPEonLquRVI+piLLvufmsDtft1Uy9vNVaxIY7fQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794998772;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=9DhHBBTbAke3fE2KT4X1GSD3YzBYGdOEjz47PoOYh3c=;
	b=2AD8z47/c1H8qtBISLk83qyuNMIEAeYWdDwZua/qWbGc9GNUx2oXuYmddm2qCy+KQn57
	 q1g+ymZ15OBE/ab5smnqXiSYE543Se3GtMDN0///htegJ7P2XNVhstY5ePfFtm0logSQe
	 bupCAoVtwsnhCSwyCwmESJgBjwIyaUGBehjR/dGqW5VOMHZJBAku4dEh00my88+a751xo
	 zTutLDIc6laduZgaBs+2u/Vp/Vx0UDHJRhOaHS7CJpT/js1jTvdHk3YQEr+LQmuK2jjjC
	 P25Fp/CnJ6td+JM4FH6WcOgEMT1so5NWc1o8iEPwzGZrCKYltwHbVICEEQUb6G8uyMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dYIzbeOs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE9C606A334
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dYIzbeOs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E0741F000CB;
	Wed, 18 Nov 2026 10:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794998772;
	bh=9DhHBBTbAke3fE2KT4X1GSD3YzBYGdOEjz47PoOYh3c=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=dYIzbeOs78jzAMhV45lp3jJd6xANXutP8FJbALJZ+PEeE7fpKGN75vLC1DCNkuNgX
	 KKrvZdzrONpP3KlvkNixqNj8ZpGCctqa5wug+Dx2W6ggu9J8ISBr5VxJiPuQZTsxBt
	 O26d8S38kNDQsrWINfx0Zp2F7XgHs4FwqgDOP4EaKq8d06qppPKkTCcb3AaScTAGIQ
	 /l3aQM8h31IeiRkhGhbVMPD/2xcjXluDaeE224kUAxBc4Ox9FycjWT5NNsrvL2JySH
	 2b4TDrDXpU82OXMNfFpcRGB3dTxYVwnQL4L0rXPlZW7FXNCM9sgytq7G6W26u5+0d1
	 rwkjhZrmmOvhQ==
Message-ID: <sashiko-outbox-220742@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 26/37] scsi: mpt3sas: Enforce minimum reply frame
 size and validate chain segment size
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1794995806-5835-27-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1794995806-5835-27-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 10:46:06 +0000
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
- [Medium] scsi: mpt3sas: NextChainOffset check in
  _base_allocate_memory_pools() misses MPI 2.0
- [Low] scsi: mpt3sas: commit message names MPI2DefaultReply_t instead
  of Mpi2SCSIIOReply_t
--

commit b46a865c83daa42dd070e27d812f6e7261e3209a
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

scsi: mpt3sas: Enforce minimum reply frame size and validate chain segment =
size

This commit enforces a minimum firmware-reported reply frame size and
validates the chain segment size and SGE count per chain segment in
_base_allocate_memory_pools().

> In _base_allocate_memory_pools(), reject a firmware-reported ReplyFrameSi=
ze
> smaller than MPI2DefaultReply_t and validate IOCMaxChainSegmentSize to av=
oid
> integer overflow and out-of-bounds access during SGL construction.

[Severity: Low]
This isn't a bug, but the commit message says ReplyFrameSize is checked
against MPI2DefaultReply_t, whereas the code checks against
sizeof(Mpi2SCSIIOReply_t).

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/m=
pt3sas_base.c
> index dce8378f9347e..2f993dad91757 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
[ ... ]
> @@ -6422,6 +6450,13 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER=
 *ioc)
>  	/* now do the same for a chain buffer */
>  	max_sge_elements =3D ioc->chain_segment_sz - sge_size;
>  	ioc->max_sges_in_chain_message =3D max_sge_elements/sge_size;
> +	/* the SGE count is stored in the u8 NextChainOffset field */
> +	if (ioc->max_sges_in_chain_message > U8_MAX) {
> +		ioc_err(ioc,
> +			"too many SGEs per chain segment (%u), cannot safely attach\n",
> +			ioc->max_sges_in_chain_message);
> +		return -EINVAL;
> +	}

[Severity: Medium]
Can NextChainOffset still overflow on MPI 2.0 controllers even with this
check?

Storing the SGE count in NextChainOffset only applies to MPI 2.5/2.6 IEEE
SGLs in _base_build_sg_scmd_ieee().  For MPI 2.0 controllers,
ioc->chain_segment_sz is set to ioc->request_sz, and _base_build_sg_scmd()
computes NextChainOffset in 4-byte DWORDs rather than SGEs:

drivers/scsi/mpt3sas/mpt3sas_base.c:_base_build_sg_scmd() {
	...
		chain_offset =3D (sges_left =3D=3D sges_in_segment) ?
		    0 : (sges_in_segment * ioc->sge_size)/4;
		chain_length =3D sges_in_segment * ioc->sge_size;
		if (chain_offset) {
			chain_offset =3D chain_offset <<
			    MPI2_SGE_CHAIN_OFFSET_SHIFT;
			chain_length +=3D ioc->sge_size;
		}
		ioc->base_add_sg_single(sg_local, chain_flags | chain_offset |
		    chain_length, chain_dma);
	...
}

With 12-byte 64-bit SGEs (or 8-byte 32-bit SGEs), a
max_sges_in_chain_message between 86 and 255 passes the U8_MAX check, but
chain_offset exceeds 255 and shifts into the SGE Flags byte at bits 24..31,
corrupting the chain SGE descriptor.

In addition, mpi_request->ChainOffset in the main request frame is a u8
computed from ioc->request_sz in both _base_build_sg_scmd() (in DWORDs) and
_base_build_sg_scmd_ieee() (in SGEs), which is not bounded by the
chain_segment_sz check when ioc->request_sz is large.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1794995806-5835-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D26

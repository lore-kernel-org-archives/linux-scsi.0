Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793927556;
	b=LOB1QsAGd5i2u0n+R1EODkqglrDFBG31lz7C+iDhcMGstfboodTPC/7RkwlFzh3XAnyT
	 0qfUW+eg8fW+wgLdzSKBBkNQdJn8ZpkRcRORNbsdsDUClCKPTHmvPpJRWJNQGKJwFoJWB
	 aAtrnimEWMqnu6Y1y/epDGdXQx0yM80jqKvDnHxkhUdIKS8VjCJrMmXqfMxdaB9PRbWsB
	 cVO+D5YqG96vXAHIjZdEYieUnK+2pPjTW5+XIKdqpHPO38F8HPv6H7rB5J9UbkObfNhkX
	 9p0Ab5TN7X+HHG/EThy7k8wrkMEo8MRPOVJQ+ROza+aTVlAztb29oG/I1FL59FNcQCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793927556;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=DpTnHEK6+eXF0ju6p4zY5wXwO8IBOnUqaDPMt0c4zfw=;
	b=UmfWdTryxd5mCBKWeAGfOffOpWaaVNRJzf/k68u4lc302zU5T5DmRcuBIMR8EmMW8mCs
	 6wz/QcisL7VBuIzgNWShBWkmxPC1BfVaJiX/Ftd7m+qiE07rHnkR6QToNYmPMoJMBrgXk
	 qOnFYQADP9DAvLODZJemW0blFLNvRSHjJ/yLcomJwBj085UinBBY53rzl6egVXcm8lXUH
	 HwL+UGdgjtbamRyxpVkmxTW5poygv+00YesFKb6qBO4OWl4UqSBx2xgJA0M4ogeGY0ojg
	 8Buzlza+tSiD8n9iemiygbA3lr7XOmJOcNAhMiZ1VAPy/uoAgoJP2KHtAGTRkqP6nOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J72TYXfA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177AF606A328
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 01:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J72TYXfA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 799061F008A5;
	Fri,  6 Nov 2026 01:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793927555;
	bh=DpTnHEK6+eXF0ju6p4zY5wXwO8IBOnUqaDPMt0c4zfw=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=J72TYXfAqfS0Q9BwnvaE9MhOuTKDrs9W2KYwoCnMc76M50wPUGIBEm50msXfxjLm8
	 BUhgf8Gzc8XgsIFl+7/lx8ALxfnLp5Aocmn+N77HpR4xF+myGDT9KUqJ06VTwipumB
	 IBUN8mur2B209lItKYE3JxzvHTkz8hHSVk/Mq4Atzjx+1Q3ba7MbOXUKLsBX/7Y3Mc
	 O3i02lvrgp3UUb3HCkr6uQL1jijO6+RAlejxG2gwZhImQ0VRF0eXcDaXnFzLJG3Ol4
	 oz1+MOqCSsXQnyC4rYtfJ71bhJrmroTu+6KV+KSOUagFOw81PuJz+XTkKBXm4H3MSn
	 rfn+cFiBIHBgg==
Message-ID: <sashiko-outbox-200486@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 20/37] scsi: mpt3sas: Validate CurrentHostPageSize
 before using it as a shift amount
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1793925772-1303-21-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1793925772-1303-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1793925772-1303-21-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 01:12:35 +0000
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
- [Medium] scsi: mpt3sas: signed shift overflow and bad bound in _base_get_=
ioc_facts()
--

commit b31d1219a60f67ee63fd2b46be49926f2f8e49c3
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

scsi: mpt3sas: Validate CurrentHostPageSize before using it as a shift amou=
nt

This commit validates facts->CurrentHostPageSize read from the IOCFacts rep=
ly
in _base_get_ioc_facts() and falls back to MPT3SAS_HOST_PAGE_SIZE_4K if it =
is
outside the allowed range before computing ioc->page_size.

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/m=
pt3sas_base.c
> index 12295ab544ad5..3622d8a42725b 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -7532,8 +7532,15 @@ _base_get_ioc_facts(struct MPT3SAS_ADAPTER *ioc)
>  	facts->CurrentHostPageSize =3D mpi_reply.CurrentHostPageSize;
> =20
>  	/*
> -	 * Get the Page Size from IOC Facts. If it's 0, default to 4k.
> +	 * Get the Page Size from IOC Facts. If it's 0 or too large to be a
> +	 * valid shift amount, default to 4k.
>  	 */
> +	if ((facts->CurrentHostPageSize >=3D 32) ||
> +	    (facts->CurrentHostPageSize !=3D 0 && facts->CurrentHostPageSize < =
12)) {
> +		ioc_warn(ioc, "CurrentHostPageSize(%d) is invalid: Setting default hos=
t page size to 4k\n",
> +			 facts->CurrentHostPageSize);
> +		facts->CurrentHostPageSize =3D MPT3SAS_HOST_PAGE_SIZE_4K;
> +	}
>  	ioc->page_size =3D 1 << facts->CurrentHostPageSize;

[Severity: Medium]
Can facts->CurrentHostPageSize =3D=3D 31 still trigger a signed 32-bit shift
overflow here, and can values in 13..31 break downstream page_size consumer=
s?

Because the left operand of 1 << facts->CurrentHostPageSize is a signed 32-=
bit
int literal (rather than 1U or BIT()), a value of 31 passes the >=3D 32 che=
ck
and shifts 1 into the sign bit, which is undefined behavior in C and still
triggers UBSAN shift-out-of-bounds.

In addition, _base_send_ioc_init() always programs the controller for a 4 K=
iB
host page size:

drivers/scsi/mpt3sas/mpt3sas_base.c:_base_send_ioc_init() {
	...
	mpi_request.HostPageSize =3D MPT3SAS_HOST_PAGE_SIZE_4K;
	...
}

Allowing CurrentHostPageSize values up to 31 produces ioc->page_size values=
 up
to 0x80000000U (2 GiB). During probe in _base_allocate_memory_pools(), this
can overflow 32-bit pool sizing arithmetic and cause
_base_allocate_pcie_sgl_pool() to fail in dma_pool_create() with -ENOMEM
instead of falling back to 4 KiB:

drivers/scsi/mpt3sas/mpt3sas_base.c:_base_allocate_memory_pools() {
	...
		sz =3D nvme_blocks_needed * ioc->page_size;
		rc =3D _base_allocate_pcie_sgl_pool(ioc, sz);
		if (rc =3D=3D -ENOMEM)
			return -ENOMEM;
		else if (rc =3D=3D -EAGAIN)
			goto try_32bit_dma;
		total_sz +=3D sz * ioc->scsiio_depth;
	...
}

If a controller reset via
mpt3sas_base_hard_reset_handler()->_base_get_ioc_facts() updates
ioc->page_size to 0x80000000U after pools are already allocated,
base_make_prp_nvme() subtracts u32 nvme_pg_size (ioc->page_size) from signed
int data_len and sge_len:

drivers/scsi/mpt3sas/mpt3sas_base.c:base_make_prp_nvme() {
	...
		sge_addr +=3D nvme_pg_size;
		sge_len -=3D nvme_pg_size;
		data_len -=3D nvme_pg_size;

		if (data_len <=3D 0)
			break;
	...
}

When nvme_pg_size is 0x80000000U, subtracting it wraps negative signed 32-b=
it
values back to positive, which can walk sg_next(sg_scmd) past the end of the
scatterlist and overrun the 4 KiB pcie_sgl DMA buffer.

Should this use 1U << facts->CurrentHostPageSize (or BIT()) and restrict
CurrentHostPageSize to MPT3SAS_HOST_PAGE_SIZE_4K (or a safe upper bound that
cannot overflow DMA pool and NVMe PRP calculations)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1793925772-1303-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D20

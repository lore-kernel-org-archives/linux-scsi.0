Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793927850;
	b=cjkpsY5WNw63DYN2+NuhEPQ1eqq2wqINWWmW0ZCL4vs+GyCiM9gai2EIC1ylPPfgyzCD
	 W5tsCiRm3rhS91fFp8qTyTBOJ1na1SDaVeXW6aQ4q4uNeS+Nn+5Fp2de8WX5u0vZGzPQi
	 285/vgzrhIxfZzJdqNz7zF02CfbrtsentPGWGy4NF9WWaFdZcKcnXGI8E07Dqorh2lclw
	 f2GjCohJsfKrzocK69kkunkzsNBwboc2XLom9KkDXS1MGzuG37KSKmoofrcxmAtVBI3hi
	 06+hnYTrguGT/5bbX8Ncvuk7M8jJMQZ3MoIxHKFg3pzywgKYax610po/H0ujUznCo1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793927850;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=XQZoDasU8RFEBJ3yfXOEOcuOZg8rBfbXi1pZ/QrxbMw=;
	b=NmwdO0pvqnXaB8KWCJ6gDLWNtKJ/qrjCIr7m/cUu78uXsLSSdKSNGOFLQILUzwZYOdPW
	 xosnxZmNF8CuZ6aEV7ZboLMLA8HGpl8vgob69CV/2rvk3IbIt88ucNLh6hLMt4Tut8y0J
	 rZmcX0ujXrme7avR0d2Ks5HfysoiYnbKbAex+0h6qTC6klh+UbOSg7ah52/ydkfwO0/DZ
	 LEBWI3gOHXdw0Zj9n4zgsMF3dpU4H2+pvJVuXOB5QjKpEDqUjrWtlLN05FMEbB6blY6tN
	 LNlqErj+chtsGjSvVcsv7QrCe66kB/knBaj4g2upm8j0wb/hLdAf0bwjrwFHGuq2TYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EyRo++8w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4457F606A329
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 01:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EyRo++8w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03DC01F008A1;
	Fri,  6 Nov 2026 01:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793927850;
	bh=XQZoDasU8RFEBJ3yfXOEOcuOZg8rBfbXi1pZ/QrxbMw=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=EyRo++8wWIr77VavJiffCcFdqYv5h4Oa4+bB4z3Rj6fhPY09hPmtXT7TrsF5f04ww
	 ByXl+f9kSBLQIkm3fHXC58Z1b+8rsBfE2Kw1AHX6Y+aOKxsLPK7gk8ocP9ZyA3E/sd
	 kxx09ap7/3ETSD4UF2qjwQuJKhBTMjsCOqZYJY+xgYs+3401Z5ItIxmqgWA2Lz9HBR
	 wsdd+2C4qhjVDYmRlxFyfWrm2aQkqgDqklcoskChUsOO9MAaG+HFcGinnsg0tp7Bc0
	 qecJryd8v158kjzjORQ8qXEJC6n22N6vIM2VJKVOQemBwcEEiz3z7Od2PnzTlslkXw
	 83Jl/y2H9u4GQ==
Message-ID: <sashiko-outbox-200501@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 19/37] scsi: mpt3sas: Reject implausibly small
 MaxReplyDescriptorPostQueueDepth
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1793925772-1303-20-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1793925772-1303-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1793925772-1303-20-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 01:17:29 +0000
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
- [High] scsi: mpt3sas: scsiio_depth underflow in _base_allocate_memory_poo=
ls()
--

commit 3982113aa57710616a39847fb5922b95a8b805cf
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

scsi: mpt3sas: Reject implausibly small MaxReplyDescriptorPostQueueDepth

This commit adds a minimum bound check on MaxReplyDescriptorPostQueueDepth =
in
_base_allocate_memory_pools() to prevent an unsigned underflow when computi=
ng
ioc->hba_queue_depth.

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/m=
pt3sas_base.c
> index 4e2cee2e13fc2..12295ab544ad5 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -6452,6 +6452,13 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER=
 *ioc)
>  				(ioc->reply_post_queue_depth % 16);
>  	}
> =20
> +	if (facts->MaxReplyDescriptorPostQueueDepth <
> +	    MPT3SAS_MIN_REPLY_POST_QUEUE_DEPTH) {
> +		ioc_err(ioc, "MaxReplyDescriptorPostQueueDepth is too small (%u)\n",
> +			facts->MaxReplyDescriptorPostQueueDepth);
> +		return -EINVAL;
> +	}
> +
>  	if (ioc->reply_post_queue_depth >
>  	    facts->MaxReplyDescriptorPostQueueDepth) {
>  		ioc->reply_post_queue_depth =3D
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/m=
pt3sas_base.h
> index 47255bf9cdda1..192b8e8a5b4d4 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.h
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
> @@ -145,6 +145,15 @@
>  #define MPT_MAX_HBA_NUM_PHYS		32
> =20
>  #define INTERNAL_CMDS_COUNT		10	/* reserved cmds */
> +
> +/*
> + * Minimum reply post queue depth for hba_queue_depth to stay non-negati=
ve.
> + * Values 66-79 floor to 64 after 16-alignment, making ((64-64)/2)-1 =3D=
 -1
> + * which wraps to 65535 as u16. The smallest value whose aligned floor e=
xceeds
> + * 64 is 80 (80 % 16 =3D=3D 0, giving ((80-64)/2)-1 =3D=3D 7).
> + */
> +#define MPT3SAS_MIN_REPLY_POST_QUEUE_DEPTH	80

[Severity: High]
Does a minimum of 80 for MPT3SAS_MIN_REPLY_POST_QUEUE_DEPTH still leave
ioc->scsiio_depth and ioc->shost->can_queue vulnerable to underflow in
_base_allocate_memory_pools()?

Earlier in _base_allocate_memory_pools(), ioc->internal_depth and
ioc->hi_priority_depth are initialized as:

	ioc->internal_depth =3D min_t(int, (facts->HighPriorityCredit + (5)),
		(facts->RequestCredit / 4));
	if (ioc->internal_depth < INTERNAL_CMDS_COUNT) {
		...
		ioc->internal_depth =3D 10;
	}

	ioc->hi_priority_depth =3D ioc->internal_depth - (5);

So ioc->internal_depth is at least 10 and ioc->hi_priority_depth is at least
5 (and both can be larger when facts->HighPriorityCredit > 5).

When facts->MaxReplyDescriptorPostQueueDepth is between 80 and 95, it passes
the MPT3SAS_MIN_REPLY_POST_QUEUE_DEPTH check and clamps ioc->hba_queue_depth
to 7:

	if (ioc->reply_post_queue_depth >
	    facts->MaxReplyDescriptorPostQueueDepth) {
		ioc->reply_post_queue_depth =3D
				facts->MaxReplyDescriptorPostQueueDepth -
		    (facts->MaxReplyDescriptorPostQueueDepth % 16);
		ioc->hba_queue_depth =3D
				((ioc->reply_post_queue_depth - 64) / 2) - 1;
		ioc->reply_free_queue_depth =3D ioc->hba_queue_depth + 64;
	}

Later in _base_allocate_memory_pools(), ioc->hi_priority_depth and
ioc->internal_depth are subtracted from ioc->hba_queue_depth:

	ioc->scsiio_depth =3D ioc->hba_queue_depth -
	    ioc->hi_priority_depth - ioc->internal_depth;

	/* set the scsi host can_queue depth
	 * with some internal commands that could be outstanding
	 */
	ioc->shost->can_queue =3D ioc->scsiio_depth - INTERNAL_SCSIIO_CMDS_COUNT;

With ioc->hba_queue_depth =3D=3D 7, subtracting ioc->hi_priority_depth (>=
=3D 5) and
ioc->internal_depth (>=3D 10) underflows the u16 ioc->scsiio_depth to at mo=
st
65528, setting ioc->shost->can_queue to 65525 and sizing the request and
lookup allocations for ~65k entries. Similarly, if
facts->MaxReplyDescriptorPostQueueDepth is in 96..111, ioc->hba_queue_depth
becomes 15, which yields ioc->scsiio_depth =3D=3D 0 and a negative
ioc->shost->can_queue of -3 (or underflows ioc->scsiio_depth if
ioc->internal_depth > 10).

Should _base_allocate_memory_pools() also verify that the resulting
ioc->hba_queue_depth is greater than ioc->hi_priority_depth +
ioc->internal_depth + INTERNAL_SCSIIO_CMDS_COUNT?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1793925772-1303-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D19

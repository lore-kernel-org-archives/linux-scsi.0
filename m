Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794997672;
	b=pMr07+zUYkdSUX/b5/MJ4GbjExEqmHeQC74t95Ih0H+9Lk12Gvp+La1dtDQSnyKLNS1+
	 EFbyonTNyA5PVtxS3BWkHD/euYgI8qqA70PYX3k1eseia6sft5rlW7wS6koDlRgnN5WPs
	 fvdFFaRxZQnVpwT6tcNv3fFTsTa7qxz04gyuJrnDYfDdF6pFGvDwCiG1+4RFjREsdgmsn
	 HVHSN0xuIvYOPTYBUEHZN76mhNV9/FeGhlTBzFC3ySPP4OW/def8LfiwQJZVCqbnZ62I1
	 1VI0SBk/WzLw3caM0w0vqZmPo+JGhPA6ehaleeniE/xH/Lf6NzqfPBNq2qxo6M2x67A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794997672;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=HL+VwUdBrtIgoMuvrNB0+kWXOrNxaP/zUB0IC7pF9QA=;
	b=qJzB7cvU4ppv7CbvNKW7SVm4bIiPMjfg8SbkNwS4g3aMHQNJhB6OGuCv6GBq//IuznGl
	 3stX9/NaQyK5TWmdL9HAB3Hs89dE5PsA1qN29uQIoivKchEqOI/YCbX13m2MzThW4g4Mf
	 ebttXOZnEg415l+UzwdrBILQj4wV4bPEiYa2UcHiki2ZwaEkUDCw3wm9Wb61/Zv5GD5tk
	 Axr/S+JE7ru0rPLl0SxLIPAJvRcnaDM9I8gxtcTh9KnWzFBuGttMG48vlZPtfx0ipPWW2
	 0qgFnT35TMBNZdhbJNR5M1xTnj8auKlp6l3CjUx6qGY22xF0YIA63FY5KrQ7XWUV9SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NyXenMZZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF2A606A33B
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NyXenMZZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F7701F000C4;
	Wed, 18 Nov 2026 10:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794997672;
	bh=HL+VwUdBrtIgoMuvrNB0+kWXOrNxaP/zUB0IC7pF9QA=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=NyXenMZZ4Zdg3b+93LCUnb5iSgePO4eKiWXvrZiI4C6+qhLBSBXM6NIld1LbWeFuL
	 haM7WyKjPEq7caQF0hSq3dhoWEB9aoe/k4JcT9OP+S36IKh45sXY7GFBHMKAhO1I7+
	 2WkBw7vYX4z53c7+sprAsjfEUNyu+S8RwwScBOCCEOEDj2TMTjrJSC9qgoTtOsf1lo
	 UOBbv4GPwdyio/Ue5MibDfFcZxlmUscgKU2egagTZ9qFGNjNGYPl9rkhW/3mdT5/xm
	 +DnGV1u5IB9a05jKOvIfG5qq+jC6/6DEXd2kb2EhWxbU61r1DnT6gwcMHVkKZ8irLo
	 RZ/K2+lBl/bUQ==
Message-ID: <sashiko-outbox-220690@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 10/37] scsi: mpt3sas: NULL ioc->reply_post after
 freeing it
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1794995806-5835-11-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1794995806-5835-11-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 10:27:51 +0000
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
- [Low] scsi: mpt3sas: missing Fixes trailer for commit 9b05c91ae7fb
--

commit 956a2d8532f74a3ece3dfc96d7c47ac51d5013d8
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

> scsi: mpt3sas: NULL ioc->reply_post after freeing it
>
> Match the pattern used for other pool pointers in
> _base_release_memory_pools() so a repeat call can't reuse it.
>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>

[Severity: Low]
When _base_allocate_memory_pools() calls _base_release_memory_pools() on
a retry path and then fails, mpt3sas_base_attach() calls
_base_release_memory_pools() a second time and would otherwise
dereference and double free ioc->reply_post.  Should this include:

  Fixes: 9b05c91ae7fb ("mpt3sas: Added Reply Descriptor Post Queue (RDPQ) A=
rray support")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1794995806-5835-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D10

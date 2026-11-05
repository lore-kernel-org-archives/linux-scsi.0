Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793899947;
	b=0UzeAUE2hMU6YzaHSsmSKsCuSWj/UNPkSXjnGUkvwmUQtlDGdSDlo0BrNJxvuJBbKTU3
	 j/RAz47pV8AhuCmo5xhdwo2UfooKEVGsBWoLGDM9fU72X2SGEkWvo5IIGGl3lHebWtVhe
	 cqc71EigjOmxBFl5t1UpxhxvrHnhq9sgQmXHR33CT/vHE9A/G3RBZPUvIB9aK6isAzCZQ
	 zdfaVhDBNfhUzYj/Qyg+VIKzNvK1I/J5+/lhUqA6xmFPVUHN8fTeyZWXeDkYiCNpYOqAB
	 pIkh+lAE1T0M4ugROwioTnwvN4YZFwZ2HmvZC52VmBo4XkILuc/wyk/tdsFcPWbebAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793899947;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=lp0NGZovHOZFgM8Bydql0MxHwiduWzL/2fD0i5iRoF0=;
	b=OmZdNsmZYzh2ErVOU3IRFnD5Ygi5/ubiVUEUGp1dRpaii9GdRubadkNpkg/OI1DfzA8C
	 3KihSIn0TLsGPpfGudEFxYSvQL6T8++AEso48XQ9tQ+HkJHiMpCPeO55w+wXUs8jFc2Qc
	 ERvr7+ycS+dnXJ9NYPDzsjzjSRXsinkW2Z9upEuooJV6NmsbtrMys+r6y0/JIA0qRjX7X
	 +rfcQm37M1VNtfouxTUP+YCr0QvpdyCWbjYXC1puVqNyvX4wO170w+NTFcnxexJra5yet
	 fmRlXPDueNrHByb96HdIQg427HQc9lLYaykn+THnAZyjVVrDzJQTnBkr71wVwlK73Jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S5naOIGa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDE8606A328;
	Thu,  5 Nov 2026 17:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S5naOIGa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE191F000C1;
	Thu,  5 Nov 2026 17:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793899947;
	bh=lp0NGZovHOZFgM8Bydql0MxHwiduWzL/2fD0i5iRoF0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=S5naOIGaaD2J0fiVVP8ceihDTb/hSIh1mWM1o667RDtp6/+xObpwQBZ19kvzL/RkW
	 qJvNF0ER9qNGrIGt7dLJ8x/P/cPn9xBkYktmFMHojSuE9woerIFFDaHcQW0MY91/Zt
	 uzfrlmSm6xgmbxCPVVyF8RZniWRputBS3ZZlAjIS3fzwDrg3H1Bd76xqI+1ADuFZ0D
	 eZYLdlYiVzSAb9SZLJWFL1IQn60UG2llt4BhU+PNWCj8KdMvnyGTGREglZHswG+uFI
	 3SzLukV9JdXhlkAxIcVYaMvYsREHcqd99Y0a+HKQjx0+uDjQb9hSTqShILpb0d33sD
	 Q5pyDXzzvOK9w==
Message-ID: <sashiko-outbox-199628@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/3] treewide: Use offsetofp()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bence Csokas" <bence.csokas@arm.com>
Cc: linux-rdma@vger.kernel.org, bpf@vger.kernel.org, linux-security-module@vger.kernel.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, linux-hyperv@vger.kernel.org, linux-scsi@vger.kernel.org, linux-sound@vger.kernel.org, media-ci@linuxtv.org
In-Reply-To: <20261105-offsetof-v1-3-4153f5c10edc@arm.com>
References: <20261105-offsetof-v1-0-4153f5c10edc@arm.com>
 <20261105-offsetof-v1-3-4153f5c10edc@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 17:32:26 +0000
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
- [Low] treewide: offsetofp() duplicates existing struct_offset() helper
--

commit d78220885af6984fafc359340778dba58aea1b73
Author: Bence Csokas <bence.csokas@arm.com>

treewide: Use offsetofp()

This commit converts treewide uses of offsetof(typeof(*ptr), member) to the
newly introduced offsetofp(ptr, member) macro via Coccinelle.

> diff --git a/drivers/dma-buf/dma-resv.c b/drivers/dma-buf/dma-resv.c
> index 2365a6d8ca15f..83c204458d409 100644
> --- a/drivers/dma-buf/dma-resv.c
> +++ b/drivers/dma-buf/dma-resv.c
> @@ -108,7 +108,7 @@ static struct dma_resv_list *dma_resv_list_alloc(unsi=
gned int max_fences)
>  		return NULL;
> =20
>  	/* Given the resulting bucket size, recalculated max_fences. */
> -	list->max_fences =3D (size - offsetof(typeof(*list), table)) /
> +	list->max_fences =3D (size - offsetofp(list, table)) /
>  		sizeof(*list->table);

[Severity: Low]
This isn't a bug, but include/linux/overflow.h already provides
struct_offset() with the exact same definition (introduced in commit
f6ed9c5d3190 ("overflow: Introduce struct_offset() to get offset of
member")):

    #define struct_offset(p, member) (offsetof(typeof(*(p)), member))

While include/linux/stddef.h now defines:

    #define offsetofp(P, MEMBER) offsetof(typeof(*(P)), MEMBER)

For example, dma_resv_list_alloc() in drivers/dma-buf/dma-resv.c already
uses struct_size(list, table, max_fences) from include/linux/overflow.h just
a few lines above.

Could these conversions across the 39 modified files reuse struct_offset(),
or should struct_offset() and offsetofp() be consolidated instead of keeping
two identical macros?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-offsetof-v=
1-0-4153f5c10edc@arm.com?part=3D3

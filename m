Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795003653;
	b=1uft6ogYZZf2dsFm615K0YykDTPet0BigASLQhV5fjllg6g1aiabPoB1VDTIV92+W/eX
	 Btf/WCmPJY42jat0XjZCs0/ff1UKGw4XZ8+aq/YAi5Emhp70YQjCBG6w6W2pSypkTqSE3
	 TyJTWHzaOXhfDGMU6wGLB6fn2ACTeg2KV2EaqvkeQAsQRg4zpYK3cQQ3hEUQg3aV3apd9
	 /Zyi5CN0YFVHgOh7fmOvCMUMnlSPacTxursNTf8blmnOeC7baROOTNkAKNEHJ+jNeic/H
	 S9Qb01DknM+e5wzP2Dc84Nx4SHQsnPdgCfHnP7ADzZX7cgeiTl/s/ICOYl6AUGSp7Dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795003653;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=TrVpSbuxTvABMzXsIM2kgbpc7Uu8nxzZKXRdWBcBCd8=;
	b=yDhiA0ICa2hL2v7WOMWdzOKrROOjdT8Dzb4QjXanfjLhH9W2o6NL3Cl0tc3s+EhZ7Zdt
	 1r66wygsrJhPH7SXhgQFPfFjGZqfQ3la7L7SokVbOvPELvGnf0DNTXpbbAh2C5Ednhp2g
	 asmB4ljeU2po8MlgPVMkqR87Ke87LcXFV1jQhUBDHhe4uQe1wKH6vdJI6u0SdnlwdVS2h
	 /lhqJ4RnvwXwPHenT1L+odgF+36AXTZeBi/g1v1rqJ2b5yaKg71pVlkwpYMobUARwjR6z
	 u1lN/iLT7ff4B+XRFd13et/H4EanvdyK4u4tOQ496Nmf9FLRHkTNJsCgdX0qdUYWy4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h8VjTIFs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E37A606C39C;
	Wed, 18 Nov 2026 12:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h8VjTIFs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093BD1F000C5;
	Wed, 18 Nov 2026 12:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795003652;
	bh=TrVpSbuxTvABMzXsIM2kgbpc7Uu8nxzZKXRdWBcBCd8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=h8VjTIFsCUB/EpHOkH4qUs/GoCsirEPVJD6AP20cS9vUJ7MLK9giCoFxIsCI/4m+v
	 HaWoHsexGNqYWzw2DytzdYAgcC4KJK6J93WL0diLEbdimdjzR3gelRsGSz5sANO9Uv
	 FYYw4vtwDTaEMaxwTpTZkkEdH91fn7bSMhtDGlRE2NOhJUvHCiLOZom5XhRhqIpskf
	 YIlS6G+VLXycYbwHq9rwp92Z4kiJyMVaqLkqM7Ev+FauCPgDVKZzmwuhheGEGeKmUG
	 ySNn5LhF1SPW8Y+vidvzjW3Caj90hMh68BGm5SjVT/9WKsPNA1mF+hbG9y7yo3XJ9C
	 7hI/KAEQWTtnA==
Message-ID: <sashiko-outbox-220875@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 1/2] overflow: Add offsetofend() variant of
 struct_offset()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bence Csokas" <bence.csokas@arm.com>
Cc: dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org, linux-scsi@vger.kernel.org, bpf@vger.kernel.org, linux-security-module@vger.kernel.org, linux-sound@vger.kernel.org, media-ci@linuxtv.org
In-Reply-To: <20261118-offsetof-v4-1-95b385c10b22@arm.com>
References: <20261118-offsetof-v4-0-95b385c10b22@arm.com>
 <20261118-offsetof-v4-1-95b385c10b22@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 12:07:31 +0000
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
- [Low] coccinelle: struct_offsetof.cocci requires parentheses around
  ptr
--

commit bd704e7223e04b0fb7bb740d9f758d180e12c2d8
Author: Bence Csokas <bence.csokas@arm.com>

overflow: Add offsetofend() variant of struct_offset()

This commit adds the struct_offsetofend() helper macro and a Coccinelle
semantic patch to convert offsetof(typeof(*ptr), member) and
offsetofend(typeof(*ptr), member) calls.

> diff --git a/scripts/coccinelle/api/struct_offsetof.cocci b/scripts/cocci=
nelle/api/struct_offsetof.cocci
> new file mode 100644
> index 0000000000000..5a30647d37872
> --- /dev/null
> +++ b/scripts/coccinelle/api/struct_offsetof.cocci
> @@ -0,0 +1,18 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/// Use struct_offset() family of macros
> +///
> +// Confidence: High
> +// Options: --no-includes --ignore ./tools/
> +
> +virtual patch
> +
> +@offsetof depends on patch@
> +expression ptr, member;
> +@@
> +- offsetof(typeof(*(ptr)), member)
> ++ struct_offset(ptr, member)
> +@offsetofend depends on patch@
> +expression ptr, member;
> +@@
> +- offsetofend(typeof(*(ptr)), member)
> ++ struct_offsetofend(ptr, member)

[Severity: Low]
Do the inner parentheses in typeof(*(ptr)) prevent these rules from
matching unparenthesized typeof(*ptr) call sites?

In Coccinelle, the paren isomorphism expands E to (E) in one direction,
so matching typeof(*(ptr)) requires explicit parentheses around ptr in
the C source.  Writing typeof(*ptr) matches both typeof(*ptr) and
typeof(*(ptr)).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118-offsetof-v=
4-0-95b385c10b22@arm.com?part=3D1

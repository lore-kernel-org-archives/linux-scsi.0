Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794672563;
	b=faeNdxZTxLNqcP9ghoAHauxNB4RvnhkDryAkzSp93f57mFCThLtjC1o+Mkq8Vj8vCOJK
	 gKo53cmnU5Oy7fkCklgIG7SRa8m8dge693BIRRzeN0zcMrIylSHfcRTvuVLhkIq+jnOkr
	 SfEE0uhHpGt/i+IHGfqptPX/ImpaZRproEAtVHCF3UHb3ql+CmrP9UOYuSSBp3rLTpL2x
	 48togeWlrgwzv5zHJZHZCzGCj1GYIoMS/qoZSF5N2jtX/Q4a18e0bCWPKhLyRutAVLM1+
	 VIzto3p0Yul5ABGgf3haVKVzwdZOupzsXhPStgw+1qffGWeQ73pbV3ZmxWydh7r4GOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794672563;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=g2mwoviM3gWZDsBgYq6cZVNpjcLJdB0d4Fk6H1RcDHY=;
	b=1VLsdIhksdezJzQN6VHCPj3uDBtnw3WpgVoYgdsqA7zAZcY7vi0cSKJD5MFLWozbMIp6
	 53cHsu0ZwXaoXMl1gwQnlDLZET8hyktwXLdlIw8Znx6Rc5HieCrawjcMymC1o1saTeQCw
	 iCbdkZQreULoRMREeYEGmyqpJKJ55rcEFJQH7uVZv1StCT6VdMkKva9LC+UibQeMVRf/W
	 D5Z/BJf+5eNt/42YYwqqKy2WAFnW7w1X/UZxH74o1vuZ8x3asWAv6Lugc7V7cOLosWuVI
	 fUR/MsjeRoy1WIxEjnaq5tbY1O6THs4yw3zBpd539w+4kUHgSZmsXbuokYi5AOX4Fgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bg6k+3qH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBC1606A323;
	Sat, 14 Nov 2026 16:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bg6k+3qH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823BE1F000C4;
	Sat, 14 Nov 2026 16:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794672562;
	bh=g2mwoviM3gWZDsBgYq6cZVNpjcLJdB0d4Fk6H1RcDHY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Bg6k+3qHXBlLMrYh4GUg3XfgETcgAtGlji0dQqvLgA6j3n5MFqgfVDEP+n5bD/EJk
	 8V8feVaVyqAMNBde/Hl0keLqm2WtO/yqfxAjNbgtGV6CUutaPwVBOrz2bAdxD158f1
	 UOzxUuwdDRyYBpLv1dhQcAKeURpFwCXJ6oa10GG0kGJAW1Tby9vRNNQ6DfUc60mHJ8
	 7H/lOKluSRBaFzh5oLKJ29wrlGRyAq6MsWk8ca7pfSoMJvAubSJVxsDJe1TgE5t5gM
	 r80zeltItkwuqHKMASZEOTKS28d0jge440Jlwnxz215llHPiOwyS3i/i9E1KZe4XIQ
	 ofDy67AOvWqGA==
Message-ID: <sashiko-outbox-214737@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/2] overflow: Add offsetofend() variant of
 struct_offset()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bence Csokas" <bence.csokas@arm.com>
Cc: dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org, linux-scsi@vger.kernel.org, media-ci@linuxtv.org
In-Reply-To: <20261113-offsetof-v3-1-714df7053893@arm.com>
References: <20261113-offsetof-v3-0-714df7053893@arm.com>
 <20261113-offsetof-v3-1-714df7053893@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 16:09:22 +0000
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
- [Low] coccinelle: struct_offsetof.cocci lacks virtual mode
  declarations and guards
- [Low] coccinelle: struct_offsetof.cocci lacks tools/ and overflow.h
  exclusions
--

commit c626ce371da764dd2d49c4588f1e87be178e9327
Author: Bence Csokas <bence.csokas@arm.com>

overflow: Add offsetofend() variant of struct_offset()

This commit adds a struct_offsetofend() helper macro to
include/linux/overflow.h and a Coccinelle semantic patch to convert
offsetof() and offsetofend() calls using typeof(*ptr).

> diff --git a/scripts/coccinelle/api/struct_offsetof.cocci b/scripts/cocci=
nelle/api/struct_offsetof.cocci
> new file mode 100644
> index 0000000000000..6cbc5596d673d
> --- /dev/null
> +++ b/scripts/coccinelle/api/struct_offsetof.cocci
> @@ -0,0 +1,14 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/// Use struct_offsetof() family of macros
> +///
> +// Confidence: High
> +@@
> +expression ptr, member;
> +@@
> +- offsetof(typeof(*ptr), member)
> ++ struct_offset(ptr, member)

[Severity: Low]
Does struct_offsetof.cocci need virtual mode declarations and mode guards
on its rules?

scripts/coccicheck checks each script for "virtual $MODE" before running
spatch, so without declarations such as "virtual patch", make coccicheck
skips this file with a warning in every mode.  When invoked directly with
COCCI=3Dscripts/coccinelle/api/struct_offsetof.cocci, the unguarded patch
rules also produce no output in the default report mode and emit raw
replacement diffs in context mode.

> +@@
> +expression ptr, member;
> +@@
> +- offsetofend(typeof(*ptr), member)
> ++ struct_offsetofend(ptr, member)

[Severity: Low]
Will applying these rules across the tree break builds under tools/ or
rewrite the macro definitions in include/linux/overflow.h?

tools/include/linux/overflow.h does not define struct_offset() or
struct_offsetofend(), so converting matches in files such as
tools/perf/util/header.c and
tools/testing/selftests/bpf/progs/test_cls_redirect.c introduces calls to
undeclared macros unless tools/ and samples/ are excluded via rule
dependencies like other scripts in scripts/coccinelle/api/.  Running spatch
with --include-headers or on include/linux/overflow.h also rewrites the
struct_offset() and struct_offsetofend() definitions themselves into
recursive self-references.

In addition, matching typeof(*ptr) instead of typeof(*(ptr)) leaves
redundant parentheses on parenthesized expressions such as
offsetof(typeof(*(reg)), iobase_addr) in drivers/scsi/qla2xxx/qla_tmpl.c,
and the "///" header comment names a nonexistent struct_offsetof() macro.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-offsetof-v=
3-0-714df7053893@arm.com?part=3D1

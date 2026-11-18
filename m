Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794997996;
	b=GwYtuT297SpLGOWl+OlW+2HXDQ1DuFM9f1SNf+icXT5iRUqajjERWkb/5l6krSB5kHgf
	 RWcrBiOCQv2Jp7RhDN6aFlZrOi9euB+zKfehbSCVn1BDBIg2MTvogXzNbswqh9Hc0GPeP
	 Y4xKH0el27hy5BxF0Z0PQHXw8NnXcghK4vgqJhAxUxWw/gsEFnDKeHPTErJ6cEOv4NlH8
	 KUT9C6ORfCTs8H487DGMl17UkYeSXzndP+z75WViTcdy6AIo39BNEd/Zqc5vqFSqNbiO/
	 VCzDjieOcrT5caItdu9a12xvzw8xkz2IlF94iyCsegwAUFzTT6+fGDMiHC/rutNhmRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794997996;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=lzjGu4v7BHbR0wp60M+BYr2iyC7QLJnbiBb8vFKd2QQ=;
	b=G5uARuVLijZekl36elz+xRl6WEQANkFHm+Asq242X4aOsksV/67rGO8ctIm/6BCc2VWw
	 FYszCHH6tB8ntbDknfiThZDpLy5mzL4ZSAD0uddRmT0B+f3wgvGSXQdx+IKxnqCA35evs
	 MiVBpotITp7NEL8eeXTxTW4x94W/BfGHjaHpiD4ur/xa1WAAKnx13+hbjIOkP8K/NHiBy
	 kglUGn07ZMMjjzQZLBbHOwVWJRnMHM+NVlsvAVH2tIeqJerUDrHm8//MyxZPyfW0PVgza
	 4ez4L5FocyujKFJgGVOME0RtnBPrTjPoHyAApcsP0B15t7KMmz+AA3BNBBKRu7ZJ55Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dn0cHJG3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B4F606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dn0cHJG3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EAEE1F000C4;
	Wed, 18 Nov 2026 10:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794997996;
	bh=lzjGu4v7BHbR0wp60M+BYr2iyC7QLJnbiBb8vFKd2QQ=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=dn0cHJG3AiAN2oQNfEK5PFhrqEtlK9gccQh0AiWLUC20uVPzFyqoAEZWbISEqMopg
	 mCMLpFmpLmGxB98uUrsbRkYQAOYBIJJ9F4ciY69Um5UBhNVXuflEUmYQZMzy1fo3h5
	 K0bmGzartWEnnXIfabYbf4IMwVPjxQYNzB/e4LIOFUpgp/CrE6AcHB2+1HtfOs11ch
	 of2fLRnvFK7H94BKsQEbyPl1plMFr80l/LALsh1/tTrKiMHNHKSjnDFCqVDQI1C0E/
	 BR7/iRNEIy/lCCzjiM3YhiOPcYkzWZQf5yIiN8G5pCJ9SLg6H3D1aSPh8wK0yZ0Cgl
	 LrH8kNLeYogOg==
Message-ID: <sashiko-outbox-220703@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 20/37] scsi: mpt3sas: Validate CurrentHostPageSize
 before using it as a shift amount
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1794995806-5835-21-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1794995806-5835-21-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 10:33:15 +0000
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
- [Low] scsi: mpt3sas: missing Fixes trailer for _base_get_ioc_facts()
  shift fix
--

commit 397af194b8267f2475a201fdc3150680a1b5ba71
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

> scsi: mpt3sas: Validate CurrentHostPageSize before using it as a shift am=
ount
>
> Reject an out-of-range CurrentHostPageSize instead of using it
> directly as a shift amount.
>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>

[Severity: Low]
Since this fixes the unvalidated shift of facts->CurrentHostPageSize in
_base_get_ioc_facts(), should it include a Fixes tag?

  Fixes: 016d5c35e278 ("scsi: mpt3sas: SGL to PRP Translation for I/Os to N=
VMe devices")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1794995806-5835-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D20

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794997782;
	b=TxpU0zgnR+ii5b506aLGlGzex2nXFuWh7HXx7VzQ5dRMoRvq/j/JWmBefDAOj4pkAwWS
	 +C7Q3Od+GZP2bqo2481AcIm7LulQsc9n/speodIHN/SPcyON4bam11rf8dtojlfrZczke
	 a0cRCtbIdhyKob/jH2lznwwTKvBjIZAg1KB/vScNSdcCKd7+ocT15AtRjTqujgoPK/hxY
	 owaEWIf7RehHrCeATd5YcBAS3iVZYoWNFFDr0XuQRL9Zpa2PcapG1e9cM53xdJVkeOJC1
	 qxwDmn8Nw8QMuWlsadqjFaEKRJWajvtAH7NLTgOvvfMjw00foCmDS8meHoqejITtHDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794997782;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=u1JPmVguq195gGQnQYzXh0wTQYfyQAI4SdSRX3N90fM=;
	b=B/P+pRmcZz58TccsOuU7KnjrpcEFt7WkQfv0ewJg8f6hXPnluFsTPAdKbJwIwBnKTZSX
	 RmmW8ILxGc6UHnlp/Z3XFb6sLr5X32MZyelf518N+O4xDQTfqkIfOgpjHZHi7XkuYTPyQ
	 w6IB9u6xAdPu/unH06xKWqCr7z29uhmQVFo8ZMZq6iYxEW5hTiWXudfaQ0/fw+GRpZCCc
	 7kkvUT4Tso5MelruicAiBODeRfkwAjcYEdzWivLSPPPIcBF0eueOFez/FcDUHnODrVEOt
	 i2oEaoFp80rwSUI7cTcfQkVE2NnaSLkjlaG1ydmFc2ar72D7D13ZnPdvi7XA/QfHauA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OLBUmMZs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D27606A330
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OLBUmMZs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38671F000C5;
	Wed, 18 Nov 2026 10:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794997782;
	bh=u1JPmVguq195gGQnQYzXh0wTQYfyQAI4SdSRX3N90fM=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=OLBUmMZs1sn1jCYhgwXjnw9m1LA2WxiS8pbQGvcYCsDKAz6B5uXRAZUwrVrgnyg/b
	 6ZRmf1pVioJDosQ6DR/+vfjAKiIItNiX6BFwsDk7AqnebOlOLvwg9szUjcWvl9Hs5o
	 xm+NOK53un3WVp0etBvBKogckjDxb294oT7KoAe87XzzC3WkI5AID1FJutxPBIDxVR
	 lM99pU2elbSFiaHe/Y7i4z+NK3Scj4Z1ONckBmgk4F46HEvZG/jT+kYRmZhMw00R7p
	 t5lrwFEcA2DlI5OFEtJmkR3saOxEY/MBW1cvOyNjcIWD9cdApcHesoYqLrjN0OF4il
	 veO8j2yz6sqMw==
Message-ID: <sashiko-outbox-220697@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 17/37] scsi: mpt3sas: Clamp ValidEntries in driver
 trigger page update helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1794995806-5835-18-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1794995806-5835-18-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 10:29:41 +0000
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
- [Low] scsi: mpt3sas: missing Fixes trailers for trigger page update
  helpers
--

commit dcd564521e5587b8463313055759db28291e6ac0
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

> scsi: mpt3sas: Clamp ValidEntries in driver trigger page update helpers
>
> Clamp ValidEntries to NUM_VALID_ENTRIES in the pg2/pg3/pg4 trigger
> update helpers before it's used as a copy count.
>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>

[Severity: Low]
This fixes an unclamped copy loop in the driver trigger page update
helpers.  Should this include:

  Fixes: 71b3fb8fe6dd ("scsi: mpt3sas: Add persistent Event trigger page")
  Fixes: 2a5c3a35c156 ("scsi: mpt3sas: Add persistent SCSI sense trigger pa=
ge")
  Fixes: 0e17a87c5950 ("scsi: mpt3sas: Add persistent MPI trigger page")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1794995806-5835-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D17

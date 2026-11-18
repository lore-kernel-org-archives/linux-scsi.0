Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794997775;
	b=1QusT0jU08teqpSEwCR3uukrhhF97QGaRI7roqR4Nw/3O61ERToYWfxCa3Tlvl3bJ6pe
	 Xly4N2OEniWh93HMNnKvo1bkhXbztc8jtUZ1/WcZR1EpIMyuIZs5Z5WS/ZZGCRriWJPuJ
	 WtY7eCq6VmpzdeA87Jrod06LMfm2RZQRnA38wg/Nf2/bkJQZHyVvtYGHK4l0INoO8wnxN
	 G+pQYdqLB++RUCn0HNzgyaQ6olN/S70Ga+zEBFFghbJwpzMVRz+BT9UAn8GXmetBTeePo
	 d4ug3CW6ZGn/4Z8EgTkVuKf+17tbZ7l2bN0Xl0O+x/IKg31N1wKIaTftdFo4n6BitfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794997775;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=CG08bGTLp+3k4SSoIyjn0TZ9QN/Kl70hSU0d20S+Fi4=;
	b=Cf5k0PIwod6i9aN1eO/XZXUGU3JNNk15IUyFuWYE/lyKcHlXQdrYysoUb6jzcKcYxLZ3
	 wzNHUU0SldUcq5jvHpR/flU+/lXCZzhEr1PJxmbzrEAdZ2ajiafMRF1pNw1P/lfstqgHM
	 IKQGT8y7yaR7KMHZZnpQmH2sgl3etxjnJgeCQL8CITP31tqPsvhYo5VJcaMhrGCZmAeke
	 7uyp9JbG+EKeVQti+rq3KKShBjUY5oM+S+KwUQEDkknScuvr3xvO3w6xM7GJhpG1c28LL
	 X++BUrmZStCXkm6zfexAzkiksyLyC0iQlJzKG3udWFgncWP55LopqNzfQgaf7cVwaaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CxIPrOCp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F6D606A32A
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CxIPrOCp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C1081F000C4;
	Wed, 18 Nov 2026 10:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794997774;
	bh=CG08bGTLp+3k4SSoIyjn0TZ9QN/Kl70hSU0d20S+Fi4=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=CxIPrOCpyGYgAnyu9QxxlV3o8+9lDMoaPSXea6VibRcw1BtN01dynzUuUT0S/h4mZ
	 yhv90dAI5SkDEzrWTPZQSBRtSu2vW9BwBv1qTRGPkzTp1BEXvu06jPTR/vJRmKfXUS
	 2klUdzOX0Pa4hbZPLTjxqFS1556oSKT1VCv7Yk+Zm/8V2vvmE8A3BjD8mEjLifQwGQ
	 lUM4mQax7leieS8JxEnL8/q8lssEMe9RpLhjN7OhEAwbZSdR9TCvKgYrGOovfFJSCP
	 6ogh2v9oCTrf5Rdtbbt2NTXBCD/tVX/Rs25hvyOaNW1qF/R7q2MeLtXN26p/eKYjqO
	 q2jsuiYLz6+/Q==
Message-ID: <sashiko-outbox-220695@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 18/37] scsi: mpt3sas: Clamp firmware reply copies to
 the allocated reply buffer
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1794995806-5835-19-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1794995806-5835-19-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 10:29:34 +0000
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
- [Low] scsi: mpt3sas: missing Fixes trailer for unbounded MsgLength
  reply copies
--

commit b374b47a54633c9bf2af24964142863927dcf94a
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

> scsi: mpt3sas: Clamp firmware reply copies to the allocated reply buffer
>
> Clamp MsgLength-based memcpy()s of firmware replies to ioc->reply_sz
> across the driver's completion handlers.
>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>

[Severity: Low]
This fixes unbounded reply copies present since the driver was added.
Should this include:

  Fixes: f92363d12359 ("[SCSI] mpt3sas: add new driver supporting 12GB SAS")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1794995806-5835-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D18

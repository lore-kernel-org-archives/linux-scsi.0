Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794997781;
	b=AuZ7l4zlJ2JXH+2YAz47ysP6dJV+CuaEfSMMel88dX+cXIIHT4Z6rTF9cr8YoVDO8dR8
	 dalUOcGhpm4i1QK/xOOnJwbj92/zx9k9Jx8gvy2qZJQB5HkOb7yrUjlSzCgN1vmdCJ0qQ
	 HTRGQtQFiALDHklSOmyhQ7JeCDGCxGV7QISiZ+q5xQl9e/7aKvHAHn2fdIJmzH3553eDs
	 zgAq2wkpxs4j5t/EI6MEV8JggqrfyZM5h7mCHGlu6oSjB2LKTO6tw225uO8SrbtgmeMI8
	 5DBEphNId/moqPb7+0FwnXtLeZUsErgLX8px21BAA8qpXYqvKiyjSUFU//ScEq8fGtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794997781;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=wt+zT6Q4AOqHCmsaSyMc3Yupth16tPhVcryNIQjjWzc=;
	b=rJMACQCy91Z3bMIlvEn4OKAz36qQZYVFnLRJOvIBz/3Tpud+iVxa/lZXo/Z3CP3vW8jZ
	 dr1aDCmV7Me0zlJSMDvilviERI44IiU9faVLpSMxVXuLkECmw6ly5LYTP30z55E6e39Lk
	 wuMzmwCcZ21jc3bksKGbNkneT9E0SakIt2BDg/WvRQ/owVX7xliRy6XRoDU2zQeGsMBp8
	 6pkudDQ/1oaXrbG0ICP9Si989hTJ1nQaVvvFvHncFtwmDNXnPXgsnofIiGNCRpIZDJGn6
	 irTVKYXHPl0vSlfzQ8snPymvjDrDciBpgE9pAkU1+CgPnkulA8qaBJK4JI37MwY5Jqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jAsks0mY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4231606A32A
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jAsks0mY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EDB41F000C4;
	Wed, 18 Nov 2026 10:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794997781;
	bh=wt+zT6Q4AOqHCmsaSyMc3Yupth16tPhVcryNIQjjWzc=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=jAsks0mYuPKdbkjCWyxAWHPcPDWO2VZaWIvqubDcjT4Dw7XAo8sXDlZTk6otqw6tj
	 Q1W7md+UocPCooK++9VpoqRVMongUExsX1tVK95E2qZGcqMW9xBcmZorceP1zPXQgT
	 rNQ64OS9ycvsaGNuez8ptyNUwsX7F/0zXzW4vYxUwPVbPT5ijeCA0yS8FhKNwpBbIQ
	 ztn8Q0YtWdN5057cehCDMiGxActannaVkBn5F18yIB/Ws0YRBfrdUTG1J/9TebB4Nm
	 aA/JD72xygXPTztQTgXrFtxdQVBnAkaQ3wi+1jr/8y6At3ntw+nZL0x1XfygRWgqxn
	 H1STCEb4v1+Zw==
Message-ID: <sashiko-outbox-220696@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 07/37] scsi: mpt3sas: Validate SMP request/response
 length in bsg handler
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1794995806-5835-8-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1794995806-5835-8-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 10:29:39 +0000
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
- [Low] scsi: mpt3sas: missing Fixes trailer for
  _transport_smp_handler() fix
--

commit 060984be700991973c1d95141b9dd8e66c82834b
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

> scsi: mpt3sas: Validate SMP request/response length in bsg handler
>
> Reject SMP requests whose mapped request or response buffer is
> smaller than 4 bytes, avoiding a length underflow when building the
> SGE.
>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>

[Severity: Low]
This fixes a length underflow in _transport_smp_handler().  Should this
include a Fixes: tag, such as:

  Fixes: 651a01364994 ("scsi: scsi_transport_sas: switch to bsg-lib for SMP=
 passthrough")

or:

  Fixes: f92363d12359 ("[SCSI] mpt3sas: add new driver supporting 12GB SAS")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1794995806-5835-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D7

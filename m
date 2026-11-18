Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794997837;
	b=qq9ZXxU8WyCq+CvPHKgCYj3LMnOYLaDeezbBlcGGT7g48m88p7U8fGxXGgfCHW4ycRgN
	 1sqBUlkJ4BNl6VdFao32Rb2JST9ZqJ2j4dN90clK/Xn5Fn06imTwSdkzovmgHl2aYxobY
	 doucvEBoHTIG+u+vH17DK9d4hmMnbvkLzJZeqm60kWkpH2VO1WhqF2QAwy3qnXZMxrSma
	 pGXyBun2pBaXjRszQ3SLAoFpaUY6/rlXbOi68ZqU21AgpeHQQFFagc4WcQTQqgjpz1egq
	 qGaPWSVa01MMLJuwOtwzoXidZLI847rHLyEDU4ZjHMU26gpr93NQV/AcVbGHvJUYuZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794997837;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=2NL5gN3QMQzXXK1eIBKRnSjhI5XZnQrw514ZrGLnSyM=;
	b=WU2laLR+W/GRYPWKvPGIIRgrJJlY3n7YeN4LheIe2pEX1lezSfZ8e8czKXpdNJR5vxUQ
	 1f6eGDDtYRj2LsfuTvbURcymCVUDcZ7CbggKo27jlzmjHYpmYpM6mBXnbgNGgoboJGpuV
	 DYeInNMOWpcScVg2mWVPX+aLmHEoutxvC/I4Ke9o0S2MMtf9mBZssoSpgpz8rfO7+myNC
	 ikeJw/6O51psKi/7Y2p14tN8yPdmtuGZfGaMPrVZbF/Kkv6NxP3HmPSNfV3PFQfsf2BN3
	 HfWjJ2OXHr2hGGZmXLZv+/w5RPFs0UPH5KWQUAz7j5eKjOFqpzBhArW8pwiad2TG5jQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DdXRDD15;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CEA606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DdXRDD15
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA1A1F000C4;
	Wed, 18 Nov 2026 10:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794997837;
	bh=2NL5gN3QMQzXXK1eIBKRnSjhI5XZnQrw514ZrGLnSyM=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=DdXRDD15Oan4taHUJI8/B4qcXxo17lYeTxOhsLuHoXyrQtQadv4zGn8RzOU6N1dna
	 Gnr9FyaJVU4WaTISaf/jfmXkGOiyjQ49TpYGOeSRr1KpzHGAss7axHTBJfMV8pDllU
	 vQYogvjhqyG1VW1QGB+kkMgghemT32poyKuKGAd9wdvafJbJJ/HMGRe31z5OsscV1o
	 K+Fh/SB8C0qs15sbhLiVzPDa5amC7JEkrgIZamMmQkCXYkg6hF39Fa84JcLo+RSlkB
	 xmadga4tOiP7sPx+5ISU25BRjWJx9/V0gqWKA0MdYZLiJsql7qgEJNSKOvmdRPqbtJ
	 rvKjWCqDvWK/g==
Message-ID: <sashiko-outbox-220698@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 06/37] scsi: mpt3sas: Fix invalid kfree() of
 fw_event_work event_data
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1794995806-5835-7-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1794995806-5835-7-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 10:30:37 +0000
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
  mpt3sas_scsih_event_callback() fix
--

commit 919960a29ab6529ce505fc0fb585ac3b629d2374
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

> scsi: mpt3sas: Fix invalid kfree() of fw_event_work event_data
>
> Drop an errant kfree() of fw_event->event_data, a flexible array
> member of fw_event_work rather than its own allocation.
>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>

[Severity: Low]
Should this bug fix include a Fixes: tag for the commit that added the
kfree(fw_event->event_data) call?

  Fixes: ad5957193107 ("scsi: mpt3sas: Add firmware event requeue support f=
or busy devices")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1794995806-5835-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D6

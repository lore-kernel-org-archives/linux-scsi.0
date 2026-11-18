Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794998353;
	b=u3IBCvfIPFXhVpl4rog1CXVXZbPGSCegPEO8u1Uj3bTbd06ih6YjYuor/UWs4tuCD+G0
	 gydxAChexzp6AfWSjT52fLcJUfyMUy1HAbHkdPiNbVT06PNRHef0CQHHDe+K2Ya1SosF7
	 Fl0obWH8F0+6ub5hjwLud9jT/kKVSE7TQ50suTnMWAgH6D6lUeSxjaD2QqyTB27qCG0vy
	 opL0lOoEEhyIAqxW9fqO9hmTfin/GiWPuuH9HtGm/CGuzZ5rus09Xj2LpU0fSC+5ReG2t
	 t0dz5SsYGhxhRQ+kPcdbuO9khlKXtPpIwYeVaSMuon/1fcjkY4N20x2z2Q2eVZDzo0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794998353;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=z/ulekBBplIEW6mhMh8lFRRQQsbsVjEzsuPLuFMvkHI=;
	b=uXce79MSZl5TdRlGb5OsPXSPT3MscK3404VU/waPC8qPJIH/x7H2O9B7/hM4y+6c5eOF
	 W/67S1afMr8VdEgVXhG6+HyrLo5R1nVNTzwBlpNY+7uZlG7KqEh29ThqaXQ5Gyn3HKq/g
	 ZQeEiD9i5ZMQkV3xv1jXPbKh1tnuaYrujGgMlPiVZve05PVDWm9LESC860++0/grKZiDQ
	 4LAwZ1yRzKMMUYN5YH4cc/6p27/o15YhvBajTBDSwCVrQcFEjN5CKB1JpGcvete67aKlv
	 bREU0TEApKWdZah5EHPHUu71N88CN2WR2/4xmAWWITLIOraniq/B5WmzoEGTZiQar5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SP4wsd1O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479FE606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SP4wsd1O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF391F000C4;
	Wed, 18 Nov 2026 10:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794998352;
	bh=z/ulekBBplIEW6mhMh8lFRRQQsbsVjEzsuPLuFMvkHI=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=SP4wsd1OXIuM4sU2QDQkxw2dIVdnMBQyLZWUmqjUtfGuAR81ySzayMuAEOUieWZ7h
	 kADp8wXI+hIm/2kkDWAa6vzxroDfG14P1dV/CCWQv3JE8lIkazkoDrS5se60PdSGHg
	 W8Cvr6Xq3u+8T7V6QmfSI0RpMtsNCUqqz7AyHIA6ShRYcqtgtkTTLOSm6Op072uUqt
	 U49JYKKTWhjzBvoR5yENjEG1tto2pyIUJZoN/yExSYNJAy9gyVpzdFAxudW45n9eN2
	 dP5I2M6xb8QuoRFAJmB5QziWdwdO4x+R+4Lttis7zdwJVVSFEJqvsrXexfIo0qnHkY
	 YE9Jd6pyHU+0A==
Message-ID: <sashiko-outbox-220724@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 29/37] scsi: mpt3sas: Bound event-log copy size
 against reply frame size
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1794995806-5835-30-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1794995806-5835-30-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 10:39:12 +0000
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
  mpt3sas_ctl_add_to_event_log() bounds fix
--

commit dc77a741c46884a47491b6aaf492e68771521963
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

> scsi: mpt3sas: Bound event-log copy size against reply frame size
>
> Cap the event data copy in mpt3sas_ctl_add_to_event_log() against the
> space available in the reply frame, not just MPT3_EVENT_DATA_SIZE. Treat
> frames too small to hold the Mpi2EventNotificationReply_t header as having
> nothing to copy to avoid underflow in the size calculation.
>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>

[Severity: Low]
This fixes an unclamped copy in mpt3sas_ctl_add_to_event_log() present
since the driver was added.  Should this include:

  Fixes: f92363d12359 ("[SCSI] mpt3sas: add new driver supporting 12GB SAS")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1794995806-5835-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D29

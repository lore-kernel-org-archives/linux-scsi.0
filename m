Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=81.169.146.168
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794422992;
	b=OusdBpxqa0o39kTpqGoFMbXbenlNnrFLTEDACtTBCdiO5F1miGq2G1czQSyH3v7MNXGT
	 3/9niXsuyNFZHdg7y3bLTIL2+XsfbRw/Yw7A8cB9fl38ZXiW0Yo6fJOU77R3GVWIrNfSM
	 hSyDNMJK25FAGrq1qI3WT7OeoLvmbx+f4dBYPWtzAv+CTH4G1HfJYfvB1LQYap9Yct55j
	 wuWzL5IBVoqzdzxi6TeZzD97XEi5d5URgIjW6OgkIrMc6O/EmCfWIeC5icLi3FaG2iYJ0
	 oA5GVNso+xkAjFt9YsVSLn4TAzdHogmPmvPD7vM3MMv+k2pZRcf8qRyFa9+U0Z6ERag==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794422992;
	h=DMARC-Filter:X-RZG-CLASS-ID:DKIM-Signature:DKIM-Signature:X-RZG-AUTH:
	 Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=E9+u97kUQihFWK/syVLKJ8ze+8fQmZoDrDGh7sbcqLI=;
	b=R8cOIrobh83E1Lfh+H10L0K1wYxf941eVj1zIJA4QttVSrGntnF3i6452taO7sXD80I4
	 1C9DzyiMnyGQHC1HpEIb5q4dUMOeZOCioGGAG8RLE1LmeO/YX0jvcW8hVtVIBF9FFBff/
	 5ShkalXafXzSez997KjcM88nfvLg+r5TJwtHwSG8NgRJPY6pDDbTZ0RAp1iM78ql0+aCR
	 DoB/FYo3X/j6EePLHyrYLey7meYBLpTneW8hkgPIsSSIQGzeXaQtuTGBaUQfwaAUW66Az
	 KBrSXr12VWOfZAah9whW9FfUOw0N5RdrCtuvtUWX+pPrMKv6SVpXKgm34AtOz56ahGQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=iokpp.de;
	spf=none smtp.mailfrom=iokpp.de;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=qfowml7o;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=f7junY1s;
	arc=pass header.oldest-pass=0 smtp.remote-ip=81.169.146.168
Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [81.169.146.168])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA375606A31C;
	Wed, 11 Nov 2026 18:49:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DA375606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=qfowml7o;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=f7junY1s
ARC-Seal: i=1; a=rsa-sha256; t=1794422981; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=h3u9AoFiZDUwYf6WgnI/p764yF8gRVBwkv1YGO2bOgf0yR+EN6IsakQ+Lk99z0lF0r
    rMIOW3XBUvUPnY8LFCousszVadRtoKjkWecOPpijwNCc3XRavJNzM+C8hDqglGjehYnL
    GfuUsBjNO6zgGg0usm8u2D1RZYdith2n3YMYSJixwkstEE0TSoRvQRTlxY71oLwlR+WR
    yUC0s6uBcyeeU8gg1M7SY/89bawjd4DWHXoamFPcSbW806Hfu8ZAz+FIjuYceoLI6GsH
    MvjcE0oKmfwwTTdtx253dkk8D58JwRP0HnjmVrJL1A7w6jlqkY5GaCfVKw7hqOFC21pe
    LIWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1794422981;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=E9+u97kUQihFWK/syVLKJ8ze+8fQmZoDrDGh7sbcqLI=;
    b=ow9s4/jN830BllNNIUNenemGqHW/D1USagaHxA3WJy01ymBeSQEpB/EifIWeYQ8vOx
    ExbvHQ7affWARd3WaaNo1K0uaPmu02WH69UY5rjEzZCfKF+w03FFTocgCYanyqDtm0U+
    p5gCqGVbDOiAAafZzcHymi1cvD/7vOVEy+VLWcgNJZaBLsxtFgp8d7fyWm2uMtIA4UG3
    iI3GFhNmQEULPKu5fcWszq2PP3rpZP7OpLtjUfGG6gUgTbJF2ua/lp3JLyUV0Ym6FBoh
    Lqmjx7HZRYGCbRkrJfLmP23oLoGHtWmJ6R9myqj1uxtVLpG9kI4AnMCv31iuE3ZDftia
    IMKw==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1794422981;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=E9+u97kUQihFWK/syVLKJ8ze+8fQmZoDrDGh7sbcqLI=;
    b=qfowml7o6sVsofa/aKAF8qzfzApsonK+sZdlKdFnby7Ib7QPRLExovovXuiIJkT7en
    3WBd5BnO3DxqAdvydcgIfmOSu4F+VIPIt5Bkgn/tErA/g3Ner8XK7up/hdAcRwV8Bf0D
    XPgcgLp73eeip/Ceed4MCCfGBV60VTJLltMbafDNbRKiku8nJ5gbap6660Nq6BexKEid
    eRLBwXr9NdQDnTTF9tGeb2rYjMq1uOiJ5hFfhZ/9JHfM5dO1khBytPCwguT4Wg719sVO
    Tz4PafIoSEasmqKIXuDjFxpByzyvHe/aqgFCVmIatPCbjHSgBc4Nz++CMj7sAgG9pSK3
    5UDQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1794422981;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=E9+u97kUQihFWK/syVLKJ8ze+8fQmZoDrDGh7sbcqLI=;
    b=f7junY1sPeWuLlZfoSZlt+dAWLnkwy5WoQGyYspKkxgiEkcsZzfatxsReFW+5YZTHP
    aijuI2iP8IMRfJ1o5DBg==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zNriHg+YfT0rGaTpIu+r+eHzyBFvc/0mM2I80og9K0iXpLsCzk="
Received: from p200300c5872329b218616a30d22a9174.dip0.t-ipconnect.de
    by smtp.strato.de (RZmta 55.6.3 AUTH)
    with ESMTPSA id z831ad2ABIneiDa
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Wed, 11 Nov 2026 19:49:40 +0100 (CET)
Message-ID: <4ec390037882aa4cbfd8437b5597009058409460.camel@iokpp.de>
Subject: Re: [PATCH v5 0/3] rpmb: Fix request serialisation and teardown
 races
From: Bean Huo <beanhuo@iokpp.de>
To: Stanley Jhu <stanleyjhu@google.com>, jenswi@kernel.org, Jens Wiklander
	 <jens.wiklander@oss.qualcomm.com>, alchark@flipper.net
Cc: mkp@kernel.org, gregkh@linuxfoundation.org, arnd@arndb.de,
 bvanassche@acm.org,  avri.altman@sandisk.com, alim.akhtar@samsung.com,
 beanhuo@micron.com,  can.guo@oss.qualcomm.com, ulfh@kernel.org,
 linusw@kernel.org,  shyamsaini@linux.microsoft.com, alex.bennee@linaro.org,
  James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, 
 linux-kernel@vger.kernel.org
Date: Wed, 11 Nov 2026 19:49:39 +0100
In-Reply-To: <18d98074c73f90db.3137322e31362e3131332e313435.266ebc.0000sendgmr@google.com>
References: <20260914144910.931518-1-stanleyjhu@google.com>
	 <18d98074c73f90db.3137322e31362e3131332e313435.266ebc.0000sendgmr@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Mon, 2026-09-28 at 13:52 +0000, Stanley Jhu wrote:
> Hi Jens,
>=20
> Gentle ping on this series. All three patches carry Bean's
> Reviewed-by.
>=20
> 1/3 touches drivers/misc/rpmb-core.c and 2/3-3/3 depend on it. Are
> you OK with Martin taking the whole series through the SCSI tree, or
> would you prefer to pick up 1/3 yourself?
>=20
> Thanks,
> Stanley
>=20

Hi Martin, Jens,

Gentle ping. Alexey just hit the same failure on Rockchip and sent a separa=
te
fix=C2=A0https://patchwork.kernel.org/project/linux-scsi/patch/20261111-ufs=
-rpmb-bus-v1-1-b07100e53f6c@flipper.net/

UFS RPMB is broken on v7.2 and later, and all three patches here have my
Reviewed-by.

Jens,=C2=A0
could you ack 1/3 so Martin can take the whole series through SCSI? Or pick=
 up
1/3 yourself, whichever you prefer.


Kind regards,
Bean

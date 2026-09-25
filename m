Received: from layka.disroot.org (layka.disroot.org [178.21.23.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163291DDF0;
	Fri, 25 Sep 2026 12:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.21.23.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790340131; cv=none; b=StG6+Ps6ZvkJqbLs/afkXYAwEfz6SHu0wN0Dfxi5YoldsXm4hhBRst0iPB+b0c7k/cZ8SFLM2yTbolbTRATkEBDnrZlccpWlA6NT8KnudCMErzaDJ6RPMs4TiJQXjKGgPZQvMbC242tfcW3pr+1+roRAvgppNvEdz24oTpYa6JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790340131; c=relaxed/simple;
	bh=q4QS4UE3at3YzFmXewffE5SIQq54qBpHCXi2+KEP1r4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gRiJpAlF4/wAbi+fXgnuAHTSXe0l5yVYwlbkv19E5Ka24rggGv2a0juZX1rMQrxVuHU6zvGjiLWrPnGptaSzxnFmBnBkbA7TUmNcyk8g0lOrsEyaF0+BrzJA2K6wJWbklNAdMVv9Z0qmos3sTSZJZfjTeQNHInpwwwvQzKnAl1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=disroot.org; spf=pass smtp.mailfrom=disroot.org; dkim=pass (2048-bit key) header.d=disroot.org header.i=@disroot.org header.b=hQSNA8OW; arc=none smtp.client-ip=178.21.23.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=disroot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=disroot.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=disroot.org header.i=@disroot.org header.b="hQSNA8OW"
Received: from mail01.layka.lan (localhost [127.0.0.1])
	by disroot.org (Postfix) with ESMTP id 8571382D29;
	Fri, 25 Sep 2026 14:42:00 +0200 (CEST)
X-Virus-Scanned: SPAM Filter at disroot.org
Received: from layka.disroot.org ([127.0.0.1])
 by localhost (disroot.org [127.0.0.1]) (amavis, port 10024) with ESMTP
 id POdwVJKzNGET; Fri, 25 Sep 2026 14:41:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=disroot.org; s=mail;
	t=1790340119; bh=q4QS4UE3at3YzFmXewffE5SIQq54qBpHCXi2+KEP1r4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hQSNA8OW/YLPq6fjpTGbXWiKzr6o1DgQqHdX8KlK4tteXES+59Ov34VRB64nr/0Q3
	 hPiCysBvI3Vlq1Rh2qVU+XyVw7C4htcNuH6aX6gwHq5WUk/hRUBaOgtCzhkE23/WlD
	 oqQw2yw78m9u7dzAR+Ly4DqXb9B1bSf6xPqBI+yazrQJ0WTDhzogU5cGsYwakOfVFo
	 Ig1MMIFocEHvbaQuWzsfGHnhoODd3Ix3ROunObfoAajpm8PvXMcDj/5JhtnH1pfmio
	 uzM9AlN8de2fMLJDbeAa1yf7peooYjrJmN4rCusJ6Qkw0dx4xZnLLHUnGPTxDRfzHE
	 gV07a7kG0uonw==
From: Marco Scardovi <scardracs@disroot.org>
To: Denis Benato <denis.benato@linux.dev>,
 Ilpo =?UTF-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>,
 Liang Haowen <nbg2974@gmail.com>
Cc: linux-leds@vger.kernel.org, Lee Jones <lee@kernel.org>,
 Pavel Machek <pavel@kernel.org>, "Martin K.  Petersen" <mkp@kernel.org>,
 linux-scsi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
 linux-kernel@vger.kernel.org, Armin Wolf <W_Armin@gmx.de>,
 Hans de Goede <hansg@kernel.org>,
 "Derek J.  Clark" <derekjohn.clark@gmail.com>,
 Ahmed Yaseen <yaseen@ghoul.dev>
Subject:
 Re: [RFC v7 0/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED driver for ROG
 NVMe enclosures
Date: Fri, 25 Sep 2026 14:41:46 +0200
Message-ID: <mTEVQW_BRQmYsDDsTddE2A@disroot.org>
In-Reply-To: <202609251958.ReplyMarco.lhw@gmail.com>
References:
 <UuqOxFagT_OBL0l5ZYtfKg@disroot.org> <202609251958.ReplyMarco.lhw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

In data venerd=C3=AC 25 settembre 2026 14:22:03 Ora legale dell=E2=80=99Eur=
opa centrale,=20
Liang Haowen ha scritto:
> Hi Marco,
>=20
> I went through your SCSI version in PR #17 against what the hardware
> told us while developing this series. The class layout fits the
> device well: the ENE mode register is the hardware effect offload,
> and direct streaming as table write + apply-without-save matches
> what the controller does.
>=20
> A few things our hardware testing can add:
>=20
> - ene_write() maps the caller's buffer with blk_rq_map_kern(); your
>   call sites pass stack buffers (colors[12] in direct_write). That
>   is the VMAP_STACK DMA issue Lee caught in my v8: the payload needs
>   a DMA-safe buffer in the device struct.
>=20
> - asus_aura_brightness_set_blocking() will never run on the current
>   LED core: brightness_set_blocking is superseded by the fast-path
>   brightness_set there, verified with a test module on 7.2. The
>   callback to use is brightness_set plus deferred work.
>=20
> - The firmware effect numbers from register probing here are
>   1 Static, 3 Strobe, 4 the rainbow flow (all verified on device);
>   2 looks like Breathing but was not confirmed. Your mapping sends
>   Spectrum Cycle to 4 and Rainbow to 5: on this enclosure 4 is the
>   rainbow flow, so those two need on-device confirmation, and
>   mode 0 for OFF is plausible but unverified.
>=20
> - If the class core serializes the ops with led_access, sysfs ops
>   cannot race each other, but trigger events reach the LED core
>   without that lock, so a trigger-driven brightness update can
>   still interleave with an ops sequence. The device ignores a
>   sequence that loses its leading MODE write; one work item owning
>   the sequence, like in this series, closes that too.
>=20
> The 12-byte block write to both colour tables in one go is verified
> working, so your direct_write shape is fine once the buffer is
> DMA-safe.
>=20
> Whatever survives your rebase, the verified SCSI core in this series
> is yours to reuse; happy to rebase my side onto the class once it
> settles.

Hi Liang,

I've read your mail: as said on github I've dropped both scsi and tuf as
I don't own any of these: I'll leave them to you and voidvore. If you find
my pieces of code useful in any way feel free to pick them up and implement
them in your code (please don't add me as co-author as I would not be able =
to=20
test or maintain the code in the long run): as soon as it will be stable=20
enough I'll proceed to post it here in lore too.

Marco




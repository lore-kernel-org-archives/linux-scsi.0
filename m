Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792694745;
	b=aB1dJsQ3vHc7z4NDY5V0oLL8DwW4+0jlv4xqW85XH41QuyAaKveoEZXntWt9Jws4DoGc
	 ZNgkYBc9VpahAgACgBlxEx6XG0LxXcrc59naT9SCHp0O/Mpmos+c+te6UNtFY1wJOXlrS
	 UA33x2CeWhxq2pP7OHuACoZPKy/Aoh25apRFtszKlz8D47vy3wLQN/MSg1OAwiEB25Y7B
	 v2W/1wIAQqT/DpZyO6O0zwlHBCRiWjVAKGPld1vx9LqKCsL2c5wAVNq8WMrCAVGUXm0Ba
	 4LuEVqtPLcls3PeFty3sTli5t2fGu3WIsodol7uXE38dmtP6O/d6KJUFOPxddBkkOAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792694745;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=bdTp9jD5UsHayMIUOUjPFjDBuIiz49SNbtf2bsvLAww=;
	b=1V16qjyZWR5fII+umdJ9ZYMpETJR9QbkZ1O4b85xEaFyhJ99TpFelKZsvUDPH5AaTjsD
	 0BHNjyz4D70E2htPtfe7R609szu8carD+gf1ehy+D578DYzgBKtrTKQMdHfAyLEoOYBKb
	 Lqd6uqWGZoubFHYbcvTo42FLgVs0IPlR8sQK+Diq0//AQk6BtFS4ZP2F1qKVR+jui2C2Z
	 MWTFXXRAL0RVImya+ct0p0rNk0gPRIHGdTVSdgY+Zb5130PhdW0Y9iPzrj93fUxQem9iP
	 sV5S4wrUrhMbguvjKCfVb4NriRrutclOoNNrYVgILXvXO3yHB9+ICQ6D8KQtSfcxeFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="PSwc/wt1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBC8606A319
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 18:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PSwc/wt1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E851F01825;
	Thu, 22 Oct 2026 18:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792694744;
	bh=bdTp9jD5UsHayMIUOUjPFjDBuIiz49SNbtf2bsvLAww=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PSwc/wt1ZtN73/OpykOheAycPjiZlmdnXMmR5wls00xi3orfFX+kCk9aGnU7w8s69
	 SRel+dSsDYqrGS+GAv8f/kBVilb+cyVTgeGGS2fWueVLWzlhCqAnxBBTbxJvCijDgL
	 dLm8YpPWow+/CKmdfDpmn3MxDBRnHtUHwguj3OlW3YPoGwOvMEK94mwaKVLaewZrgg
	 K4BVKWBTDJo8FLoW6EtUJk3fCkAsQVJRPaX32uEUk5Wgx47yKjhzRFYhoj0XCBn29V
	 1u+IgM3fCnqCAOeT0sD+dLJacaRHNgPGaz9vuYQBelPQMSigCmTPnSkXae/gYiXQAq
	 xpjwYdo/LcJPw==
Message-ID: <sashiko-outbox-181933@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: arm: Convert acornscsi-io.S to C
Reply-To: sashiko-reviews@lists.linux.dev
To: "Breno Rodrigues Alves" <breno3011alves@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261022183658.58090-2-breno3011alves@gmail.com>
References: <20261022183658.58090-1-breno3011alves@gmail.com>
 <20261022183658.58090-2-breno3011alves@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 18:45:43 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] scsi: arm: PTR_ALIGN() rounds up in __acornscsi_in() and __aco=
rnscsi_out()
- [High] scsi: arm: wrong MMIO pointer stride in __acornscsi_out() for trai=
ling bytes
--

commit a11c03319840bf581ce6e4031f7b0b04ae3afccc
Author: Breno Rodrigues Alves <breno3011alves@gmail.com>

scsi: arm: Convert acornscsi-io.S to C

This commit replaces the hand-written ARM assembly routines __acornscsi_in()
and __acornscsi_out() in drivers/scsi/arm/acornscsi-io.S with C
implementations in drivers/scsi/arm/acornscsi-io.c.

> diff --git a/drivers/scsi/arm/acornscsi-io.c b/drivers/scsi/arm/acornscsi=
-io.c
> new file mode 100644
> index 0000000000000..ad16d984d513a
> --- /dev/null
> +++ b/drivers/scsi/arm/acornscsi-io.c
> @@ -0,0 +1,168 @@

[ ... ]

> +/*
> + * Transfer a block of data from the Acorn SCSI card into memory.
> + *
> + * The card address is rounded down to a 32-bit boundary.  Each
> + * 32-bit read from the card yields one valid 16-bit halfword in
> + * the low half; pairs of card reads are packed into single 32-bit
> + * memory words.
> + */
> +void __acornscsi_in(void __iomem *addr, char *buffer, int length)
> +{
> +	const u32 __iomem *card =3D PTR_ALIGN((const u32 __iomem *)addr, 4);

[Severity: Critical]
Should __acornscsi_in() and __acornscsi_out() use PTR_ALIGN_DOWN() instead =
of
PTR_ALIGN() here?

In the removed assembly in drivers/scsi/arm/acornscsi-io.S, both routines
started with:

    bic r0, r0, #3

which clears the lowest two bits of addr and rounds it down to the containi=
ng
4-byte boundary, matching the comment above __acornscsi_in().

PTR_ALIGN(addr, 4) expands to ALIGN() and rounds an unaligned address up to
the next 4-byte boundary. In drivers/scsi/arm/acornscsi.c,
acornscsi_data_read() and acornscsi_data_write() pass:

    host->base + (offset << 1)

Whenever start_addr (and therefore offset) in on-card RAM is odd,
(offset << 1) is only 2-byte aligned ((addr & 3) =3D=3D 2). Rounding up with
PTR_ALIGN() advances card by 2 bytes to the next 32-bit card word instead of
the containing 32-bit card word.

Won't this shift the entire transfer by one 16-bit halfword in card RAM, and
cause a transfer reaching the end of the 4 KiB page window
(offset + this_len =3D=3D (1 << 12)) to access past the RAM window into
host->base + 0x2000 (SBIC_REGIDX)?

> +	u8 *buf =3D (u8 *)buffer;

[ ... ]

> +void __acornscsi_out(void __iomem *addr, char *buffer, int length)
> +{
> +	u32 __iomem *card =3D PTR_ALIGN((u32 __iomem *)addr, 4);
> +	const u8 *buf =3D (const u8 *)buffer;

[ ... ]

> +	while (length >=3D 2) {
> +		u16 v =3D *(const u16 *)buf;
> +		void __iomem *cp =3D (void __iomem *)card;
> +
> +		writeb(v & 0xff, cp);
> +		writeb(v >> 8, cp + 1);
> +
> +		card =3D (u32 __iomem *)(cp + 2);
> +		buf +=3D 2;
> +		length -=3D 2;
> +	}
> +
> +	if (length >=3D 1)
> +		writeb(*buf, (void __iomem *)card);
> +}

[Severity: High]
When acornscsi_data_write() calls __acornscsi_out() with an odd transfer
length where length % 4 =3D=3D 3, does the trailing byte get written to the=
 wrong
MMIO offset?

Each 16-bit SCSI data halfword is exposed in the low 16 bits (offsets +0 and
+1) of a 32-bit card word, while the upper 16 bits (offsets +2 and +3) are
not sampled by the hardware. In __acornscsi_in(), the while (length >=3D 2)
loop advances card++ (4 bytes) so that if (length >=3D 1) reads the final o=
dd
byte from the next 32-bit card word.

Here in __acornscsi_out(), setting:

    card =3D (u32 __iomem *)(cp + 2);

only advances card by 2 bytes into the unused upper half of the current
32-bit card word. If length % 4 =3D=3D 3, the while (length >=3D 2) loop ru=
ns once
and the following if (length >=3D 1) statement writes the final byte to cp =
+ 2
instead of the low byte of the next 32-bit card word at cp + 4. Should this
advance card by a full 32-bit word (card++) instead?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022183658.5809=
0-1-breno3011alves@gmail.com?part=3D1

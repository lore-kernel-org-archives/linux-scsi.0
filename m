Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794346469;
	b=0pvBOzPfdpufFOoaTb0xiEhDWWfSBoxVx/K/+vkFbc2Y+TKjvr+uetJgEcrPaef+PhPo
	 lxsLBKNXQxywEkJpIngtwG7rt8mKBMjvR0nldIOCAB1krS5DFoZgGf2I/Xma5CGLbGvkT
	 S6xHQpFTuK4Us80Y8LATBRF1wQX7KM+ETPC3EAcbwdQPDWrJpjc8W3dUZ9Y+GMIPifd1p
	 cSmMd4JdMXfaggngn2fJT3FusPwbOMqbNt5Mum2C32xoIedernQwCgs8j0g8JeorT+1Kg
	 jvGTetDHSkLgpP4mNAdKkJq70uz8hsms9/7Yaj2T/9RyJAxeEjItZ8BgHkGQBe0STxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794346469;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=XlBszREvDRznGYwRAnNE8aW+g8GtGTwkG4kQo4NdaJw=;
	b=M/k+sZF+H+or6DkD+tqgkNw8qpbldJxUeOzyglK7aMSXoAs8lBllNPp4Ew5WmBw6pAW2
	 naxI47OqweLreOqJtkTcyq8399IineoaoMBAUTtZABQZsDh5YeMy6Yp/lxuGaDH5jPhHH
	 Qq+B0aWeW6YFmuh4c4OGAQrP+EvA4kyIuakRPcFa5EJvc7Qu2BMHjec+Wk8FKrncGbz34
	 ZN8UFIJM85urRUp3wPZs+tycFWOn1TIykfwMP8I9fjRiOuXgARaYsoXyIQPZ7Z3SxRStw
	 5bOSXbHTm6X3n1sANpDT0D5RVe4TPrS1pn59ZEeQ7DWzui3+EznCPoFyzhzO+BJs4iQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jnlzlj+3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF28606A320
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 21:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jnlzlj+3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81FC31F0089F;
	Tue, 10 Nov 2026 21:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794346468;
	bh=XlBszREvDRznGYwRAnNE8aW+g8GtGTwkG4kQo4NdaJw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jnlzlj+3lV5GPQNrEgxV7qkh4hNJ7HRHgBfYRLdAqPJHfhoIr4vGmrKkdzOE5Heua
	 DUcKMzpTLfb0ZcxjTHwtrsyLghl5kJOzPaTruEfdil7GW7IdjDLZGPV/hD6Pja0jKH
	 79iZ80iV7K8S/txwLIns/Yas4f5xhtZdlW1MNYFLwrSkcbtC4i1ez33LVG1XitWSU1
	 SlCDq+/xldjM9kGQCulGGMB27/J2x7CaYmP/psg2rYQjWnKjwd5Tej9UCsizEWb7M9
	 aoLNVO2Ubuu3rjS+NbQCcPHUPzindZc637aMlNFsDNB0FS79km2ybma/nxCx4FsN2Q
	 hF14Ou1+jRPjw==
Message-ID: <sashiko-outbox-207772@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] scsi: scsi_debug: reset protection information on
 zone reset
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tal Zussman" <tz2294@columbia.edu>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261110-scsi-debug-zone-reset-v1-2-28cb9184b5ea@columbia.edu>
References: <20261110-scsi-debug-zone-reset-v1-0-28cb9184b5ea@columbia.edu>
 <20261110-scsi-debug-zone-reset-v1-2-28cb9184b5ea@columbia.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 21:34:28 +0000
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
- [Low] scsi: scsi_debug: Fixes trailer cites wrong commit for zone
  zeroing
--

commit 9eaf9f0aa21e38b43d9e35227a9895fa8453a7ae
Author: Tal Zussman <tz2294@columbia.edu>

> scsi: scsi_debug: reset protection information on zone reset
>
> zbc_rwp_zone() zeroes the data of a zone that is reset, but leaves the
> protection information of its previous contents in place. Reads of a
> zoned device are not limited to the blocks below the write pointer, so
> with DIX enabled reading those blocks back fails the guard check.
>
> Write to a zone, reset it and read it back:
>
>   # modprobe scsi_debug zbc=3Dmanaged sector_size=3D4096 dev_size_mb=3D64=
 \
>         zone_size_mb=3D4 dif=3D1 dix=3D1
>   # dd if=3D/dev/urandom of=3D/dev/sda bs=3D1M count=3D1 seek=3D8 oflag=
=3Ddirect
>   # blkzone reset -o 16384 -c 1 /dev/sda
>   # dd if=3D/dev/sda of=3D/dev/null bs=3D1M count=3D1 skip=3D8 iflag=3Ddi=
rect
>   dd: error reading '/dev/sda': Invalid or incomplete multibyte or wide c=
haracter
>
> The read fails with EILSEQ, and the guard tag that the device reports
> is still that of the data that was written, while the block now holds
> zeroes:
>
> scsi_debug:dif_verify: GUARD check failed on sector 2048 rcvd 0x288f, dat=
a 0x0000
> protection error, dev sda, sector 16384 op 0x0:(READ) flags 0x10800 phys_=
seg 256 prio class 2
>
> Reset the protection information of the zeroed blocks to 0xff, as
> unmap_region() does, so that they are not checked until they are
> written again.
>
> Fixes: f0d1cf9378bd ("scsi: scsi_debug: Add ZBC zone commands")
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

[Severity: Low]
Should the Fixes: tag reference 2d62253eb1b6 ("scsi: scsi_debug: Zero
clear zones at reset write pointer") instead?

Commit f0d1cf9378bd ("scsi: scsi_debug: Add ZBC zone commands") did not
zero sip->storep in zbc_rwp_zone(); zeroing zone data on reset without
resetting sip->dif_storep was added in 2d62253eb1b6 ("scsi: scsi_debug:
Zero clear zones at reset write pointer").

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110-scsi-debug=
-zone-reset-v1-0-28cb9184b5ea@columbia.edu?part=3D2

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792708119;
	b=wV4p0+jS0To3acJ5NUbPBQ7edbCsjUbkMvK9t0h7tZDorv7rlEfQvnuLshAcYHRlfTVJ
	 5N1uJAXi3i3crQpK8sOH0Nx1PFkOLE5PHmDkN4jdw+HUtz5wxo3+wE5pL8vlKiOspWnQY
	 T/v+/vO4klfJMxqbPPRe3q/2YrUVHE6wA93pxYpBGN1kde1U44SehhUa6oLbCxthZtrde
	 nOKwLH2QhAGA2hKSWl21Cp5Ptyu6XcmZm18B1ucYydTTIcscChtWqOTYgf7YDkYUPg6sB
	 rIL4uAVmBqhed3cNIExv4QL3SGn/CFEfW+NPu7KnR7nrZnvvf342VIBU3X6VGUA7S0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792708119;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S9nvo0dYAQsPs8WnHZoy9/22ZqY9nCZeAyTVnl3n0P0=;
	b=YQnJoyBmgu86jmHk9hi5mWeDYGiFwxuPRE2I8TYN33GHK/yFRe1JoT0kP7h/NDZI17W/
	 YhFnsQlhVl4RM2n3EnCOnZULS9aC4Zy61KIZgzqjCbVpGxatVqmnc8vSSgsCq2Qwv0zzD
	 HTT8klus242754mueyx0x135myB6vFW3ZM2LJwxoaV0NI6nWvwotSb9zMqYPYzDtRjeac
	 lZ4myafyp48kEpbZzhwWwT7jE/tfgFfkPZIy7L3Y1Y/A1ckVdbL4SkXGwyaICHPHN/jjk
	 sNx6ib7/mI811Vhi896RKXeMfCyoXFHj7oMo76310BTqw9Pg2hN7o4A0AkCfZMQ0FWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=d2ROXMaU;
	arc=none smtp.remote-ip=209.85.217.46
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEEA2606A31A
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 22:28:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DEEA2606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=d2ROXMaU
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-745497ac8fcso180570137.0
        for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 15:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792708118; x=1793312918; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S9nvo0dYAQsPs8WnHZoy9/22ZqY9nCZeAyTVnl3n0P0=;
        b=d2ROXMaU1QF9tDs4gp2Vzc3IaCpystzRzXf6WwzwZiYMN2q4N/C/xxOFznhkSRUfST
         o9luOS5+mcaAJFXxDzIcvI0FSBNUNU0Ry32gYXj9lZGcZgDzw25tsgNhPMJvHFi0AXNq
         +P83tPpkHHtOrEH97ndNyAEN+I0teQo2UpFjOM3rUb6cLF7BAP0keIyfqxVZH/nRn0i2
         JwB7WuucNEgWy/JECIzT9hgd7cFRIq13PpvTwne7U2GIeydzxY/3iPptp5z2JwZKgenm
         o69ohwtwPxTkpzTSo98Emv138VHTWwVWBdfqrXsw+n9kaxmXfPjYgpDzgyjgBnHaS3De
         dO8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792708118; x=1793312918;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=S9nvo0dYAQsPs8WnHZoy9/22ZqY9nCZeAyTVnl3n0P0=;
        b=fqMtlX/kP0/WNOtMfGWoBSWeW+YgAA2FlZoxY0Kc6s5vXyjdOBEgfAbAzEfKoMhVjZ
         iV0B01tnkh476hhrf+A8BJufBYiUmGGEcAn/V1royz4MIuLotlVZEOgQ1nxaQM6liCDK
         uNop6UkDKzQB09Gcaj6NboGBPb/hOlZr4efWQ24fIpS30dGnRwJ31Xxsdz4+ekWAhF5/
         TbICbkWkrDXP5Mv7si5cdxTX9SOlviKCXxztwZE9amJgwyEpm3GsWha6In5bZk59fYBo
         dUCoDNFzkPFtkbRzZyB75f9JbJT/EqpTcCPd7EErkGb7GlfzDnxauqO9ul1noTP87ObT
         q/kA==
X-Forwarded-Encrypted: i=1; AKwUvBwUDUJVPU2OUkqugpAoAbn+AkwXDKE10v8Uhu7Yl+OmsHdyhO/s2gC5LfnL3KYPhwPr3m5WqGd/NTrU@vger.kernel.org
X-Gm-Message-State: AFq9FYK+kmEHhJNLAzRM/gfkTg5Ze2jU8FxViDbe4BjYOk4r2Haxtj2r
	cQ+8bbHOL3V4jyKeHPf5VExlFo4ZJs2c3k9LqULEsW5ZDzhjBZzS7Rdp
X-Gm-Gg: AYBFou1sQjPpbvkz6XePi4KopPbNhJQW1+3M498+/Ny+2IyOCwJLc/EK7ZgZsP/3dQD
	HXFvNTGz6rHVywVf27Is2nxWVMirKnQmLQAm7wlL9m5s64I4+GQ+6KOfwz0/3/jX9o9Ny2Nx3vh
	79ujRvHLIZAnqepVDnLeo9Agil+AeIVqMMl+bFTOKDIQRq7mg3dWObVymXUgUHN84nhenAWud2T
	uTyYWAKc5bOTYCjExtPvVnculA3Mg9gQcMqUh5gEW1JSqEm8EfMoZw1ZQCW4oR4+it5y4Rxxjq9
	5LqfBsWUvhyStOhUYjFQ9LZjnQOR9Hjnxbxs59dmyjQ1xurc8GQ+lN9K6CEiOmtqX7BRbv++7i+
	cjzF7xYGTNsC+g2ALmfSAlh62sDqjO7CoOUxbMvhODRhgT3jtrow86Mfm1H1ZVy/0sXY0oBJxDz
	t+LFaWcKyTr5xkz3x6eji9RAedvoUN0DeY3Mvt/r65/HkImlUP0Gvjm5yT3kRRNj6sniIgOqZwE
	Y4Jq4sEzjk7p08cTR7If+FS8beUM1+Rn2t6mcT0VIdud3iuMJnadYcsPddg7R1OGjCfm8spP/ym
	yCi0UJFI8Y0R1vL6OuGW
X-Received: by 2002:a05:6102:290e:b0:7c3:1213:1e2b with SMTP id ada2fe7eead31-7ccc337cf94mr314700137.18.1792708117775;
        Thu, 22 Oct 2026 15:28:37 -0700 (PDT)
Received: from Biostar-A520MT ([187.94.15.233])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ec13f2cfe0sm481582e0c.14.2026.10.22.15.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 15:28:37 -0700 (PDT)
From: Breno Rodrigues Alves <breno3011alves@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux@armlinux.org.uk,
	Bart Van Assche <bvanassche@acm.org>,
	James.Bottomley@HansenPartnership.com,
	mkp@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Breno Rodrigues Alves <breno3011alves@gmail.com>
Subject: Re: [PATCH v4] scsi: arm: Convert acornscsi-io.S to C
Date: Thu, 22 Oct 2026 19:28:19 -0300
Message-ID: <20261022222819.92507-1-breno3011alves@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <87wlr9z8iq.fsf@trenco.lwn.net>
References: <20261022183658.58090-1-breno3011alves@gmail.com> <20261022185224.60700-1-breno3011alves@gmail.com> <20261022185224.60700-2-breno3011alves@gmail.com> <871p9h1kc7.fsf@trenco.lwn.net> <87wlr9z8iq.fsf@trenco.lwn.net>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Jonathan,

You are right, and I should have been clearer about the motivation.

The reason this patch exists is that the original assembly has a latent
bug: for odd transfer lengths, it drops the final byte.  The C version
fixes that, and the odd-length case is now exercised by the userspace
unit test.  But that bug cannot be triggered by any current caller, so
even the bug-fix justification is weak - it is a fix for a path that
nothing currently exercises, in a driver for hardware almost nobody
still has.

You are also right about the broader point: "assembly to C" on its own
is not a justification.  The kernel's assembly is there for reasons, and
translating it for its own sake is churn that reviewers have to pay for.
I have been approaching this as a translation exercise, and that is not
the right frame.  I will not propose further conversions of that kind
without a concrete functional benefit - something that fixes a bug that
can actually be hit, or enables a change that cannot be done in assembly.

Bart's Reviewed-by: stands on the technical merits of the change as a
change (the C code is equivalent to the assembly for even lengths and
correct for odd ones).  Your concern is a different question - whether
the change should exist at all.  Both are valid, and the decision
belongs to the SCSI maintainers, not to me.

If the consensus is that this patch is not worth the churn, I am happy
to withdraw it.  I would rather withdraw it than have it sit in the tree
as an example of exactly the kind of change you are warning against.

Thanks for the direct feedback - it is a useful correction to how I was
approaching this, and more valuable than the patch itself.

Breno

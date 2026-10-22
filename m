Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792705724;
	b=uZBpCL7M1eKSxMLjwGAcKlFPYZ+L1Hs8VZGjQS6bmh3czSgu9NOl6sC0LGM+8wvc2Jh+
	 LGdPjkXoPznn9GQTv22no17X8BPJE5mxc8ujmFq9YmMtHIgL8GgN2wDDjrle0SJMSQNrX
	 1BRVI2JlIMEoQ7Biw1xwotPy1UiO+xq+V+OAYxJrY6JIGoq93bk1iIyFWfv3fGxwzcBam
	 tBey3eCNCxr4lRoT9sR6ctSeafKzT/sLe08bp2L8hfnLx2u+/r4R2z9WuBcNy6qga5a5y
	 GX8ypW1976+3dMR8stFt8LVjXm2Ia9KTLH/h3mm1N9j5NURUCGgz5s+sr8wFkzgJgQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792705724;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SeYJzOStxDcCY5T2FRu069D80kN/5wtqcCKwZQpFtxI=;
	b=gxYgg6G6ahq+e6wht7r1lJQRme5qhnxO9UVDCkycQgO1YT8dAn01FETXFb/sC8IZwS7H
	 zXRAWWvoqjw459ENP0LuHjbzJ5kFe+CDW0MuHwLsJxPzmw0rYTb8ctKgi1aKWYhY+NVKg
	 oXK5pyNNiu4Dg/5mhcQeKQnSCS+nBEBlH15dyxJZ/wdbraJpwV+yQ7E6u7xu0cDe11+za
	 bR68x5yQxvZBF0V4IUxgaTR3McOBOPhwr77fJw2AB7s8K6AsvvXOKFgPeis5iTvJFFDuK
	 i+XfdJgY8xvMnJcGjgX9wbfxOmQRpwddaaQwU3B+bM2dymFpiSybIYQTjH5yVV2ADMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="TrKe5/iX";
	arc=none smtp.remote-ip=209.85.221.170
Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CB9606A31D
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 21:48:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 44CB9606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=TrKe5/iX
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-5ea969fafeeso146438e0c.0
        for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 14:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792705723; x=1793310523; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SeYJzOStxDcCY5T2FRu069D80kN/5wtqcCKwZQpFtxI=;
        b=TrKe5/iXcZxJX68DCRVOyHPuanGptudaW0VlYsCyagJw6CW7VK1S7mIBDeMY6Sa9zp
         NTwWdKLYDuLSljX371yMG3RDo3m/fcNA2TsPYOXNUoKWXrV5f8o2HAnRhTnc9UksLJoa
         pWXt6CJTy4cSyvCxOmuMH8SFYoxliZROs8wzEF9EwdDVJaDq+VrAJndboyEEOo0+eCL8
         VB+uAab/EJp5vztPLkhMyHfUIzRt9OkZQuOdMRosywTas/DROXCbYEH90FOnefGo3HBY
         6jD5DQNNjnJTXUAfxzRWPzc1ofqMCpW0O4ez9EP6UyJ0cWlhWGqMQ6lostlRIA1xTNhL
         3+/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792705723; x=1793310523;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SeYJzOStxDcCY5T2FRu069D80kN/5wtqcCKwZQpFtxI=;
        b=PxIr6xrWZSZM74aGdzkXpYSgv1w+NJAxqkjDAENQiCI9RJLUXyH9sW+i76YxjQte+R
         vlYdtMM/2vrnBtsgoecjkJR831uw3751h9vQrB+ZioUE+UYM6g4m3zn2Sq47RHuDg2G3
         GFT4kb9c2qNJbEgl0GwMaSJPws8Am098i2WhrrM2I2xA4XgXQpXBsgwpnhJxXZn4ZuIJ
         lx8mUBgpTa+vK0XikL8IUzzC63auckFU1rP0Th+jhp3O5GdUtWo+opP2WlksG1QCrjBZ
         05IQeW4WVnG+A8S8mG1ekP8MI58ayR/ubzWWZ0WvvcUoOap94q62cGVIx2SFwfYg5grE
         wblg==
X-Forwarded-Encrypted: i=1; AKwUvBxiXyaK7yCo5tyooLrLcdg+4H2PRu5jn0NzAOHbDShQYh00HmAO92brmOmdrf69knpkQwmI9qDSvUr4@vger.kernel.org
X-Gm-Message-State: AFq9FYIqnZflLMrOErdpHCIH7s++7ReLYGzLYys3NJ6R3vMq0cqfmXw6
	Jj3OAKCCafnL2tK0RG6ry/zb/9/oe/jz4CecJslnUmKR9e6Vlg+gMc3E
X-Gm-Gg: AYBFou3tB2P7T1aP8aZ2+gVy3cwyXdDO+s+aXjB/9ldsyN/Dk6Y1yZ8FXagYD7LoJ4K
	yCpmVcLe2x823yEN7JqMoyMyFVNalb283ep0MX8DCoJwg+DOEM0FqedW25wT4ZSAxdM5+5C+hh8
	QSOdE78lMQHH50OfVyjEfVg6elQxMDXRrnWP6hTjVG5wbez4daXSvf/OKf4W0+j5ZhhqizlbwE+
	t7Kon/io3w4ayLRdDEjySt+BQZUppJsnlKwAuaMPCDkXtpVcyj5EzhfbvP3F5ymSbD6zbvXDDL/
	pSlcdinOeBgMsMl39jBwXCXpds6xSPTuMmzzSYXHHfSLkMrPonz1IBpiyHqa6Y+9tlGAVrAXGjE
	CLPJ+g+xzU+t4pPtaYGVxO0fH/fipftkKnIAzjf6sYoVu9lb/cWZ0CvFdTCrWMsBvillUhJPGLE
	/hUv5vvGFIGIHkOiMeJ5jinCHextGeXXIhFubJQ2DzukO10Pt4UpPi8iIcGEZn+wZGvAWHu0o4R
	MQ139efCfnS92cmZd0iC9daHJi1M6RNnhPjmz1bKVjCCqNyfLbUkMskUdg6Xdb1jyXSoXVa4Rvo
	Bd4qNt+RtWZmmKmRdYmx
X-Received: by 2002:a05:6102:3f8f:b0:7b3:8f0a:f76c with SMTP id ada2fe7eead31-7ccc32f27e0mr325464137.13.1792705723097;
        Thu, 22 Oct 2026 14:48:43 -0700 (PDT)
Received: from Biostar-A520MT ([187.94.15.233])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ec13deaba5sm443786e0c.1.2026.10.22.14.48.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 14:48:42 -0700 (PDT)
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
Date: Thu, 22 Oct 2026 18:48:15 -0300
Message-ID: <20261022214815.86306-1-breno3011alves@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <871p9h1kc7.fsf@trenco.lwn.net>
References: <20261022183658.58090-1-breno3011alves@gmail.com> <20261022185224.60700-1-breno3011alves@gmail.com> <20261022185224.60700-2-breno3011alves@gmail.com> <871p9h1kc7.fsf@trenco.lwn.net>
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

Fair question - the change is a conversion, and I do not have a RiscPC
with an Acorn SCSI card to test on real hardware.  Here is what I did
test:

1. Userspace unit test with a mocked MMIO layer

   I built a small harness that compiles acornscsi-io.c unmodified
   against stub <linux/io.h> and <linux/types.h> headers.  The stubs
   map readl()/writel()/writeb() onto a byte-addressable "card" buffer
   and a plain userspace memory buffer.  For each transfer length L in
   {0, 2, 4, 8, 16, 32, 64, 100, 512, 1000}:

     - __acornscsi_in: I filled the "card" with L bytes of a known
       pattern (each 32-bit card word carrying one 16-bit halfword in
       the low half, garbage in the high half) and verified that the
       output buffer matched the pattern byte-for-byte.

     - __acornscsi_out: I filled a userspace buffer with a known
       pattern, called the function, and verified that each 32-bit card
       word held the expected halfword duplicated in both halves.

   All 20 cases pass.  This is the harness that caught the two issues
   the sashiko bot later reported independently - it is not just a
   smoke test.

2. Cross-compile for the target

   Built with arm-linux-gnueabi-gcc on rpc_defconfig with
   CONFIG_SCSI_ACORNSCSI_3=m.  The module links cleanly
   (acornscsi_mod.ko), and nm on acornscsi-io.o shows:

     00000000 T __acornscsi_in
     00000104 T __acornscsi_out

   objdump on the resulting object shows that the alignment step
   compiles to "bic sl, r0, #3", matching the original assembly's
   "bic r0, r0, #3".

3. Apply to a clean tree and rebuild

   Copied the tree, git reset --hard to the parent commit, applied the
   patch with "git am".  It applies cleanly; re-running the same
   compile command produces the same object.  This confirms the patch
   file itself is intact and does not depend on my working tree state.

4. checkpatch.pl --strict --no-tree on the patch itself

   Reports 0 errors, 0 warnings (with FILE_PATH_CHANGES ignored, as
   drivers/scsi/arm/ is already covered by MAINTAINERS).

What I did NOT test:

 - Real hardware.  I do not have an Acorn RiscPC or the SCSI expansion
   card.  The unit test proves equivalence with the original assembly
   semantics, but it cannot prove that the semantics match the actual
   hardware - only that the C version does the same thing the assembly
   did.

 - Odd transfer lengths through acornscsi.c.  All current callers pass
   even lengths, so the trailing-byte path is only exercised by the
   unit test, not by the driver end-to-end.

 - Interrupt handling under load.  This is unchanged by the patch (the
   IRQ path is untouched), so I did not add specific coverage.

If there is a specific test or configuration you would like me to run,
please let me know.

Breno

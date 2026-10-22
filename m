Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792694245;
	b=DjhUXRiR/W6rrx7NLXB97udfXfCxHH7aeOSF/tbJfbAEjvGDovfIueux3bIvSKxmoQBt
	 2D7bvYnC2l8aSZ+2+9u42M6hReIWnqZwYhUYQzVqX5v+Ii1ZNhGpieaVVZD086brdpLHv
	 NUrkxt77qHr1t1zqwMKwCjT66I+lQSS+4fZyMJxs/TTwc5J80HuyffdWPOrO7mXWM1a27
	 AzduTD/LSLRzXNhnUocY3aEnsiCwssuK9pyqWp30aZ5juQQoKO8aUMGNpJWGf/Jy9kzOg
	 RK5YEb4xQOGNV5n0Bledb6pw/IdwvTkwzs2nIqNs7vrCe2Q6+LiDSVoL75kX1P3iB+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792694245;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Z5cUY9Mri59TRv/H7HqmFuQUWT+VeCjs07XpBmB92yw=;
	b=r9VjjUPNQRrgmqRbrPG/ILCpQ+l0L1El9nqdr3IPKHOMVubp/Yei+844tikR1mnELIWG
	 yHMOi6U+81YFtckxmF8SQkj43Zsm/wLSMC79LLTstYyTDe2r5iXv9VCrx5BCEznTz/ydh
	 B2MtMtlRjzn4WBo0oZtoTq0sP3ZwHrFhIYpOVKP1M2Fa3BIDKbD3jUs8xbNTzKRlnCABt
	 7gCk9xw1UUIwwjzMiYCwCoJLo4IPAjZZlB2WatE7jgNE41A5C09cjOcB5GktQK5UJJNil
	 dkRY2p4j7yJKGlwrK2sjZFA+Lw/LIlXcZ/OL0kS8F6XoW3EuXOlpeZWBTK402Ft4/jQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=UEasAaPU;
	arc=none smtp.remote-ip=209.85.217.51
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E9F60A380C
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 18:37:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B0E9F60A380C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=UEasAaPU
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-74ab99038afso32713137.3
        for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 11:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792694244; x=1793299044; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z5cUY9Mri59TRv/H7HqmFuQUWT+VeCjs07XpBmB92yw=;
        b=UEasAaPUjd3nDF4vej13dH1Om3zvRljHNuyyTcBA7mDNRUZiJzHADEPd84SWLelerZ
         HVHicG0Q5XQJ66XWIoPZW+en1HMuIlJmvgWkvAwEkKVY9s1FDG1/NgeRso5czLU53Ghw
         Psn/0XKMuu7S7eaXiQWEcam+7bTU+4Iz5kbMuZfTv8hnkPM8tiulYgJUzIb8p0zzlVea
         yy8bapxXo9HLYNv9cYldRh3692rdtuyfFuMb8kLVkoWrmS5r0MZuLGeYGQLd29UmE7Vr
         BcAYP5KEKxAJKnk8L8nf4EURTgi7x00AUbb6Jv+hmMk4P0DpyFxgy/10gDJS5/lSbemd
         YJRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792694244; x=1793299044;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z5cUY9Mri59TRv/H7HqmFuQUWT+VeCjs07XpBmB92yw=;
        b=tSEU6QENRT06FW9W+Gp8nplwzX4l4CF+rKi73CF4N+IowgRD0FiHYHhjoftxrr5sUs
         VnrB4L/z6YOzp2B18aNTezbIOKKf8iVPH09QfA3oskVo2Qu70g8HJRIFwqZmvWvc6tO7
         2CMsYdsROOlMA72OPBpVFl036Uwr57j4FoFyWqKaRSsXMOKE0uIUCRhFWskF5zlb0063
         bcKI35IUUdEijeoeRYwjyUaDJyEoQV/ErIjS94WNn4Cu8ySmM2I3LLcI7ywNCeV4/cHe
         xwgqOWDBiuSgQ5xlx2VMGnDQmA55D4oJICoM1CmXoFvT1icyzcEi7nosB7eSlCE+uN8r
         0xhw==
X-Forwarded-Encrypted: i=1; AKwUvBzYEfHH6QuWLYYDs/8/4E9QeVAP2WRXwaKCpccJiHiF0/rI4ggLNYIfrJNJe2Ter9lgPM0XFMwUM2jx@vger.kernel.org
X-Gm-Message-State: AFq9FYJRef/gSmmToovGlLKid5kAP7Qrio7EWP81nfttgkyb5egSIZ2B
	y61yUUaCD1nM7RJEibO21NXI9NFmkKkejcCnULWgVkS+/IeDujLy07OC
X-Gm-Gg: AYBFou3PFqr4b3lNgsAyW2w/u0FTeGcX3LnoqX/ncPkgEhZtMhHrHE8qsqIl+Q/AS4A
	aNTgE6I5E9Couexl5tNeTHjp6KYdEubvW9C44Bs+Cq7asrUgZEs4L2pOhKzP04zIFGV6PjG3B50
	L8dg+IBndYDOIcHzqbnBFfNry6Bx7DoxYxUMlNTZHIoX6oCrM/EEBNUqGWarMa+tenoCDIUkQP7
	qD5zt0hKEipAQlNjfD/UJ5PKCRV+QtlWMJPuicirjKvzSiqLkC+L///WG02YtmzHmnu1/ORq/YO
	s8mnv1Mw8lu1JAQXjg5poPhlqaIfOGwFQfzdvrKXabnbFVh6cRB9CuUeNPqcJwK5tn8vtkWfeaW
	XGrTdnp/i8wzMQwKOk72o1uOzijcYkJXCh4BbRI5KaidpKTgTQ2AvyTCmiEM1C8LnyX+ZvnA7Oc
	/fN1rDlyumYAMcefdJIdqF8Cf4x6hWQgfKifh1fNaUbk5/vD9zC2hqLclv5rE2LhCnUCR2vEBA6
	6M+323A/gH+dhrevxlwCqIjb75/nWsw6pJJMvxQDOy/JvKhocqhHKDeEJp3WMjFRVTJ8pVpP9ap
	P+GEyz03shKzvX8iMsFf
X-Received: by 2002:a05:6102:358d:b0:7c3:872c:8be6 with SMTP id ada2fe7eead31-7ccc33e4ea1mr127424137.25.1792694243526;
        Thu, 22 Oct 2026 11:37:23 -0700 (PDT)
Received: from Biostar-A520MT ([187.94.15.233])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7ccc2052f7dsm581623137.3.2026.10.22.11.37.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 11:37:23 -0700 (PDT)
From: Breno Rodrigues Alves <breno3011alves@gmail.com>
To: linux@armlinux.org.uk
Cc: James.Bottomley@HansenPartnership.com,
	mkp@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Breno Rodrigues Alves <breno3011alves@gmail.com>
Subject: [PATCH 0/1] scsi: arm: Convert acornscsi-io.S to C
Date: Thu, 22 Oct 2026 15:36:57 -0300
Message-ID: <20261022183658.58090-1-breno3011alves@gmail.com>
X-Mailer: git-send-email 2.56.0
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

This series contains a single mechanical conversion of the Acorn SCSI
card I/O helpers from ARM assembly to C.

The new acornscsi-io.h carries the prototypes for both helpers and is
included from acornscsi-io.c and acornscsi.c, replacing the
block-scoped extern declarations that the latter used to carry.  The
first argument is now typed as (void __iomem *), matching what
acornscsi.c actually passes; the assembly version had no C prototype,
so the original comment declaring that argument as unsigned int was
never enforced.

No functional change is intended for even-length transfers, which is
what all current callers use.  Odd-length transfers now no longer lose
the final byte.

Testing:
 - userspace unit test mocking readl/writel/writeb verified byte-exact
   equivalence with the original assembly for transfer lengths 0, 2,
   4, 8, 16, 32, 64, 100, 512 and 1000
 - cross-compiled for ARM with arm-linux-gnueabi on rpc_defconfig; the
   module links cleanly and nm shows both helpers as global text
   symbols
 - checkpatch.pl --strict reports 0 errors, 0 warnings, 0 checks
   (FILE_PATH_CHANGES ignored: drivers/scsi/arm/ is already covered by
   MAINTAINERS)

Breno (1):
  scsi: arm: Convert acornscsi-io.S to C

 drivers/scsi/arm/acornscsi-io.S | 116 ------------
 drivers/scsi/arm/acornscsi-io.c | 170 ++++++++++++++++++++++++
 drivers/scsi/arm/acornscsi-io.h |  15 ++++
 drivers/scsi/arm/acornscsi.c    |   3 +-
 4 files changed, 184 insertions(+), 137 deletions(-)

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794559222;
	b=GWjNWaAlbbRxgUzNYN2ByktH6R/1kwNREUTRGRGUa4QVa7gpTCw52fDfC0jZX6NSAAJ3
	 VYdr3Su9q17uQ+y9q9ilr/vva5teVkVNKeGX5AzS1EtimjHIeEDNGVulN8swZop21pfyd
	 x95LEtdQxby/IcWlCUHxNQRtOmUAOr8bBxQdD7NwD4CApntuXqdGqA32N2Thv9qtbelsw
	 pR5i2stodx0KzijN6atqWWi9TPK/BKBKmgMh2nB1awPzRJBuatbzGs3eNNbQeoEjcynTi
	 Rt4CzXgBSBrhEFOGM09Yz5JnNgH/hVYBqpm04K0mMiQyA5u5pbFbTTppQK1ucQXgyvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794559222;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lQZj+I5onjkuCEafsJ6iaagMsGU3FXN3YvHwXS5E/ks=;
	b=WhHv7MDvjpfqjsoieYa18k/ikrb5Otxp/R1ximHfBv7N2e0YEgfqQ8PrpBT2bsFWEeHY
	 Hcfkm4muCa4iTRl/ut6II0EvOYxePsHDbT7Ig/TsFr+3Tm+UGYzeF4XCVJ5e4G5loN9EL
	 POcI/tsgqcs1uWSnlVJL7HvJNcFGenkxaXVgZ3nXKZSw/UvMDjoVeqn1Sio1PFlKfWpNq
	 +mZFFX6Zs90UD3v3vH/dgqmtUEGoq40X/PdVsCkubC53DGGhQ+GBGx4SfCvaNKaajh4ze
	 aybsAWOCA/NrSaoTb2xBQpb9t3DsFv8PT+c0q0vpQuY+eJGnFZURfEfJnhGAD8LWqfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vMPn8R5V;
	arc=none smtp.remote-ip=209.85.215.179
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F69B606A334
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 08:40:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F69B606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vMPn8R5V
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cdb9f760337so890507a12.0
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 00:40:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794559222; x=1795164022; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lQZj+I5onjkuCEafsJ6iaagMsGU3FXN3YvHwXS5E/ks=;
        b=vMPn8R5VMR9iI0ko8VJph2JIkdkn5kHcbotl71V6RBCRzZ4xd+JdtnHZcwclEOOlY/
         ihl0rygCUBMSiarvtTlBqqMxkfY9u2CClFgwurx1TK6eKare1vnVRAbexXkzeYIh46SV
         QBmJ1zWroreUI5Fzah7tNXOGTJ49iiIe/KtjQF0YlrplHBFRmwCcAIMZfL8vJRjiQ+ca
         7H9i3Hf4bT5R4NybB0h2twif9li5VoE42xYo2GJwYc24FbcbQw2OB4p3uTSZnbb3qqaI
         aMPWa6E4FT+mG8x74fpTtNJmAz8QYIfmmsQxJcv2IQ2XJk4eU+1//UWlcQlI0bDVtwUa
         yIvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794559222; x=1795164022;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lQZj+I5onjkuCEafsJ6iaagMsGU3FXN3YvHwXS5E/ks=;
        b=JThjyI2EB6A9FgqEme6WJkAniHczpV7Fv3vPMK/y4ZSdw815JcJ+Ho5TLTwYpujv/i
         zbD8YUBMikYbI9DqgzdZJcjufJUjZqwNvpLeSQHxdAnTLVnLF5pDCVvvb2u3G0d2rfTk
         bOs01GEbOCRABhUkRHYyVKONDIIvS8NEU7pvPhMlPoOkk5a4fq3rz4/5bOB/UYWBSwAs
         UYKnS6pCXSaY+nbLe/AT7jsTvX7sTgXngzGq5gn0eH8kx/aw9O3Uzr7jtouZNOHbHNq5
         wB1pY29BQlDfAfY0kNHVklUbTcpttNCMnDGTB1Gcirq4yZxEa0rTs5FxIGHpfK0BhJa4
         OA3A==
X-Forwarded-Encrypted: i=1; AL+hErFYQ7sFZQ7UBT6KNytVX0UM+u9LZOYhY0xAr5IJSFdl4lUbPE1GUi5GSg1xFc5I6sgRC/lvrkZR0cpG@vger.kernel.org
X-Gm-Message-State: APuU4Z+upuqD0xwWURT9IG8LScCI/tN/EwzocWTXfhZIOQl75FftfjTF
	bO/e8v1k55rnMwG0ozKi6B2pz7y3mjg4wrNBh+Vgm9dUJWGPrTqrTWFI
X-Gm-Gg: AYBFou1d+JLLij5ys+bPo9OxpgONqYQFUglfj4u78YNkv7Ux2vJ11SWFAaeLegMODvc
	7rFGdZJD33C8iiHzQGotI/smZTT/OXlyPZwcq3VNP6/LCf7yNvoFDJaq1KF2yRNBmIY+E8o/nnK
	F+VlEcPY3t43QqOgYn4feCc5xJTNLkIZ6o7+zNPj30ogYB9ylRenASEqEQM8Q8/M9LHtNWm5FlC
	yMBc2UmAzlWXwwb0teJxJx6hWs1zP/YVSedkxF9bY0RFgOTwMxT8zCOmFmO45MYzu20B18A/FAW
	4CQ6khzuMi/TxUUVKF2Di+2Zg9c9///AXlmQgByEWkifGJH1PW9OhU/wIoluzFAMC5LKTVbl67g
	Y15+WHq5DGlLEJ8Qs646HSPJwKayK9oLHO+RtKX3yzjaCi8nECoiK16KCEMUTsAHAlOXjdRSAjy
	yKwu52gxuUaxQ+gM9hzoo4iScNF95BLIxTpkCldk+IDYHap+21Imt7RLY3p+AeKSLawfN/4xmZQ
	4EwNYf1yJLzD71isL8zJ7dblM2dl0yCsYaogCfApPoDxqT7Kp+vRvIdlvTuuOd2oCAh5f0odcIN
	19sLP0uJsRkb/+R6Dt91Ris0ogkBtdeX3zg95OdwQBlIY6Sq931OMxDoAOTGT7o=
X-Received: by 2002:a17:90b:4f41:b0:3b0:a1c6:95ae with SMTP id 98e67ed59e1d1-3b1b0ccfbfcmr894078a91.31.1794559221886;
        Fri, 13 Nov 2026 00:40:21 -0800 (PST)
Received: from localhost.localdomain ([183.62.176.219])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b25a365asm1264855a91.1.2026.11.13.00.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 00:40:21 -0800 (PST)
From: Yong Liu <pkfxxxing@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	security@kernel.org
Subject: [PATCH v5 0/3] RDMA/srpt: Fix command initialization and read buffer disclosure
Date: Fri, 13 Nov 2026 16:38:39 +0800
Message-ID: <20261113083848.1517595-1-pkfxxxing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <92a82300-a454-4ee5-a191-0ce5a2ee58c7@acm.org>
References: <20261110030809.913063-1-pkfxxxing@gmail.com> <20261110030809.913063-2-pkfxxxing@gmail.com> <20261110052827.963143-1-pkfxxxing@gmail.com> <20261111065342.1282709-1-pkfxxxing@gmail.com> <20261112094138.1390409-1-pkfxxxing@gmail.com> <92a82300-a454-4ee5-a191-0ce5a2ee58c7@acm.org>
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

Hi Bart,

Thanks for the review and suggestions. This revision separates the BUSY
initialization fix and the target core control-read buffer fix from the
SRPT descriptor validation and read-tail clearing fix. Together they
address the NULL pointer dereference on descriptor parsing errors and
uninitialized target kernel memory disclosure to an initiator.

Changes in v5:
- Move BUSY command initialization into patch 1 and explain why the
  target_init_cmd() return value is ignored.
- Clear all control-read SG entries in target core in patch 2.
- In patch 3, log inconsistent descriptor lengths and zero the read tail
  with one sg_zero_buffer() call through the command's chained SG list.
  Remove the SRPT-specific DMA synchronization.

> Do the SRP tests from https://github.com/linux-blktests/blktests still
> pass?

I ran the following against this v5 series in an x86-64 QEMU VM using RXE,
with blktests commit 79c32fb31b7bca6a4383b749030128683cf6b6b4:

    USE_RXE=1 ./check srp

Results: 13 passed, 2 skipped, 0 failed. Tests srp/003 and srp/004 require
legacy single-queue device mapper support, which is absent from this
kernel. The multiqueue test, srp/002, passed. The kernel and modules also
build successfully.

This series is based on commit:
f66469d9905b39d2c260a15d7d6db450f4db67c1

Regards,
Yong Liu
360 Vulnerability Research Institute

Yong Liu (3):
  RDMA/srpt: Initialize commands before returning BUSY
  scsi: target: Clear all control read scatterlist entries
  RDMA/srpt: Prevent uninitialized read buffer disclosure

 drivers/infiniband/ulp/srpt/ib_srpt.c  | 24 ++++++++++++++++++++++++
 drivers/infiniband/ulp/srpt/ib_srpt.h  |  2 ++
 drivers/target/target_core_transport.c | 19 ++++++-------------
 3 files changed, 32 insertions(+), 13 deletions(-)

-- 
2.43.0


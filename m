Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794620683;
	b=Qni56SS7uY5VfdZQiTalpjYYb+mcnYFoGAbNtOXMzGQYMU1Sh1QP75QsSG/Rfk4s6avX
	 tDcnk6/C8qJ+Y52SH4UaWVRChZtq8JinyFhgVnM6+Yw1awlNQqcX8O7XKHnSBCgkLE2FN
	 RRipXjs8h+WWTY1d9R3DqLmS2MrEmuQwaX/0zeFGW+xYAe2AATH9SP81vSQBIfM4A0e9U
	 5/1tCiOjQHUk7IseJYbjvPvbTyHkfWDwTHpXMKr2C+jBdrApEY5wnwtOb8zE9IuGo1CV2
	 j26n8GOioa9tycyP2DCXTXi68wa21aYsol+dAQRWMrgDAGd1CR9u5Bsc8srtaMyK+XA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794620683;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=OUIhV01zym7F3dnaq+SSRF5JFvrIUpSj3DyEg3o3VF8=;
	b=vSiL0cpXior8a653aGa3dotlNXCMMu7Y3krtiGT7nuK50b5zt6cP1StpajK1sTpfODHL
	 WQf+yCn1HnsfeE7LdQg42Rlsw6jBFnACsIG/xmPtfw/BDPwPo/dZyrsgRB7ia1pe3ZDeH
	 Q3V9HejI3FMXH++fwt95hXVBLYQqCor8Hzhxl4VAhmzH4IiCnc9Xsdz79XiRVCIXnZ/Pu
	 1coLbgv9ehK3vBSjU2eOuNyTg2jfmsfhS0derv18LOSn/G3kn4/m0l7F5d5tnnEyBKrF1
	 dj6nbPjyS+hWNHVNV1Q6ziFdKkc437N9QF/O2QrUJKcOR8m/GtnVwz85wE00XvqYsvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=dpxisuUi;
	arc=none smtp.remote-ip=209.85.216.43
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D31E606A334
	for <linux-scsi@vger.kernel.org>; Sat, 14 Nov 2026 01:44:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6D31E606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=dpxisuUi
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3b1535be329so1485676a91.3
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 17:44:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794620681; x=1795225481; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OUIhV01zym7F3dnaq+SSRF5JFvrIUpSj3DyEg3o3VF8=;
        b=dpxisuUi9wEtB98CoBktt1y+AO+7yYlw5tQxa7E8uRVwh6KCwhmJtxdJdHmMDTggc8
         2SAj12OWFEsQ1jEJ4PDMh4w+vbAb7bjNnlQ6MvuanitTRl2g80ckQOOpBSjFrFUkr9j7
         G9i66NzkiSUNEHEJTQLd3vPeutfVEU8fs3Wj/amyJGSoizDlJaUfFFsGk5OeZqkac1kl
         x++lQuy+QXhcHPmVt3Hn00YunjNHVpva7tfGgeFoJDq7x+E3cDqR+OdaiFDJ7NmzZEyl
         GW4oxPJfEX4glxahyq4JPgEi1noP63GVQ+m2jh/zitUXp7MRwA0SZptrWrKvUuXmIsms
         7h3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794620681; x=1795225481;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OUIhV01zym7F3dnaq+SSRF5JFvrIUpSj3DyEg3o3VF8=;
        b=jzgvv8jI4rz0XJuN6hQcC0/0ArN8u3VpaIa1RMKt55M/R+u/oxSkA/xMBYR73scsMm
         7/oft36Qo5L1mrYR4oH4/IREwwDe1r8MY3ZlrzCbG61EmulxijTehtPIvikOsCGMbb1b
         ferYz+O4bHAJU3QmGjyQimwIQPeUI9qZdpGeJ8+90wOJtnu8kfcIqhPx2al1kkIv6tPj
         nPpJis5bMVyBEqoec8CurM4EJVSml6dgkWJ5Lw/HeZxu8Lfp0O3rFimo9oTpAcHTWXNC
         OMVXu5KIzkbZzIYAgyVh00TVeOwlotfARHHVGAhV8orKgNDo2KP5nbdNh0ZxACSHzWRL
         8CQw==
X-Gm-Message-State: APuU4Z+CI/feOvKcLbUWklO+qOoU1FF0PTCHnwrKKFf2L7annlPCr9oe
	4PiJSPioMkla5DqcFKByj+nnCp6imbF8IUr2xyMbDA4GH7rhfzLoJQ+QVvbNS4cgsP4cvcTLK1y
	Uo2iQrYGI0g==
X-Gm-Gg: AYBFou1/ln7Mb9F2NVKGZ6c+zm7ozwWaEPsscGdH1L0/PKv2qJS0t/dDjIBNba+Tc+B
	eHZxLIjiCoHlpdZMXoVlo8m+wh0ohDrd1g5L43OFglStC/pQeqir0XrWZVmvMY2o6Yqbx3a+iEi
	l/lYLd55pRHy+0MTJ2HTUZnN7UGDOV78sJU659P/Vo8G4QZKTJ6yw3RvM+e9kO0EALmrBTFkK39
	bNStPVfLb7PGuwwVoKQzPNtPY1PdEN8uj82FxLZaEyz4u0zHAVWC4pecfKlsRjUno1KGeLq4hU6
	oD/4+82Fajyr+3i0ov2q40ptw6UHl84d6rGLdmfDmpOEzs8raUJWcDEg7TjwQTHJfMaA7CE00Ic
	iAeRzlU1pSHbDwtnvydnI8+HSpQ5OvFCxzVKnl0fGu9jE/X8Lq3y7YwdtNs0699gHTcHVExhvF4
	ibBXrb/wvoXC0d0e6Chbu3So2TKrAV+envFk+ag0GzmKEWRXJzmhPHCOwUxd4L4Vti9sxKSkGbf
	uUDkvfIoHErD45zo5IN6Xc8nfIIU6m02MJaWJ7YOWfegqJnXS7CQD6R6DQY1DChjsZzqc01WnQw
	Ic3E/GBC4+6LzlKGjNVL+AN5UfNHO8B8+GM09uo+crunaIyYemKTQQCNQKWA6ISdibOMtch6Mhw
	kGIJs5REbNo8gjPaclk/AY54AIBbL1zVH9o8Zx/jzaJ0O9a9qC6oRzVdfeTY=
X-Received: by 2002:a17:90a:e710:b0:3b0:9941:8d42 with SMTP id 98e67ed59e1d1-3b1b0a0e108mr4042515a91.33.1794620681401;
        Fri, 13 Nov 2026 17:44:41 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:f861:b117:6318:c068])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b1e9ef15sm3437082a91.0.2026.11.13.17.44.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 17:44:40 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] scsi: mvumi: do not free buffers a timed-out command left with the device
Date: Sat, 14 Nov 2026 10:44:28 +0900
Message-ID: <20261114014430.489668-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
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

This is the follow-up I promised when answering the review of v9 7/9,
https://lore.kernel.org/all/20261015055719.3992456-1-yhlee@isslab.korea.ac.kr/
and https://lore.kernel.org/all/sashiko-outbox-172292@kernel.org/

1/2 stops the controller bus-mastering before mvumi_detach_one() frees
the buffers it was given.  2/2 keeps a timed-out internal command's
buffers until then, rather than while the controller still has them.

Based on mainline; it conflicts textually with v9 7/9 of
https://lore.kernel.org/all/20261015045213.3975845-1-yhlee@isslab.korea.ac.kr/
in mvumi_delete_internal_cmd(), and I will rebase whichever goes in second.
I have no mvumi hardware; this was checked with a KUnit model.

Best regards,
Yehyeong Lee

Yehyeong Lee (2):
  scsi: mvumi: stop the controller bus-mastering before freeing its
    buffers
  scsi: mvumi: quarantine a timed-out internal command's buffers

 drivers/scsi/mvumi.c | 42 +++++++++++++++++++++++++++++++++++++-----
 drivers/scsi/mvumi.h |  1 +
 2 files changed, 38 insertions(+), 5 deletions(-)


base-commit: 97d73c8251226cf27cc6656b4c542869bb8c69fa
-- 
2.43.0


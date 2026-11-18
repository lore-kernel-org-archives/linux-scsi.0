Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794975238;
	b=yEOIb//PN0+CAvD6QE8mCSwSHSUlgFfbzB1gDK2jMz6U8R0VLrqa8Jpw9xKlkTOSAg/T
	 aXjTxBmW3AdbfsmTy1S02Byj2X6c++bXZ7aVJ9htfrvmzSVjd56SmN6NBe2CEpSJi4Nzv
	 kGsXvqNKfsBVH4Ww8xr+oiCCj+WhSZDWYROh0dRlLXU2UE4O8THkSFfX6tJe5svdffedJ
	 xA73pGj6EaWz56j6Ww6QkjnTbiE0WoR/iIxdE/H2OtqpPDg1Dl1qi4KKRZMaFZhcc+rM9
	 TIThBjiTH0dRfzSThATmS+4Kydz/wOGae2GOe6oikO/ZpQZgT1XsbWFKg83K4Ab3IqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794975238;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=Fu1m7ZEN5/rsF3HjhNuEgJi893J5oEhA5qYrglHCai8=;
	b=rWPaVW47qixcWw83FPrK0vZ1tjjRzC++QaEW0jJ0AxoWEa/0dRzcknsv0cmVxiHBJcQN
	 laW7wYGHXRiRu91EOybMNV+KIj1OVGjvlWfJWkfD+9Q5TxncLvE7Znbs9DFbwfNpofNu2
	 I4KHAH022nWfOF/J3qNVVBk5H+VS2mYr0h1eK/QwR+n4BEVC4K7qle1AWU9ZRKLus8rxt
	 Qaqg0isuM8L3P+CcPPzoRWL8OXBs4/J7MPmRbhxX0FQfzV0SE7d6f5CnTP1kxhxK6txy0
	 AsrPOwLGCZ+oQu5yZVTKyaI/Pufk5sYse0oAb3fuvws57oZ/4LQtHBBUKL6vEg0yG1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hHzlUa3L;
	arc=none smtp.remote-ip=209.85.214.171
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC64606A331
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 04:13:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2FC64606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hHzlUa3L
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2e9ae391a05so2856885ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 20:13:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794975237; x=1795580037; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Fu1m7ZEN5/rsF3HjhNuEgJi893J5oEhA5qYrglHCai8=;
        b=hHzlUa3L8oeFVoRTNRPd3jqxrDytrnAMuKpitUROtse1WA+Pl3Ra/c03SJlC9mrxnb
         ZeGrJTHM4ct9uXLmcR6NuNrizvLVQEAbItCIDoXtVdBdohe7e3WGUBqY20K1ecbPjl+2
         HQeE1p1JNs9jVkZVr4UGGWb+nAeaAC7/WQU4yLNDfmcxjN97IkGBDGOmjuzAV/ZKtQ+n
         w9TnNVX4n2e48KuWahKY2hpM3EcOm+x/hU8Lu+PeZL45joaBfItFaQduz8vJ3/3At8cA
         mUP64ua8GzRtyapA/8C0ET8wWM80K98chEabonISWm6rh2KkjlgadCFdcqOrQ6UxWJS8
         nWNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794975237; x=1795580037;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Fu1m7ZEN5/rsF3HjhNuEgJi893J5oEhA5qYrglHCai8=;
        b=DvFjRUM9F094ayqxDIblNnsTJ7JAli7OQqQymlHuLJaV7WRv2/lV+OpMKcIgBDmsxX
         5O0ii/bjMYi4vydiYVVNvxgQ7jAlkiYi7QYd5B39FCTrZCKMOhIozH8tXPreWLzurGNV
         aXlBW7YkYGZtymFx9sWjwN4Rw6UgV1zhGERlmewebK5CrdngKh/QGwLgRD8GTTXo/kRu
         dDWsbA2ClsRrIXPWV35UzYcAfPXHwBLhC9ugYJowv3O0A9oFv2ET+Odswb1A1Gx1xEQF
         o0SiTwSPlYjuunw5gERglRFHVzq22noXosR32lCH4jbLkVRhlpiI50QtQRL8UKpf+vby
         W44w==
X-Gm-Message-State: APuU4Z/vgXLEOcoDaFj3gXSKXLYiBjpaspwGi1OdaJZXbL8m8LATcicg
	0X6Gb69rCTQYSDFW8DVwm+izmIkDss15U6veDm/CQuqXeis9/vYoWupo
X-Gm-Gg: AZFdTZccvNX8iBK5xfFGbKlmI3gu5Gf2Dl3y0WNGqJzHkX1UYdPBcL3GhxiVK9Y/i8z
	Gi2bZEs/4y1yJa/dbSIDsKcPFKvMJ6MfTAdm/jLtBONntvtTWJ0IcxG3sJIJCLggfQ5oLjR6spZ
	L+C1C16dNDlRYXQdl5FZ5COvvWzkGHUQMcSZps9gdYlBi87izb1abIKlPTT7l/WA9Z8BpUL06s+
	hdJiJJuPKVqLdB5ON/C6X4giShe545JS2RgvO51x/lTg4yPBKSglYXjFlmYaVOQzH9JUAjczQ0H
	LYN2gwtmvy07u1G2WLXH+ckuefWYb2kISi9lcemw2/i5/YsI13AdcMv8J1FKgZhP4ER42qswSam
	dRRdR4/aath/02m5OMc2Yv77mqItiLbh9RoWNIrMOmhf6E15WTGhtZ/Knp/XiYnYkxpdhCtt1Yx
	rUaE+j/mcSRPKjbbbd34NkjGAuMP1jAkNgYApxWwlKA9WnQlrQCtIOP+HPgG76lAwI+f6hEd3R/
	F3V1ctKxq1twSu33QaxOqupm6+YTXPxJNwzoybhKkUSAOw3PZj8+bVy6G5oQJZDYfktDIzM1C/M
	34/aqPZ0S5vQv3gwJ8muBA==
X-Received: by 2002:a17:902:f683:b0:2e9:528c:b9ea with SMTP id d9443c01a7336-2eff72fa3c1mr9708575ad.11.1794975237447;
        Tue, 17 Nov 2026 20:13:57 -0800 (PST)
Received: from gmail.com ([2407:cdc0:d002:0:188:253:12:32])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eff6214f4dsm5728685ad.43.2026.11.17.20.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 20:13:57 -0800 (PST)
From: Jia Jia <physicalmtea@gmail.com>
To: "Martin K . Petersen" <mkp@kernel.org>,
	Jan Engelhardt <jengelh@inai.de>,
	Hannes Reinecke <hare@suse.de>,
	James Bottomley <James.Bottomley@suse.de>,
	Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jia Jia <physicalmtea@gmail.com>
Subject: [PATCH v2 0/8] scsi: target: keep command bytes inside the sg
Date: Wed, 18 Nov 2026 12:13:03 +0800
Message-Id: <20261118041311.19011-1-physicalmtea@gmail.com>
X-Mailer: git-send-email 2.34.1
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

This series fixes eight target-core accesses past command-buffer or sg
boundaries. vhost-scsi can supply guest buffers whose sg boundaries do
not coincide with command fields, logical blocks or protection tuples.

Patch 1 builds the COMPARE AND WRITE write sg table from the entries
that contain the write half.

Patch 2 limits each REPORT REFERRALS LBA store to the bytes remaining
in the response buffer.

Patch 3 rejects SET TARGET PORT GROUPS parameter lists that end in a
partial four-byte descriptor.

Patch 4 lets sbc_dif_generate() write an eight-byte protection tuple
split across protection sg entries.

Patch 5 lets sbc_dif_verify() read a tuple split across protection sg
entries and rejects a partial tuple at the end of the list.

Patch 6 limits each CRC update to the bytes available in the current
data sg in both DIF generation and verification.

Patch 7 checks buffer lengths and uses sg copies for the pscsi MODE
SENSE write-protect byte and tape MODE SELECT block descriptor.

Patch 8 makes sbc_dif_verify() advance past an escaped block spanning
multiple data sg entries.

Patches 1, 2, 3 and 7 are independent. The DIF patches 4, 5, 6 and 8 fix
separate bugs and are posted in that order: patch 4 can stand alone,
patch 5 uses its tuple-copy helper, and patch 6 builds on both. Patch 8
covers escaped blocks, which bypass the CRC walk.

Changes in v2:
- Keep data sg advancement before the escape check in patch 5.
- Retain the existing atomic page mappings in the DIF paths.
- Fix escape advancement with the existing cursor loop in patch 8.
- Use the existing sg copy helpers for pscsi mode data in patch 7.
- Correct the Fixes tags in patches 1, 3 and 5.
- Explain why PI generation reads an existing tuple before updating it.
- Shorten the commit descriptions and retain the relevant trace frames.

Jia Jia (8):
  scsi: target: take COMPARE AND WRITE data from the write half
  scsi: target: keep REPORT REFERRALS stores inside the buffer
  scsi: target: reject a short SET TARGET PORT GROUPS list
  scsi: target: copy a DIF insert tuple across prot sgs
  scsi: target: copy a DIF verify tuple across prot sgs
  scsi: target: limit DIF block CRC to each data sg
  scsi: target: keep pscsi mode bytes inside the data sgs
  scsi: target: advance past escaped DIF blocks across data sgs

 drivers/target/target_core_alua.c      |  29 ++-
 drivers/target/target_core_pscsi.c     |  37 ++-
 drivers/target/target_core_sbc.c       | 422 ++++++++++++++++++++++-----------
 drivers/target/target_core_transport.c |  11 +-
 4 files changed, 338 insertions(+), 161 deletions(-)

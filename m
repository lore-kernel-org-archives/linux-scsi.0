Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728D478F45;
	Fri, 11 Apr 2025 20:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744403851; cv=none; b=fFt7/z9Wu+3Uyae/nUqwsBhW9X6sFBAkYLD006fWTiM+sJojBqvjK3b7ZV9MheFnQ/vxKzZGPGN/yD2Mv3flTfNR9bTEr8K+uzF3Ylq1+7bUBZjdP0nui+Wh2dCTzWgh7/ezt25esLXuVzXMNRktt4pGj3dPBjVwoRdnDruCIIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744403851; c=relaxed/simple;
	bh=oIWBKkXkkO4Zh/VDrurxg+HNlP+42/RW0fj+dTWJ2KU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jnfQLxtZBLu0RE1tX00KF7Nl4aRHzgA3aWtix/hsh/UDiyBPBO8LAq/ydpkFxtwPt0XDN/Ya+TK1odsWxgt9xhm7pxdCyOBq4WHmHE2kpI2SFIm1K0/E8jF0pV4gbbTqY1+ecIeZlCHKWuvy05KvxqewqUMfeaiRworGknkZPyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HoqY8PpT; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HoqY8PpT"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-6e8efefec89so21189516d6.3;
        Fri, 11 Apr 2025 13:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744403848; x=1745008648; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pDw/ZTuHFnJesj//SiyqIBnca/7W39lBjmBrmXxiUuY=;
        b=HoqY8PpTC8xnPh6obHMcHrghSk3o50sMcDeqa5azhhSsbRkWXDh7VQ9CYzzNCmoonC
         tfdd+SW9Kv8m4WBaK1x7G3qb034SDEeu+jijB0jH5X8S87dwUGw9rKR4IU81siACZRyK
         IzefTZmKZIJZvNlc2ihINr6bSzF7/oMMtJHXUZpaOUagodIiIPPs5T5I0A4qotaFv+LX
         uZWoMVFMJUkt167ZGdmy68wAwscd0P1EW0uYHe1wAu4nbdcm8glf59EYmC+tyWV2hYfW
         FGL0sVsxPAlNpjO6Hw+p8tcQT3fI2nVIV+esCw09pSnqZsMGLAVgVjZmC3QbdBgfIZYj
         UHQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744403848; x=1745008648;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pDw/ZTuHFnJesj//SiyqIBnca/7W39lBjmBrmXxiUuY=;
        b=uCKU+3vTo2mcC2Y+zAO0dPNgWRGEkgQpZYWm/Hhd/wE8ps9WmTWV0s87CdK3b0VBG6
         KRAk9jN5UEQMo2ZC49Lhm6c3cT9f2j5bqg1K5Bx7GtWzUtl+vdhZVc4xJ/x6I2Zmq4R7
         zfEAnichxc5ebJCGREYoADaSVS2A0R4ZuDAWWVyzRaTupW4+MfN3HBBvULQYMkv9UMyt
         VrWBAK8mTkjSias7hfa/Q3Zh3dEVPxjxAbtz2lPO6Wdi/pG9E2lwSGgXGW0XvFV2Pf5d
         yMLm9a/0INwd8f+ymBV5eMwYYUXcRPibRwAFJqP80KZfrwiGTYoeIZykQWdr07UL70ld
         nkow==
X-Forwarded-Encrypted: i=1; AJvYcCXzvRNDfkouUD8veGl/NYKnGTozJp1xT6o0nRvsXUSg+swcjZMfju2+BGAvtPMhqvsvFi8iHLGbpabf@vger.kernel.org
X-Gm-Message-State: AOJu0YxT1vAAxD0oqFE3xnYemb83lY55Ugs06x180cYuPVpuC3HL3sL9
	uZ2Ml8Q019DwqK0j82xMCkM2Y1qtnIBh+zTNnXRua/RaOJSRQNxsLCqhwUfo
X-Gm-Gg: ASbGnctXVKeEinWiQfK5PVodKlfVb/54YptMxQLOtvWv4xmFgmJ39/adpTiEI/sj5iY
	MeL0iHSpkAFbIb1UaogLJqsGXWL57/Ue1Dke1ydvqdqJ6dpIDJk63VYstGAHpt/O1MAkZJWGyNd
	yDcJ1N4xuSvqF1vVhjt+a+UvM4QGdc/beMqLj4m0HLWWXImrrJoUxql51hgIT0clV3zvuYq1VS+
	FqMlms0TcbuNoYSvtiw9TSADhRLeB7yVVlRZ+WH4LlDq0Rllpi91sU72soczkbHnhc6UN33+hO0
	UJx5GRDn15SSYeBp8tCnyEBzK/PDYjOKRG/Xnwj7sfkUu3shtqOzmoFvhSFMkfVi3B4=
X-Google-Smtp-Source: AGHT+IFKJCiPL/txs5IUnRij57IfGbWPux7jawiwWcbebRmXf+IJZF2m3W142hBW8wEjgv/207PJkA==
X-Received: by 2002:a05:6214:ac3:b0:6e4:407c:fcfc with SMTP id 6a1803df08f44-6f230d55380mr64312606d6.4.1744403848149;
        Fri, 11 Apr 2025 13:37:28 -0700 (PDT)
Received: from localhost.localdomain.com (sw.attotech.com. [208.69.85.34])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f0dea10681sm41165856d6.104.2025.04.11.13.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Apr 2025 13:37:27 -0700 (PDT)
From: Steve Siwinski <stevensiwinski@gmail.com>
X-Google-Original-From: Steve Siwinski <ssiwinski@atto.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	bgrove@atto.com,
	Steve Siwinski <ssiwinski@atto.com>
Subject: [PATCH] scsi: sd_zbc: Limit the report zones buffer size to UIO_MAXIOV
Date: Fri, 11 Apr 2025 16:36:00 -0400
Message-ID: <20250411203600.84477-1-ssiwinski@atto.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The report zones buffer size is currently limited by the HBA's
maximum segment count to ensure the buffer can be mapped. However,
the user-space SG_IO interface further limits the number of iovec
entries to UIO_MAXIOV when allocating a bio.

To avoid allocation of buffers too large to be mapped, further
restrict the maximum buffer size to UIO_MAXIOV * PAGE_SIZE.

This ensures that the buffer size complies with both kernel
and user-space constraints.

Signed-off-by: Steve Siwinski <ssiwinski@atto.com>
---
 drivers/scsi/sd_zbc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 7a447ff600d2..a19e76ec8fb6 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -180,12 +180,15 @@ static void *sd_zbc_alloc_report_buffer(struct scsi_disk *sdkp,
 	 * Furthermore, since the report zone command cannot be split, make
 	 * sure that the allocated buffer can always be mapped by limiting the
 	 * number of pages allocated to the HBA max segments limit.
+	 * Since max segments can be larger than the max sgio entries, further
+	 * limit the allocated buffer to the UIO_MAXIOV.
 	 */
 	nr_zones = min(nr_zones, sdkp->zone_info.nr_zones);
 	bufsize = roundup((nr_zones + 1) * 64, SECTOR_SIZE);
 	bufsize = min_t(size_t, bufsize,
 			queue_max_hw_sectors(q) << SECTOR_SHIFT);
 	bufsize = min_t(size_t, bufsize, queue_max_segments(q) << PAGE_SHIFT);
+	bufsize = min_t(size_t, bufsize, UIO_MAXIOV * PAGE_SIZE);
 
 	while (bufsize >= SECTOR_SIZE) {
 		buf = kvzalloc(bufsize, GFP_KERNEL | __GFP_NORETRY);
-- 
2.43.5


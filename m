Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.227.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793168491;
	b=UbfWk7hdn1qVEbvdaF5riQUyxXZ9av6Uq5Ka3lMRRjtNOFRQZ0VWlUljW7tvf8ueRBR0
	 s8Mb2N5P30bQJuHJKFYljpDzWyQqrx/TJwFKOytdc438rKJG5Yv7kIaSFMGvys9hZ3I1G
	 J+0qa+WrvbhAjagqaBWba4WotqHvIsaMrR8fDpIjlPawC5TF99UxJbUPXu2Y5n04kCHcn
	 BZZ/xhH9w4dyaMdX5GrL+aUbveAKdWTJ0ZFADWVOets+BAIY5QKAR+FJ/3QvKYxvUvtvW
	 mUNUAvuNggi26yX3s2Qp0zcYdzxUQBQ/OInvwoIy52FodFgTuohX47CPHaJiUFzmsjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793168491;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=/05ZaCRLQ9lx6QfXSfycpdBANncM/d6CKhfzXQZzHNE=;
	b=jUPXpdRPBluRQVMyujSUOgmTQXpBQ91FlwhsteUMpN6ae9+BYrWhXnN3Vtlby8hTu6rV
	 JQT3zfZnWYLNSwceF2fInpCxsrQk73pvuGv8D9L2TxX4ilAC9nqOqk9Xsl3S0Ofsw2fe5
	 kZTR3D47Yi9/1vcngpxJWkTNGBBXoPvXLXXsXopZZHIoD3wEr2qF/LbeO0VrngaqOdxCQ
	 Mvyc4lcdaJ9f+XAs4Q0S3QrEuwPBI6OMz36pl9d3FGmrYiIB4XCVPcq1sIHQSMjPTnuDg
	 ugVb91ezvpMl1qN8qUIDDOS8y57pKJWUlJrC6FhrFtFC2DnJEaibtsDsPeHL0PNxukw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="hOlg+nA/";
	arc=none smtp.remote-ip=74.125.227.130
Received: from mail-pj2-f2.google.com (mail-pj2-f2.google.com [74.125.227.130])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E78606A31D
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 06:21:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1E78606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hOlg+nA/
Received: by mail-pj2-f2.google.com with SMTP id d9443c01a7336-2e61817b178so1923295ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2026 23:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793168490; x=1793773290; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/05ZaCRLQ9lx6QfXSfycpdBANncM/d6CKhfzXQZzHNE=;
        b=hOlg+nA/4j3I+dum72siK93wRo/zZ5R0RYTABviO0iUbEAPzLR1Cn34yl1rcxDv97W
         u6sO2IoTkPGl4Jg67O5IQCEC3OXgZFKcL3YLDqfg9+Csvg2pw/EijY9vfpOPmRxSYpy8
         v0ElFL5/4xliuJZdTng6X8aCZ8GEi0sfl2DQdFPnD6QO3ZHEZepapdAC2kS+vLHW8C/X
         3CnQEOqinnayZ0ydRKNX1+BkSQ4iDh3097DIQp9VZ0rRyQBKgcH8M6AkNtK8uYQGowkw
         spxxCmzFxggsJ1SjimGPxJu4Bu1t5bHpn9679QGR9+OlSh4OnO3mDlUBCedmdiu9C0NF
         rYgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793168490; x=1793773290;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/05ZaCRLQ9lx6QfXSfycpdBANncM/d6CKhfzXQZzHNE=;
        b=D0qrdStGzUNPwv9J0xpYb/RD7a/C7viVoLAZ91u8AmiGjGFhhRv7TfOlgD26kRyVm2
         nUkfCk+tJ9d5SUSc1YvESF/A7VBsKNdwy8nN8rt81uWgtpcNGtbUIewl14MYm8wbLNzu
         zjdLvSNKFRi/T9QX1XtzK5ZhHmUMCYrHSWP7bicLkAxiboHmpe7GQOYSQi1nxwIfqPLR
         CJFrcEwXpj92DZuz50ArAv3CjrzJ3mCERIacmsF6WjpDRpbV3GE0C9jy2Xj0NpSFk5R2
         4o/PQKV+p/OGtVREzkwwvsbDXBRZzmFC7VbSIChx63OK+wv/erTb6RfDPTPPqhMYfel+
         2lNA==
X-Gm-Message-State: AFq9FYL9MTb+doBcjARPhX283TJrTADZmKvJSxrmn4mhiGWZIsgBZdCm
	wZcHssNRX4KNEojCr/qCk32ZKXEMOvvvRDDt7f+5MsgNhzSyNO55FjOp
X-Gm-Gg: AYBFou3fVeb/o+Bhu4JKzYGNLwTIeSsb/whRz8YpsC6UGhx69QbQF1tQNXDZAxmI16w
	AtuksjNeF5Px5x/yTJ/sxSxVKFuuaMZpTgw7ilKNuG7fjIgQ+NZqXFgU1GiPPqMJYoZo2qhvz8w
	97tjn7/xyANYLlytS9O9oqOSSm1qTyYCeLkE/JN40ccFIVENnw0VKhmXA5I39RA5hH5MLu6jk7j
	cZRuvEkS9OKVydv5kyV28K7cPavumrPGO/OZ+o8UahKzFwdSKFHTPrChqd+kilsfSUAdcB2r8Vj
	9Qag8pRAudYQF3nhLOkXZCcG3P84w5pCR5LbXbL6+adn/bOjD+4IWPB7XhSfKflXitb2C4TNUFb
	KqWo54mI7+/DS2kC6tx3qLFCP8s53mKxlxHCmhqHgKzccsfykKUjI3T4mrHzDLjMRE02MX8YOrf
	4zWZtixr8023/g+iOJisMk2lnzYlre7NFZZsoFcJ2OmyS+COeEYpPKAJ+LHQjaioOi3rC8qh6kK
	wxrJzzS6HJc+AMAzolyuw+hskjPSldtj/kCxzlRol93w6t6ou1YVVpmFxxDrflYyJtz0mOeOTND
	zwkjxu3+YE471/XFUBIvbnYtdhH0v2uhNDg87Qip59qWG4Gik5U=
X-Received: by 2002:a17:903:324d:b0:2e8:3d48:4d8d with SMTP id d9443c01a7336-2eaffb1868bmr15283205ad.0.1793168490216;
        Tue, 27 Oct 2026 23:21:30 -0700 (PDT)
Received: from LAPTOP-QJLDGQ2L.localdomain ([112.224.179.134])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eae6c33917sm17992275ad.48.2026.10.27.23.21.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 23:21:29 -0700 (PDT)
From: Boyan Liu <yymhvert@gmail.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	co+4a4f9998e2b4b490@bugs.sh,
	Boyan Liu <yymhvert@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: sd_zbc: cap zone report count by buffer size
Date: Wed, 28 Oct 2026 14:16:51 +0800
Message-ID: <20261028061651.110435-1-yymhvert@gmail.com>
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

sd_zbc_report_zones() limits descriptor parsing to the requested zone
count and the device-reported ZONE LIST LENGTH, but not to the number of
descriptors that fit in the allocated report buffer. A malicious or
malfunctioning device can report an oversized length and cause
out-of-bounds reads while the descriptors are parsed:

    BUG: KASAN: slab-out-of-bounds in sd_zbc_report_zones (drivers/scsi/sd_zbc.c:256)
    Read of size 8 at addr ffff88802c8d2610 by task kworker/u8:2/37
    Call Trace:
     sd_zbc_report_zones (drivers/scsi/sd_zbc.c:256)
     blk_revalidate_disk_zones (block/blk-zoned.c:2354)
     sd_zbc_revalidate_zones (drivers/scsi/sd_zbc.c:566)
     sd_revalidate_disk (drivers/scsi/sd.c:3898)
     sd_probe (drivers/scsi/sd.c:4101)

Cap the descriptor count with min3() over the remaining requested zones,
the device-reported count, and max_in_buf derived from buflen. This
matches nvme_ns_report_zones() and preserves iteration over reports
that require multiple commands.

Fixes: d41003513e61 ("block: rework zone reporting")
Cc: stable@vger.kernel.org
Reported-by: co+4a4f9998e2b4b490@bugs.sh
Signed-off-by: Boyan Liu <yymhvert@gmail.com>
---
 drivers/scsi/sd_zbc.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 56e455fb5add..6a2644a67849 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -222,7 +222,7 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 {
 	struct scsi_disk *sdkp = scsi_disk(disk);
 	sector_t lba = sectors_to_logical(sdkp->device, sector);
-	unsigned int nr, i;
+	unsigned int nr, i, max_in_buf;
 	unsigned char *buf;
 	u64 zone_length, start_lba;
 	size_t offset, buflen = 0;
@@ -241,13 +241,16 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 	if (!buf)
 		return -ENOMEM;
 
+	max_in_buf = (buflen - 64) / 64;
+
 	while (zone_idx < nr_zones && lba < sdkp->capacity) {
 		ret = sd_zbc_do_report_zones(sdkp, buf, buflen, lba, true);
 		if (ret)
 			goto out;
 
 		offset = 0;
-		nr = min(nr_zones, get_unaligned_be32(&buf[0]) / 64);
+		nr = min3(nr_zones - zone_idx,
+			  get_unaligned_be32(&buf[0]) / 64, max_in_buf);
 		if (!nr)
 			break;
 
-- 
2.43.0


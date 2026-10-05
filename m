Received: from pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.35.192.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FA54BE45E;
	Mon,  5 Oct 2026 15:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.35.192.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791212858; cv=none; b=pQ9p/iQW7x6ejb8f4jwrwnJu24aPoDfcOqcuPdYITpK7H3fFOHGSpaUC/xdCST+/NYCdJmC8B4gFU1OwslHUc+6EU4TdZZZVfkoq573nUUvvbDDo7rFYY58DsqXCo0ph0COYiJDyVeY3NOVa6Q7dDiQJG/1ZRqX/Dtmx6TawQWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791212858; c=relaxed/simple;
	bh=qbRb7m0W+PoCP/ydv/A5mNZA1WpiVpWH/horh4AM5KA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=liTOn9LWu/4x2iIp/AAtOJzMFx8L2b1GeO99s1l3wcXgushuKRHgAdY/Gvy86or0DOzLf2L7+0Pe+JRn34A2nSMX5Pa9NZIf/63LLy7gwn9W+r4Z2MQ8lbXm7oz50HNrswAWQTG1d6Ue7yf7G6IcNVjBUqCkK3r6q9XSN4nw6dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=Oy0h2WsE; arc=none smtp.client-ip=52.35.192.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="Oy0h2WsE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1791212856; x=1822748856;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=SX/38+1acCgyolsTpD/95INgKPAiwyaFbSFGlDo0eAM=;
  b=Oy0h2WsEVZdkvE6M9TQRwqI9UDh0YXFMLR5KxStBPvV0k7H0HQGkTKrx
   If5LdS/lgNha3A+uOVD2PJWRFsTB91aWI0JFV9oM8h1BnsVrcOdACtCsY
   JpQYXDxmMzoj2Af5E2X0Li/49tqML15v0MCsyGymvCJZp+CT8tC8A1Hnj
   R8EcPqkhleKqeM+52gzXtbHcslXO9ei8XVy9gOVuMr7ci95sbDi/rbCLQ
   PN9R2RZBCLBHgRzZJS5IsZWkOik87ktXuMkjWM9KEA2gcco/ARnOXttSy
   adaASQ14L5gxrrfaFRUb6G5RlKkcwu+9KVXDxeZKhCEIFpkmZX/g5GKn5
   w==;
X-CSE-ConnectionGUID: WXzmcKJ3RWes/tJCaiF8dw==
X-CSE-MsgGUID: JarcJ2vdQ+qFMq0fVJlM4w==
X-IronPort-AV: E=Sophos;i="6.27,142,1787011200"; 
   d="scan'208";a="30208467"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2026 15:07:33 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:8722]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.61.153:2525] with esmtp (Farcaster)
 id 412f4bbe-f806-4630-9618-00c65325090a; Mon, 5 Oct 2026 15:07:33 +0000 (UTC)
X-Farcaster-Flow-ID: 412f4bbe-f806-4630-9618-00c65325090a
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Mon, 5 Oct 2026 15:07:33 +0000
Received: from dev-dsk-simonlie-1b-ad174abf.eu-west-1.amazon.com
 (172.19.78.185) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49; Mon, 5 Oct 2026
 15:07:32 +0000
From: Simon Liebold <simonlie@amazon.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>, "James E.J.
 Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
CC: Simon Liebold <simonlie@amazon.de>
Subject: [PATCH 5.15.y] Revert "scsi: sd: sd_zbc: Use logical blocks as unit when querying zones"
Date: Mon, 5 Oct 2026 15:07:13 +0000
Message-ID: <20261005150713.3919586-1-simonlie@amazon.de>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D032UWB003.ant.amazon.com (10.13.139.165) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

This reverts commit 9c78f3cf7785f3de5afb3d632f0d81c2cb0e9020, the 5.15.y
backport of upstream 43af5da09efb.

43af5da09efb is a cleanup ("slightly simplifies sd_zbc_report_zones()"),
not a fix. It entered 5.15.y only as a Stable-dep-of: 93dde0bf2f39
("scsi: scsi_debug: Fix REPORT ZONES alloc_len underflow OOB write"),
which touches only scsi_debug.c and does not actually depend on it.

On its own it zeroes the capacity of host-managed SMR drives at boot. It
changed the REPORT ZONES loop advance from

	sector += sd_zbc_zone_sectors(sdkp) * i;	/* sector_t, 64-bit */
to
	lba += sdkp->zone_blocks * i;			/* u32, wraps */

(zone_info.zone_blocks on 5.15.y after bffcb7d6a287). zone_blocks is
u32, so the product is computed in 32 bits and wraps before being
widened into the 64-bit lba. A drive returning >= 8192 zones in one
REPORT ZONES (~2 TiB+ at 256 MiB zones, i.e. any modern HM-SMR part)
overflows on the first iteration; the next batch is requested at a
wrapped LBA, the block layer rejects the backward jump, and sd truncates
the device to zero:

	sdX: Zone gap at sectors 18219532288..1039663104
	sdX: failed to revalidate zones

(524288 * 34751 = 18219532288, mod 2^32 = 1039663104.)

Mainline never shipped this: in the same series, patch 7 c976e588b34e
("scsi: sd: sd_zbc: Hide gap zones") rewrote the loop to advance per
descriptor from 64-bit device values. 5.15.y took patch 4 and the
intervening 628617be8968 but not c976e588b34e, keeping the broken
intermediate state.

Reverting is preferred over pulling in c976e588b34e: it is a ZBC-2
feature (gap zones, constant zone-starting-LBA granularity) adding ~130
lines across sd_zbc.c, sd.h and include/scsi/scsi_proto.h. It gains
nothing for the constant-zone-size HM-SMR drives 5.15.y serves, which
the restored sector_t advance already handles correctly.

The revert conflicted with bffcb7d6a287 (which renamed the field on the
advance line); resolved by keeping the restored "sector +=
sd_zbc_zone_sectors(sdkp) * i", which reads zone_info.zone_blocks via
logical_to_sectors() and is 64-bit. 93dde0bf2f39 stays in place and is
unaffected.

Signed-off-by: Simon Liebold <simonlie@amazon.de>
---
 drivers/scsi/sd_zbc.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 90d0f8ddd179c..d84a9c1d76c5a 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -223,7 +223,7 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 			unsigned int nr_zones, report_zones_cb cb, void *data)
 {
 	struct scsi_disk *sdkp = scsi_disk(disk);
-	sector_t lba = sectors_to_logical(sdkp->device, sector);
+	sector_t capacity = logical_to_sectors(sdkp->device, sdkp->capacity);
 	unsigned int nr, i;
 	unsigned char *buf;
 	size_t offset, buflen = 0;
@@ -234,7 +234,7 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 		/* Not a zoned device */
 		return -EOPNOTSUPP;
 
-	if (!sdkp->capacity)
+	if (!capacity)
 		/* Device gone or invalid */
 		return -ENODEV;
 
@@ -242,8 +242,9 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 	if (!buf)
 		return -ENOMEM;
 
-	while (zone_idx < nr_zones && lba < sdkp->capacity) {
-		ret = sd_zbc_do_report_zones(sdkp, buf, buflen, lba, true);
+	while (zone_idx < nr_zones && sector < capacity) {
+		ret = sd_zbc_do_report_zones(sdkp, buf, buflen,
+				sectors_to_logical(sdkp->device, sector), true);
 		if (ret)
 			goto out;
 
@@ -261,7 +262,7 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 			zone_idx++;
 		}
 
-		lba += sdkp->zone_info.zone_blocks * i;
+		sector += sd_zbc_zone_sectors(sdkp) * i;
 	}
 
 	ret = zone_idx;

base-commit: 0248c33e835ecbec3a591f93fdaae53f7b90a4d6
-- 
2.50.1


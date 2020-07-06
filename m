Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53977C433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 12:33:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2821D20722
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 12:33:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="RdyYGunS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729135AbgGFMd4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 08:33:56 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:37664 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbgGFMdz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 08:33:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594038836; x=1625574836;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GQ9s9/XmUBkm/zbNHvG0/bSQ+s0KIIp/p3VpmxY3az4=;
  b=RdyYGunS23dOxYoNz8SDLKS8eSwZlem/NXh+c3WAc5klKOKhA3Or/t5H
   1PdApMqdU1d/3n5dNODrnjP0Jp+LpD8uXV43UwlIVtOxVwMBrjpVSy5LI
   RrfeIzqkLRA2XwAsKh4+4kzx+Ltos+U+7unlREA1Lj8/IYLCdO7mILH13
   uWzAiJ+o+8ofh95fKnDyYMgkp2U4T4msYRx672PHpchUoDOQr/T2mtxXm
   Lacik33PbCgb/e/4NASLGjiDCOioawtD1vfi3pNA5vkUccPKv1fLufXds
   7rDls4n4jyi83Lg7NpXVQJcfvQaRMkZSpLY18r97AygtgGJRFibcdSHyf
   g==;
IronPort-SDR: nsMLFWmFOdmemWJYqyADiJ0WJ5Oari9Ga2yYrk5FUveNtRqntWHg4HoHhWad9hGWrg4A3RkeXt
 X7J2OukWcOo7LVyCYruobi5P344aryU9oWnj4UAdak22HDRhA4IxR0fpxxP/5qJq6XUFwm4v8L
 r5wXn70z7+YLwfgvugTEvrAIdGHuzNSKNzfD/s5/7CsJxOmluVKgLYFk/LyjTJmt4mGcJIuOYH
 ktQqwEuEt/+vRzErbsPMCIBq35duMUdwCA+OmvxFZ6NSfx2cl9e/HYbbQGM0T5W7pjCyF0V9kv
 Trg=
X-IronPort-AV: E=Sophos;i="5.75,318,1589212800"; 
   d="scan'208";a="146052069"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Jul 2020 20:33:55 +0800
IronPort-SDR: SMBgrglB4ADnRA/YmHKDL9EQTUpeug3pt5XRz6yGCSAYVPR5tjm3uEzbyj7WBQAiVdVGJHdoUA
 PpnR3f1Lx9IcmkTtqARAAPJfMJksiXyxc=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 05:22:03 -0700
IronPort-SDR: 78w3JdqbSr7WpBRyX7531ESKSC4PMwUfJJR+LRzrwvqAtbAF4jIiH6l90HQGe9587Sl66A1rmP
 8Qvd37jQ+GDw==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Jul 2020 05:33:55 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 07/10] scsi: sd: Fix kdoc comment format
Date:   Mon,  6 Jul 2020 21:33:54 +0900
Message-Id: <20200706123354.452047-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the kdoc comment of the function sd_ioctl_common() to avoid a
compiler warning when compiling with W=1.

No functional changes.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d90fefffe31b..acde0ca35769 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1479,7 +1479,7 @@ static int sd_getgeo(struct block_device *bdev, struct hd_geometry *geo)
  *	@bdev: target block device
  *	@mode: FMODE_* mask
  *	@cmd: ioctl command number
- *	@arg: this is third argument given to ioctl(2) system call.
+ *	@p: this is third argument given to ioctl(2) system call.
  *	Often contains a pointer.
  *
  *	Returns 0 if successful (some ioctls return positive numbers on
-- 
2.26.2


Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7ECDC433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 12:33:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E9BD20715
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 12:33:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="mgOtUg0y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729139AbgGFMd5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 08:33:57 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:37664 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbgGFMd5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 08:33:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594038837; x=1625574837;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pdI+PBufFwWN4+0vClGCaZYvdgoc02DLa9/tmsmRTJM=;
  b=mgOtUg0ygIvvLCKJbzA1kwd+tCcaACodMbz+5pdrSEDNw9FlEPA+eWB0
   KDpgbFLj0rbDUIRWCV/1isL9+/MqJsrTz4QpaAvVkLW6n4F8kD5IZ+f09
   BPqxSKInrW/MA+p3UfYZPS542aEmMruSiVnNvN/l0oB2UeUnKj39W1uCe
   jzraNYuYdxlxHk8/UDZ/1nkqVwP0dsfEaG+zi3dz7bR8v8Ojv73W7ZU3j
   g+6Fn/cw28GdZjl4p419SgJH8TNXpDDj492GEyc6mKbrCqi2UzOa4OH5d
   Jy5X5B/CZohWOOfmu1AqZGAgwNRmi+AMolRpmO4MxQrqqTaywQ50wETpv
   w==;
IronPort-SDR: Z11JeA+/abaQCjgq6Lj0GNxTAxoqK9KC8IwQCwofutVoiSQl3QOT1oTHhEc+nVHNB1TNtaH5ub
 DeKRQaFkJxZ86pIUT13+hj42XlVcYMMtqbxJC8RP20F124L/ed+gMRQk7pQk89ox7729A9OWsD
 mFvRVgl5c20uvC3H4OZ5XyyzegDI3ihfFlErv0ws/KpOOC4oC2YVsmHyMVlpG2/BUHKkELqKkd
 qhqTrQDl2iH6eNOIqgm/vAIBoXQ69ZEZ+lF3LWWLRiOdKiUUrOLP/XPiHF1dl8iDpjecVv4PPS
 GlI=
X-IronPort-AV: E=Sophos;i="5.75,318,1589212800"; 
   d="scan'208";a="146052071"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Jul 2020 20:33:57 +0800
IronPort-SDR: RVS2DlLadUH1AtG/Lvo1b9MKyxo4pqiHQxT4AGOE66paQBaaDRQhUR0XsqONQq794B0e8JWbPC
 Srrgk0ljBsdkDM0aiLr8dVWn6e8FHhMF0=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 05:22:05 -0700
IronPort-SDR: A7PZbcWmdaj0PRV0WmJeDzy3CnQ7Mlhb4SJnRC3SciXAk6YnPksp/eYFG4PzWJz09rthDuMQ1C
 5+gGRURm/9rw==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Jul 2020 05:33:56 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 08/10] scsi: sd_zbc: Fix kdoc comment format
Date:   Mon,  6 Jul 2020 21:33:55 +0900
Message-Id: <20200706123355.452091-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the kdoc comment of the function sd_zbc_check_capacity() to avoid a
compiler warning when compiling with W=1.

No functional changes.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd_zbc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 6f7eba66687e..c43755b52b86 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -584,7 +584,7 @@ static int sd_zbc_check_zoned_characteristics(struct scsi_disk *sdkp,
  * sd_zbc_check_capacity - Check the device capacity
  * @sdkp: Target disk
  * @buf: command buffer
- * @zblock: zone size in number of blocks
+ * @zblocks: zone size in number of blocks
  *
  * Get the device zone size and check that the device capacity as reported
  * by READ CAPACITY matches the max_lba value (plus one) of the report zones
-- 
2.26.2


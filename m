Return-Path: <SRS0=3mnS=DM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FA2CC4363D
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 14:40:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCC5A207F7
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 14:40:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726337AbgJEOkb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Oct 2020 10:40:31 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:60223 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbgJEOka (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Oct 2020 10:40:30 -0400
IronPort-SDR: Ouw7vHkTeC8hI6ht8AgVIfVjh1WcY0rJHOTSSAIwZd9W6tRjdgxumhmzWFs2+sNihHTew52CYb
 6pB0EdA3LyqsCj1+y7tNz9K/zV/aqS4Vq0nW3y6YhKb7Iz6EVclvnY5qcdKQhl+krSLXBK3aod
 wbv5QFTnD/b3IVOdOu66789ACTRIcVXe597yx1K/3cfm1Th5IdlYl6hqtEpv8HObvXucFTXI9w
 nOyUtgaXn59542yaIoZaJ8Kt7tw2uu7hJ8gjSoENldtHYh/EOlkMWqCOFGfU9jcRO31gq0W/zJ
 hg0=
X-IronPort-AV: E=Sophos;i="5.77,338,1596524400"; 
   d="scan'208";a="28759295"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Oct 2020 07:40:30 -0700
Received: from AVMBX2.microsemi.net (10.100.34.32) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Mon, 5 Oct 2020
 07:40:29 -0700
Received: from bby1unixsmtp01.microsemi.net (10.180.100.98) by
 avmbx2.microsemi.net (10.100.34.32) with Microsoft SMTP Server id 15.1.1979.3
 via Frontend Transport; Mon, 5 Oct 2020 07:40:29 -0700
Received: from localhost (bby1unixlb02.microsemi.net [10.180.100.121])
        by bby1unixsmtp01.microsemi.net (Postfix) with ESMTP id 6B6D2A09C6;
        Mon,  5 Oct 2020 07:40:29 -0700 (PDT)
From:   Viswas G <Viswas.G@microchip.com.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH V2 4/4] pm80xx: Driver version update
Date:   Mon, 5 Oct 2020 20:20:11 +0530
Message-ID: <20201005145011.23674-5-Viswas.G@microchip.com.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20201005145011.23674-1-Viswas.G@microchip.com.com>
References: <20201005145011.23674-1-Viswas.G@microchip.com.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Viswas G <Viswas.G@microchip.com>

Update driver version from "0.1.39" -> "0.1.40"

Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/scsi/pm8001/pm8001_sas.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 9d7796a74ed4..95663e138083 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -58,7 +58,7 @@
 #include "pm8001_defs.h"
 
 #define DRV_NAME		"pm80xx"
-#define DRV_VERSION		"0.1.39"
+#define DRV_VERSION		"0.1.40"
 #define PM8001_FAIL_LOGGING	0x01 /* Error message logging */
 #define PM8001_INIT_LOGGING	0x02 /* driver init logging */
 #define PM8001_DISC_LOGGING	0x04 /* discovery layer logging */
-- 
2.16.3


Return-Path: <SRS0=8X05=DC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 153CDC4741F
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 06:13:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4F1A23447
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 06:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbgIYGN3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Sep 2020 02:13:29 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:60502 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727176AbgIYGN3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Sep 2020 02:13:29 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Sep 2020 02:13:24 EDT
IronPort-SDR: G32DGsBNUnYaq7QbggVGXE2gjnBiDU+G3amXzZMbw3gu6QNFwcbx2KnwbKOBqBtPjIBAwO4sob
 4Ng09mDNxuDC6urYwZhO3BbU5BPz90i6HeQs0qcNyhil3b+QFGvOQ+0k3z959BmBb+kpzU4A0n
 OUCdUvA2xdVFlxJBDxUrbDfL2wFVrVCpGWQXOyq/SIo7rbpNke/MdCEbO7APvnmqylxVVHdUx/
 YsCz2lvN4ESFnrJF5tjPluh+Z5MS1eD/mQPTpIe2m0NMitQncFYDfyapLJjJMgqVv7BSwdFCqN
 cFk=
X-IronPort-AV: E=Sophos;i="5.77,300,1596524400"; 
   d="scan'208";a="97147219"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.21])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Sep 2020 23:06:24 -0700
Received: from AVMBX2.microsemi.net (10.100.34.32) by AVMBX1.microsemi.net
 (10.100.34.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Thu, 24 Sep
 2020 23:06:24 -0700
Received: from bby1unixsmtp01.microsemi.net (10.180.100.99) by
 avmbx2.microsemi.net (10.100.34.32) with Microsoft SMTP Server id 15.1.1979.3
 via Frontend Transport; Thu, 24 Sep 2020 23:06:24 -0700
Received: from localhost (bby1unixlb02.microsemi.net [10.180.100.121])
        by bby1unixsmtp01.microsemi.net (Postfix) with ESMTP id C5AE740047;
        Thu, 24 Sep 2020 23:06:23 -0700 (PDT)
From:   Viswas G <Viswas.G@microchip.com.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 4/4] pm80xx : Driver version update
Date:   Fri, 25 Sep 2020 11:46:05 +0530
Message-ID: <20200925061605.31628-5-Viswas.G@microchip.com.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20200925061605.31628-1-Viswas.G@microchip.com.com>
References: <20200925061605.31628-1-Viswas.G@microchip.com.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Viswas G <Viswas.G@microchip.com>

Update driver version from "0.1.39" -> "0.1.40"

Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
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


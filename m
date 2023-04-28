Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CC46C77B61
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Apr 2023 15:38:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346472AbjD1Piz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Apr 2023 11:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346408AbjD1PiX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Apr 2023 11:38:23 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B485755A3
        for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2023 08:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682696282; x=1714232282;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ga7i6qPEeJX9O7Elm8wf2D865F6vwljovLe8SkolZnk=;
  b=XCAMR4rkxwfqYWwppTKGOeYs8XWqrYM2wK67AQaJ3tQuryT6osnLT0uN
   KoOrv8Clx95jboYO4Arp4itmafDBTNzBZhXBq2o+HC7SRDfzcLaoslJ6m
   jRZYPr/AOsbL4R2E9h/hYSFB4+cr5lS19PMWqwERqnngyN6E1i/4oMWj9
   oP27kYLSjA3R56EeecmxuiBCZ9n+j4giqoaGXV4AnHk8z0SYbuZKmAAr6
   7iZg0d2M7wVfDmWxNtJDReWRV64wAqUaKPvBKbcvY79DuPXD9OBHF0sdp
   ODFGPf8qgzcxGs9Rq6FzKXwVlZeVG8iantNcvhsxoFj2A4cETeclvQnRZ
   w==;
X-IronPort-AV: E=Sophos;i="5.99,234,1677567600"; 
   d="scan'208";a="223049446"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Apr 2023 08:37:09 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 28 Apr 2023 08:37:08 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Fri, 28 Apr 2023 08:37:07 -0700
From:   Don Brace <don.brace@microchip.com>
To:     <don.brace@microchip.com>, <Kevin.Barnett@microchip.com>,
        <scott.teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <scott.benesh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <mike.mcgowen@microchip.com>,
        <murthy.bhat@microchip.com>, <kumar.meiyappan@microchip.com>,
        <jeremy.reeves@microchip.com>, <david.strahan@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Subject: [PATCH 12/12] smartpqi: update version to 2.1.22-040
Date:   Fri, 28 Apr 2023 10:37:12 -0500
Message-ID: <20230428153712.297638-13-don.brace@microchip.com>
X-Mailer: git-send-email 2.40.1.375.g9ce9dea4e1
In-Reply-To: <20230428153712.297638-1-don.brace@microchip.com>
References: <20230428153712.297638-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Gerry Morong <gerry.morong@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 0740bec5d9ae..3669affd114b 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -33,11 +33,11 @@
 #define BUILD_TIMESTAMP
 #endif
 
-#define DRIVER_VERSION		"2.1.20-035"
+#define DRIVER_VERSION		"2.1.22-040"
 #define DRIVER_MAJOR		2
 #define DRIVER_MINOR		1
-#define DRIVER_RELEASE		20
-#define DRIVER_REVISION		35
+#define DRIVER_RELEASE		22
+#define DRIVER_REVISION		40
 
 #define DRIVER_NAME		"Microchip SmartPQI Driver (v" \
 				DRIVER_VERSION BUILD_TIMESTAMP ")"
-- 
2.40.1.375.g9ce9dea4e1


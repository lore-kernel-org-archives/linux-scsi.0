Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30A72C43334
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jul 2022 18:47:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239686AbiGHSrN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 14:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239678AbiGHSrM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 14:47:12 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18BE6564DB
        for <linux-scsi@vger.kernel.org>; Fri,  8 Jul 2022 11:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657306031; x=1688842031;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0YBcylRJgjxZsmHBJWzdhO43EB0XZBTwnI3Grjh9MuA=;
  b=H0peT2FLpEB/RFpuB1ARKaI3VNelkbM8H94JdE18CxtYzKrBPIzNkUde
   AKLtklWDfMA97Ub5UCZ5hQbfLJ/FvOByQ1qDWi4tgLwpDiB9PZmtBjvBL
   vA3ujwTo9Ltd0eGuyQv0RsL8KDpfenTuXBrzvoj7oMD91vzbSsVmOZf4u
   rkGyrO0LR6Z4VIPkAo2SS9yBjUWEIpi2v7BwDe/IclBTrvowUR4WI9tSn
   +cePGiSqonjWQmBkvacdFiTgctNBcClVM78sIvwsNsTko3rTwAhMPR2OB
   Rlfcq+drECkZz4RZqppuGKuk44KkcieS4fm/6thC9ynlFEmpFArvhLBRH
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="163971208"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Jul 2022 11:47:00 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 8 Jul 2022 11:46:59 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Fri, 8 Jul 2022 11:46:59 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (8.15.2/8.15.2/Debian-22ubuntu3) with ESMTP id 268Im63H177540;
        Fri, 8 Jul 2022 13:48:06 -0500
Received: (from brace@localhost)
        by brunhilda.pdev.net (8.15.2/8.15.2/Submit) id 268Im67B177539;
        Fri, 8 Jul 2022 13:48:06 -0500
X-Authentication-Warning: brunhilda.pdev.net: brace set sender to don.brace@microchip.com using -f
Subject: [PATCH V2 16/16] smartpqi: update version to 2.1.18-045
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <kumar.meiyappan@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 8 Jul 2022 13:48:06 -0500
Message-ID: <165730608687.177165.11815510982277242966.stgit@brunhilda>
In-Reply-To: <165730597930.177165.11663580730429681919.stgit@brunhilda>
References: <165730597930.177165.11663580730429681919.stgit@brunhilda>
User-Agent: StGit/1.5.dev2+g9ce680a52bd9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Gerry Morong <gerry.morong@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 0ab6e8f9a7b7..7a8c2c75acba 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -33,11 +33,11 @@
 #define BUILD_TIMESTAMP
 #endif
 
-#define DRIVER_VERSION		"2.1.14-035"
+#define DRIVER_VERSION		"2.1.18-045"
 #define DRIVER_MAJOR		2
 #define DRIVER_MINOR		1
-#define DRIVER_RELEASE		14
-#define DRIVER_REVISION		35
+#define DRIVER_RELEASE		18
+#define DRIVER_REVISION		45
 
 #define DRIVER_NAME		"Microchip SmartPQI Driver (v" \
 				DRIVER_VERSION BUILD_TIMESTAMP ")"


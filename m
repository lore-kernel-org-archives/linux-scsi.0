Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E66C1C433E9
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:04:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B200464FD0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 20:04:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbhCJUEB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Mar 2021 15:04:01 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:38591 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232874AbhCJUD6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2021 15:03:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615406638; x=1646942638;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JwSmG3ZiIwgUnLcBN0Ht8SlAh76d5EGYaLwouFqGumA=;
  b=daqlkAC6Ck6kPKiQwO27aSHFnfXcAH1ftyX+7bu/Mimv6yZtTlwZVItd
   cuZQbKJoqOdaAxNz4kzgyZJa+UYMfRerxzsvCR6t/wjPHq+y1IC+cx51K
   SnT7xv3WkaT1icPwVU1EcrxRMC5MDBj0G1/w6NBLlknZFHchUBc+yRVeh
   KIw9p9tE7IeK5V/GCOBUSPLcwMiAmzRRLZrgXnu2HCvv1/s2q5qZywo4N
   RXeD152xyuc+JYx4VCk9WAMyP3zHS1E7KDFnLo79Q3BsFUZyt/UQTuTBD
   jljUO4uHRK4ewEFB81S8AcdyiKa0x0ME2sUvI9y+R/9s/GrDSE9Dkc7H6
   Q==;
IronPort-SDR: DGTvae+o7cj4RtrUnpN1OkVXQ4aAtf4nXPFetreZvG5rig9WHfuGM277FVLcj+8u6zU79tSKyv
 ah4sUxrSeWrGzydoxPG7TT0u/xufdURpXsrbvHRnwmTay6BD26Ache6jiH65PMsq6lXwtinySh
 wsg6c4hBk1o5lW4lBO0pyTI7GamTOX/k+6cOMYMzBOxICVLKGC4bAwzjqnqK+D49v1OBQIraGO
 eHcdrDrUZqIR+v4zRaXCB0tAIp/A230o8DgtFlhngLz7yUzTCpu5btJlEQ8ge2uIH6VgpbYcJe
 4mI=
X-IronPort-AV: E=Sophos;i="5.81,238,1610434800"; 
   d="scan'208";a="106699655"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Mar 2021 13:03:57 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 10 Mar 2021 13:03:46 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 10 Mar 2021 13:03:46 -0700
Subject: [PATCH V4 31/31] smartpqi: update version to 2.1.8-045
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Wed, 10 Mar 2021 14:03:46 -0600
Message-ID: <161540662617.19430.10431993267130810890.stgit@brunhilda>
In-Reply-To: <161540568064.19430.11157730901022265360.stgit@brunhilda>
References: <161540568064.19430.11157730901022265360.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

* Update version for tracking

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Gerry Morong <gerry.morong@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index ec1859e2e420..ff4ee8aed5ec 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -33,11 +33,11 @@
 #define BUILD_TIMESTAMP
 #endif
 
-#define DRIVER_VERSION		"1.2.16-012"
-#define DRIVER_MAJOR		1
-#define DRIVER_MINOR		2
-#define DRIVER_RELEASE		16
-#define DRIVER_REVISION		12
+#define DRIVER_VERSION		"2.1.8-045"
+#define DRIVER_MAJOR		2
+#define DRIVER_MINOR		1
+#define DRIVER_RELEASE		8
+#define DRIVER_REVISION		45
 
 #define DRIVER_NAME		"Microsemi PQI Driver (v" \
 				DRIVER_VERSION BUILD_TIMESTAMP ")"


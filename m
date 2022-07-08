Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFF93C43334
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jul 2022 18:47:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239699AbiGHSrU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 14:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239684AbiGHSrM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 14:47:12 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0740B59271
        for <linux-scsi@vger.kernel.org>; Fri,  8 Jul 2022 11:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657306032; x=1688842032;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rokaAsIEmTukpVo6Fver4m8BRU9vl6Rr9Bac99JVPaE=;
  b=kVqxJSax6TlSJaafZBy3CkstSxUTUKHTgCc4GEx63mIzDkdWY1DrBIRJ
   dxYgBu3WpDLQfh4nAmb/cG7zWD1ZRPfLrt8VXBTIQODuAeRl364wo7EzD
   KEe+J6gDwW3luKmSSSqaxkjm2xOJISpSbGwZBYF6VroeGjxH5P7PQiJdn
   Q6omAa0V16YnV7Sd3AL44EP8PesRS1dMGwtnUq43tfcdWRBQ80R6QivyV
   cpp5ELbJU88UTZxoJ1u6zJlH41s0cOq2fotqHVk3o4te8yajVOQSOZ7f6
   okcH3BuYJ7gM91x0kexNM79UxGT34/lXLLqjwrypt9MktE428zZsxKo8s
   g==;
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="163971232"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Jul 2022 11:47:02 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 8 Jul 2022 11:46:54 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Fri, 8 Jul 2022 11:46:54 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (8.15.2/8.15.2/Debian-22ubuntu3) with ESMTP id 268Im1ss177517;
        Fri, 8 Jul 2022 13:48:01 -0500
Received: (from brace@localhost)
        by brunhilda.pdev.net (8.15.2/8.15.2/Submit) id 268Im1bp177516;
        Fri, 8 Jul 2022 13:48:01 -0500
X-Authentication-Warning: brunhilda.pdev.net: brace set sender to don.brace@microchip.com using -f
Subject: [PATCH V2 15/16] smartpqi: update copyright to current year.
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <kumar.meiyappan@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 8 Jul 2022 13:48:01 -0500
Message-ID: <165730608177.177165.13184715486635363193.stgit@brunhilda>
In-Reply-To: <165730597930.177165.11663580730429681919.stgit@brunhilda>
References: <165730597930.177165.11663580730429681919.stgit@brunhilda>
User-Agent: StGit/1.5.dev2+g9ce680a52bd9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update copyright to current year.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/Kconfig                  |    2 +-
 drivers/scsi/smartpqi/smartpqi.h               |    2 +-
 drivers/scsi/smartpqi/smartpqi_init.c          |    2 +-
 drivers/scsi/smartpqi/smartpqi_sas_transport.c |    2 +-
 drivers/scsi/smartpqi/smartpqi_sis.c           |    2 +-
 drivers/scsi/smartpqi/smartpqi_sis.h           |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/smartpqi/Kconfig b/drivers/scsi/smartpqi/Kconfig
index 6f83e2df4d64..973d240649ab 100644
--- a/drivers/scsi/smartpqi/Kconfig
+++ b/drivers/scsi/smartpqi/Kconfig
@@ -1,7 +1,7 @@
 #
 # Kernel configuration file for the SMARTPQI
 #
-# Copyright (c) 2019-2021 Microchip Technology Inc. and its subsidiaries
+# Copyright (c) 2019-2022 Microchip Technology Inc. and its subsidiaries
 # Copyright (c) 2017-2018 Microsemi Corporation
 # Copyright (c) 2016 Microsemi Corporation
 # Copyright (c) 2016 PMC-Sierra, Inc.
diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 49d3a8a275f3..e550b12e525a 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
  *    driver for Microchip PQI-based storage controllers
- *    Copyright (c) 2019-2021 Microchip Technology Inc. and its subsidiaries
+ *    Copyright (c) 2019-2022 Microchip Technology Inc. and its subsidiaries
  *    Copyright (c) 2016-2018 Microsemi Corporation
  *    Copyright (c) 2016 PMC-Sierra, Inc.
  *
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index f18b63637d0b..0ab6e8f9a7b7 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  *    driver for Microchip PQI-based storage controllers
- *    Copyright (c) 2019-2021 Microchip Technology Inc. and its subsidiaries
+ *    Copyright (c) 2019-2022 Microchip Technology Inc. and its subsidiaries
  *    Copyright (c) 2016-2018 Microsemi Corporation
  *    Copyright (c) 2016 PMC-Sierra, Inc.
  *
diff --git a/drivers/scsi/smartpqi/smartpqi_sas_transport.c b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
index dea4ebaf1677..13e8c539010e 100644
--- a/drivers/scsi/smartpqi/smartpqi_sas_transport.c
+++ b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  *    driver for Microchip PQI-based storage controllers
- *    Copyright (c) 2019-2021 Microchip Technology Inc. and its subsidiaries
+ *    Copyright (c) 2019-2022 Microchip Technology Inc. and its subsidiaries
  *    Copyright (c) 2016-2018 Microsemi Corporation
  *    Copyright (c) 2016 PMC-Sierra, Inc.
  *
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.c b/drivers/scsi/smartpqi/smartpqi_sis.c
index 12b575f2bcef..5811fb3c22a9 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.c
+++ b/drivers/scsi/smartpqi/smartpqi_sis.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  *    driver for Microchip PQI-based storage controllers
- *    Copyright (c) 2019-2021 Microchip Technology Inc. and its subsidiaries
+ *    Copyright (c) 2019-2022 Microchip Technology Inc. and its subsidiaries
  *    Copyright (c) 2016-2018 Microsemi Corporation
  *    Copyright (c) 2016 PMC-Sierra, Inc.
  *
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.h b/drivers/scsi/smartpqi/smartpqi_sis.h
index 2f825d31a47e..9dcbae96a5c6 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.h
+++ b/drivers/scsi/smartpqi/smartpqi_sis.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
  *    driver for Microchip PQI-based storage controllers
- *    Copyright (c) 2019-2021 Microchip Technology Inc. and its subsidiaries
+ *    Copyright (c) 2019-2022 Microchip Technology Inc. and its subsidiaries
  *    Copyright (c) 2016-2018 Microsemi Corporation
  *    Copyright (c) 2016 PMC-Sierra, Inc.
  *


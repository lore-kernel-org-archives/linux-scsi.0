Return-Path: <SRS0=lsqi=CG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EEBDC433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 21:09:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 143C0208FE
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 21:09:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgH1VJZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Aug 2020 17:09:25 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:28306 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbgH1VJY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Aug 2020 17:09:24 -0400
IronPort-SDR: Uwa6stbgJK4TaoGTMA5SLEdcxDFo930gjvfkxNx4wPSzkGkHdcdmhU1auZp65mpBGLiLTxLaRl
 3cweEd80WxccWcgBK9d9NwIxwOhOFz93IwoWjAkVyz/T9OGBrsSOHkL7CNdY0xG11xOkL0shuk
 mPVIRBkH3jOCy/hw2xS0dQcbRzMU30WidwtThM0mMxtz/SDHwlXq8+2zplGz2nQMhs/0TX798o
 R35O0YhUPT9TXTpQIALObAIPdFgk5UC8ntPdFv/+JHxoVCyshjA8JIip7lQfeg8vZWI26lw4ku
 RGk=
X-IronPort-AV: E=Sophos;i="5.76,365,1592895600"; 
   d="scan'208";a="89759735"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Aug 2020 14:09:23 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 28 Aug 2020 14:09:23 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 28 Aug 2020 14:09:16 -0700
Subject: [PATCH 2/2] smartpqi: update copyright
From:   Don Brace <don.brace@microsemi.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 28 Aug 2020 16:09:22 -0500
Message-ID: <159864896224.13630.9798419111015060967.stgit@brunhilda>
In-Reply-To: <159864889781.13630.2796712754333982084.stgit@brunhilda>
References: <159864889781.13630.2796712754333982084.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

* update driver Copyright to current year.

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/Kconfig                  |    4 ++--
 drivers/scsi/smartpqi/smartpqi.h               |    2 +-
 drivers/scsi/smartpqi/smartpqi_init.c          |    2 +-
 drivers/scsi/smartpqi/smartpqi_sas_transport.c |    2 +-
 drivers/scsi/smartpqi/smartpqi_sis.c           |    2 +-
 drivers/scsi/smartpqi/smartpqi_sis.h           |    2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/smartpqi/Kconfig b/drivers/scsi/smartpqi/Kconfig
index 8eec241f074b..cb9e4e968b60 100644
--- a/drivers/scsi/smartpqi/Kconfig
+++ b/drivers/scsi/smartpqi/Kconfig
@@ -1,11 +1,11 @@
 #
 # Kernel configuration file for the SMARTPQI
 #
-# Copyright (c) 2019 Microchip Technology Inc. and its subsidiaries
+# Copyright (c) 2019-2020 Microchip Technology Inc. and its subsidiaries
 # Copyright (c) 2017-2018 Microsemi Corporation
 # Copyright (c) 2016 Microsemi Corporation
 # Copyright (c) 2016 PMC-Sierra, Inc.
-#  (mailto:esc.storagedev@microsemi.com)
+#  (mailto:storagedev@microchip.com)
 
 # This program is free software; you can redistribute it and/or
 # modify it under the terms of the GNU General Public License
diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 1129fe7a27ed..a675ae73d0d4 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
  *    driver for Microsemi PQI-based storage controllers
- *    Copyright (c) 2019 Microchip Technology Inc. and its subsidiaries
+ *    Copyright (c) 2019-2020 Microchip Technology Inc. and its subsidiaries
  *    Copyright (c) 2016-2018 Microsemi Corporation
  *    Copyright (c) 2016 PMC-Sierra, Inc.
  *
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index ca1e6cf6a38e..8fa394286adc 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  *    driver for Microsemi PQI-based storage controllers
- *    Copyright (c) 2019 Microchip Technology Inc. and its subsidiaries
+ *    Copyright (c) 2019-2020 Microchip Technology Inc. and its subsidiaries
  *    Copyright (c) 2016-2018 Microsemi Corporation
  *    Copyright (c) 2016 PMC-Sierra, Inc.
  *
diff --git a/drivers/scsi/smartpqi/smartpqi_sas_transport.c b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
index b7289112455c..999870eb9ed8 100644
--- a/drivers/scsi/smartpqi/smartpqi_sas_transport.c
+++ b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  *    driver for Microsemi PQI-based storage controllers
- *    Copyright (c) 2019 Microchip Technology Inc. and its subsidiaries
+ *    Copyright (c) 2019-2020 Microchip Technology Inc. and its subsidiaries
  *    Copyright (c) 2016-2018 Microsemi Corporation
  *    Copyright (c) 2016 PMC-Sierra, Inc.
  *
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.c b/drivers/scsi/smartpqi/smartpqi_sis.c
index f0d6e88ba2c1..26ea6b9d4199 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.c
+++ b/drivers/scsi/smartpqi/smartpqi_sis.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  *    driver for Microsemi PQI-based storage controllers
- *    Copyright (c) 2019 Microchip Technology Inc. and its subsidiaries
+ *    Copyright (c) 2019-2020 Microchip Technology Inc. and its subsidiaries
  *    Copyright (c) 2016-2018 Microsemi Corporation
  *    Copyright (c) 2016 PMC-Sierra, Inc.
  *
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.h b/drivers/scsi/smartpqi/smartpqi_sis.h
index 86b0e484d921..878d34ca6532 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.h
+++ b/drivers/scsi/smartpqi/smartpqi_sis.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
  *    driver for Microsemi PQI-based storage controllers
- *    Copyright (c) 2019 Microchip Technology Inc. and its subsidiaries
+ *    Copyright (c) 2019-2020 Microchip Technology Inc. and its subsidiaries
  *    Copyright (c) 2016-2018 Microsemi Corporation
  *    Copyright (c) 2016 PMC-Sierra, Inc.
  *


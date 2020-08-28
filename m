Return-Path: <SRS0=lsqi=CG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1CE7C433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 21:09:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D03E2086A
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 21:09:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgH1VJS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Aug 2020 17:09:18 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:28295 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbgH1VJS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Aug 2020 17:09:18 -0400
IronPort-SDR: WogkpnRkMwqPDfwkihLMS4siMDgQGrR6KSPqknbDV1hY8u/cbtDAWLlptgNkg0CYq1AUHpk3MI
 3f8BaJMWh7kREYHEUZzIKaWzkt8C945Lr9Msj4j5oGYmDycdJn9kU9eLT7aGW8Os4Ah5Z6pbBC
 mjRcPjf2GvrIafbb7E5BNwtjVHkvwbv/KaG5dvL+cQa4S4gb0ic2m3sT0xBxWb9/mDx8zHJNug
 nfEeL54YOGNNDI2SejTAWYOjyXf0dUfp8X3+gtA2TKNhROApEBmBtJP+j2MxMut7aJNndMLmG5
 2Pg=
X-IronPort-AV: E=Sophos;i="5.76,365,1592895600"; 
   d="scan'208";a="89759716"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Aug 2020 14:09:17 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 28 Aug 2020 14:09:16 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 28 Aug 2020 14:09:08 -0700
Subject: [PATCH 1/2] smartpqi: update documentation
From:   Don Brace <don.brace@microsemi.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 28 Aug 2020 16:09:15 -0500
Message-ID: <159864895592.13630.18113151805817361168.stgit@brunhilda>
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

* change Microsemi to Microchip

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 Documentation/scsi/smartpqi.rst |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/scsi/smartpqi.rst b/Documentation/scsi/smartpqi.rst
index a7de27352c6f..e574a1ccf4ac 100644
--- a/Documentation/scsi/smartpqi.rst
+++ b/Documentation/scsi/smartpqi.rst
@@ -1,12 +1,12 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-=====================================
-SMARTPQI - Microsemi Smart PQI Driver
-=====================================
+==============================================
+SMARTPQI - Microchip Smart Storage SCSI driver
+==============================================
 
-This file describes the smartpqi SCSI driver for Microsemi
-(http://www.microsemi.com) PQI controllers. The smartpqi driver
-is the next generation SCSI driver for Microsemi Corp. The smartpqi
+This file describes the smartpqi SCSI driver for Microchip
+(http://www.microchip.com) PQI controllers. The smartpqi driver
+is the next generation SCSI driver for Microchip Corp. The smartpqi
 driver is the first SCSI driver to implement the PQI queuing model.
 
 The smartpqi driver will replace the aacraid driver for Adaptec Series 9
@@ -14,7 +14,7 @@ controllers. Customers running an older kernel (Pre-4.9) using an Adaptec
 Series 9 controller will have to configure the smartpqi driver or their
 volumes will not be added to the OS.
 
-For Microsemi smartpqi controller support, enable the smartpqi driver
+For Microchip smartpqi controller support, enable the smartpqi driver
 when configuring the kernel.
 
 For more information on the PQI Queuing Interface, please see:


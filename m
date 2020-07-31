Return-Path: <SRS0=WBt/=BK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 752F4C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 21:01:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 513DB22B43
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 21:01:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729158AbgGaVBw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Jul 2020 17:01:52 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:16576 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729043AbgGaVBv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Jul 2020 17:01:51 -0400
IronPort-SDR: 33UnXlFMaT7YYZY5Zf4alLyOmbJAqhgv+668dtHqWhO5D01dgLpIBbEwRjrromfbltbE5KYsnI
 AFD7OPCsNpse8P4sF5aj+/rjrEOHw13UlbD4ThFxfMwZ+kZDd+pnHuMHwCD8DHZB85skUHH8yM
 SFj/CZEklWS4r+g5QjtCMJc1soEKZI8EGz3NtWbVq0zrNkQHQU67KJgKuDghNsVia9O9ps2IZg
 4o0rkicYaloevx586FFCFfNKxKRQC1Ms/cqUFVNqjgdmL//p94i+c1yTFDNA04QD7UUpxg15c+
 sac=
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="90019859"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 31 Jul 2020 14:01:51 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 31 Jul 2020 14:01:49 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 31 Jul 2020 14:01:49 -0700
Subject: [PATCH 7/7] smartpqi: bump version to 1.2.16-010
From:   Don Brace <don.brace@microsemi.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <bader.alisaleh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 31 Jul 2020 16:01:50 -0500
Message-ID: <159622931040.30579.9167901134341507088.stgit@brunhilda>
In-Reply-To: <159622890296.30579.6820363566594432069.stgit@brunhilda>
References: <159622890296.30579.6820363566594432069.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Gerry Morong <gerry.morong@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 392d00cbef22..a8b02647163a 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -33,11 +33,11 @@
 #define BUILD_TIMESTAMP
 #endif
 
-#define DRIVER_VERSION		"1.2.10-025"
+#define DRIVER_VERSION		"1.2.16-010"
 #define DRIVER_MAJOR		1
 #define DRIVER_MINOR		2
-#define DRIVER_RELEASE		10
-#define DRIVER_REVISION		25
+#define DRIVER_RELEASE		16
+#define DRIVER_REVISION		10
 
 #define DRIVER_NAME		"Microsemi PQI Driver (v" \
 				DRIVER_VERSION BUILD_TIMESTAMP ")"


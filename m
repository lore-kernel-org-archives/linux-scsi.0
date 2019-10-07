Return-Path: <SRS0=5MTk=YA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B97CBC47404
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Oct 2019 22:32:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9534A206C0
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Oct 2019 22:32:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729545AbfJGWcR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Oct 2019 18:32:17 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:17338 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729413AbfJGWcR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Oct 2019 18:32:17 -0400
Authentication-Results: esa6.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=don.brace@microsemi.com; spf=None smtp.helo=postmaster@email.microchip.com
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  don.brace@microsemi.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="don.brace@microsemi.com";
  x-sender="don.brace@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:68.232.147.0/24 ip4:68.232.148.0/22 ip4:68.232.152.0/23
  ip4:68.232.154.0/24 ip4:216.71.150.0/24 ip4:216.71.151.0/24
  ip4:216.71.152.0/23 ip4:216.71.154.0/24 ip4:198.175.253.41
  ip4:198.175.253.82 include:servers.mcsv.net -all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="don.brace@microsemi.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
X-Ironport-Dmarc-Check-Result: validskip
IronPort-SDR: DWCJT5O+QcthmiOmBuNr6C/i1ck+LER3bpDlYqllzBfHDAoSNJd8wt18u7S/KoTBz21ZoVx6dY
 kFVBGo4N3OhthkguscmUuNFnieZaDQwzuJHSbi4lm820Ts2SK5oECMFVw1js6tVNVJLvcBIZUz
 ZR3okBZoWQeSU2jG5hvQnteMpHOsT+QXq2LPTmSxn1aFttun2RoTPmefnYx8vzQIWxbifhWnbB
 vok8xwdoQzsQJv8GvFUoXMlHyMDPAFGWSDlKmg+8T9RfEaRAmJQKRrxjhLVpEf5K2fKzBv5wSP
 rMM=
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="49125816"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Oct 2019 15:32:16 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 7 Oct 2019 15:32:16 -0700
Received: from [127.0.1.1] (10.10.85.251) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Mon, 7 Oct 2019 15:32:16 -0700
Subject: [PATCH 10/10] smartpqi: bump version
From:   Don Brace <don.brace@microsemi.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <bader.alisaleh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>, <shunyong.yang@hxt-semitech.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Mon, 7 Oct 2019 17:32:15 -0500
Message-ID: <157048753592.11757.3634142461093493860.stgit@brunhilda>
In-Reply-To: <157048745695.11757.6602264644727193780.stgit@brunhilda>
References: <157048745695.11757.6602264644727193780.stgit@brunhilda>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Gerry Morong <gerry.morong@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index f179a745946d..2c8e5a0ed286 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -33,11 +33,11 @@
 #define BUILD_TIMESTAMP
 #endif
 
-#define DRIVER_VERSION		"1.2.8-026"
+#define DRIVER_VERSION		"1.2.10-025"
 #define DRIVER_MAJOR		1
 #define DRIVER_MINOR		2
-#define DRIVER_RELEASE		8
-#define DRIVER_REVISION		26
+#define DRIVER_RELEASE		10
+#define DRIVER_REVISION		25
 
 #define DRIVER_NAME		"Microsemi PQI Driver (v" \
 				DRIVER_VERSION BUILD_TIMESTAMP ")"


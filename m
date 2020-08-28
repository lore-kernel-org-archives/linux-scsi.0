Return-Path: <SRS0=lsqi=CG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3117AC433E2
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 20:05:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E268208A9
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 20:05:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgH1UFK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Aug 2020 16:05:10 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:1708 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbgH1UFK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Aug 2020 16:05:10 -0400
IronPort-SDR: yYcxa2HAVvq9rrL7qPKo+2pYrx5RHTuNc173N2Dq1ziR5cNM0kt5mYEPhTQ9tyaEGk6Zb04I5B
 +U59Uwp3otFepEX1WhFIutxr+NXDYH4pv3pFr3HOxtvVWUfbHXzaBY/Bs2y7+yzoz2gy1uUCRN
 3U2lDOYZfdqfx80ssuloAkbnGUZn8TDpxfb+C24DPzKUpUGccQEn/BIZxIAfNeQjL33rMbxBT1
 on59sMxTwxvRg2R2jWoG27zqhdZm5UVaSFSk7xKRfFM7pwDLhBzBXKRyP3GCWIsdMtaHGveYQZ
 Wps=
X-IronPort-AV: E=Sophos;i="5.76,364,1592895600"; 
   d="scan'208";a="85110885"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Aug 2020 13:05:10 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 28 Aug 2020 13:05:04 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 28 Aug 2020 13:05:03 -0700
Subject: [PATCH] MAINTAINERS: update smartpqi and hpsa
From:   Don Brace <don.brace@microsemi.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 28 Aug 2020 15:05:08 -0500
Message-ID: <159864510818.12656.822985017436862534.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

* change M entry e-mail to microchip
* change L entry e-mail for storagedev to microchip

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 MAINTAINERS |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3b186ade3597..038c4e3b8257 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7717,8 +7717,8 @@ F:	Documentation/watchdog/hpwdt.rst
 F:	drivers/watchdog/hpwdt.c
 
 HEWLETT-PACKARD SMART ARRAY RAID DRIVER (hpsa)
-M:	Don Brace <don.brace@microsemi.com>
-L:	esc.storagedev@microsemi.com
+M:	Don Brace <don.brace@microchip.com>
+L:	storagedev@microchip.com
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	Documentation/scsi/hpsa.rst
@@ -11522,8 +11522,8 @@ F:	arch/mips/configs/generic/board-ocelot.config
 F:	arch/mips/generic/board-ocelot.c
 
 MICROSEMI SMART ARRAY SMARTPQI DRIVER (smartpqi)
-M:	Don Brace <don.brace@microsemi.com>
-L:	esc.storagedev@microsemi.com
+M:	Don Brace <don.brace@microchip.com>
+L:	storagedev@microchip.com
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	Documentation/scsi/smartpqi.rst


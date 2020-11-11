Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6001BC388F9
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 20:24:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC920208B3
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 20:24:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="deHglWKY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgKKUYx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Nov 2020 15:24:53 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:2511 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgKKUYx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Nov 2020 15:24:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1605126293; x=1636662293;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GQofUBLUsWkSgQyTw9klXT9p2mQAM03JalPVTufkWUw=;
  b=deHglWKYAdVR5qnak09wUROsmXknWulKn/tvspjIdGfhnEPb0PnT5aYB
   rVFxLVpNpF0RVGEBN3+khlSMScwt/f2KzABCzvv6JFrWJITcM7ZUgHPKU
   /PptC5F7ktgq4d1nEcArIhQ+gvYSfVonhtAfZdp6sdqj7Xc50Zi/n46i6
   yZiV/WE7b+L2W4r0mfOAPD7htEalU4gHZ3cEbgb2ShZ9DqoRjzkd5ZWy+
   kK3m9F0nJi2nk1Augd0bONAVkSOLSR7R2kafvxfXx4LGe039P7BDHo10q
   MGC23Xo/MHsWSGCRlkj/2Rekh1HGsHBICV9GJW2aojBSlG9zderY+U3rK
   Q==;
IronPort-SDR: ZTaVC6g5zd0pFaI3Tlr7RbKVfCHb8VXk6p3TGE38aY/V1uTbWMdLkYsGDtnhCEX+P2oXmgQx5e
 12DORfQp6AvlIMoejFIDLSIi5fhvmOM9G0gOOdLoz59xBIZf89wf18/YS+0+SXYOCSW7WtovGW
 c4aP4qotNKIkmCUujEQD7WUe30sOuJJaa3Ve8Lppselo281gBIXzvBt1R6mP29C+Pz9YZlWCX5
 IEZgpgzLcZBEdO/ToXSFK/tjH1TzG4Vm4Uib09HKt6/PUezBIQ6vupabIQCqdvefj8o8fB+h7f
 JrQ=
X-IronPort-AV: E=Sophos;i="5.77,470,1596524400"; 
   d="scan'208";a="95973131"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Nov 2020 13:24:52 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 11 Nov 2020 13:24:51 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 11 Nov 2020 13:24:51 -0700
Subject: [PATCH 3/3] smartpqi: update version to 1.2.16-012
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Wed, 11 Nov 2020 14:24:50 -0600
Message-ID: <160512629093.2359.13675060282143622110.stgit@brunhilda>
In-Reply-To: <160512621964.2359.14416010917893813538.stgit@brunhilda>
References: <160512621964.2359.14416010917893813538.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Gerry Morong <gerry.morong@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 531f10853f03..c53f456fbd09 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -33,11 +33,11 @@
 #define BUILD_TIMESTAMP
 #endif
 
-#define DRIVER_VERSION		"1.2.16-010"
+#define DRIVER_VERSION		"1.2.16-012"
 #define DRIVER_MAJOR		1
 #define DRIVER_MINOR		2
 #define DRIVER_RELEASE		16
-#define DRIVER_REVISION		10
+#define DRIVER_REVISION		12
 
 #define DRIVER_NAME		"Microsemi PQI Driver (v" \
 				DRIVER_VERSION BUILD_TIMESTAMP ")"


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7BA6C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:19:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E43A64E6B
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:19:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhCKUSa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 15:18:30 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:62359 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbhCKUSB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 15:18:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615493881; x=1647029881;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vj9K0BmEfP46Tn8aMogNqj82TlA9TBM0hl73CfRp7eo=;
  b=zKWBJ1o2/3F3rROc9jdN5U2MihPrIZCBDXjpu0dl2vmcn00jPVBwRddv
   gnXO3jdWMAJjYv6M8hTtC8SCulPi5ve7rrvb9feAV4gDPa35CIpvos5zO
   ZIzqbOZOq5uPQIwceEeVLQxGeLZk94OcJQEbLjaMUYMDPWBfXD7fo/Bla
   GvTBzUe+MFQs2VbjeiIQc0sDJ6WzgV50V/zwU6UHPusLMPaYqas1HpFkY
   s7SDmkG1VtzhGKj2EbLvMyMoMq7MlqCATDtqBsSlSNyXfjAzebKrogKT/
   ebYOdIrVaHt+R1uvGgfmnLqE4yGjonOm5/txTT8eY8ua6LEi6Iq+smdkd
   A==;
IronPort-SDR: 0IMXRhbpvxAH+GcY1HdD59drGpv05mtBCM7mFFyu+1OW6HsGFcyo3EB8x7a59T4FxoJxScYoK8
 gjjzLXs1Au4Tpw75bQ2f2qi8CKQYcm/OxZsCnOPoPA9ZqBCsU1vL5ukeJGHKAswensMaEl2z4F
 32anr3cu0U+OxObSwEOL3733dNmrPLApLN3fUzpU7QJydb5GNOq+nrs9xgNwfeDxeFZgDrfDxs
 t5v/DOsW8jB+u6dQiLwsTUmQKnxmKpGTn7+ldJywhZDPnF5UFqt3pVhT/LsDQJf7X8df18BXa3
 nPc=
X-IronPort-AV: E=Sophos;i="5.81,241,1610434800"; 
   d="scan'208";a="112888473"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Mar 2021 13:17:57 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 11 Mar 2021 13:17:55 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 11 Mar 2021 13:17:54 -0700
Subject: [PATCH V5 31/31] smartpqi: update version to 2.1.8-045
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 11 Mar 2021 14:17:54 -0600
Message-ID: <161549387469.25025.12859568843576080076.stgit@brunhilda>
In-Reply-To: <161549045434.25025.17473629602756431540.stgit@brunhilda>
References: <161549045434.25025.17473629602756431540.stgit@brunhilda>
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
index 99c24599b2c8..3b0f281daa2b 100644
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


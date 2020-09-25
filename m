Return-Path: <SRS0=8X05=DC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B6E7C4727E
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 06:13:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C79D322211
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 06:13:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbgIYGNY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Sep 2020 02:13:24 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:60502 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbgIYGNY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Sep 2020 02:13:24 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Sep 2020 02:13:24 EDT
IronPort-SDR: G/OBPApEEhWoUn0BSqdz8Ch+22oLJBCM5YNwP3MYIKqZbkyUVbSBP/VyYUsfAHyAlGE6D2bh0d
 JsYHmxjbgA+3X78kmOiC73EHPzMT5D9h3QPzC+GxI6u4TjvtqbFhbj3xarOP1ndshMrGdUEDPf
 rJU71JL0PMAeKjonwEzS0l5SpYRXcKQGIcgjry0/GWdsxKVVfnR+AViw074uRBVHbH/JYkUm8A
 gHiQzoJXsllL7Jpq9YajZxE50/aBFqJhs+tlGY1/KaZgSS6JaPpYJ3x4N/i++H6M2NOQnWl+6I
 p0U=
X-IronPort-AV: E=Sophos;i="5.77,300,1596524400"; 
   d="scan'208";a="97147201"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.21])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Sep 2020 23:06:17 -0700
Received: from AVMBX2.microsemi.net (10.100.34.32) by AVMBX1.microsemi.net
 (10.100.34.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Thu, 24 Sep
 2020 23:06:17 -0700
Received: from bby1unixsmtp01.microsemi.net (10.180.100.99) by
 avmbx2.microsemi.net (10.100.34.32) with Microsoft SMTP Server id 15.1.1979.3
 via Frontend Transport; Thu, 24 Sep 2020 23:06:17 -0700
Received: from localhost (bby1unixlb02.microsemi.net [10.180.100.121])
        by bby1unixsmtp01.microsemi.net (Postfix) with ESMTP id 91D5840047;
        Thu, 24 Sep 2020 23:06:16 -0700 (PDT)
From:   Viswas G <Viswas.G@microchip.com.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 0/4] pm80xx updates
Date:   Fri, 25 Sep 2020 11:46:01 +0530
Message-ID: <20200925061605.31628-1-Viswas.G@microchip.com.com>
X-Mailer: git-send-email 2.16.3
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Viswas G <Viswas.G@microchip.com>

This patch set includes some enhancements in pm80xx driver.

Viswas G (4):
  pm80xx : Increase number of supported queues.
  pm80xx : Remove DMA memory allocation for ccb and device structures.
  pm80xx : Increase the number of outstanding IO supported to 1024.
  pm80xx : Driver version update

 drivers/scsi/pm8001/pm8001_ctl.c  |   6 +-
 drivers/scsi/pm8001/pm8001_defs.h |  27 +++--
 drivers/scsi/pm8001/pm8001_hwi.c  |  38 +++----
 drivers/scsi/pm8001/pm8001_init.c | 220 ++++++++++++++++++++++++++------------
 drivers/scsi/pm8001/pm8001_sas.h  |  15 ++-
 drivers/scsi/pm8001/pm80xx_hwi.c  | 109 ++++++++++---------
 6 files changed, 253 insertions(+), 162 deletions(-)

-- 
2.16.3


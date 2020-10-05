Return-Path: <SRS0=3mnS=DM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0DABC4363A
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 14:40:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9510420776
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 14:40:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726003AbgJEOkY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Oct 2020 10:40:24 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:21840 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgJEOkX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Oct 2020 10:40:23 -0400
IronPort-SDR: /iwFvCYXyoq7gwGfzZ0QrdHDORymhjNNLXe5N9nzdx+1Lsh1Vi+2PAYP1O31qbjJ9FBOBuQUbC
 a4oHvE7IShy7HnMSeOkGJv5dJsEfUPuHVQxsX4JsLCTLq3vOGgYPgkaG6tQayK831vkD3elso+
 0JVKhZm4huRQB8L8vDExdo2nySUiJ+EomYM6bz6KlOtSa9w6Brvpu8tJbezx+DKaucrQIGKj4L
 BgM5WZ133aXwWPelG6S5z/6KV3Dj6ssNJDRMidA/qwW/ONesEc7YSAUJOLhi35ZUkWbeSt3sE7
 c+I=
X-IronPort-AV: E=Sophos;i="5.77,338,1596524400"; 
   d="scan'208";a="89133513"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Oct 2020 07:40:23 -0700
Received: from AVMBX3.microsemi.net (10.100.34.33) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Mon, 5 Oct 2020
 07:40:22 -0700
Received: from bby1unixsmtp01.microsemi.net (10.180.100.98) by
 avmbx3.microsemi.net (10.100.34.33) with Microsoft SMTP Server id 15.1.1979.3
 via Frontend Transport; Mon, 5 Oct 2020 07:40:22 -0700
Received: from localhost (bby1unixlb02.microsemi.net [10.180.100.121])
        by bby1unixsmtp01.microsemi.net (Postfix) with ESMTP id 14F12A09C6;
        Mon,  5 Oct 2020 07:40:22 -0700 (PDT)
From:   Viswas G <Viswas.G@microchip.com.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH V2 0/4] pm80xx updates.
Date:   Mon, 5 Oct 2020 20:20:07 +0530
Message-ID: <20201005145011.23674-1-Viswas.G@microchip.com.com>
X-Mailer: git-send-email 2.16.3
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Viswas G <Viswas.G@microchip.com>

Changes from v1:
	- Improved commit messages.
	- Fixed compiler warning for 
		 "Increase the number of outstanding IO supported" patch 

Viswas G (4):
  pm80xx: Increase number of supported queues.
  pm80xx: Remove DMA memory allocation for ccb and device structures.
  pm80xx: Increase the number of outstanding IO supported to 1024.
  pm80xx: Driver version update

 drivers/scsi/pm8001/pm8001_ctl.c  |   6 +-
 drivers/scsi/pm8001/pm8001_defs.h |  27 +++--
 drivers/scsi/pm8001/pm8001_hwi.c  |  38 +++----
 drivers/scsi/pm8001/pm8001_init.c | 221 ++++++++++++++++++++++++++------------
 drivers/scsi/pm8001/pm8001_sas.h  |  15 ++-
 drivers/scsi/pm8001/pm80xx_hwi.c  | 109 ++++++++++---------
 6 files changed, 254 insertions(+), 162 deletions(-)

-- 
2.16.3


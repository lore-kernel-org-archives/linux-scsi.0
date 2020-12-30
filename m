Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5C02C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Dec 2020 04:49:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6941F207AF
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Dec 2020 04:49:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgL3EtC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Dec 2020 23:49:02 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:25324 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbgL3EtC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Dec 2020 23:49:02 -0500
IronPort-SDR: a9eQGdsmTRRzALz2VEfrxW9pPZNaup1LSV6pKIfhq6hVZ/fA/2ZyJEJQxvmslbDz3hz4FGeknW
 QCmLz1HLcETqxOlFrkAwel8qBxkRbGgXks5nAkyZ+4Ray7P0LCu12CT/LzyVYintCbkuweJ6YX
 q1bMnimzdvR+NLEXEHzNDyCWWw5LNg51FgpMZjRhAO1YTk1i7UVNbIO349xkuSqw4l/yS1lMRD
 5mC6YX7uvLM87IAq6IQ+MEhQUhcOai2HEQcSg/1dcu+g5M21AkQm+nL5oA+FAKIggXxsdn28MR
 xBA=
X-IronPort-AV: E=Sophos;i="5.78,460,1599548400"; 
   d="scan'208";a="98575452"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Dec 2020 21:47:46 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 29 Dec 2020 21:47:46 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 29 Dec 2020 21:47:45 -0700
From:   Viswas G <Viswas.G@microchip.com.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <yuuzheng@google.com>, <vishakhavc@google.com>, <radha@google.com>,
        <akshatzen@google.com>, <bjashnani@google.com>,
        <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 0/8] pm80xx updates.
Date:   Wed, 30 Dec 2020 10:27:35 +0530
Message-ID: <20201230045743.14694-1-Viswas.G@microchip.com.com>
X-Mailer: git-send-email 2.16.3
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Viswas G <Viswas.G@microchip.com>

This patch set include some bug fixes and enhancements for pm80xx driver.

Bhavesh Jashnani (1):
  pm80xx: Simultaneous poll for all FW readiness.

Vishakha Channapattan (2):
  pm80xx: Log SATA IOMB completion status on failure.
  pm80xx: Add sysfs attribute for ioc health

Viswas G (1):
  pm80xx: fix driver fatal dump failure.

akshatzen (4):
  pm80xx: No busywait in MPI init check
  pm80xx: check fatal error
  pm80xx: check main config table address
  pm80xx: fix missing tag_free in NVMD DATA req

 drivers/scsi/pm8001/pm8001_ctl.c  |  42 ++++++++
 drivers/scsi/pm8001/pm8001_hwi.c  |  15 ++-
 drivers/scsi/pm8001/pm8001_init.c |  11 ++-
 drivers/scsi/pm8001/pm8001_sas.c  |   9 ++
 drivers/scsi/pm8001/pm8001_sas.h  |   2 +
 drivers/scsi/pm8001/pm80xx_hwi.c  | 202 ++++++++++++++++++++++++--------------
 drivers/scsi/pm8001/pm80xx_hwi.h  |  17 +++-
 7 files changed, 216 insertions(+), 82 deletions(-)

-- 
2.16.3


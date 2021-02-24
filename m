Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A879C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 16:09:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0A4064F00
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 16:09:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbhBXQJT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Feb 2021 11:09:19 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:18228 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236626AbhBXPtq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Feb 2021 10:49:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1614181780; x=1645717780;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=QWChIzFTx71MvJpXGBVM5rqyEx7e64onYliZtw002C8=;
  b=vNrl+BijjyuD6XstaecQLX1XC5f/sh9YgwaIVVuGU3qjWM1Xf6eS6byr
   hs3SC0rPG7gPErh0Xp4zbqJ6OskmHLRL3eNTC5jiZBW1ypTHCUuCUD0R9
   SndF1cBPJtViKlblYM8e2uRSM6gjJdMFSWuo4+dC7DNM9OTmy/Wmgo+Wg
   dp9nzwGc22WVYDj+YK9h8j/fhrtpTMWoo7iu3XBUygDh/v7y/O3pNKfFc
   xhqCz2ElG8/NDxHB537Mu2mRsS5E67vHmpQnCptut/f8kvtcLxEkMvH+r
   YDwshiFfBhwJGAauXfpQsyZwnnsX4v9AHxBqNDVtHIuMSqKVV5dcuq1PG
   g==;
IronPort-SDR: lEO1Z/h1TPxckIOTqyNMb1FjgVtmEN4FjaUyn5x+bigdUblFt5vM8sh14U1MwC+792B97X6jRD
 AUNmt/llLozgqqv/VqMy2ETzmT3ui0votGpiRGNp5hj0z1A8Ek8+eYY9bZJuVFQ4XA1y+XxKCz
 0lSq7xvZfNyinAimGT6vFUbMmD7SbkGLb5vfBkVUodVw76m7F7twefHeUg4S3HXTrkn3ccf5f1
 Dc0jKlchpCkbNXdxQmTeOC1lKJFqy3Fl91liqKy7sw5AlVQyFOms2YyrfYgeyPPsG2bQ9jY27I
 Mfc=
X-IronPort-AV: E=Sophos;i="5.81,203,1610434800"; 
   d="scan'208";a="107803924"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Feb 2021 08:48:16 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 24 Feb 2021 08:48:16 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 24 Feb 2021 08:48:16 -0700
From:   Viswas G <Viswas.G@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <vishakhavc@google.com>, <radha@google.com>,
        <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 0/7] pm80xx updates 
Date:   Wed, 24 Feb 2021 21:27:55 +0530
Message-ID: <20210224155802.13292-1-Viswas.G@microchip.com>
X-Mailer: git-send-email 2.16.3
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch set include some bug fixes fnd enhancementments for pm80xx driver.

Ruksar Devadi (1):
  pm80xx: Completing pending IO after fatal error

Vishakha Channapattan (4):
  pm80xx: Add sysfs attribute to check mpi state
  pm80xx: Add sysfs attribute to track RAAE count
  pm80xx: Add sysfs attribute to track iop0 count
  pm80xx: Add sysfs attribute to track iop1 count

Viswas G (2):
  pm80xx: Reset PI and CI memory during re-initialize
  pm80xx: remove global lock from outbound queue processing

 drivers/scsi/pm8001/pm8001_ctl.c  | 111 +++++++++++++++++++++++++++++++++++++-
 drivers/scsi/pm8001/pm8001_hwi.c  |  68 ++++++++++++++++++++---
 drivers/scsi/pm8001/pm8001_hwi.h  |   1 +
 drivers/scsi/pm8001/pm8001_init.c |   9 ++--
 drivers/scsi/pm8001/pm8001_sas.c  |   2 +-
 drivers/scsi/pm8001/pm8001_sas.h  |   2 +
 drivers/scsi/pm8001/pm80xx_hwi.c  |   7 ++-
 drivers/scsi/pm8001/pm80xx_hwi.h  |   1 +
 8 files changed, 188 insertions(+), 13 deletions(-)

-- 
2.16.3


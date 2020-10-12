Return-Path: <SRS0=8h8k=DT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16F33C433E7
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 05:14:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E310020780
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 05:14:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgJLFO2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Oct 2020 01:14:28 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:37211 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725967AbgJLFO2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Oct 2020 01:14:28 -0400
IronPort-SDR: SAjauPERKmjbtTrQxZaFRpQ/si0YsqT2qX6NDBj+0tjUMcSY1aq2d52fEKcOMxTMmx9fqtUbWN
 cGNMQ3DkF7XxwsBDG//57HHFpbK6dNGvV3BWLk+mN0ebdT9HrCW/Z7eIVTHOhlFUYVtzQBAWG+
 NSmJ1J73ZIfYzrSG/J/WUDs+MmX5kNWMZ7gM6uZYq5cwCaqRnB+XEB+xJFUEfoRNwlqGGfxqnn
 3ClGVhZ8xOUuA0pWB5l88kOOFwsdsDA7sp5eneXz49GFtbvP0LoOrMEZMrAT6MsT8zHBs+VACe
 pUY=
X-IronPort-AV: E=Sophos;i="5.77,365,1596524400"; 
   d="scan'208";a="89863713"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Oct 2020 22:14:27 -0700
Received: from AVMBX1.microsemi.net (10.100.34.31) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Sun, 11 Oct
 2020 22:14:26 -0700
Received: from bby1unixsmtp01.microsemi.net (10.180.100.99) by
 avmbx1.microsemi.net (10.100.34.31) with Microsoft SMTP Server id 15.1.1979.3
 via Frontend Transport; Sun, 11 Oct 2020 22:14:26 -0700
Received: from localhost (bby1unixlb02.microsemi.net [10.180.100.121])
        by bby1unixsmtp01.microsemi.net (Postfix) with ESMTP id 5724040047;
        Sun, 11 Oct 2020 22:14:26 -0700 (PDT)
From:   Viswas G <Viswas.G@microchip.com.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        Ruksar Devadi <Ruksar.devadi@microchip.com>,
        <Viswas.G@microchip.com>,
        "peter chang --cc=yuuzheng @ google . com" <dpf@google.com>,
        <vishakhavc@google.com>, <radha@google.com>, <akshatzen@google.com>
Subject: [PATCH 0/4] pm80xx updates 
Date:   Mon, 12 Oct 2020 10:54:11 +0530
Message-ID: <20201012052415.18963-1-Viswas.G@microchip.com.com>
X-Mailer: git-send-email 2.16.3
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Viswas G <Viswas.G@microchip.com>

This patch set include some bug fixes for pm80xx driver.  

Viswas G (1):
  pm80xx: make running_req atomic.

akshatzen (1):
  pm80xx: Avoid busywait in FW ready check

peter chang (1):
  pm80xx: make mpi_build_cmd locking consistent

yuuzheng (1):
  pm80xx: make pm8001_mpi_set_nvmd_resp free of race condition

 drivers/scsi/pm8001/pm8001_hwi.c  |  86 +++++++++++++++++++------
 drivers/scsi/pm8001/pm8001_init.c |   2 +-
 drivers/scsi/pm8001/pm8001_sas.c  |  11 ++--
 drivers/scsi/pm8001/pm8001_sas.h  |   2 +-
 drivers/scsi/pm8001/pm80xx_hwi.c  | 130 ++++++++++++++++++++++++++++++--------
 drivers/scsi/pm8001/pm80xx_hwi.h  |   6 ++
 6 files changed, 185 insertions(+), 52 deletions(-)

-- 
2.16.3


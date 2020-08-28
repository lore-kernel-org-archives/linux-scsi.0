Return-Path: <SRS0=lsqi=CG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A83DEC433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 19:07:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9324F20776
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 19:07:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgH1THs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Aug 2020 15:07:48 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:41842 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbgH1THo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Aug 2020 15:07:44 -0400
IronPort-SDR: 3a9Ur4ANACoZOPHKGdFpAj/csv6ilfYQA+fvjJC701VGeaFY2gvK/SjTpm48t0rLDHkUUoeiMd
 poEhMfZksDYUgZx3prsvhf+JP6tVRfFphV9LbphU4zaHVlPGocxF7MeH3aA56pFrjtPvgcwatS
 /qw81LBECDOh2LifO1ynQSTTDpudAfLvtc3M5NLg4YZqkmv1R2BDeOJ9cxhN+CKTKKCAZ1jJY3
 6BndavUeZ/TKntFsIt8gCrEb5Fsyt+qX1E1pLiv5LaAmLWiP9viwtIcjHFKv4SPEOS3zVTcxQg
 Zjc=
X-IronPort-AV: E=Sophos;i="5.76,364,1592895600"; 
   d="scan'208";a="88986632"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Aug 2020 12:07:43 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 28 Aug 2020 12:07:36 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 28 Aug 2020 12:07:35 -0700
Subject: [PATCH] hpsa: update copyright
From:   Don Brace <don.brace@microsemi.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 28 Aug 2020 14:07:42 -0500
Message-ID: <159864166227.12131.3427629298809272795.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

* Add entry for Microchip

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c     |    1 +
 drivers/scsi/hpsa.h     |    1 +
 drivers/scsi/hpsa_cmd.h |    1 +
 3 files changed, 3 insertions(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 91794a50b31f..de90284ca96b 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1,5 +1,6 @@
 /*
  *    Disk Array driver for HP Smart Array SAS controllers
+ *    Copyright (c) 2019-2020 Microchip Technology Inc. and its subsidiaries
  *    Copyright 2016 Microsemi Corporation
  *    Copyright 2014-2015 PMC-Sierra, Inc.
  *    Copyright 2000,2009-2015 Hewlett-Packard Development Company, L.P.
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 6b87d9815b35..99b0750850b2 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -1,5 +1,6 @@
 /*
  *    Disk Array driver for HP Smart Array SAS controllers
+ *    Copyright (c) 2019-2020 Microchip Technology Inc. and its subsidiaries
  *    Copyright 2016 Microsemi Corporation
  *    Copyright 2014-2015 PMC-Sierra, Inc.
  *    Copyright 2000,2009-2015 Hewlett-Packard Development Company, L.P.
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index 7825cbfea4dc..46df2e3ff89b 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -1,5 +1,6 @@
 /*
  *    Disk Array driver for HP Smart Array SAS controllers
+ *    Copyright (c) 2019-2020 Microchip Technology Inc. and its subsidiaries
  *    Copyright 2016 Microsemi Corporation
  *    Copyright 2014-2015 PMC-Sierra, Inc.
  *    Copyright 2000,2009-2015 Hewlett-Packard Development Company, L.P.


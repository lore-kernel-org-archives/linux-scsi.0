Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB138C3F2D2
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 08:17:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81E522468E
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 08:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583137073;
	bh=s531gSxDkVtdzJAGp8Gxaqlfbpc382cg5q+qNefPNJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=sYWkGE/IT2uoUvGKU+2AEDN+zDL4cHG2+P7VyKZVp1F21R5re97ZZ1mxmrRxyHA5p
	 E4+qAtURJ312mrCNLGEMEVVIT2qBKUM/9pXdvdyoi2HgemRfBWO2SMn8vdjku9uWm2
	 meow4sC8jkE2JuM2QBhGrptC7iKwoDu3GCH/oYHA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727700AbgCBIRn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Mar 2020 03:17:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:57212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727237AbgCBIQW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Mar 2020 03:16:22 -0500
Received: from mail.kernel.org (ip5f5ad4e9.dynamic.kabel-deutschland.de [95.90.212.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90F4F246EE;
        Mon,  2 Mar 2020 08:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583136979;
        bh=s531gSxDkVtdzJAGp8Gxaqlfbpc382cg5q+qNefPNJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X15Rw1GV1++3pJBDxAayewKzBkVMzNrtizhyLzo5iQdKScxac29NZesaAIcRNbzgj
         AXUV3jbxHgjQ3YUBNeSiFtB1mUtaCZuTd9WEuh5xrtSWQ01YCb5O2p1r7bFS3vsNkQ
         V/H5cLDzjpucYoHHuHQ6Es/oTnpLa7p6vkDdK5JY=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1j8gFN-0003yg-Mj; Mon, 02 Mar 2020 09:16:17 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 26/42] docs: scsi: convert qlogicfas.txt to ReST
Date:   Mon,  2 Mar 2020 09:15:59 +0100
Message-Id: <b69f795c781811b9a908abe43485f1dca0ee8ac5.1583136624.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <cover.1583136624.git.mchehab+huawei@kernel.org>
References: <cover.1583136624.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/scsi/index.rst                    |  1 +
 .../scsi/{qlogicfas.txt => qlogicfas.rst}       | 17 +++++++++++++----
 drivers/scsi/Kconfig                            |  2 +-
 3 files changed, 15 insertions(+), 5 deletions(-)
 rename Documentation/scsi/{qlogicfas.txt => qlogicfas.rst} (92%)

diff --git a/Documentation/scsi/index.rst b/Documentation/scsi/index.rst
index 17327f67af68..29e211ee9145 100644
--- a/Documentation/scsi/index.rst
+++ b/Documentation/scsi/index.rst
@@ -30,5 +30,6 @@ Linux SCSI Subsystem
    ncr53c8xx
    NinjaSCSI
    ppa
+   qlogicfas
 
    scsi_transport_srp/figures
diff --git a/Documentation/scsi/qlogicfas.txt b/Documentation/scsi/qlogicfas.rst
similarity index 92%
rename from Documentation/scsi/qlogicfas.txt
rename to Documentation/scsi/qlogicfas.rst
index c211d827fef2..b17f1b3676c3 100644
--- a/Documentation/scsi/qlogicfas.txt
+++ b/Documentation/scsi/qlogicfas.rst
@@ -1,3 +1,8 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=================================
+Qlogic FASXXX Family Driver Notes
+=================================
 
 This driver supports the Qlogic FASXXX family of chips.  This driver
 only works with the ISA, VLB, and PCMCIA versions of the Qlogic
@@ -16,7 +21,8 @@ is provided by the qla1280 driver.
 Nor does it support the PCI-Basic, which is supported by the
 'am53c974' driver.
 
-PCMCIA SUPPORT
+PCMCIA Support
+==============
 
 This currently only works if the card is enabled first from DOS.  This
 means you will have to load your socket and card services, and
@@ -31,7 +37,8 @@ it from configuring the card.
 I am working with the PCMCIA group to make it more flexible, but that
 may take a while.
 
-ALL CARDS
+All Cards
+=========
 
 The top of the qlogic.c file has a number of defines that controls
 configuration.  As shipped, it provides a balance between speed and
@@ -46,7 +53,8 @@ command or something.  It comes up faster if this is set to zero, and
 if you have reliable hardware and connections it may be more useful to
 not reset things.
 
-SOME TROUBLESHOOTING TIPS
+Some Troubleshooting Tips
+=========================
 
 Make sure it works properly under DOS.  You should also do an initial FDISK
 on a new drive if you want partitions.
@@ -54,7 +62,8 @@ on a new drive if you want partitions.
 Don't enable all the speedups first.  If anything is wrong, they will make
 any problem worse.
 
-IMPORTANT
+Important
+=========
 
 The best way to test if your cables, termination, etc. are good is to
 copy a very big file (e.g. a doublespace container file, or a very
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 82462d6a4ce5..d34c682e94cf 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1117,7 +1117,7 @@ config SCSI_QLOGIC_FAS
 	  SCSI support"), below.
 
 	  Information about this driver is contained in
-	  <file:Documentation/scsi/qlogicfas.txt>.  You should also read the
+	  <file:Documentation/scsi/qlogicfas.rst>.  You should also read the
 	  SCSI-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>.
 
-- 
2.21.1


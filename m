Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57B46C3F2D8
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 08:19:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 306B9246BE
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 08:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583137173;
	bh=XsQJ1i4+U1vKLIHBb0iuZxTTYKZjKKpjTdHYQ+ASJBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=taaCVQ3j1y4YVEIdOyVcmjxKDR3/kbDjVskbEmRlmlJ7jdtjNJxq9DCuQUWd/rT7o
	 mn0nQkzQKhD2KIr/FgABpqsX7vEKQjCVcRKgcpXWvwNtSVnvuJtYBI9s8RmWwf2uuZ
	 Q1RJN7ali/zmimJyWvivTRvE0TF51S8Ds8gtNars=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727609AbgCBITZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Mar 2020 03:19:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:56672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726960AbgCBIQT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Mar 2020 03:16:19 -0500
Received: from mail.kernel.org (ip5f5ad4e9.dynamic.kabel-deutschland.de [95.90.212.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E075E246B6;
        Mon,  2 Mar 2020 08:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583136979;
        bh=XsQJ1i4+U1vKLIHBb0iuZxTTYKZjKKpjTdHYQ+ASJBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XVg1QNhic0ebfUl+Cdak06D/0msKDQp70nvO31BvDpJrDErWJFDUilsXQj/a733z1
         h2+QUfPRMymErWgf02cxnvCO8bebZrH/ZR4qISSsd1Mp6M8RxCA63MF1pkJwyxAMoO
         XOXwrneVk96/e7J6n+iCdhfO0UX3hb8IpV5Fk7Nw=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1j8gFN-0003wr-1o; Mon, 02 Mar 2020 09:16:17 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 03/42] docs: scsi: convert 53c700.txt to ReST
Date:   Mon,  2 Mar 2020 09:15:36 +0100
Message-Id: <a2e5116b70564f36b4fc7f1f1e5da1e693d7dadb.1583136624.git.mchehab+huawei@kernel.org>
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
 Documentation/scsi/{53c700.txt => 53c700.rst} | 61 +++++++++----------
 Documentation/scsi/index.rst                  |  2 +
 MAINTAINERS                                   |  2 +-
 3 files changed, 33 insertions(+), 32 deletions(-)
 rename Documentation/scsi/{53c700.txt => 53c700.rst} (75%)

diff --git a/Documentation/scsi/53c700.txt b/Documentation/scsi/53c700.rst
similarity index 75%
rename from Documentation/scsi/53c700.txt
rename to Documentation/scsi/53c700.rst
index e31aceb6df15..53a0e9f9c198 100644
--- a/Documentation/scsi/53c700.txt
+++ b/Documentation/scsi/53c700.rst
@@ -1,3 +1,9 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=======================
+The 53c700 Driver Notes
+=======================
+
 General Description
 ===================
 
@@ -16,9 +22,9 @@ fill in to get the driver working.
 Compile Time Flags
 ==================
 
-A compile time flag is:
+A compile time flag is::
 
-CONFIG_53C700_LE_ON_BE
+	CONFIG_53C700_LE_ON_BE
 
 define if the chipset must be supported in little endian mode on a big
 endian architecture (used for the 700 on parisc).
@@ -51,9 +57,11 @@ consistent with the best operation of the chip (although some choose
 to drive it off the CPU or bus clock rather than going to the expense
 of an extra clock chip).  The best operation clock speeds are:
 
-53c700 - 25MHz
-53c700-66 - 50MHz
-53c710 - 40Mhz
+=========  =====
+53c700     25MHz
+53c700-66  50MHz
+53c710     40Mhz
+=========  =====
 
 Writing Your Glue Driver
 ========================
@@ -69,7 +77,7 @@ parameters that matter to you (see below), plumb the NCR_700_intr
 routine into the interrupt line and call NCR_700_detect with the host
 template and the new parameters as arguments.  You should also call
 the relevant request_*_region function and place the register base
-address into the `base' pointer of the host parameters.
+address into the 'base' pointer of the host parameters.
 
 In the release routine, you must free the NCR_700_Host_Parameters that
 you allocated, call the corresponding release_*_region and free the
@@ -78,7 +86,7 @@ interrupt.
 Handling Interrupts
 -------------------
 
-In general, you should just plumb the card's interrupt line in with 
+In general, you should just plumb the card's interrupt line in with
 
 request_irq(irq, NCR_700_intr, <irq flags>, <driver name>, host);
 
@@ -95,41 +103,32 @@ Settable NCR_700_Host_Parameters
 The following are a list of the user settable parameters:
 
 clock: (MANDATORY)
-
-Set to the clock speed of the chip in MHz.
+  Set to the clock speed of the chip in MHz.
 
 base: (MANDATORY)
-
-set to the base of the io or mem region for the register set. On 64
-bit architectures this is only 32 bits wide, so the registers must be
-mapped into the low 32 bits of memory.
+  Set to the base of the io or mem region for the register set. On 64
+  bit architectures this is only 32 bits wide, so the registers must be
+  mapped into the low 32 bits of memory.
 
 pci_dev: (OPTIONAL)
-
-set to the PCI board device.  Leave NULL for a non-pci board.  This is
-used for the pci_alloc_consistent() and pci_map_*() functions.
+  Set to the PCI board device.  Leave NULL for a non-pci board.  This is
+  used for the pci_alloc_consistent() and pci_map_*() functions.
 
 dmode_extra: (OPTIONAL, 53c710 only)
-
-extra flags for the DMODE register.  These are used to control bus
-output pins on the 710.  The settings should be a combination of
-DMODE_FC1 and DMODE_FC2.  What these pins actually do is entirely up
-to the board designer.  Usually it is safe to ignore this setting.
+  Extra flags for the DMODE register.  These are used to control bus
+  output pins on the 710.  The settings should be a combination of
+  DMODE_FC1 and DMODE_FC2.  What these pins actually do is entirely up
+  to the board designer.  Usually it is safe to ignore this setting.
 
 differential: (OPTIONAL)
-
-set to 1 if the chip drives a differential bus.
+  Set to 1 if the chip drives a differential bus.
 
 force_le_on_be: (OPTIONAL, only if CONFIG_53C700_LE_ON_BE is set)
-
-set to 1 if the chip is operating in little endian mode on a big
-endian architecture.
+  Set to 1 if the chip is operating in little endian mode on a big
+  endian architecture.
 
 chip710: (OPTIONAL)
-
-set to 1 if the chip is a 53c710.
+  Set to 1 if the chip is a 53c710.
 
 burst_disable: (OPTIONAL, 53c710 only)
-
-disable 8 byte bursting for DMA transfers.
-
+  Disable 8 byte bursting for DMA transfers.
diff --git a/Documentation/scsi/index.rst b/Documentation/scsi/index.rst
index 3ef7ad65372a..99efc77c3ac2 100644
--- a/Documentation/scsi/index.rst
+++ b/Documentation/scsi/index.rst
@@ -7,4 +7,6 @@ Linux SCSI Subsystem
 .. toctree::
    :maxdepth: 1
 
+   53c700
+
    scsi_transport_srp/figures
diff --git a/MAINTAINERS b/MAINTAINERS
index 09b04505e7c3..1552db209e69 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9445,7 +9445,7 @@ LASI 53c700 driver for PARISC
 M:	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
-F:	Documentation/scsi/53c700.txt
+F:	Documentation/scsi/53c700.rst
 F:	drivers/scsi/53c700*
 
 LEAKING_ADDRESSES
-- 
2.21.1


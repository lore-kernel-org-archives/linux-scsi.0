Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A045EC3F2D9
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 08:17:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E3A6246B9
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 08:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583137040;
	bh=uRMw8DHS2+mjwJ6WCZ5ML8KJ623fBLgRY86aZe0Vbk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=cy/26IfPuGDex/lnB/kph/Ox2TOBM4WxeXlld08qSyf1/fSc9MekZUKDUAnBQS6qY
	 twbTb2l8Rjaty3s7ULYQkq7AFvmVRHiMtrVBPcE1eKzVvp+JIJca3EAbojX9V8/up4
	 Odnd56Rhh89Mdrcjl0kz9NrDjG9gad3gsQrs5p3o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbgCBIRE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Mar 2020 03:17:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:57142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727364AbgCBIQY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Mar 2020 03:16:24 -0500
Received: from mail.kernel.org (ip5f5ad4e9.dynamic.kabel-deutschland.de [95.90.212.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4E75246FE;
        Mon,  2 Mar 2020 08:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583136980;
        bh=uRMw8DHS2+mjwJ6WCZ5ML8KJ623fBLgRY86aZe0Vbk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E28pUejODXCjrYS5SWr+qOvYQXtSVTwlWEq3vBVhUijmqP6GqBxYzVQF53bZBJwRf
         VGUg1lPqrNw0pGrEJB1OGcKVymnuXw+F9HvusTxZHgWHxbpsSMVJGHvTQoHypPKjZq
         RgITMCVSgmJpCVOk6jNZwUEvtDZjkt3CihtKTA0E=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1j8gFN-0003zC-Sl; Mon, 02 Mar 2020 09:16:17 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 33/42] docs: scsi: convert scsi.txt to ReST
Date:   Mon,  2 Mar 2020 09:16:06 +0100
Message-Id: <c617b37769a82901def0fed3d236a25995c4e160.1583136624.git.mchehab+huawei@kernel.org>
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
 Documentation/scsi/index.rst              |  1 +
 Documentation/scsi/{scsi.txt => scsi.rst} | 31 +++++++++++++----------
 drivers/scsi/Kconfig                      | 16 ++++++------
 3 files changed, 26 insertions(+), 22 deletions(-)
 rename Documentation/scsi/{scsi.txt => scsi.rst} (82%)

diff --git a/Documentation/scsi/index.rst b/Documentation/scsi/index.rst
index 4bf0bb26f3d5..97276e425f25 100644
--- a/Documentation/scsi/index.rst
+++ b/Documentation/scsi/index.rst
@@ -37,5 +37,6 @@ Linux SCSI Subsystem
    scsi-generic
    scsi_mid_low_api
    scsi-parameters
+   scsi
 
    scsi_transport_srp/figures
diff --git a/Documentation/scsi/scsi.txt b/Documentation/scsi/scsi.rst
similarity index 82%
rename from Documentation/scsi/scsi.txt
rename to Documentation/scsi/scsi.rst
index 3d99d38cb62a..276918eb4d74 100644
--- a/Documentation/scsi/scsi.txt
+++ b/Documentation/scsi/scsi.rst
@@ -1,44 +1,47 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+============================
 SCSI subsystem documentation
 ============================
+
 The Linux Documentation Project (LDP) maintains a document describing
 the SCSI subsystem in the Linux kernel (lk) 2.4 series. See:
 http://www.tldp.org/HOWTO/SCSI-2.4-HOWTO . The LDP has single
 and multiple page HTML renderings as well as postscript and pdf.
 It can also be found at:
-http://web.archive.org/web/*/http://www.torque.net/scsi/SCSI-2.4-HOWTO
+http://web.archive.org/web/%2E/http://www.torque.net/scsi/SCSI-2.4-HOWTO
 
 Notes on using modules in the SCSI subsystem
 ============================================
-The scsi support in the linux kernel can be modularized in a number of 
+The scsi support in the linux kernel can be modularized in a number of
 different ways depending upon the needs of the end user.  To understand
 your options, we should first define a few terms.
 
-The scsi-core (also known as the "mid level") contains the core of scsi 
+The scsi-core (also known as the "mid level") contains the core of scsi
 support.  Without it you can do nothing with any of the other scsi drivers.
 The scsi core support can be a module (scsi_mod.o), or it can be built into
-the kernel. If the core is a module, it must be the first scsi module 
-loaded, and if you unload the modules, it will have to be the last one 
+the kernel. If the core is a module, it must be the first scsi module
+loaded, and if you unload the modules, it will have to be the last one
 unloaded.  In practice the modprobe and rmmod commands (and "autoclean")
 will enforce the correct ordering of loading and unloading modules in
 the SCSI subsystem.
 
-The individual upper and lower level drivers can be loaded in any order 
+The individual upper and lower level drivers can be loaded in any order
 once the scsi core is present in the kernel (either compiled in or loaded
 as a module).  The disk driver (sd_mod.o), cdrom driver (sr_mod.o),
-tape driver ** (st.o) and scsi generics driver (sg.o) represent the upper 
-level drivers to support the various assorted devices which can be 
-controlled.  You can for example load the tape driver to use the tape drive, 
+tape driver [1]_ (st.o) and scsi generics driver (sg.o) represent the upper
+level drivers to support the various assorted devices which can be
+controlled.  You can for example load the tape driver to use the tape drive,
 and then unload it once you have no further need for the driver (and release
 the associated memory).
 
 The lower level drivers are the ones that support the individual cards that
 are supported for the hardware platform that you are running under. Those
 individual cards are often called Host Bus Adapters (HBAs). For example the
-aic7xxx.o driver is used to control all recent SCSI controller cards from 
-Adaptec. Almost all lower level drivers can be built either as modules or 
+aic7xxx.o driver is used to control all recent SCSI controller cards from
+Adaptec. Almost all lower level drivers can be built either as modules or
 built into the kernel.
 
-
-** There is a variant of the st driver for controlling OnStream tape
-   devices. Its module name is osst.o .
+.. [1] There is a variant of the st driver for controlling OnStream tape
+       devices. Its module name is osst.o .
 
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index bdf65b0bb78b..c705e2b951a4 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -33,7 +33,7 @@ config SCSI
 	  Channel, and FireWire storage.
 
 	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/scsi/scsi.txt>.
+	  <file:Documentation/scsi/scsi.rst>.
 	  The module will be called scsi_mod.
 
 	  However, do not compile this as a module if your root file system
@@ -79,7 +79,7 @@ config BLK_DEV_SD
 	  CD-ROMs.
 
 	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/scsi/scsi.txt>.
+	  <file:Documentation/scsi/scsi.rst>.
 	  The module will be called sd_mod.
 
 	  Do not compile this driver as a module if your root file system
@@ -98,7 +98,7 @@ config CHR_DEV_ST
 	  for SCSI CD-ROMs.
 
 	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/scsi/scsi.txt>. The module will be called st.
+	  <file:Documentation/scsi/scsi.rst>. The module will be called st.
 
 config BLK_DEV_SR
 	tristate "SCSI CDROM support"
@@ -112,7 +112,7 @@ config BLK_DEV_SR
 	  Make sure to say Y or M to "ISO 9660 CD-ROM file system support".
 
 	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/scsi/scsi.txt>.
+	  <file:Documentation/scsi/scsi.rst>.
 	  The module will be called sr_mod.
 
 config CHR_DEV_SG
@@ -136,7 +136,7 @@ config CHR_DEV_SG
 	  <file:Documentation/scsi/scsi-generic.rst> for more information.
 
 	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/scsi/scsi.txt>. The module will be called sg.
+	  <file:Documentation/scsi/scsi.rst>. The module will be called sg.
 
 	  If unsure, say N.
 
@@ -154,7 +154,7 @@ config CHR_DEV_SCH
 	  If you want to compile this as a module ( = code which can be
 	  inserted in and removed from the running kernel whenever you want),
 	  say M here and read <file:Documentation/kbuild/modules.rst> and
-	  <file:Documentation/scsi/scsi.txt>. The module will be called ch.o.
+	  <file:Documentation/scsi/scsi.rst>. The module will be called ch.o.
 	  If unsure, say N.
 
 config SCSI_ENCLOSURE
@@ -604,7 +604,7 @@ config FCOE_FNIC
 	  This is support for the Cisco PCI-Express FCoE HBA.
 
 	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/scsi/scsi.txt>.
+	  <file:Documentation/scsi/scsi.rst>.
 	  The module will be called fnic.
 
 config SCSI_SNIC
@@ -614,7 +614,7 @@ config SCSI_SNIC
 	  This is support for the Cisco PCI-Express SCSI HBA.
 
 	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/scsi/scsi.txt>.
+	  <file:Documentation/scsi/scsi.rst>.
 	  The module will be called snic.
 
 config SCSI_SNIC_DEBUG_FS
-- 
2.21.1


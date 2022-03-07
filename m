Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B2E0C433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Mar 2022 01:32:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234604AbiCGBd2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Mar 2022 20:33:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233960AbiCGBd2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2022 20:33:28 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2F9303;
        Sun,  6 Mar 2022 17:32:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=8scveQ0yvF1fZzX2Ib/Z9C+ILbGxteGvid64z61YsgA=; b=xs3slkKeVjHwVDyEYr/OhF+pZx
        LcO6coBl08W0ONkoPA9azgOOcwhoPro6AUtDfOTbo2upatBwB437wQXDBCgE+qSKFG1diPGh/Asoh
        84MkVbXgfUHAcwxzmjmTcYYz2IELPExIRnvtivjGcSPXacauKjinOxt3opbu5WH4Bb7dKHuAbpk7E
        WFUZsSOTT5GWjYZvLCDd2XrvyeJSeHx+Uad3bTl2bj5Uf9JVgIeQcmugRNcvEKfglNhbUdqXs3tmH
        f9d2V4Om3HPas/YThEm8j4vEw8UuRlfxQodzzJAY5gK9nMF98wvwIbyXYfepMUFumY1pkMa4u20Af
        jZkx7+iQ==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nR2Ed-00FVVj-7f; Mon, 07 Mar 2022 01:32:27 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-doc@vger.kernel.org
Cc:     patches@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH] SCSI: docs: UFS documentation corrections
Date:   Sun,  6 Mar 2022 17:32:24 -0800
Message-Id: <20220307013224.5130-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make a variety of corrections to ufs.rst:

- add spaces around parenthetical phrases
- correct singular/plural grammar and nouns
- correct punctuation
- add article adjectives
- add hyphens to multi-word adjectives
- spell Lun as LUN
- spell upiu as UPIU (in text, not code examples)
- don't capitalize generic "specification"

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>
---
 Documentation/scsi/ufs.rst |   70 +++++++++++++++++------------------
 1 file changed, 35 insertions(+), 35 deletions(-)

--- linux-next-20220304.orig/Documentation/scsi/ufs.rst
+++ linux-next-20220304/Documentation/scsi/ufs.rst
@@ -10,8 +10,8 @@ Universal Flash Storage
    1. Overview
    2. UFS Architecture Overview
      2.1 Application Layer
-     2.2 UFS Transport Protocol(UTP) layer
-     2.3 UFS Interconnect(UIC) Layer
+     2.2 UFS Transport Protocol (UTP) layer
+     2.3 UFS Interconnect (UIC) Layer
    3. UFSHCD Overview
      3.1 UFS controller initialization
      3.2 UTP Transfer requests
@@ -22,15 +22,15 @@ Universal Flash Storage
 1. Overview
 ===========
 
-Universal Flash Storage(UFS) is a storage specification for flash devices.
-It is aimed to provide a universal storage interface for both
-embedded and removable flash memory based storage in mobile
+Universal Flash Storage (UFS) is a storage specification for flash devices.
+It aims to provide a universal storage interface for both
+embedded and removable flash memory-based storage in mobile
 devices such as smart phones and tablet computers. The specification
 is defined by JEDEC Solid State Technology Association. UFS is based
-on MIPI M-PHY physical layer standard. UFS uses MIPI M-PHY as the
+on the MIPI M-PHY physical layer standard. UFS uses MIPI M-PHY as the
 physical layer and MIPI Unipro as the link layer.
 
-The main goals of UFS is to provide:
+The main goals of UFS are to provide:
 
  * Optimized performance:
 
@@ -53,17 +53,17 @@ The main goals of UFS is to provide:
 UFS has a layered communication architecture which is based on SCSI
 SAM-5 architectural model.
 
-UFS communication architecture consists of following layers,
+UFS communication architecture consists of the following layers.
 
 2.1 Application Layer
 ---------------------
 
-  The Application layer is composed of UFS command set layer(UCS),
+  The Application layer is composed of the UFS command set layer (UCS),
   Task Manager and Device manager. The UFS interface is designed to be
   protocol agnostic, however SCSI has been selected as a baseline
-  protocol for versions 1.0 and 1.1 of UFS protocol  layer.
+  protocol for versions 1.0 and 1.1 of the UFS protocol layer.
 
-  UFS supports subset of SCSI commands defined by SPC-4 and SBC-3.
+  UFS supports a subset of SCSI commands defined by SPC-4 and SBC-3.
 
   * UCS:
      It handles SCSI commands supported by UFS specification.
@@ -78,10 +78,10 @@ UFS communication architecture consists
      requests which are used to modify and retrieve configuration
      information of the device.
 
-2.2 UFS Transport Protocol(UTP) layer
--------------------------------------
+2.2 UFS Transport Protocol (UTP) layer
+--------------------------------------
 
-  UTP layer provides services for
+  The UTP layer provides services for
   the higher layers through Service Access Points. UTP defines 3
   service access points for higher layers.
 
@@ -89,19 +89,19 @@ UFS communication architecture consists
     manager for device level operations. These device level operations
     are done through query requests.
   * UTP_CMD_SAP: Command service access point is exposed to UFS command
-    set layer(UCS) to transport commands.
+    set layer (UCS) to transport commands.
   * UTP_TM_SAP: Task management service access point is exposed to task
     manager to transport task management functions.
 
-  UTP transports messages through UFS protocol information unit(UPIU).
+  UTP transports messages through UFS protocol information unit (UPIU).
 
-2.3 UFS Interconnect(UIC) Layer
--------------------------------
+2.3 UFS Interconnect (UIC) Layer
+--------------------------------
 
-  UIC is the lowest layer of UFS layered architecture. It handles
-  connection between UFS host and UFS device. UIC consists of
+  UIC is the lowest layer of the UFS layered architecture. It handles
+  the connection between UFS host and UFS device. UIC consists of
   MIPI UniPro and MIPI M-PHY. UIC provides 2 service access points
-  to upper layer,
+  to upper layer:
 
   * UIC_SAP: To transport UPIU between UFS host and UFS device.
   * UIO_SAP: To issue commands to Unipro layers.
@@ -110,25 +110,25 @@ UFS communication architecture consists
 3. UFSHCD Overview
 ==================
 
-The UFS host controller driver is based on Linux SCSI Framework.
-UFSHCD is a low level device driver which acts as an interface between
-SCSI Midlayer and PCIe based UFS host controllers.
+The UFS host controller driver is based on the Linux SCSI Framework.
+UFSHCD is a low-level device driver which acts as an interface between
+the SCSI Midlayer and PCIe-based UFS host controllers.
 
-The current UFSHCD implementation supports following functionality,
+The current UFSHCD implementation supports the following functionality:
 
 3.1 UFS controller initialization
 ---------------------------------
 
-  The initialization module brings UFS host controller to active state
-  and prepares the controller to transfer commands/response between
+  The initialization module brings the UFS host controller to active state
+  and prepares the controller to transfer commands/responses between
   UFSHCD and UFS device.
 
 3.2 UTP Transfer requests
 -------------------------
 
   Transfer request handling module of UFSHCD receives SCSI commands
-  from SCSI Midlayer, forms UPIUs and issues the UPIUs to UFS Host
-  controller. Also, the module decodes, responses received from UFS
+  from the SCSI Midlayer, forms UPIUs and issues the UPIUs to the UFS Host
+  controller. Also, the module decodes responses received from the UFS
   host controller in the form of UPIUs and intimates the SCSI Midlayer
   of the status of the command.
 
@@ -136,19 +136,19 @@ The current UFSHCD implementation suppor
 ----------------------
 
   Error handling module handles Host controller fatal errors,
-  Device fatal errors and UIC interconnect layer related errors.
+  Device fatal errors and UIC interconnect layer-related errors.
 
 3.4 SCSI Error handling
 -----------------------
 
   This is done through UFSHCD SCSI error handling routines registered
-  with SCSI Midlayer. Examples of some of the error handling commands
-  issues by SCSI Midlayer are Abort task, Lun reset and host reset.
+  with the SCSI Midlayer. Examples of some of the error handling commands
+  issues by the SCSI Midlayer are Abort task, LUN reset and host reset.
   UFSHCD Routines to perform these tasks are registered with
   SCSI Midlayer through .eh_abort_handler, .eh_device_reset_handler and
   .eh_host_reset_handler.
 
-In this version of UFSHCD Query requests and power management
+In this version of UFSHCD, Query requests and power management
 functionality are not implemented.
 
 4. BSG Support
@@ -182,14 +182,14 @@ If you wish to read or write a descripto
 sg_io_v4.
 
 The userspace tool that interacts with the ufs-bsg endpoint and uses its
-upiu-based protocol is available at:
+UPIU-based protocol is available at:
 
 	https://github.com/westerndigitalcorporation/ufs-tool
 
 For more detailed information about the tool and its supported
 features, please see the tool's README.
 
-UFS Specifications can be found at:
+UFS specifications can be found at:
 
 - UFS - http://www.jedec.org/sites/default/files/docs/JESD220.pdf
 - UFSHCI - http://www.jedec.org/sites/default/files/docs/JESD223.pdf

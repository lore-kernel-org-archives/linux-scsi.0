Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8400BC3F2D2
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 08:19:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44CAD246B4
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 08:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583137149;
	bh=GLxZsUQq+Lij8M5TFkR1baqj1S8OGH1zk8esZJ1wNcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=HeHzVj8MTrOA9eunlNCFxjJ0yXPjpCt4+uvrmJiuoTnUXd005P/jP2oFn/cysho3O
	 LjST5rzH/7Bv9MzjQpUeBgbu+tVtSz4quI11Z0bvNWW8q9nvTNlGYNJUN0WQoYHUv0
	 Bi22H5eXDfzE3yG04P/yW+P6AcM6Z3cozCTfkP2k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbgCBITA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Mar 2020 03:19:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:57094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727154AbgCBIQU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Mar 2020 03:16:20 -0500
Received: from mail.kernel.org (ip5f5ad4e9.dynamic.kabel-deutschland.de [95.90.212.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 401E2246D5;
        Mon,  2 Mar 2020 08:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583136979;
        bh=GLxZsUQq+Lij8M5TFkR1baqj1S8OGH1zk8esZJ1wNcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ds7nPUvsI4F0Celyc8rzVkvLv8/pNwQpo5zgezjJtGA1lFPoCD58AHPo7Bct/N2Ne
         4h2apFBDolOWigUnJXUPUQ+hb4zRJR1NNQNEDFr0ikYPcqgxI2gXOWuhml5NTjpmJK
         7apaLpK13kNjRc/cnZSp4VRwuest8tfUGdgdMhHc=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1j8gFN-0003xe-C0; Mon, 02 Mar 2020 09:16:17 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 14/42] docs: scsi: convert dpti.txt to ReST
Date:   Mon,  2 Mar 2020 09:15:47 +0100
Message-Id: <212fd7961c134c5bd73d87cd818bcddc30270804.1583136624.git.mchehab+huawei@kernel.org>
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
 Documentation/scsi/dpti.rst   | 92 +++++++++++++++++++++++++++++++++++
 Documentation/scsi/dpti.txt   | 83 -------------------------------
 Documentation/scsi/index.rst  |  1 +
 drivers/scsi/Kconfig          |  2 +-
 drivers/scsi/dpt/dpti_ioctl.h |  2 +-
 drivers/scsi/dpt_i2o.c        |  2 +-
 drivers/scsi/dpti.h           |  2 +-
 7 files changed, 97 insertions(+), 87 deletions(-)
 create mode 100644 Documentation/scsi/dpti.rst
 delete mode 100644 Documentation/scsi/dpti.txt

diff --git a/Documentation/scsi/dpti.rst b/Documentation/scsi/dpti.rst
new file mode 100644
index 000000000000..0496919d87d3
--- /dev/null
+++ b/Documentation/scsi/dpti.rst
@@ -0,0 +1,92 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===================
+Adaptec dpti driver
+===================
+
+Redistribution and use in source form, with or without modification, are
+permitted provided that redistributions of source code must retain the
+above copyright notice, this list of conditions and the following disclaimer.
+
+This software is provided ``as is`` by Adaptec and
+any express or implied warranties, including, but not limited to, the
+implied warranties of merchantability and fitness for a particular purpose,
+are disclaimed. In no event shall Adaptec be
+liable for any direct, indirect, incidental, special, exemplary or
+consequential damages (including, but not limited to, procurement of
+substitute goods or services; loss of use, data, or profits; or business
+interruptions) however caused and on any theory of liability, whether in
+contract, strict liability, or tort (including negligence or otherwise)
+arising in any way out of the use of this driver software, even if advised
+of the possibility of such damage.
+
+This driver supports the Adaptec I2O RAID and DPT SmartRAID V I2O boards.
+
+Credits
+=======
+
+The original linux driver was ported to Linux by Karen White while at
+Dell Computer.  It was ported from Bob Pasteur's (of DPT) original
+non-Linux driver.  Mark Salyzyn and Bob Pasteur consulted on the original
+driver.
+
+2.0 version of the driver by Deanna Bonds and Mark Salyzyn.
+
+History
+=======
+
+The driver was originally ported to linux version 2.0.34
+
+==== ==========================================================================
+V2.0 Rewrite of driver.  Re-architectured based on i2o subsystem.
+     This was the first full GPL version since the last version used
+     i2osig headers which were not GPL.  Developer Testing version.
+V2.1 Internal testing
+V2.2 First released version
+
+V2.3 Changes:
+
+     - Added Raptor Support
+     - Fixed bug causing system to hang under extreme load with
+     - management utilities running (removed GFP_DMA from kmalloc flags)
+
+V2.4 First version ready to be submitted to be embedded in the kernel
+
+     Changes:
+
+     - Implemented suggestions from Alan Cox
+     - Added calculation of resid for sg layer
+     - Better error handling
+     - Added checking underflow conditions
+     - Added DATAPROTECT checking
+     - Changed error return codes
+     - Fixed pointer bug in bus reset routine
+     - Enabled hba reset from ioctls (allows a FW flash to reboot and use
+       the new FW without having to reboot)
+     - Changed proc output
+==== ==========================================================================
+
+TODO
+====
+- Add 64 bit Scatter Gather when compiled on 64 bit architectures
+- Add sparse lun scanning
+- Add code that checks if a device that had been taken offline is
+  now online (at the FW level) when test unit ready or inquiry
+  command from scsi-core
+- Add proc read interface
+- busrescan command
+- rescan command
+- Add code to rescan routine that notifies scsi-core about new devices
+- Add support for C-PCI (hotplug stuff)
+- Add ioctl passthru error recovery
+
+Notes
+=====
+The DPT card optimizes the order of processing commands.  Consequently,
+a command may take up to 6 minutes to complete after it has been sent
+to the board.
+
+The files dpti_ioctl.h dptsig.h osd_defs.h osd_util.h sys_info.h are part of the
+interface files for Adaptec's management routines.  These define the structures used
+in the ioctls.  They are written to be portable.  They are hard to read, but I need
+to use them 'as is' or I can miss changes in the interface.
diff --git a/Documentation/scsi/dpti.txt b/Documentation/scsi/dpti.txt
deleted file mode 100644
index f36dc0e7c8da..000000000000
--- a/Documentation/scsi/dpti.txt
+++ /dev/null
@@ -1,83 +0,0 @@
- /* TERMS AND CONDITIONS OF USE
- * 
- * Redistribution and use in source form, with or without modification, are
- * permitted provided that redistributions of source code must retain the
- * above copyright notice, this list of conditions and the following disclaimer.
- * 
- * This software is provided `as is' by Adaptec and
- * any express or implied warranties, including, but not limited to, the
- * implied warranties of merchantability and fitness for a particular purpose,
- * are disclaimed. In no event shall Adaptec be
- * liable for any direct, indirect, incidental, special, exemplary or
- * consequential damages (including, but not limited to, procurement of
- * substitute goods or services; loss of use, data, or profits; or business
- * interruptions) however caused and on any theory of liability, whether in
- * contract, strict liability, or tort (including negligence or otherwise)
- * arising in any way out of the use of this driver software, even if advised
- * of the possibility of such damage.
- * 
- ****************************************************************
- * This driver supports the Adaptec I2O RAID and DPT SmartRAID V I2O boards.
- *
- * CREDITS:
- * The original linux driver was ported to Linux by Karen White while at 
- * Dell Computer.  It was ported from Bob Pasteur's (of DPT) original 
- * non-Linux driver.  Mark Salyzyn and Bob Pasteur consulted on the original
- * driver. 
- * 
- * 2.0 version of the driver by Deanna Bonds and Mark Salyzyn.
- *
- * HISTORY:
- * The driver was originally ported to linux version 2.0.34 
- *
- * V2.0 Rewrite of driver.  Re-architectured based on i2o subsystem.
- *   This was the first full GPL version since the last version used
- *   i2osig headers which were not GPL.  Developer Testing version.
- * V2.1 Internal testing
- * V2.2 First released version
- *
- * V2.3 
- *   Changes:
- *      Added Raptor Support
- *      Fixed bug causing system to hang under extreme load with 
- *         management utilities running (removed GFP_DMA from kmalloc flags)
- *
- *
- * V2.4 First version ready to be submitted to be embedded in the kernel
- *   Changes: 
- *      Implemented suggestions from Alan Cox
- *      Added calculation of resid for sg layer
- *      Better error handling
- *         Added checking underflow conditions 
- *         Added DATAPROTECT checking
- *         Changed error return codes
- *         Fixed pointer bug in bus reset routine
- *      Enabled hba reset from ioctls (allows a FW flash to reboot and use the new
- *         FW without having to reboot)
- *      Changed proc output
- *
- * TODO:
- *      Add 64 bit Scatter Gather when compiled on 64 bit architectures
- *      Add sparse lun scanning 
- *      Add code that checks if a device that had been taken offline is
- *         now online (at the FW level) when test unit ready or inquiry 
- *         command from scsi-core
- *      Add proc read interface
- *         busrescan command
- *         rescan command
- *      Add code to rescan routine that notifies scsi-core about new devices
- *      Add support for C-PCI (hotplug stuff)
- *      Add ioctl passthru error recovery
- *
- * NOTES:
- * The DPT card optimizes the order of processing commands.  Consequently,
- * a command may take up to 6 minutes to complete after it has been sent
- * to the board.  
- *
- * The files dpti_ioctl.h dptsig.h osd_defs.h osd_util.h sys_info.h are part of the
- * interface files for Adaptec's management routines.  These define the structures used
- * in the ioctls.  They are written to be portable.  They are hard to read, but I need
- * to use them 'as is' or I can miss changes in the interface.
- *
- */
-
diff --git a/Documentation/scsi/index.rst b/Documentation/scsi/index.rst
index 6fe00709cbce..b553dd9904bf 100644
--- a/Documentation/scsi/index.rst
+++ b/Documentation/scsi/index.rst
@@ -18,5 +18,6 @@ Linux SCSI Subsystem
    BusLogic
    cxgb3i
    dc395x
+   dpti
 
    scsi_transport_srp/figures
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 9f5b2ddec6e0..5e834fba7934 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -448,7 +448,7 @@ config SCSI_DPT_I2O
 	help
 	  This driver supports all of Adaptec's I2O based RAID controllers as 
 	  well as the DPT SmartRaid V cards.  This is an Adaptec maintained
-	  driver by Deanna Bonds.  See <file:Documentation/scsi/dpti.txt>.
+	  driver by Deanna Bonds.  See <file:Documentation/scsi/dpti.rst>.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called dpt_i2o.
diff --git a/drivers/scsi/dpt/dpti_ioctl.h b/drivers/scsi/dpt/dpti_ioctl.h
index 6bc33f4f020d..25e9251f8c78 100644
--- a/drivers/scsi/dpt/dpti_ioctl.h
+++ b/drivers/scsi/dpt/dpti_ioctl.h
@@ -5,7 +5,7 @@
     begin                : Thu Sep 7 2000
     copyright            : (C) 2001 by Adaptec
 
-    See Documentation/scsi/dpti.txt for history, notes, license info
+    See Documentation/scsi/dpti.rst for history, notes, license info
     and credits
  ***************************************************************************/
 
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index abc74fd474dc..5362fb0b96a7 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -8,7 +8,7 @@
 			   July 30, 2001 First version being submitted
 			   for inclusion in the kernel.  V2.4
 
-    See Documentation/scsi/dpti.txt for history, notes, license info
+    See Documentation/scsi/dpti.rst for history, notes, license info
     and credits
  ***************************************************************************/
 
diff --git a/drivers/scsi/dpti.h b/drivers/scsi/dpti.h
index 42b1e28b5884..6da9ab1fcfe8 100644
--- a/drivers/scsi/dpti.h
+++ b/drivers/scsi/dpti.h
@@ -5,7 +5,7 @@
     begin                : Thu Sep 7 2000
     copyright            : (C) 2001 by Adaptec
 
-    See Documentation/scsi/dpti.txt for history, notes, license info
+    See Documentation/scsi/dpti.rst for history, notes, license info
     and credits
  ***************************************************************************/
 
-- 
2.21.1


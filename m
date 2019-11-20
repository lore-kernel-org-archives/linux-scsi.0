Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E828C432C3
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 13:39:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DAC52251E
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 13:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574257185;
	bh=wh6gs7JZdnRSi3V+gwHQpwk4FJGVKz369YHz8iexk4I=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=miwKxE89XuzNOm5+RNwA41Kc7QbnERhsHpSs6UK5j8/rGnfssrCOI57B5qE3cshQH
	 cZXpp3CO5LEWfFDac2eKCmuTukXMXnGyvqyuK11RIsCZWGPXmz/boM0+TnttQULt8A
	 q5nCuXrmNVJP5YozRYptb2s8TWPy5pkHvdRYKlnw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728983AbfKTNjl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 08:39:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:47410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728748AbfKTNjk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Nov 2019 08:39:40 -0500
Received: from localhost.localdomain (unknown [118.189.143.39])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67919224FA;
        Wed, 20 Nov 2019 13:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574257179;
        bh=wh6gs7JZdnRSi3V+gwHQpwk4FJGVKz369YHz8iexk4I=;
        h=From:To:Cc:Subject:Date:From;
        b=tH6j1B7RK5l9V7SL8/evr0mvUk3L0FmndML6TKA2wSBtYlkKMHBTXWjN8T0SxzQG5
         KFfJCLE3lzB91WjdwLA+U1fnQO2Z1bC75405TCojLMyGk1VBp/0gRWLA2DQ8Ben5Au
         WUPRf6Ys+jiI1W8rgo0H1asXgbksxxvb8Sewgpi0=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>,
        QLogic-Storage-Upstream@cavium.com,
        Don Brace <don.brace@microsemi.com>,
        linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com
Subject: [PATCH] scsi: Fix Kconfig indentation
Date:   Wed, 20 Nov 2019 21:39:34 +0800
Message-Id: <20191120133935.13823-1-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Adjust indentation from spaces to tab (+optional two spaces) as in
coding style with command like:
	$ sed -e 's/^        /\t/' -i */Kconfig

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/scsi/Kconfig                 | 22 +++++++++++-----------
 drivers/scsi/aic7xxx/Kconfig.aic7xxx | 14 +++++++-------
 drivers/scsi/pcmcia/Kconfig          |  2 +-
 drivers/scsi/qedf/Kconfig            |  4 ++--
 drivers/scsi/smartpqi/Kconfig        |  8 ++++----
 5 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 90cf4691b8c3..de6b99573f9e 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1166,8 +1166,8 @@ config SCSI_LPFC
 	depends on NVME_FC || NVME_FC=n
 	select CRC_T10DIF
 	---help---
-          This lpfc driver supports the Emulex LightPulse
-          Family of Fibre Channel PCI host adapters.
+	  This lpfc driver supports the Emulex LightPulse
+	  Family of Fibre Channel PCI host adapters.
 
 config SCSI_LPFC_DEBUG_FS
 	bool "Emulex LightPulse Fibre Channel debugfs Support"
@@ -1480,14 +1480,14 @@ config ZFCP
 	depends on S390 && QDIO && SCSI
 	depends on SCSI_FC_ATTRS
 	help
-          If you want to access SCSI devices attached to your IBM eServer
-          zSeries by means of Fibre Channel interfaces say Y.
-          For details please refer to the documentation provided by IBM at
-          <http://oss.software.ibm.com/developerworks/opensource/linux390>
+	  If you want to access SCSI devices attached to your IBM eServer
+	  zSeries by means of Fibre Channel interfaces say Y.
+	  For details please refer to the documentation provided by IBM at
+	  <http://oss.software.ibm.com/developerworks/opensource/linux390>
 
-          This driver is also available as a module. This module will be
-          called zfcp. If you want to compile it as a module, say M here
-          and read <file:Documentation/kbuild/modules.rst>.
+	  This driver is also available as a module. This module will be
+	  called zfcp. If you want to compile it as a module, say M here
+	  and read <file:Documentation/kbuild/modules.rst>.
 
 config SCSI_PMCRAID
 	tristate "PMC SIERRA Linux MaxRAID adapter support"
@@ -1518,8 +1518,8 @@ config SCSI_VIRTIO
 	tristate "virtio-scsi support"
 	depends on VIRTIO
 	help
-          This is the virtual HBA driver for virtio.  If the kernel will
-          be used in a virtual machine, say Y or M.
+	  This is the virtual HBA driver for virtio.  If the kernel will
+	  be used in a virtual machine, say Y or M.
 
 source "drivers/scsi/csiostor/Kconfig"
 
diff --git a/drivers/scsi/aic7xxx/Kconfig.aic7xxx b/drivers/scsi/aic7xxx/Kconfig.aic7xxx
index 3546b8cc401f..4ed44ba4a55b 100644
--- a/drivers/scsi/aic7xxx/Kconfig.aic7xxx
+++ b/drivers/scsi/aic7xxx/Kconfig.aic7xxx
@@ -71,20 +71,20 @@ config AIC7XXX_DEBUG_ENABLE
 	driver errors.
 
 config AIC7XXX_DEBUG_MASK
-        int "Debug code enable mask (2047 for all debugging)"
-        depends on SCSI_AIC7XXX
-        default "0"
-        help
+	int "Debug code enable mask (2047 for all debugging)"
+	depends on SCSI_AIC7XXX
+	default "0"
+	help
 	Bit mask of debug options that is only valid if the
 	CONFIG_AIC7XXX_DEBUG_ENABLE option is enabled.  The bits in this mask
 	are defined in the drivers/scsi/aic7xxx/aic7xxx.h - search for the
 	variable ahc_debug in that file to find them.
 
 config AIC7XXX_REG_PRETTY_PRINT
-        bool "Decode registers during diagnostics"
-        depends on SCSI_AIC7XXX
+	bool "Decode registers during diagnostics"
+	depends on SCSI_AIC7XXX
 	default y
-        help
+	help
 	Compile in register value tables for the output of expanded register
 	contents in diagnostics.  This make it much easier to understand debug
 	output without having to refer to a data book and/or the aic7xxx.reg
diff --git a/drivers/scsi/pcmcia/Kconfig b/drivers/scsi/pcmcia/Kconfig
index dc9b74c9348a..a7920fc95e7d 100644
--- a/drivers/scsi/pcmcia/Kconfig
+++ b/drivers/scsi/pcmcia/Kconfig
@@ -56,7 +56,7 @@ config PCMCIA_NINJA_SCSI
 	    [I-O DATA (OEM) (version string: "IO DATA","CBSC16       ","1")]
 	    I-O DATA CBSC-II
 	    [Kyusyu Matsushita Kotobuki (OEM)
-               (version string: "KME    ","SCSI-CARD-001","1")]
+	       (version string: "KME    ","SCSI-CARD-001","1")]
 	    KME KXL-820AN's card
 	    HP M820e CDRW's card
 	    etc.
diff --git a/drivers/scsi/qedf/Kconfig b/drivers/scsi/qedf/Kconfig
index 7cd993be4e57..80328dbd44c9 100644
--- a/drivers/scsi/qedf/Kconfig
+++ b/drivers/scsi/qedf/Kconfig
@@ -3,8 +3,8 @@ config QEDF
 	tristate "QLogic QEDF 25/40/100Gb FCoE Initiator Driver Support"
 	depends on PCI && SCSI
 	depends on QED
-        depends on LIBFC
-        depends on LIBFCOE
+	depends on LIBFC
+	depends on LIBFCOE
 	select QED_LL2
 	select QED_FCOE
 	---help---
diff --git a/drivers/scsi/smartpqi/Kconfig b/drivers/scsi/smartpqi/Kconfig
index bc6506884e3b..456ec474fa17 100644
--- a/drivers/scsi/smartpqi/Kconfig
+++ b/drivers/scsi/smartpqi/Kconfig
@@ -50,7 +50,7 @@ config SCSI_SMARTPQI
 	To compile this driver as a module, choose M here: the
 	module will be called smartpqi.
 
-        Note: the aacraid driver will not manage a smartpqi
-              controller. You need to enable smartpqi for smartpqi
-              controllers. For more information, please see
-              Documentation/scsi/smartpqi.txt
+	Note: the aacraid driver will not manage a smartpqi
+	      controller. You need to enable smartpqi for smartpqi
+	      controllers. For more information, please see
+	      Documentation/scsi/smartpqi.txt
-- 
2.17.1


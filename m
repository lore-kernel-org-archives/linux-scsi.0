Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4AB7C3F2D2
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 08:16:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95BE6246BF
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 08:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583137013;
	bh=AITD7simnYvG/55RG6ql5zrQiA32yGAnHizU+xiGK6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=x4q/Xd75uiHRiZtdTt+LnnvsHzA2ci1Zh90XPSqu82uXSnBmz40J9LTueSxofm3Wt
	 4uephPn3gxKc3xFiCiEGLEm3oFH00+khU9sOfDCNp5ERHVA7dy1zbfAWRgNTULgEXl
	 +xsExkySgArk2qih9jTCM/+/ekad2EsF1lVWLhaQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbgCBIQZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Mar 2020 03:16:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:57372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727367AbgCBIQZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Mar 2020 03:16:25 -0500
Received: from mail.kernel.org (ip5f5ad4e9.dynamic.kabel-deutschland.de [95.90.212.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2052222C4;
        Mon,  2 Mar 2020 08:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583136980;
        bh=AITD7simnYvG/55RG6ql5zrQiA32yGAnHizU+xiGK6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D8NY649zEqE6VcLkhcp9pvJn1T1N1bUmAZq6L9TF3l6sDi86OtaQj0I9PiqC7dO7Q
         8gXQ19WtjUnmwJwi4OlXsXMN7BAd35a0z8BOKRJj2vPamQ3Zw6D3ulWH2zCf8CAoiu
         H1iwNc68ayXReq2CLZ5SGu+mFFRnIVkeCWS9fRUc=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1j8gFN-0003zP-Uj; Mon, 02 Mar 2020 09:16:17 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Don Brace <don.brace@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org
Subject: [PATCH 35/42] docs: scsi: convert smartpqi.txt to ReST
Date:   Mon,  2 Mar 2020 09:16:08 +0100
Message-Id: <00b398efb7cfc667b046fbef92a84f1d3c33eb64.1583136624.git.mchehab+huawei@kernel.org>
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
 Documentation/scsi/index.rst                  |  1 +
 .../scsi/{smartpqi.txt => smartpqi.rst}       | 52 +++++++++----------
 MAINTAINERS                                   |  2 +-
 drivers/scsi/smartpqi/Kconfig                 |  2 +-
 4 files changed, 28 insertions(+), 29 deletions(-)
 rename Documentation/scsi/{smartpqi.txt => smartpqi.rst} (67%)

diff --git a/Documentation/scsi/index.rst b/Documentation/scsi/index.rst
index 6805e157b6e8..ff98919faed7 100644
--- a/Documentation/scsi/index.rst
+++ b/Documentation/scsi/index.rst
@@ -39,5 +39,6 @@ Linux SCSI Subsystem
    scsi-parameters
    scsi
    sd-parameters
+   smartpqi
 
    scsi_transport_srp/figures
diff --git a/Documentation/scsi/smartpqi.txt b/Documentation/scsi/smartpqi.rst
similarity index 67%
rename from Documentation/scsi/smartpqi.txt
rename to Documentation/scsi/smartpqi.rst
index df129f55ace5..a7de27352c6f 100644
--- a/Documentation/scsi/smartpqi.txt
+++ b/Documentation/scsi/smartpqi.rst
@@ -1,6 +1,8 @@
+.. SPDX-License-Identifier: GPL-2.0
 
+=====================================
 SMARTPQI - Microsemi Smart PQI Driver
------------------------------------------
+=====================================
 
 This file describes the smartpqi SCSI driver for Microsemi
 (http://www.microsemi.com) PQI controllers. The smartpqi driver
@@ -16,20 +18,21 @@ For Microsemi smartpqi controller support, enable the smartpqi driver
 when configuring the kernel.
 
 For more information on the PQI Queuing Interface, please see:
-http://www.t10.org/drafts.htm
-http://www.t10.org/members/w_pqi2.htm
 
-Supported devices:
-------------------
+- http://www.t10.org/drafts.htm
+- http://www.t10.org/members/w_pqi2.htm
+
+Supported devices
+=================
 <Controller names to be added as they become publicly available.>
 
 smartpqi specific entries in /sys
------------------------------
+=================================
 
-  smartpqi host attributes:
-  -------------------------
-  /sys/class/scsi_host/host*/rescan
-  /sys/class/scsi_host/host*/driver_version
+smartpqi host attributes
+------------------------
+  - /sys/class/scsi_host/host*/rescan
+  - /sys/class/scsi_host/host*/driver_version
 
   The host rescan attribute is a write only attribute. Writing to this
   attribute will trigger the driver to scan for new, changed, or removed
@@ -37,12 +40,13 @@ smartpqi specific entries in /sys
 
   The version attribute is read-only and will return the driver version
   and the controller firmware version.
-  For example:
+  For example::
+
               driver: 0.9.13-370
               firmware: 0.01-522
 
-  smartpqi sas device attributes
-  ------------------------------
+smartpqi sas device attributes
+------------------------------
   HBA devices are added to the SAS transport layer. These attributes are
   automatically added by the SAS transport layer.
 
@@ -50,31 +54,25 @@ smartpqi specific entries in /sys
   /sys/class/sas_device/end_device-X:X/enclosure_identifier
   /sys/class/sas_device/end_device-X:X/scsi_target_id
 
-smartpqi specific ioctls:
--------------------------
+smartpqi specific ioctls
+========================
 
   For compatibility with applications written for the cciss protocol.
 
-  CCISS_DEREGDISK
-  CCISS_REGNEWDISK
-  CCISS_REGNEWD
-
-  The above three ioctls all do exactly the same thing, which is to cause the driver
-  to rescan for new devices.  This does exactly the same thing as writing to the
-  smartpqi specific host "rescan" attribute.
+  CCISS_DEREGDISK, CCISS_REGNEWDISK, CCISS_REGNEWD
+	The above three ioctls all do exactly the same thing, which is to cause the driver
+	to rescan for new devices.  This does exactly the same thing as writing to the
+	smartpqi specific host "rescan" attribute.
 
   CCISS_GETPCIINFO
-
 	Returns PCI domain, bus, device and function and "board ID" (PCI subsystem ID).
 
   CCISS_GETDRIVVER
+	Returns driver version in three bytes encoded as::
 
-	Returns driver version in three bytes encoded as:
-	(DRIVER_MAJOR << 28) | (DRIVER_MINOR << 24) | (DRIVER_RELEASE << 16) | DRIVER_REVISION;
+	  (DRIVER_MAJOR << 28) | (DRIVER_MINOR << 24) | (DRIVER_RELEASE << 16) | DRIVER_REVISION;
 
   CCISS_PASSTHRU
-
 	Allows "BMIC" and "CISS" commands to be passed through to the Smart Storage Array.
 	These are used extensively by the SSA Array Configuration Utility, SNMP storage
 	agents, etc.
-
diff --git a/MAINTAINERS b/MAINTAINERS
index 776de9c5b404..f27c24d82c0f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11153,7 +11153,7 @@ F:	drivers/scsi/smartpqi/Kconfig
 F:	drivers/scsi/smartpqi/Makefile
 F:	include/linux/cciss*.h
 F:	include/uapi/linux/cciss*.h
-F:	Documentation/scsi/smartpqi.txt
+F:	Documentation/scsi/smartpqi.rst
 
 MICROSEMI ETHERNET SWITCH DRIVER
 M:	Alexandre Belloni <alexandre.belloni@bootlin.com>
diff --git a/drivers/scsi/smartpqi/Kconfig b/drivers/scsi/smartpqi/Kconfig
index bc6506884e3b..d3311c014863 100644
--- a/drivers/scsi/smartpqi/Kconfig
+++ b/drivers/scsi/smartpqi/Kconfig
@@ -53,4 +53,4 @@ config SCSI_SMARTPQI
         Note: the aacraid driver will not manage a smartpqi
               controller. You need to enable smartpqi for smartpqi
               controllers. For more information, please see
-              Documentation/scsi/smartpqi.txt
+              Documentation/scsi/smartpqi.rst
-- 
2.21.1


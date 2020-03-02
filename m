Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78C2BC3F2DF
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 08:18:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 497A5246B4
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 08:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583137117;
	bh=TYe3QSV9TWPID/dPwasRZ4lyd48T/A8F4VzFpXM3i6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=oMRgHsnTUo79nDemf6gOEe33h7OxZWsdOlo6dkw22tU1+MhtOUaS0RzP9aQGAGTQ/
	 +oPVaHrAdI/7ODbcWsHfMTpX8eG+aCeeUYP4yw4B+Lg71yLbhoKUaQnUN/a6FL3Pel
	 3pYRNG/wp339004atSXoAxUjs3ZZqvwvlt9NmUb4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727574AbgCBISg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Mar 2020 03:18:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:57142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727173AbgCBIQV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Mar 2020 03:16:21 -0500
Received: from mail.kernel.org (ip5f5ad4e9.dynamic.kabel-deutschland.de [95.90.212.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C9FF246D7;
        Mon,  2 Mar 2020 08:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583136979;
        bh=TYe3QSV9TWPID/dPwasRZ4lyd48T/A8F4VzFpXM3i6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VJ86OOo30dwmnFplL+Ics9T+Z9MTzZ/iVuVgUe1m20X1ST2a4jvzE2nv9U9HcfrAS
         g9hGOI4JXHz/tHydaC52h0kCOvtwst0/mdAFs18Do+dQ/leH2iFdCvr6qf9UeQ8oDZ
         sik0La4WyfkLrULb3VucSBdlevK2eDf20QtRrX/0=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1j8gFN-0003xv-F3; Mon, 02 Mar 2020 09:16:17 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Don Brace <don.brace@microsemi.com>,
        esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org
Subject: [PATCH 17/42] docs: scsi: convert hpsa.txt to ReST
Date:   Mon,  2 Mar 2020 09:15:50 +0100
Message-Id: <ea58e04176d43fb7194615b145060aa04c9cf3ad.1583136624.git.mchehab+huawei@kernel.org>
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
 Documentation/scsi/{hpsa.txt => hpsa.rst} | 79 +++++++++++------------
 Documentation/scsi/index.rst              |  1 +
 MAINTAINERS                               |  2 +-
 3 files changed, 41 insertions(+), 41 deletions(-)
 rename Documentation/scsi/{hpsa.txt => hpsa.rst} (77%)

diff --git a/Documentation/scsi/hpsa.txt b/Documentation/scsi/hpsa.rst
similarity index 77%
rename from Documentation/scsi/hpsa.txt
rename to Documentation/scsi/hpsa.rst
index 891435a72fce..340e10c6e35f 100644
--- a/Documentation/scsi/hpsa.txt
+++ b/Documentation/scsi/hpsa.rst
@@ -1,6 +1,8 @@
+.. SPDX-License-Identifier: GPL-2.0
 
+=========================================
 HPSA - Hewlett Packard Smart Array driver
------------------------------------------
+=========================================
 
 This file describes the hpsa SCSI driver for HP Smart Array controllers.
 The hpsa driver is intended to supplant the cciss driver for newer
@@ -11,17 +13,17 @@ driver (for logical drives) AND a SCSI driver (for tape drives). This
 complexity and eliminating that complexity is one of the reasons
 for hpsa to exist.
 
-Supported devices:
-------------------
+Supported devices
+=================
 
-Smart Array P212
-Smart Array P410
-Smart Array P410i
-Smart Array P411
-Smart Array P812
-Smart Array P712m
-Smart Array P711m
-StorageWorks P1210m
+- Smart Array P212
+- Smart Array P410
+- Smart Array P410i
+- Smart Array P411
+- Smart Array P812
+- Smart Array P712m
+- Smart Array P711m
+- StorageWorks P1210m
 
 Additionally, older Smart Arrays may work with the hpsa driver if the kernel
 boot parameter "hpsa_allow_any=1" is specified, however these are not tested
@@ -35,18 +37,20 @@ mode, each command completion requires an interrupt, while with "performant mode
 command completions indicated by a single interrupt.
 
 HPSA specific entries in /sys
------------------------------
+=============================
 
   In addition to the generic SCSI attributes available in /sys, hpsa supports
   the following attributes:
 
-  HPSA specific host attributes:
-  ------------------------------
+HPSA specific host attributes
+=============================
 
-  /sys/class/scsi_host/host*/rescan
-  /sys/class/scsi_host/host*/firmware_revision
-  /sys/class/scsi_host/host*/resettable
-  /sys/class/scsi_host/host*/transport_mode
+  ::
+
+    /sys/class/scsi_host/host*/rescan
+    /sys/class/scsi_host/host*/firmware_revision
+    /sys/class/scsi_host/host*/resettable
+    /sys/class/scsi_host/host*/transport_mode
 
   the host "rescan" attribute is a write only attribute.  Writing to this
   attribute will cause the driver to scan for new, changed, or removed devices
@@ -58,7 +62,7 @@ HPSA specific entries in /sys
   tape drives, or entire storage boxes containing pre-configured logical drives.
 
   The "firmware_revision" attribute contains the firmware version of the Smart Array.
-  For example:
+  For example::
 
 	root@host:/sys/class/scsi_host/host4# cat firmware_revision
 	7.14
@@ -78,16 +82,18 @@ HPSA specific entries in /sys
   kexec tools to warn the user if they attempt to designate a device which is
   unable to honor the reset_devices kernel parameter as a dump device.
 
-  HPSA specific disk attributes:
-  ------------------------------
+HPSA specific disk attributes
+-----------------------------
 
-  /sys/class/scsi_disk/c:b:t:l/device/unique_id
-  /sys/class/scsi_disk/c:b:t:l/device/raid_level
-  /sys/class/scsi_disk/c:b:t:l/device/lunid
+  ::
+
+    /sys/class/scsi_disk/c:b:t:l/device/unique_id
+    /sys/class/scsi_disk/c:b:t:l/device/raid_level
+    /sys/class/scsi_disk/c:b:t:l/device/lunid
 
   (where c:b:t:l are the controller, bus, target and lun of the device)
 
-  For example:
+  For example::
 
 	root@host:/sys/class/scsi_disk/4:0:0:0/device# cat unique_id
 	600508B1001044395355323037570F77
@@ -96,35 +102,28 @@ HPSA specific entries in /sys
 	root@host:/sys/class/scsi_disk/4:0:0:0/device# cat raid_level
 	RAID 0
 
-HPSA specific ioctls:
----------------------
+HPSA specific ioctls
+====================
 
   For compatibility with applications written for the cciss driver, many, but
   not all of the ioctls supported by the cciss driver are also supported by the
   hpsa driver.  The data structures used by these are described in
   include/linux/cciss_ioctl.h
 
-  CCISS_DEREGDISK
-  CCISS_REGNEWDISK
-  CCISS_REGNEWD
-
-  The above three ioctls all do exactly the same thing, which is to cause the driver
-  to rescan for new devices.  This does exactly the same thing as writing to the
-  hpsa specific host "rescan" attribute.
+  CCISS_DEREGDISK, CCISS_REGNEWDISK, CCISS_REGNEWD
+	The above three ioctls all do exactly the same thing, which is to cause the driver
+	to rescan for new devices.  This does exactly the same thing as writing to the
+	hpsa specific host "rescan" attribute.
 
   CCISS_GETPCIINFO
-
 	Returns PCI domain, bus, device and function and "board ID" (PCI subsystem ID).
 
   CCISS_GETDRIVVER
+	Returns driver version in three bytes encoded as::
 
-	Returns driver version in three bytes encoded as:
 		(major_version << 16) | (minor_version << 8) | (subminor_version)
 
-  CCISS_PASSTHRU
-  CCISS_BIG_PASSTHRU
-
+  CCISS_PASSTHRU, CCISS_BIG_PASSTHRU
 	Allows "BMIC" and "CISS" commands to be passed through to the Smart Array.
 	These are used extensively by the HP Array Configuration Utility, SNMP storage
 	agents, etc.  See cciss_vol_status at http://cciss.sf.net for some examples.
-
diff --git a/Documentation/scsi/index.rst b/Documentation/scsi/index.rst
index 4b577c9e804e..b16f348bd31b 100644
--- a/Documentation/scsi/index.rst
+++ b/Documentation/scsi/index.rst
@@ -21,5 +21,6 @@ Linux SCSI Subsystem
    dpti
    FlashPoint
    g_NCR5380
+   hpsa
 
    scsi_transport_srp/figures
diff --git a/MAINTAINERS b/MAINTAINERS
index 451a3f67d23a..39767eca07d9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7456,7 +7456,7 @@ M:	Don Brace <don.brace@microsemi.com>
 L:	esc.storagedev@microsemi.com
 L:	linux-scsi@vger.kernel.org
 S:	Supported
-F:	Documentation/scsi/hpsa.txt
+F:	Documentation/scsi/hpsa.rst
 F:	drivers/scsi/hpsa*.[ch]
 F:	include/linux/cciss*.h
 F:	include/uapi/linux/cciss*.h
-- 
2.21.1


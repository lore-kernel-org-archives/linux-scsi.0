From: "Roland" <devzero@web.de>
Subject: [PATCH] mpt fusion: Improve fusion mpt drivers description
Date: Fri, 2 May 2008 18:32:26 +0200
Message-ID: <00c901c8ac72$2198cb50$6400a8c0@bui.materna.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:56468 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757231AbYEBQci (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2008 12:32:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: nadejdalevitsky@gmail.com, "Moore, Eric" <Eric.Moore@lsi.com>, samuel.thibault@ens-lyon.org

Since end-users may have difficulties finding the right configuration option 
for some popular LSI controllers,
this patch adds some information to drivers/message/fusion/Kconfig.

Also see http://marc.info/?l=linux-kernel&m=120967940402791&w=2

This attached patch is agaings current git.

Signed-off-by: Roland Kletzing <devzero@web.de>

--- drivers/message/fusion/Kconfig.orig 2008-05-02 02:38:44.000000000 +0200
+++ drivers/message/fusion/Kconfig      2008-05-02 20:16:19.000000000 +0200
@@ -1,18 +1,21 @@

 menuconfig FUSION
-       bool "Fusion MPT device support"
+       bool "LSI Fusion MPT device support"
        depends on PCI
        ---help---
-       Say Y here to get to see options for Fusion Message
+       Say Y here to get to see options for LSI Fusion Message
        Passing Technology (MPT) drivers.
-       This option alone does not add any kernel code.
+       This option alone does not add any kernel code, but enables
+       selection of ScsiHost drivers for parallel SCSI, Fiber Channel
+       and SAS host adapters.
+

        If you say N, all options in this submenu will be skipped and 
disabled.

 if FUSION

 config FUSION_SPI
-       tristate "Fusion MPT ScsiHost drivers for SPI"
+       tristate "LSI Fusion MPT ScsiHost drivers for SPI"
        depends on PCI && SCSI
        select SCSI_SPI_ATTRS
        ---help---
@@ -27,7 +30,7 @@
          ATTO UL4D

 config FUSION_FC
-       tristate "Fusion MPT ScsiHost drivers for FC"
+       tristate "LSI Fusion MPT ScsiHost drivers for FC"
        depends on PCI && SCSI
        select SCSI_FC_ATTRS
        ---help---
@@ -46,7 +49,7 @@
          Brocade FC 410/420

 config FUSION_SAS
-       tristate "Fusion MPT ScsiHost drivers for SAS"
+       tristate "LSI Fusion MPT ScsiHost drivers for SAS"
        depends on PCI && SCSI
        select SCSI_SAS_ATTRS
        ---help---
@@ -72,10 +75,10 @@
          on a per controller instance.

 config FUSION_CTL
-       tristate "Fusion MPT misc device (ioctl) driver"
+       tristate "LSI Fusion MPT misc device (ioctl) driver"
        depends on FUSION_SPI || FUSION_FC || FUSION_SAS
        ---help---
-         The Fusion MPT misc device driver provides specialized control
+         The LSI Fusion MPT misc device driver provides specialized control
          of MPT adapters via system ioctl calls.  Use of ioctl calls to
          the MPT driver requires that you create and use a misc device
          node ala:
@@ -83,7 +86,7 @@

          One use of this ioctl interface is to perform an upgrade (reflash)
          of the MPT adapter firmware.  Refer to readme file(s) distributed
-         with the Fusion MPT linux driver for additional details.
+         with the LSI Fusion MPT linux driver for additional details.

          If enabled by saying M to this, a driver named: mptctl
          will be compiled.
@@ -91,11 +94,11 @@
          If unsure whether you really want or need this, say N.

 config FUSION_LAN
-       tristate "Fusion MPT LAN driver"
+       tristate "LSI Fusion MPT LAN driver"
        depends on FUSION_FC && NET_FC
        ---help---
          This module supports LAN IP traffic over Fibre Channel port(s)
-         on Fusion MPT compatible hardware (LSIFC9xx chips).
+         on LSI Fusion MPT compatible hardware (LSIFC9xx chips).
          The physical interface used is defined in RFC 2625.
          Please refer to that document for details.

@@ -108,10 +111,10 @@
          If unsure whether you really want or need this, say N.

 config FUSION_LOGGING
-       bool "Fusion MPT logging facility"
+       bool "LSI Fusion MPT logging facility"
        ---help---
          This turns on a logging facility that can be used to debug a 
number
-         of Fusion MPT related problems.
+         of LSI Fusion MPT related problems.

          The debug level can be programmed on the fly via SysFS (hex 
values)


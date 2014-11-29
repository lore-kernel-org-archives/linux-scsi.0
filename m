From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi_debug: improve driver description in Kconfig
Date: Fri, 28 Nov 2014 19:14:02 -0500
Message-ID: <54790FCA.6020402@interlog.com>
References: <5476302C.9050509@interlog.com> <5478E3A1.5090608@infradead.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000504050905070006070306"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:60377 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312AbaK2AOV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Nov 2014 19:14:21 -0500
In-Reply-To: <5478E3A1.5090608@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>, SCSI development list <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>

This is a multi-part message in MIME format.
--------------000504050905070006070306
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 14-11-28 04:05 PM, Randy Dunlap wrote:
> On 11/26/14 11:55, Douglas Gilbert wrote:
>> From: Douglas Gilbert <dgilbert@interlog.com>
>> Date: Wed, 26 Nov 2014 14:41:55 -0500
>> Subject: [PATCH] scsi_debug improve driver description in Kconfig
>>
>> Try to give a more accurate driver description and some extra
>> useful information in less lines.
>> ---
>>   drivers/scsi/Kconfig | 17 ++++++++---------
>>   1 file changed, 8 insertions(+), 9 deletions(-)
>>
>> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
>>
>
> creating a small ram disk device.
>
> I would say:     RAM
>
> Otherwise looks good to me.

Okay, version 2 attached.

From: Douglas Gilbert <dgilbert@interlog.com>
Date: Fri, 28 Nov 2014 19:03:21 -0500
Subject: [PATCH] scsi_debug improve driver description in Kconfig

Try to give a more accurate driver description and some extra
information in less lines.
---
  drivers/scsi/Kconfig | 17 ++++++++---------
  1 file changed, 8 insertions(+), 9 deletions(-)

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>


--------------000504050905070006070306
Content-Type: text/x-patch;
 name="0001-scsi_debug-improve-driver-description-in-Kconfig-v2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-scsi_debug-improve-driver-description-in-Kconfig-v2.pat";
 filename*1="ch"

>From 9d735409215bb44fdec1dcf0cbe4acf7bd05021f Mon Sep 17 00:00:00 2001
From: Douglas Gilbert <dgilbert@interlog.com>
Date: Fri, 28 Nov 2014 19:03:21 -0500
Subject: [PATCH] scsi_debug improve driver description in Kconfig

Try to give a more accurate driver description and some extra
information in less lines.
---
 drivers/scsi/Kconfig | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 86cf3d6..9c92f41 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1462,18 +1462,17 @@ config SCSI_WD719X
 	  SCSI controllers (based on WD33C296A chip).
 
 config SCSI_DEBUG
-	tristate "SCSI debugging host simulator"
+	tristate "SCSI debugging host and device simulator"
 	depends on SCSI
 	select CRC_T10DIF
 	help
-	  This is a host adapter simulator that can simulate multiple hosts
-	  each with multiple dummy SCSI devices (disks). It defaults to one
-	  host adapter with one dummy SCSI disk. Each dummy disk uses kernel
-	  RAM as storage (i.e. it is a ramdisk). To save space when multiple
-	  dummy disks are simulated, they share the same kernel RAM for 
-	  their storage. See <http://sg.danny.cz/sg/sdebug26.html> for more
-	  information. This driver is primarily of use to those testing the
-	  SCSI and block subsystems. If unsure, say N.
+	  This pseudo driver simulates one or more hosts (SCSI initiators),
+	  each with one or more targets, each with one or more logical units.
+	  Defaults to one of each, creating a small RAM disk device. Many
+	  parameters found in the /sys/bus/pseudo/drivers/scsi_debug
+	  directory can be tweaked at run time.
+	  See <http://sg.danny.cz/sg/sdebug26.html> for more information.
+	  Mainly used for testing and best as a module. If unsure, say N.
 
 config SCSI_MESH
 	tristate "MESH (Power Mac internal SCSI) support"
-- 
1.9.1


--------------000504050905070006070306--

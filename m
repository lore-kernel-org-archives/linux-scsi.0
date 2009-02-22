From: Erik Ekman <erik@kryo.se>
Subject: [PATCH -tip] libfc: add crc32 dependency
Date: Sun, 22 Feb 2009 02:02:39 +0100
Message-ID: <20090222020239.59ee6b23.erik@kryo.se>
References: <20090222015606.629487d8.erik@kryo.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:47084 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714AbZBVBCo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Feb 2009 20:02:44 -0500
Received: by fg-out-1718.google.com with SMTP id 16so2290600fgg.17
        for <linux-scsi@vger.kernel.org>; Sat, 21 Feb 2009 17:02:42 -0800 (PST)
In-Reply-To: <20090222015606.629487d8.erik@kryo.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

drivers/scsi/libfc/fc_fcp.c needs CRC32 to build.

Signed-off-by: Erik Ekman <erik@kryo.se>
---
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 256c7be..bdfa6f2 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -608,6 +608,7 @@ config SCSI_FLASHPOINT
 config LIBFC
 	tristate "LibFC module"
 	select SCSI_FC_ATTRS
+	select CRC32
 	---help---
 	  Fibre Channel library module
 

From: Rolf Eike Beer <eike@bilbo.math.uni-mannheim.de>
Subject: [PATCH] 2.5.46 kill unneeded declaration from drivers/scsi/sim710.h
Date: Wed, 13 Nov 2002 08:32:26 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200211130832.26958@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

Richard agreed that this is completely unneeded so we should just kill it.

Eike

--- linux-2.5.46/drivers/scsi/sim710.h	Mon Nov  4 23:30:29 2002
+++ linux-2.5.46-lacon/drivers/scsi/sim710.h	Sat Nov  9 21:26:11 2002
@@ -14,8 +14,6 @@
 int sim710_bus_reset(Scsi_Cmnd * SCpnt);
 int sim710_dev_reset(Scsi_Cmnd * SCpnt);
 int sim710_host_reset(Scsi_Cmnd * SCpnt);
-int sim710_biosparam(struct scsi_device *, struct block_device *,
-		sector_t, int*);
 #ifdef MODULE
 int sim710_release(struct Scsi_Host *);
 #else

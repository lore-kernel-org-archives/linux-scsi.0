From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] 2.5.46 kill unneeded declaration from drivers_scsi_sim710.h (fwd)
Date: Fri, 06 Dec 2002 14:01:32 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021206035755.771322C2B1@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: torvalds@transmeta.com, linux-scsi@vger.kernel.org

From:  Adrian Bunk <bunk@fs.tum.de>

  The patch below is obviously correct (only occurence of sim710_biosparam
  in the whole kernel sources).
  
  cu
  Adrian
  
  
  ----- Forwarded message from Rolf Eike Beer <eike@bilbo.math.uni-mannheim.de> -----
  
  Date:	Sat, 9 Nov 2002 21:33:37 +0100
  From: Rolf Eike Beer <eike@bilbo.math.uni-mannheim.de>
  To: linux-kernel@vger.kernel.org
  Subject: [PATCH] 2.5.46 kill unneeded declaration from drivers/scsi/sim710.h
  
  Hi,
  
  Richard agreed that this is completely unneeded so we should just kill it.
  
  Eike
  

--- trivial-2.5-bk/drivers/scsi/sim710.h.orig	2002-12-06 13:56:30.000000000 +1100
+++ trivial-2.5-bk/drivers/scsi/sim710.h	2002-12-06 13:56:30.000000000 +1100
@@ -14,8 +14,6 @@
 int sim710_bus_reset(Scsi_Cmnd * SCpnt);
 int sim710_dev_reset(Scsi_Cmnd * SCpnt);
 int sim710_host_reset(Scsi_Cmnd * SCpnt);
-int sim710_biosparam(struct scsi_device *, struct block_device *,
-		sector_t, int*);
 #ifdef MODULE
 int sim710_release(struct Scsi_Host *);
 #else
-- 
  Don't blame me: the Monkey is driving
  File: Adrian Bunk <bunk@fs.tum.de>: [PATCH] 2.5.46 kill unneeded declaration from drivers_scsi_sim710.h (fwd)

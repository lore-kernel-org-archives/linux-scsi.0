From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 0/5] esp_scsi, mac_esp: Various fixes and cleanups
Date: Fri,  4 Aug 2017 01:43:19 -0400 (EDT)
Message-ID: <cover.1501825111.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>, David Miller <davem@davemloft.net>, Hannes Reinecke <hare@suse.com>, Meelis Roos <mroos@linux.ee>, Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This series has been tested on m68k Macs (ESP236 equivalent).

Some more testing with different targets and devices (FAS236 etc)
might be nice. Being that the esp_scsi fixes are on error paths,
more review may actually be more valuable than more testing...


Finn Thain (5):
  scsi/mac_esp: Avoid type warning from sparse
  scsi/mac_esp: Fix PIO transfers for MESSAGE IN phase
  scsi/esp_scsi: Clean up control flow and dead code
  scsi/esp_scsi: Avoid sending ABORT TASK SET messages
  scsi/esp_scsi: Always clear msg_out_len after MESSAGE OUT phase

 drivers/scsi/esp_scsi.c | 53 +++++++++++++++++++++----------------------------
 drivers/scsi/esp_scsi.h |  1 -
 drivers/scsi/mac_esp.c  | 37 +++++++++++++++++-----------------
 3 files changed, 42 insertions(+), 49 deletions(-)

-- 
2.13.0

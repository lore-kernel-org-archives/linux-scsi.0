From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 0/6] mac_esp, zorro_esp, esp_scsi: Various improvements
Date: Sat, 13 Oct 2018 11:51:16 +1100
Message-ID: <cover.1539391876.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This series has fixes and cleanup for mac_esp, zorro_esp and the
core esp_scsi driver.

The improvements include elimination of duplicated code temporarily
introduced for zorro_esp.

Michael, would you please regression test this series on elgar,
if convenient? So far, only mac_esp has been tested with this code.


Finn Thain (6):
  zorro_esp: Limit DMA transfers to 65535 bytes
  esp_scsi: Track residual for PIO transfers
  esp_scsi: Grant disconnect privilege for untagged commands
  esp_scsi: Eliminate ESP_FLAG_DOING_SLOWCMD
  esp_scsi: De-duplicate PIO routines
  esp_scsi: Optimize PIO loops

 drivers/scsi/esp_scsi.c  | 192 +++++++++++++++++++++++++++++--------
 drivers/scsi/esp_scsi.h  |  10 +-
 drivers/scsi/mac_esp.c   | 171 ++-------------------------------
 drivers/scsi/zorro_esp.c | 240 +++++++----------------------------------------
 4 files changed, 201 insertions(+), 412 deletions(-)

-- 
2.16.4

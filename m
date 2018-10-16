From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 0/6] mac_esp, zorro_esp, esp_scsi: Various improvements
Date: Tue, 16 Oct 2018 16:31:25 +1100
Message-ID: <cover.1539667885.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This series has fixes and cleanup for mac_esp, zorro_esp and the
core esp_scsi driver.

These improvements include elimination of duplicated code temporarily
introduced for zorro_esp.


Finn Thain (6):
  zorro_esp: Limit DMA transfers to 65535 bytes
  esp_scsi: Track residual for PIO transfers
  esp_scsi: Grant disconnect privilege for untagged commands
  esp_scsi: Eliminate ESP_FLAG_DOING_SLOWCMD
  esp_scsi: De-duplicate PIO routines
  esp_scsi: Optimize PIO loops

 drivers/scsi/Kconfig     |   5 +
 drivers/scsi/esp_scsi.c  | 197 +++++++++++++++++++++++++-------
 drivers/scsi/esp_scsi.h  |  11 +-
 drivers/scsi/mac_esp.c   | 171 +---------------------------
 drivers/scsi/zorro_esp.c | 240 ++++++---------------------------------
 5 files changed, 208 insertions(+), 416 deletions(-)

-- 
2.18.1

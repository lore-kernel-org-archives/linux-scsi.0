From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 0/4] g_NCR5380: Bug fix and some enhancements
Date: Mon,  5 Dec 2016 01:07:19 -0500 (EST)
Message-ID: <cover.1480917789.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ondrej Zary <linux@rainbow-software.org>
Cc: Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch series is based on the one submitted recently by Ondrej Zary.

This version has a different irq probing fix for HP C2502 boards and
a more comprehensive patch to change the default irq parameter.

It needs testing on actual ISA hardware.


Finn Thain (4):
  g_NCR5380: Check for chip presence before calling NCR5380_init()
  g_NCR5380: Use probe_irq_*() for IRQ probing
  g_NCR5380: Fix automatic IRQ on HP C2502 cards
  g_NCR5380: Autoprobe board IRQ by default

 Documentation/scsi/g_NCR5380.txt |  46 ++++++------
 drivers/scsi/NCR5380.c           |  77 +-------------------
 drivers/scsi/NCR5380.h           |  11 ---
 drivers/scsi/g_NCR5380.c         | 153 +++++++++++++++++++++++++++++++++------
 drivers/scsi/g_NCR5380.h         |   2 +
 5 files changed, 156 insertions(+), 133 deletions(-)

-- 
2.7.3

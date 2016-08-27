From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 0/3] Small fixes and cleanup
Date: Sat, 27 Aug 2016 12:29:58 +1000
Message-ID: <20160827022958.983743612@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Geert Uytterhoeven <geert@linux-m68k.org>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Miscellaneous small patches for an interrupt latency issue,
a compiler warning and a documentation cleanup.

---
 Documentation/kernel-parameters.txt    |    2 --
 Documentation/scsi/scsi-parameters.txt |    2 --
 drivers/scsi/NCR5380.c                 |   13 +++----------
 drivers/scsi/NCR5380.h                 |    8 +++++++-
 4 files changed, 10 insertions(+), 15 deletions(-)

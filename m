From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 0/5] g_NCR5380: PDMA fixes and cleanup
Date: Sat, 24 Jun 2017 02:37:36 -0400 (EDT)
Message-ID: <cover.1498285948.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ondrej Zary <linux@rainbow-software.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Ondrej, would you please test this new series?

Changed since v1:
- PDMA transfer residual is calculated earlier.
- End of DMA flag check is now polled (if there is any residual).


Finn Thain (2):
  g_NCR5380: Limit sg_tablesize to avoid PDMA read overruns on DTC436
  g_NCR5380: Cleanup comments and whitespace

Ondrej Zary (3):
  g_NCR5380: Fix PDMA transfer size
  g_NCR5380: End PDMA transfer correctly on target disconnection
  g_NCR5380: Re-work PDMA loops

 drivers/scsi/g_NCR5380.c | 231 ++++++++++++++++++++++-------------------------
 1 file changed, 107 insertions(+), 124 deletions(-)

-- 
2.13.0

From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 0/4] g_NCR5380: PDMA fixes and cleanup
Date: Mon, 26 Jun 2017 03:30:33 -0400 (EDT)
Message-ID: <cover.1498461406.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ondrej Zary <linux@rainbow-software.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Ondrej, would you please test this new series?

Changed since v1:
- PDMA transfer residual is calculated earlier.
- End of DMA flag check is now polled (if there is any residual).

Changed since v2:
- Bail out of transfer loops when Gated IRQ gets asserted.
- Make udelay conditional on board type.
- Drop sg_tablesize patch due to performance regression.


Finn Thain (1):
  g_NCR5380: Cleanup comments and whitespace

Ondrej Zary (3):
  g_NCR5380: Fix PDMA transfer size
  g_NCR5380: End PDMA transfer correctly on target disconnection
  g_NCR5380: Re-work PDMA loops

 drivers/scsi/g_NCR5380.c | 239 +++++++++++++++++++++++------------------------
 1 file changed, 116 insertions(+), 123 deletions(-)

-- 
2.13.0

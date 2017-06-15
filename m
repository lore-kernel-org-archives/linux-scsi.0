From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 0/4] g_NCR5380: PDMA fixes and cleanup
Date: Thu, 15 Jun 2017 08:17:56 -0400 (EDT)
Message-ID: <cover.1497528687.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ondrej Zary <linux@rainbow-software.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Ondrej, would you please test this patch series? One of your patches
has been modified slightly and the two I wrote are untested.


Finn Thain (2):
  g_NCR5380: Limit sg_tablesize to avoid PDMA read overruns on DTC436
  g_NCR5380: Cleanup comments and whitespace

Ondrej Zary (2):
  g_NCR5380: Fix PDMA transfer size
  g_NCR5380: End PDMA transfer correctly on target disconnection

 drivers/scsi/g_NCR5380.c | 111 +++++++++++++++++++++++------------------------
 1 file changed, 54 insertions(+), 57 deletions(-)

-- 
2.13.0

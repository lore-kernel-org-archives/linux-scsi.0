From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH] MAINTAINERS: Abandon pas16, dtc and t128 ISA card SCSI host
 adapter drivers
Date: Thu, 22 Sep 2016 14:41:20 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1609221355070.18177@nippy.intranet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


I don't intend to modernize these three drivers, so as to avoid the 
deprecated scsi_register() API. I don't have the relevant hardware.

Cc: Michael Schmitz <schmitzmic@gmail.com>
References: https://lkml.kernel.org/r/20160911171249.GA7554@infradead.org
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---

Whilst I suspect that these 3 drivers have no users, I don't think my own 
lack of hardware and interest is itself any reason for me to remove the 
drivers themselves. I'll leave that to the SCSI subsystem maintainers, as 
they intend to remove the scsi_register() API.

diff --git a/MAINTAINERS b/MAINTAINERS
index 8c20323..e09df13 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7821,20 +7821,16 @@ M:	Michael Schmitz <schmitzmic@gmail.com>
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	Documentation/scsi/g_NCR5380.txt
-F:	Documentation/scsi/dtc3x80.txt
 F:	drivers/scsi/NCR5380.*
 F:	drivers/scsi/arm/cumana_1.c
 F:	drivers/scsi/arm/oak.c
 F:	drivers/scsi/atari_scsi.*
 F:	drivers/scsi/dmx3191d.c
-F:	drivers/scsi/dtc.*
 F:	drivers/scsi/g_NCR5380.*
 F:	drivers/scsi/g_NCR5380_mmio.c
 F:	drivers/scsi/mac_scsi.*
-F:	drivers/scsi/pas16.*
 F:	drivers/scsi/sun3_scsi.*
 F:	drivers/scsi/sun3_scsi_vme.c
-F:	drivers/scsi/t128.*
 
 NCR DUAL 700 SCSI DRIVER (MICROCHANNEL)
 M:	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>

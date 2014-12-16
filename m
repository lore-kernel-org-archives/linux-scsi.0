From: Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
Subject: [PATCH RESEND 0/2] ahci_xgene: Bug fixes in APM X-Gene Soc AHCI SATA controller driver.
Date: Tue, 16 Dec 2014 22:21:06 +0530
Message-ID: <1418748666-27348-1-git-send-email-stripathi@apm.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, patches-qTEPVZfXA3Y@public.gmane.org, Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

These patches address the following two issues :

1. Endianess issue with xgene_read_id function.
2. ATAPI device enumeration failure with ATA_CMD_PACKET PIO mode command.

Signed-off-by: Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
---

Suman Tripathi (2):
  ahci_xgene: Fix the endianess issue in APM X-Gene SoC AHCI SATA
    controller driver.
  ahci_xgene: Fix the dma state machine lockup for the ATA_CMD_PACKET
    PIO mode command.

 drivers/ata/ahci_xgene.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--
1.8.2.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

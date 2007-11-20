From: Joe Perches <joe@perches.com>
Subject: [PATCH 40/59] drivers/scsi/aic7xxx: Add missing "space"
Date: Mon, 19 Nov 2007 17:48:32 -0800
Message-ID: <f9ffd78f5eb1f49e89fc578611de786ae7b9ac87.1195454436.git.joe__34332.7967836105$1195524405$gmane$org@perches.com>
References: 1234567
 <1195523331-15303-1-git-send-email-joe@perches.com>
 <1195523331-15303-2-git-send-email-joe@perches.com>
 <1195523331-15303-3-git-send-email-joe@perches.com>
 <1195523331-15303-4-git-send-email-joe@perches.com>
 <1195523331-15303-5-git-send-email-joe@perches.com>
 <1195523331-15303-6-git-send-email-joe@perches.com>
 <1195523331-15303-7-git-send-email-joe@perches.com>
 <1195523331-15303-8-git-send-email-joe@perches.com>
 <1195523331-15303-9-git-send-email-joe@perches.com>
 <1195523331-15303-10-git-send-email-joe@perches.com>
 <1195523331-15303-11-git-send-email-joe@perches.com>
 <1195523331-15303-12-git-send-email-joe@perches.com>
 <1195523331-15303-13-git-send-email-joe@perches.com>
 <1195523331-15303-14-git-send-email-joe@perches.com>
 <1195523331-15303-15-git-send-email-joe@perches.com>
 <1195523331-15303-16-git-send-email-joe@perches.com>
 <1195523331-15303-17-git-send-email-joe@perches.com>
 <1195523331-15303-18-git-send-email-joe@perches.com>
 <1195523331-15303-19-git-send-email-joe@perches.com>
 <1195523331-15303-20-git-send-email-joe@perches.com>
 <1195523331-15303-21-git-send-email-joe@perches.com>
 <1195523331-15303-22-git-send-email-joe@perches.com>
 <1195523331-15303-23-git-send-email-joe@perches.com>
 <1195523331-15303-24-git-send-email-joe@perches.com>
 <1195523331-15303-25-git-send-email-joe@perches.com>
 <1195523331-15303-26-git-send-email-joe@perches.com>
 <1195523331-15303-27-git-send-email-joe@perches.com>
 <1195523331-15303-28-git-send-email-joe@perches.com>
 <1195523331-15303-29-git-send-email-joe@perches.com>
 <1195523331-15303-30-git-send-email-joe@perches.com>
 <1195523331-15303-31-git-send-email-joe@perches.com>
 <1195523331-15303-32-git-send-email-joe@perches.com>
 <1195523331-15303-33-git-send-email-joe@perches.com>
 <1195523331-15303-34-git-send-email-joe@perches.com>
 <1195523331-15303-35-git-send-email-joe@perches.com>
 <1195523331-15303-36-git-send-email-joe@perches.com>
 <1195523331-15303-37-git-send-email-joe@perches.com>
 <1195523331-15303-38-git-send-email-joe@perches.com>
 <1195523331-15303-39-git-send-email-joe@perches.com>
 <1195523331-15303-40-git-send-email-joe@perches.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761218AbXKTCEJ@vger.kernel.org>
In-Reply-To: <1195523331-15303-40-git-send-email-joe@perches.com>
Message-Id: <f9ffd78f5eb1f49e89fc578611de786ae7b9ac87.1195454436.git.joe@perches.com>
In-Reply-To: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/aic7xxx/aic79xx_osm.c     |    2 +-
 drivers/scsi/aic7xxx/aic79xx_osm_pci.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 2d02040..581ac18 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -338,7 +338,7 @@ MODULE_PARM_DESC(aic79xx,
 "	amplitude:<int>		Set the signal amplitude (0-7).\n"
 "	seltime:<int>		Selection Timeout:\n"
 "				(0/256ms,1/128ms,2/64ms,3/32ms)\n"
-"	slowcrc			Turn on the SLOWCRC bit (Rev B only)\n"		 
+"	slowcrc			Turn on the SLOWCRC bit (Rev B only)\n"
 "\n"
 "	Sample /etc/modprobe.conf line:\n"
 "		Enable verbose logging\n"
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
index 66f0259..8ec99e2 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
@@ -374,7 +374,7 @@ ahd_pci_map_registers(struct ahd_softc *ahd)
 			ahd->bshs[1].ioport = base2;
 			command |= PCIM_CMD_PORTEN;
 		} else {
-			printf("aic79xx: PCI%d:%d:%d IO regions 0x%lx and 0x%lx"
+			printf("aic79xx: PCI%d:%d:%d IO regions 0x%lx and 0x%lx "
 			       "unavailable. Cannot map device.\n",
 			       ahd_get_pci_bus(ahd->dev_softc),
 			       ahd_get_pci_slot(ahd->dev_softc),
-- 
1.5.3.5.652.gf192c

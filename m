From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/6] aic79xx: Fix struct map_node patch
Date: Thu, 22 Dec 2005 15:19:41 +0100
Message-ID: <43AAB5FD.8080004@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:5038 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S965164AbVLVOTm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Dec 2005 09:19:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

[PATCH 3/6] aic79xx: Fix struct map_node patch

The conversion to struct map_node was missing one hunk.
---

 drivers/scsi/aic7xxx/aic79xx_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

3346d03337bea3268fee9c81a2dde1cf2c2e3d3c
diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c
b/drivers/scsi/aic7xxx/aic79xx_core.c
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -9655,7 +9655,7 @@ ahd_run_tqinfifo(struct ahd_softc *ahd,

 		cmd->cmd_valid =3D 0;
 		ahd_dmamap_sync(ahd, ahd->shared_data_dmat,
-				ahd->shared_data_dmamap,
+				ahd->shared_data_map.dmamap,
 				ahd_targetcmd_offset(ahd, ahd->tqinfifonext),
 				sizeof(struct target_cmd),
 				BUS_DMASYNC_PREREAD);

--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

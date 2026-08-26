Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003E63B6C15;
	Wed, 26 Aug 2026 08:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787733453; cv=none; b=AOvrzu/HQEHa566DB8aX4ikqlTIE/vzouDrYgW0R9fji4cAILew8Vws4WD92X+E/12OsAixVHtaswbkDR9JlCLZTwhqzLxF4ZIejZGqPZb6xwTIk0du2/TnKEm6AzKQgPUUbr/dZo3VVI5HqlVaLgL39NI7FHCzqG/wMY8/nPws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787733453; c=relaxed/simple;
	bh=/nJ+6muvPjw51iymCr3S4mmwHKOg1vP9q5wNnUEFStE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Mf+VelpsG7HnpQ7+3GeVLcEXvraqNlHfSCnSyhfB1EUSqgvmPDDnMK4Rv8kJFvsOiY7LHooju+ub0ccz5lyuGarsDGRQfnrYs2D+tBeZoKy9beb8o8mBeR8T9SgBEUpAr2xEI1m/W66/4WudMyuOftDTuN4gyiL9hKC6+7fbMn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 5b4cb9eaa12911f19a56ed5b684f684d-20260826
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:3271276e-ecaf-42b4-9819-320377205142,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:7db8b62,CLOUDID:6c3636afc8496d9cf70cbed7c874e8f3,BulkI
	D:nil,BulkQuantity:0,SF:102|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:n
	il,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LE
	S:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5b4cb9eaa12911f19a56ed5b684f684d-20260826
X-User: yanglinlin@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <yanglinlin@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1157170727; Wed, 26 Aug 2026 16:37:22 +0800
From: Linlin Yang <yanglinlin@kylinos.cn>
To: linux-kernel@vger.kernel.org
Cc: amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-hwmon@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-spi@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	Linlin Yang <yanglinlin@kylinos.cn>
Subject: [PATCH] treewide: fix spelling of "overridden"
Date: Wed, 26 Aug 2026 16:37:15 +0800
Message-Id: <20260826083715.625136-1-yanglinlin@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix misspelling of "overridden" (missing a 'd') in comments across
multiple drivers.  The correct spelling "overridden" is already used
292 times in the same drivers/ directory.

All occurrences are in comments only, no functional change.

Signed-off-by: Linlin Yang <yanglinlin@kylinos.cn>
---
 .../gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c    | 2 +-
 .../gpu/drm/amd/display/dc/dml/dcn31/display_mode_vba_31.c    | 2 +-
 .../amd/display/dc/link/protocols/link_edp_panel_control.c    | 4 ++--
 drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c               | 2 +-
 drivers/gpu/drm/msm/registers/gen_header.py                   | 2 +-
 drivers/gpu/drm/nouveau/nouveau_bios.c                        | 2 +-
 drivers/hwmon/abituguru.c                                     | 2 +-
 drivers/mmc/core/block.c                                      | 2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c              | 2 +-
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c                    | 2 +-
 drivers/net/ethernet/freescale/fman/fman_memac.c              | 2 +-
 drivers/net/ethernet/sfc/mcdi_pcol.h                          | 2 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c                            | 2 +-
 drivers/scsi/sym53c8xx_2/sym53c8xx.h                          | 2 +-
 drivers/spi/spi-omap2-mcspi.c                                 | 2 +-
 drivers/video/fbdev/tridentfb.c                               | 2 +-
 16 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c b/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c
index 33b5136f7ce3..75bdad22bf69 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c
@@ -1805,7 +1805,7 @@ static void DISPCLKDPPCLKDCFCLKDeepSleepPrefetchParametersWatermarksAndPerforman
 	v->DISPCLKWithRamping = 0;
 	v->DISPCLKWithoutRamping = 0;
 	v->GlobalDPPCLK = 0.0;
-	/* DAL custom code: need to update ReturnBW in case min dcfclk is overriden */
+	/* DAL custom code: need to update ReturnBW in case min dcfclk is overridden */
 	v->IdealSDPPortBandwidthPerState[v->VoltageLevel][v->maxMpcComb] = dml_min3(
 			v->ReturnBusWidth * v->DCFCLK,
 			v->DRAMSpeedPerState[v->VoltageLevel] * v->NumberOfChannels * v->DRAMChannelWidth,
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn31/display_mode_vba_31.c b/drivers/gpu/drm/amd/display/dc/dml/dcn31/display_mode_vba_31.c
index 8064c4b3fd25..3f62ea493787 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn31/display_mode_vba_31.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn31/display_mode_vba_31.c
@@ -2045,7 +2045,7 @@ static void DISPCLKDPPCLKDCFCLKDeepSleepPrefetchParametersWatermarksAndPerforman
 	v->DISPCLKWithRamping = 0;
 	v->DISPCLKWithoutRamping = 0;
 	v->GlobalDPPCLK = 0.0;
-	/* DAL custom code: need to update ReturnBW in case min dcfclk is overriden */
+	/* DAL custom code: need to update ReturnBW in case min dcfclk is overridden */
 	{
 	double IdealFabricAndSDPPortBandwidthPerState = dml_min(
 			v->ReturnBusWidth * v->DCFCLKState[v->VoltageLevel][v->maxMpcComb],
diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.c
index 16951a9550f2..d3fe6e024891 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.c
@@ -108,7 +108,7 @@ enum dp_panel_mode dp_get_panel_mode(struct dc_link *link)
 			/* alternate scrambler reset is required for Travis
 			 * for the case when external chip does not
 			 * provide sink device id, alternate scrambler
-			 * scheme will  be overriden later by querying
+			 * scheme will  be overridden later by querying
 			 * Encoder features
 			 */
 			if (strncmp(
@@ -124,7 +124,7 @@ enum dp_panel_mode dp_get_panel_mode(struct dc_link *link)
 			/* alternate scrambler reset is required for NUTMEG
 			 * for the case when external chip does not provide
 			 * sink device id, alternate scrambler scheme will
-			 * be overriden later by querying Encoder feature
+			 * be overridden later by querying Encoder feature
 			 */
 			if (strncmp(link->dpcd_caps.branch_dev_name,
 				DP_VGA_LVDS_CONVERTER_ID_3,
diff --git a/drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c b/drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c
index 204375f1eff8..587d26c742cd 100644
--- a/drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c
+++ b/drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c
@@ -584,7 +584,7 @@ static bool dmub_srv_hw_setup(struct dmub_srv *dmub, enum dmub_asic asic)
 		return false;
 	}
 
-	/* set default inbox type if not overriden */
+	/* set default inbox type if not overridden */
 	if (dmub->inbox_type == DMUB_CMD_INTERFACE_DEFAULT) {
 		if (default_inbox_type != DMUB_CMD_INTERFACE_DEFAULT) {
 			/* use default inbox type as specified by DCN rev */
diff --git a/drivers/gpu/drm/msm/registers/gen_header.py b/drivers/gpu/drm/msm/registers/gen_header.py
index d3b56a9d84fb..d6bfb7b7d7b3 100644
--- a/drivers/gpu/drm/msm/registers/gen_header.py
+++ b/drivers/gpu/drm/msm/registers/gen_header.py
@@ -576,7 +576,7 @@ class Parser(object):
             raise self.error(e)
 
     def parse_varset(self, attrs):
-        # Inherit the varset from the enclosing domain if not overriden:
+        # Inherit the varset from the enclosing domain if not overridden:
         varset = self.current_varset
         if "varset" in attrs:
             varset = self.enums[attrs["varset"]]
diff --git a/drivers/gpu/drm/nouveau/nouveau_bios.c b/drivers/gpu/drm/nouveau/nouveau_bios.c
index 38032bb95826..10cd606d01b9 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bios.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bios.c
@@ -323,7 +323,7 @@ get_fp_strap(struct drm_device *dev, struct nvbios *bios)
 	/*
 	 * The fp strap is normally dictated by the "User Strap" in
 	 * PEXTDEV_BOOT_0[20:16], but on BMP cards when bit 2 of the
-	 * Internal_Flags struct at 0x48 is set, the user strap gets overriden
+	 * Internal_Flags struct at 0x48 is set, the user strap gets overridden
 	 * by the PCI subsystem ID during POST, but not before the previous user
 	 * strap has been committed to CR58 for CR57=0xf on head A, which may be
 	 * read and used instead
diff --git a/drivers/hwmon/abituguru.c b/drivers/hwmon/abituguru.c
index ba8c68ae4595..5accd463599c 100644
--- a/drivers/hwmon/abituguru.c
+++ b/drivers/hwmon/abituguru.c
@@ -475,7 +475,7 @@ abituguru_detect_bank1_sensor_type(struct abituguru_data *data,
 	u8 val, test_flag, buf[3];
 	int i, ret = -ENODEV; /* error is the most common used retval :| */
 
-	/* If overriden by the user return the user selected type */
+	/* If overridden by the user return the user selected type */
 	if (bank1_types[sensor_addr] >= ABIT_UGURU_IN_SENSOR &&
 			bank1_types[sensor_addr] <= ABIT_UGURU_NC) {
 		ABIT_UGURU_DEBUG(2, "assuming sensor type %d for bank1 sensor "
diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index e760d13ee325..a02bb2fee874 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -86,7 +86,7 @@ MODULE_ALIAS("mmc:block");
 static DEFINE_MUTEX(block_mutex);
 
 /*
- * The defaults come from config options but can be overriden by module
+ * The defaults come from config options but can be overridden by module
  * or bootarg options.
  */
 static int perdev_minors = CONFIG_MMC_BLOCK_MINORS;
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
index ea310057fe3a..bc36d7578ce2 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
@@ -3743,7 +3743,7 @@ static void bnx2x_warpcore_enable_AN_KR(struct bnx2x_phy *phy,
 		{MDIO_WC_DEVAD, MDIO_WC_REG_CL72_USERB0_CL72_TX_FIR_TAP, 0},
 	};
 	DP(NETIF_MSG_LINK, "Enable Auto Negotiation for KR\n");
-	/* Set to default registers that may be overriden by 10G force */
+	/* Set to default registers that may be overridden by 10G force */
 	for (i = 0; i < ARRAY_SIZE(reg_set); i++)
 		bnx2x_cl45_write(bp, phy, reg_set[i].devad, reg_set[i].reg,
 				 reg_set[i].val);
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/sge.c b/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
index 31fab2415743..b4374ca1d653 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/sge.c
@@ -2194,7 +2194,7 @@ static void __iomem *bar2_address(struct adapter *adapter,
  *	@rspq: pointer to the new rxq's Response Queue to be filled in
  *	@iqasynch: if 0, a normal rspq; if 1, an asynchronous event queue
  *	@dev: the network device associated with the new rspq
- *	@intr_dest: MSI-X vector index (overriden in MSI mode)
+ *	@intr_dest: MSI-X vector index (overridden in MSI mode)
  *	@fl: pointer to the new rxq's Free List to be filled in
  *	@hnd: the interrupt handler to invoke for the rspq
  */
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index e2d8c58deef0..c1d588337751 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -1311,7 +1311,7 @@ int memac_initialization(struct mac_device *mac_dev,
 
 	/* Most boards should use MLO_AN_INBAND, but existing boards don't have
 	 * a managed property. Default to MLO_AN_INBAND rather than MLO_AN_PHY.
-	 * Phylink will allow this to be overriden by a fixed link. We need to
+	 * Phylink will allow this to be overridden by a fixed link. We need to
 	 * be careful and not enable this if we are using MII or RGMII, since
 	 * those configurations modes don't use in-band autonegotiation.
 	 */
diff --git a/drivers/net/ethernet/sfc/mcdi_pcol.h b/drivers/net/ethernet/sfc/mcdi_pcol.h
index b9866e389e6d..9adfa058512f 100644
--- a/drivers/net/ethernet/sfc/mcdi_pcol.h
+++ b/drivers/net/ethernet/sfc/mcdi_pcol.h
@@ -13547,7 +13547,7 @@
  * an ancestor of the current user (see MC_CMD_SET_VI_USER). Note that LL
  * queues require this to be called after allocation but before initialisation
  * of the queue. TLP options of a queue are fixed after queue is initialised,
- * with the values set to current global value or they can be overriden using
+ * with the values set to current global value or they can be overridden using
  * this command. At LL queue allocation, all overrides are cleared.
  */
 #define MC_CMD_SET_VI_TLP_PROCESSING 0xb1
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index feb1707feb7e..c9470f80626b 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -173,7 +173,7 @@ static adapter_tag_info_t aic79xx_tag_info[] =
 
 /*
  * The I/O cell on the chip is very configurable in respect to its analog
- * characteristics.  Set the defaults here; they can be overriden with
+ * characteristics.  Set the defaults here; they can be overridden with
  * the proper insmod parameters.
  */
 struct ahd_linux_iocell_opts
diff --git a/drivers/scsi/sym53c8xx_2/sym53c8xx.h b/drivers/scsi/sym53c8xx_2/sym53c8xx.h
index 11f5dc29aa59..8790f1315f75 100644
--- a/drivers/scsi/sym53c8xx_2/sym53c8xx.h
+++ b/drivers/scsi/sym53c8xx_2/sym53c8xx.h
@@ -128,7 +128,7 @@ struct sym_driver_setup {
 /*
  *  Initial setup.
  *
- *  Can be overriden at startup by a command line.
+ *  Can be overridden at startup by a command line.
  */
 #define SYM_LINUX_DRIVER_SETUP	{				\
 	.max_tag	= CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS,	\
diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index a3355147f5de..90f3990e0060 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -1244,7 +1244,7 @@ static int omap2_mcspi_transfer_one(struct spi_controller *ctlr,
 		omap2_mcspi_set_fifo(spi, t, 0);
 
 out:
-	/* Restore defaults if they were overriden */
+	/* Restore defaults if they were overridden */
 	if (par_override) {
 		par_override = 0;
 		status = omap2_mcspi_setup_transfer(spi, NULL);
diff --git a/drivers/video/fbdev/tridentfb.c b/drivers/video/fbdev/tridentfb.c
index 9f055ba776c8..6501f6e2615a 100644
--- a/drivers/video/fbdev/tridentfb.c
+++ b/drivers/video/fbdev/tridentfb.c
@@ -58,7 +58,7 @@ static struct fb_fix_screeninfo tridentfb_fix = {
 	.accel = FB_ACCEL_NONE,
 };
 
-/* defaults which are normally overriden by user values */
+/* defaults which are normally overridden by user values */
 
 /* video mode */
 static char *mode_option;
-- 
2.25.1


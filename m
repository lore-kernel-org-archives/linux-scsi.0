From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH 55/55] scsi: Mark functions as static in bfa/bfad_bsg.c
Date: Sun, 30 Mar 2014 00:21:38 +0530
Message-ID: <b201fa77b5b94dd27f71c18a84992a440a98caf8.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Anil Gurumurthy <agurumur@brocade.com>, Vijaya Mohan Guvva <vmohan@brocade.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, josh@joshtriplett.org
List-Id: linux-scsi@vger.kernel.org

Mark functions as static in bfa/bfad_bsg.c because they are not used
outside this file.

This eliminates the following type of warnings in bfa/bfad_bsg.c:
drivers/scsi/bfa/bfad_bsg.c:26:1: warning: no previous prototype for =E2=
=80=98bfad_iocmd_ioc_enable=E2=80=99 [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/bfa/bfad_bsg.c |  224 +++++++++++++++++++++--------------=
--------
 1 file changed, 112 insertions(+), 112 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index 157f604..eff75fc 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -22,7 +22,7 @@
=20
 BFA_TRC_FILE(LDRV, BSG);
=20
-int
+static int
 bfad_iocmd_ioc_enable(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd =3D (struct bfa_bsg_gen_s *)cmd;
@@ -46,7 +46,7 @@ bfad_iocmd_ioc_enable(struct bfad_s *bfad, void *cmd)
 	return rc;
 }
=20
-int
+static int
 bfad_iocmd_ioc_disable(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd =3D (struct bfa_bsg_gen_s *)cmd;
@@ -145,7 +145,7 @@ bfad_iocmd_ioc_get_attr(struct bfad_s *bfad, void *=
cmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_ioc_get_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_ioc_stats_s *iocmd =3D (struct bfa_bsg_ioc_stats_s *)c=
md;
@@ -155,7 +155,7 @@ bfad_iocmd_ioc_get_stats(struct bfad_s *bfad, void =
*cmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_ioc_get_fwstats(struct bfad_s *bfad, void *cmd,
 			unsigned int payload_len)
 {
@@ -185,7 +185,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_ioc_reset_stats(struct bfad_s *bfad, void *cmd, unsigned in=
t v_cmd)
 {
 	struct bfa_bsg_gen_s *iocmd =3D (struct bfa_bsg_gen_s *)cmd;
@@ -203,7 +203,7 @@ bfad_iocmd_ioc_reset_stats(struct bfad_s *bfad, voi=
d *cmd, unsigned int v_cmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_ioc_set_name(struct bfad_s *bfad, void *cmd, unsigned int v=
_cmd)
 {
 	struct bfa_bsg_ioc_name_s *iocmd =3D (struct bfa_bsg_ioc_name_s *) cm=
d;
@@ -217,7 +217,7 @@ bfad_iocmd_ioc_set_name(struct bfad_s *bfad, void *=
cmd, unsigned int v_cmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_iocfc_get_attr(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_iocfc_attr_s *iocmd =3D (struct bfa_bsg_iocfc_attr_s *=
)cmd;
@@ -228,7 +228,7 @@ bfad_iocmd_iocfc_get_attr(struct bfad_s *bfad, void=
 *cmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_ioc_fw_sig_inv(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd =3D (struct bfa_bsg_gen_s *)cmd;
@@ -240,7 +240,7 @@ bfad_iocmd_ioc_fw_sig_inv(struct bfad_s *bfad, void=
 *cmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_iocfc_set_intr(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_iocfc_intr_s *iocmd =3D (struct bfa_bsg_iocfc_intr_s *=
)cmd;
@@ -253,7 +253,7 @@ bfad_iocmd_iocfc_set_intr(struct bfad_s *bfad, void=
 *cmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_port_enable(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd =3D (struct bfa_bsg_gen_s *)cmd;
@@ -274,7 +274,7 @@ bfad_iocmd_port_enable(struct bfad_s *bfad, void *c=
md)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_port_disable(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd =3D (struct bfa_bsg_gen_s *)cmd;
@@ -324,7 +324,7 @@ bfad_iocmd_port_get_attr(struct bfad_s *bfad, void =
*cmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_port_get_stats(struct bfad_s *bfad, void *cmd,
 			unsigned int payload_len)
 {
@@ -358,7 +358,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_port_reset_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd =3D (struct bfa_bsg_gen_s *)cmd;
@@ -379,7 +379,7 @@ bfad_iocmd_port_reset_stats(struct bfad_s *bfad, vo=
id *cmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_set_port_cfg(struct bfad_s *bfad, void *iocmd, unsigned int=
 v_cmd)
 {
 	struct bfa_bsg_port_cfg_s *cmd =3D (struct bfa_bsg_port_cfg_s *)iocmd=
;
@@ -399,7 +399,7 @@ bfad_iocmd_set_port_cfg(struct bfad_s *bfad, void *=
iocmd, unsigned int v_cmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_port_cfg_maxfrsize(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_port_cfg_maxfrsize_s *iocmd =3D
@@ -413,7 +413,7 @@ bfad_iocmd_port_cfg_maxfrsize(struct bfad_s *bfad, =
void *cmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_port_cfg_bbcr(struct bfad_s *bfad, unsigned int cmd, void *=
pcmd)
 {
 	struct bfa_bsg_bbcr_enable_s *iocmd =3D
@@ -436,7 +436,7 @@ bfad_iocmd_port_cfg_bbcr(struct bfad_s *bfad, unsig=
ned int cmd, void *pcmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_port_get_bbcr_attr(struct bfad_s *bfad, void *pcmd)
 {
 	struct bfa_bsg_bbcr_attr_s *iocmd =3D (struct bfa_bsg_bbcr_attr_s *) =
pcmd;
@@ -474,7 +474,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_lport_get_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_fcs_lport_s *fcs_port;
@@ -498,7 +498,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_lport_reset_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_fcs_lport_s *fcs_port;
@@ -532,7 +532,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_lport_get_iostats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_fcs_lport_s *fcs_port;
@@ -557,7 +557,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_lport_get_rports(struct bfad_s *bfad, void *cmd,
 			unsigned int payload_len)
 {
@@ -599,7 +599,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_rport_get_attr(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_rport_attr_s *iocmd =3D (struct bfa_bsg_rport_attr_s *=
)cmd;
@@ -685,7 +685,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_rport_get_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_rport_stats_s *iocmd =3D
@@ -726,7 +726,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_rport_clr_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_rport_reset_stats_s *iocmd =3D
@@ -762,7 +762,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_rport_set_speed(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_rport_set_speed_s *iocmd =3D
@@ -798,7 +798,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_vport_get_attr(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_fcs_vport_s *fcs_vport;
@@ -821,7 +821,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_vport_get_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_fcs_vport_s *fcs_vport;
@@ -849,7 +849,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_vport_clr_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_fcs_vport_s *fcs_vport;
@@ -916,7 +916,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_qos_set_bw(struct bfad_s *bfad, void *pcmd)
 {
 	struct bfa_bsg_qos_bw_s *iocmd =3D (struct bfa_bsg_qos_bw_s *)pcmd;
@@ -929,7 +929,7 @@ bfad_iocmd_qos_set_bw(struct bfad_s *bfad, void *pc=
md)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_ratelim(struct bfad_s *bfad, unsigned int cmd, void *pcmd)
 {
 	struct bfa_bsg_gen_s *iocmd =3D (struct bfa_bsg_gen_s *)pcmd;
@@ -958,7 +958,7 @@ bfad_iocmd_ratelim(struct bfad_s *bfad, unsigned in=
t cmd, void *pcmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_ratelim_speed(struct bfad_s *bfad, unsigned int cmd, void *=
pcmd)
 {
 	struct bfa_bsg_trl_speed_s *iocmd =3D (struct bfa_bsg_trl_speed_s *)p=
cmd;
@@ -987,7 +987,7 @@ bfad_iocmd_ratelim_speed(struct bfad_s *bfad, unsig=
ned int cmd, void *pcmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_cfg_fcpim(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fcpim_s *iocmd =3D (struct bfa_bsg_fcpim_s *)cmd;
@@ -1000,7 +1000,7 @@ bfad_iocmd_cfg_fcpim(struct bfad_s *bfad, void *c=
md)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_fcpim_get_modstats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fcpim_modstats_s *iocmd =3D
@@ -1022,7 +1022,7 @@ bfad_iocmd_fcpim_get_modstats(struct bfad_s *bfad=
, void *cmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_fcpim_clr_modstats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fcpim_modstatsclr_s *iocmd =3D
@@ -1044,7 +1044,7 @@ bfad_iocmd_fcpim_clr_modstats(struct bfad_s *bfad=
, void *cmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_fcpim_get_del_itn_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fcpim_del_itn_stats_s *iocmd =3D
@@ -1169,7 +1169,7 @@ bfad_iocmd_itnim_get_itnstats(struct bfad_s *bfad=
, void *cmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_fcport_enable(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd =3D (struct bfa_bsg_gen_s *)cmd;
@@ -1182,7 +1182,7 @@ bfad_iocmd_fcport_enable(struct bfad_s *bfad, voi=
d *cmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_fcport_disable(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd =3D (struct bfa_bsg_gen_s *)cmd;
@@ -1195,7 +1195,7 @@ bfad_iocmd_fcport_disable(struct bfad_s *bfad, vo=
id *cmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_ioc_get_pcifn_cfg(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_pcifn_cfg_s *iocmd =3D (struct bfa_bsg_pcifn_cfg_s *)c=
md;
@@ -1217,7 +1217,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_pcifn_create(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_pcifn_s *iocmd =3D (struct bfa_bsg_pcifn_s *)cmd;
@@ -1240,7 +1240,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_pcifn_delete(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_pcifn_s *iocmd =3D (struct bfa_bsg_pcifn_s *)cmd;
@@ -1262,7 +1262,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_pcifn_bw(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_pcifn_s *iocmd =3D (struct bfa_bsg_pcifn_s *)cmd;
@@ -1286,7 +1286,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_adapter_cfg_mode(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_adapter_cfg_mode_s *iocmd =3D
@@ -1309,7 +1309,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_port_cfg_mode(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_port_cfg_mode_s *iocmd =3D
@@ -1333,7 +1333,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_ablk_optrom(struct bfad_s *bfad, unsigned int cmd, void *pc=
md)
 {
 	struct bfa_bsg_gen_s *iocmd =3D (struct bfa_bsg_gen_s *)pcmd;
@@ -1359,7 +1359,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_faa_query(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_faa_attr_s *iocmd =3D (struct bfa_bsg_faa_attr_s *)cmd=
;
@@ -1382,7 +1382,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_cee_attr(struct bfad_s *bfad, void *cmd, unsigned int paylo=
ad_len)
 {
 	struct bfa_bsg_cee_attr_s *iocmd =3D
@@ -1418,7 +1418,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_cee_get_stats(struct bfad_s *bfad, void *cmd,
 			unsigned int payload_len)
 {
@@ -1455,7 +1455,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_cee_reset_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd =3D (struct bfa_bsg_gen_s *)cmd;
@@ -1469,7 +1469,7 @@ bfad_iocmd_cee_reset_stats(struct bfad_s *bfad, v=
oid *cmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_sfp_media(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_sfp_media_s *iocmd =3D (struct bfa_bsg_sfp_media_s *)c=
md;
@@ -1491,7 +1491,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_sfp_speed(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_sfp_speed_s *iocmd =3D (struct bfa_bsg_sfp_speed_s *)c=
md;
@@ -1512,7 +1512,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_flash_get_attr(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_flash_attr_s *iocmd =3D
@@ -1533,7 +1533,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_flash_erase_part(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_flash_s *iocmd =3D (struct bfa_bsg_flash_s *)cmd;
@@ -1553,7 +1553,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_flash_update_part(struct bfad_s *bfad, void *cmd,
 			unsigned int payload_len)
 {
@@ -1585,7 +1585,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_flash_read_part(struct bfad_s *bfad, void *cmd,
 			unsigned int payload_len)
 {
@@ -1617,7 +1617,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_diag_temp(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_diag_get_temp_s *iocmd =3D
@@ -1639,7 +1639,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_diag_memtest(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_diag_memtest_s *iocmd =3D
@@ -1662,7 +1662,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_diag_loopback(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_diag_loopback_s *iocmd =3D
@@ -1685,7 +1685,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_diag_fwping(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_diag_fwping_s *iocmd =3D
@@ -1709,7 +1709,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_diag_queuetest(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_diag_qtest_s *iocmd =3D (struct bfa_bsg_diag_qtest_s *=
)cmd;
@@ -1730,7 +1730,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_diag_sfp(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_sfp_show_s *iocmd =3D
@@ -1753,7 +1753,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_diag_led(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_diag_led_s *iocmd =3D (struct bfa_bsg_diag_led_s *)cmd=
;
@@ -1766,7 +1766,7 @@ bfad_iocmd_diag_led(struct bfad_s *bfad, void *cm=
d)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_diag_beacon_lport(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_diag_beacon_s *iocmd =3D
@@ -1781,7 +1781,7 @@ bfad_iocmd_diag_beacon_lport(struct bfad_s *bfad,=
 void *cmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_diag_lb_stat(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_diag_lb_stat_s *iocmd =3D
@@ -1796,7 +1796,7 @@ bfad_iocmd_diag_lb_stat(struct bfad_s *bfad, void=
 *cmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_diag_dport_enable(struct bfad_s *bfad, void *pcmd)
 {
 	struct bfa_bsg_dport_enable_s *iocmd =3D
@@ -1818,7 +1818,7 @@ bfad_iocmd_diag_dport_enable(struct bfad_s *bfad,=
 void *pcmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_diag_dport_disable(struct bfad_s *bfad, void *pcmd)
 {
 	struct bfa_bsg_gen_s *iocmd =3D (struct bfa_bsg_gen_s *)pcmd;
@@ -1838,7 +1838,7 @@ bfad_iocmd_diag_dport_disable(struct bfad_s *bfad=
, void *pcmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_diag_dport_start(struct bfad_s *bfad, void *pcmd)
 {
 	struct bfa_bsg_dport_enable_s *iocmd =3D
@@ -1863,7 +1863,7 @@ bfad_iocmd_diag_dport_start(struct bfad_s *bfad, =
void *pcmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_diag_dport_show(struct bfad_s *bfad, void *pcmd)
 {
 	struct bfa_bsg_diag_dport_show_s *iocmd =3D
@@ -1878,7 +1878,7 @@ bfad_iocmd_diag_dport_show(struct bfad_s *bfad, v=
oid *pcmd)
 }
=20
=20
-int
+static int
 bfad_iocmd_phy_get_attr(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_phy_attr_s *iocmd =3D
@@ -1899,7 +1899,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_phy_get_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_phy_stats_s *iocmd =3D
@@ -1920,7 +1920,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_phy_read(struct bfad_s *bfad, void *cmd, unsigned int paylo=
ad_len)
 {
 	struct bfa_bsg_phy_s *iocmd =3D (struct bfa_bsg_phy_s *)cmd;
@@ -1952,7 +1952,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_vhba_query(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_vhba_attr_s *iocmd =3D
@@ -1971,7 +1971,7 @@ bfad_iocmd_vhba_query(struct bfad_s *bfad, void *=
cmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_phy_update(struct bfad_s *bfad, void *cmd, unsigned int pay=
load_len)
 {
 	struct bfa_bsg_phy_s *iocmd =3D (struct bfa_bsg_phy_s *)cmd;
@@ -2001,7 +2001,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_porglog_get(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_debug_s *iocmd =3D (struct bfa_bsg_debug_s *)cmd;
@@ -2021,7 +2021,7 @@ out:
 }
=20
 #define BFA_DEBUG_FW_CORE_CHUNK_SZ	0x4000U /* 16K chunks for FW dump *=
/
-int
+static int
 bfad_iocmd_debug_fw_core(struct bfad_s *bfad, void *cmd,
 			unsigned int payload_len)
 {
@@ -2055,7 +2055,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_debug_ctl(struct bfad_s *bfad, void *cmd, unsigned int v_cm=
d)
 {
 	struct bfa_bsg_gen_s *iocmd =3D (struct bfa_bsg_gen_s *)cmd;
@@ -2076,7 +2076,7 @@ bfad_iocmd_debug_ctl(struct bfad_s *bfad, void *c=
md, unsigned int v_cmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_porglog_ctl(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_portlogctl_s *iocmd =3D (struct bfa_bsg_portlogctl_s *=
)cmd;
@@ -2090,7 +2090,7 @@ bfad_iocmd_porglog_ctl(struct bfad_s *bfad, void =
*cmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_fcpim_cfg_profile(struct bfad_s *bfad, void *cmd, unsigned =
int v_cmd)
 {
 	struct bfa_bsg_fcpim_profile_s *iocmd =3D
@@ -2136,7 +2136,7 @@ bfad_iocmd_itnim_get_ioprofile(struct bfad_s *bfa=
d, void *cmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_fcport_get_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fcport_stats_s *iocmd =3D
@@ -2161,7 +2161,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_fcport_reset_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd =3D (struct bfa_bsg_gen_s *)cmd;
@@ -2185,7 +2185,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_boot_cfg(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_boot_s *iocmd =3D (struct bfa_bsg_boot_s *)cmd;
@@ -2207,7 +2207,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_boot_query(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_boot_s *iocmd =3D (struct bfa_bsg_boot_s *)cmd;
@@ -2229,7 +2229,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_preboot_query(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_preboot_s *iocmd =3D (struct bfa_bsg_preboot_s *)cmd;
@@ -2248,7 +2248,7 @@ bfad_iocmd_preboot_query(struct bfad_s *bfad, voi=
d *cmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_ethboot_cfg(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_ethboot_s *iocmd =3D (struct bfa_bsg_ethboot_s *)cmd;
@@ -2271,7 +2271,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_ethboot_query(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_ethboot_s *iocmd =3D (struct bfa_bsg_ethboot_s *)cmd;
@@ -2294,7 +2294,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_cfg_trunk(struct bfad_s *bfad, void *cmd, unsigned int v_cm=
d)
 {
 	struct bfa_bsg_gen_s *iocmd =3D (struct bfa_bsg_gen_s *)cmd;
@@ -2332,7 +2332,7 @@ bfad_iocmd_cfg_trunk(struct bfad_s *bfad, void *c=
md, unsigned int v_cmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_trunk_get_attr(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_trunk_attr_s *iocmd =3D (struct bfa_bsg_trunk_attr_s *=
)cmd;
@@ -2355,7 +2355,7 @@ bfad_iocmd_trunk_get_attr(struct bfad_s *bfad, vo=
id *cmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_qos(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 {
 	struct bfa_bsg_gen_s *iocmd =3D (struct bfa_bsg_gen_s *)cmd;
@@ -2383,7 +2383,7 @@ bfad_iocmd_qos(struct bfad_s *bfad, void *cmd, un=
signed int v_cmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_qos_get_attr(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_qos_attr_s *iocmd =3D (struct bfa_bsg_qos_attr_s *)cmd=
;
@@ -2409,7 +2409,7 @@ bfad_iocmd_qos_get_attr(struct bfad_s *bfad, void=
 *cmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_qos_get_vc_attr(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_qos_vc_attr_s *iocmd =3D
@@ -2441,7 +2441,7 @@ bfad_iocmd_qos_get_vc_attr(struct bfad_s *bfad, v=
oid *cmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_qos_get_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fcport_stats_s *iocmd =3D
@@ -2473,7 +2473,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_qos_reset_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd =3D (struct bfa_bsg_gen_s *)cmd;
@@ -2504,7 +2504,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_vf_get_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_vf_stats_s *iocmd =3D
@@ -2527,7 +2527,7 @@ out:
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_vf_clr_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_vf_reset_stats_s *iocmd =3D
@@ -2564,7 +2564,7 @@ bfad_iocmd_lunmask_reset_lunscan_mode(struct bfad=
_s *bfad, int lunmask_cfg)
 		bfad_reset_sdev_bflags(vport->drv_port.im_port, lunmask_cfg);
 }
=20
-int
+static int
 bfad_iocmd_lunmask(struct bfad_s *bfad, void *pcmd, unsigned int v_cmd=
)
 {
 	struct bfa_bsg_gen_s *iocmd =3D (struct bfa_bsg_gen_s *)pcmd;
@@ -2587,7 +2587,7 @@ bfad_iocmd_lunmask(struct bfad_s *bfad, void *pcm=
d, unsigned int v_cmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_fcpim_lunmask_query(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fcpim_lunmask_query_s *iocmd =3D
@@ -2601,7 +2601,7 @@ bfad_iocmd_fcpim_lunmask_query(struct bfad_s *bfa=
d, void *cmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_fcpim_cfg_lunmask(struct bfad_s *bfad, void *cmd, unsigned =
int v_cmd)
 {
 	struct bfa_bsg_fcpim_lunmask_s *iocmd =3D
@@ -2620,7 +2620,7 @@ bfad_iocmd_fcpim_cfg_lunmask(struct bfad_s *bfad,=
 void *cmd, unsigned int v_cmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_fcpim_throttle_query(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fcpim_throttle_s *iocmd =3D
@@ -2635,7 +2635,7 @@ bfad_iocmd_fcpim_throttle_query(struct bfad_s *bf=
ad, void *cmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_fcpim_throttle_set(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fcpim_throttle_s *iocmd =3D
@@ -2650,7 +2650,7 @@ bfad_iocmd_fcpim_throttle_set(struct bfad_s *bfad=
, void *cmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_tfru_read(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_tfru_s *iocmd =3D
@@ -2672,7 +2672,7 @@ bfad_iocmd_tfru_read(struct bfad_s *bfad, void *c=
md)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_tfru_write(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_tfru_s *iocmd =3D
@@ -2694,7 +2694,7 @@ bfad_iocmd_tfru_write(struct bfad_s *bfad, void *=
cmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_fruvpd_read(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fruvpd_s *iocmd =3D
@@ -2716,7 +2716,7 @@ bfad_iocmd_fruvpd_read(struct bfad_s *bfad, void =
*cmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_fruvpd_update(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fruvpd_s *iocmd =3D
@@ -2738,7 +2738,7 @@ bfad_iocmd_fruvpd_update(struct bfad_s *bfad, voi=
d *cmd)
 	return 0;
 }
=20
-int
+static int
 bfad_iocmd_fruvpd_get_max_size(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_fruvpd_max_size_s *iocmd =3D
@@ -3190,7 +3190,7 @@ out:
 }
=20
 /* FC passthru call backs */
-u64
+static u64
 bfad_fcxp_get_req_sgaddr_cb(void *bfad_fcxp, int sgeid)
 {
 	struct bfad_fcxp	*drv_fcxp =3D bfad_fcxp;
@@ -3202,7 +3202,7 @@ bfad_fcxp_get_req_sgaddr_cb(void *bfad_fcxp, int =
sgeid)
 	return addr;
 }
=20
-u32
+static u32
 bfad_fcxp_get_req_sglen_cb(void *bfad_fcxp, int sgeid)
 {
 	struct bfad_fcxp	*drv_fcxp =3D bfad_fcxp;
@@ -3212,7 +3212,7 @@ bfad_fcxp_get_req_sglen_cb(void *bfad_fcxp, int s=
geid)
 	return sge->sg_len;
 }
=20
-u64
+static u64
 bfad_fcxp_get_rsp_sgaddr_cb(void *bfad_fcxp, int sgeid)
 {
 	struct bfad_fcxp	*drv_fcxp =3D bfad_fcxp;
@@ -3224,7 +3224,7 @@ bfad_fcxp_get_rsp_sgaddr_cb(void *bfad_fcxp, int =
sgeid)
 	return addr;
 }
=20
-u32
+static u32
 bfad_fcxp_get_rsp_sglen_cb(void *bfad_fcxp, int sgeid)
 {
 	struct bfad_fcxp	*drv_fcxp =3D bfad_fcxp;
@@ -3234,7 +3234,7 @@ bfad_fcxp_get_rsp_sglen_cb(void *bfad_fcxp, int s=
geid)
 	return sge->sg_len;
 }
=20
-void
+static void
 bfad_send_fcpt_cb(void *bfad_fcxp, struct bfa_fcxp_s *fcxp, void *cbar=
g,
 		bfa_status_t req_status, u32 rsp_len, u32 resid_len,
 		struct fchs_s *rsp_fchs)
@@ -3249,7 +3249,7 @@ bfad_send_fcpt_cb(void *bfad_fcxp, struct bfa_fcx=
p_s *fcxp, void *cbarg,
 	complete(&drv_fcxp->comp);
 }
=20
-struct bfad_buf_info *
+static struct bfad_buf_info *
 bfad_fcxp_map_sg(struct bfad_s *bfad, void *payload_kbuf,
 		 uint32_t payload_len, uint32_t *num_sgles)
 {
@@ -3292,7 +3292,7 @@ out_free_mem:
 	return NULL;
 }
=20
-void
+static void
 bfad_fcxp_free_mem(struct bfad_s *bfad, struct bfad_buf_info *buf_base=
,
 		   uint32_t num_sgles)
 {
@@ -3310,7 +3310,7 @@ bfad_fcxp_free_mem(struct bfad_s *bfad, struct bf=
ad_buf_info *buf_base,
 	}
 }
=20
-int
+static int
 bfad_fcxp_bsg_send(struct fc_bsg_job *job, struct bfad_fcxp *drv_fcxp,
 		   bfa_bsg_fcpt_t *bsg_fcpt)
 {
@@ -3350,7 +3350,7 @@ bfad_fcxp_bsg_send(struct fc_bsg_job *job, struct=
 bfad_fcxp *drv_fcxp,
 	return BFA_STATUS_OK;
 }
=20
-int
+static int
 bfad_im_bsg_els_ct_request(struct fc_bsg_job *job)
 {
 	struct bfa_bsg_data *bsg_data;
--=20
1.7.9.5

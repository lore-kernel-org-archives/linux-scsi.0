From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 7/7] bfa: update bfa driver to version 2.1.2.1 part 7
Date: Thu, 19 Nov 2009 16:17:16 -0800
Message-ID: <1258676236-18489-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.82]:26623 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758146AbZKTARM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2009 19:17:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, Jing Huang <huangj@brocade.com>

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/include/aen/bfa_aen.h             |   50 ++--
 drivers/scsi/bfa/include/bfa.h                     |   49 +++-
 drivers/scsi/bfa/include/bfa_fcpim.h               |    2 +-
 drivers/scsi/bfa/include/bfa_svc.h                 |  194 +++++++------
 drivers/scsi/bfa/include/bfa_timer.h               |    6 +-
 drivers/scsi/bfa/include/bfi/bfi.h                 |   31 +-
 drivers/scsi/bfa/include/bfi/bfi_cbreg.h           |   15 +
 drivers/scsi/bfa/include/bfi/bfi_ctreg.h           |   58 +++-
 drivers/scsi/bfa/include/bfi/bfi_ioc.h             |  151 +++++-----
 drivers/scsi/bfa/include/bfi/bfi_lps.h             |   12 +-
 drivers/scsi/bfa/include/bfi/bfi_pport.h           |  172 ++++--------
 drivers/scsi/bfa/include/cna/bfa_cna_trcmod.h      |    4 +
 drivers/scsi/bfa/include/cna/cee/bfa_cee.h         |   14 +-
 drivers/scsi/bfa/include/cna/port/bfa_port.h       |   70 +++---
 drivers/scsi/bfa/include/cna/pstats/ethport_defs.h |    1 -
 drivers/scsi/bfa/include/cna/pstats/phyport_defs.h |  288 +++++++++----------
 drivers/scsi/bfa/include/cs/bfa_log.h              |    2 +-
 drivers/scsi/bfa/include/cs/bfa_plog.h             |    9 +-
 drivers/scsi/bfa/include/cs/bfa_sm.h               |    9 +
 drivers/scsi/bfa/include/defs/bfa_defs_aen.h       |   10 +
 drivers/scsi/bfa/include/defs/bfa_defs_auth.h      |   22 ++
 drivers/scsi/bfa/include/defs/bfa_defs_cee.h       |   32 +--
 drivers/scsi/bfa/include/defs/bfa_defs_driver.h    |    4 +
 drivers/scsi/bfa/include/defs/bfa_defs_ethport.h   |   15 +-
 drivers/scsi/bfa/include/defs/bfa_defs_fcport.h    |   94 +++++++
 drivers/scsi/bfa/include/defs/bfa_defs_im_common.h |   32 ---
 drivers/scsi/bfa/include/defs/bfa_defs_im_team.h   |   72 -----
 drivers/scsi/bfa/include/defs/bfa_defs_ioc.h       |    5 +-
 drivers/scsi/bfa/include/defs/bfa_defs_iocfc.h     |   12 +-
 drivers/scsi/bfa/include/defs/bfa_defs_lport.h     |    4 +-
 drivers/scsi/bfa/include/defs/bfa_defs_mfg.h       |  109 +++++++-
 drivers/scsi/bfa/include/defs/bfa_defs_port.h      |   16 +-
 drivers/scsi/bfa/include/defs/bfa_defs_pport.h     |  166 +++++++-----
 drivers/scsi/bfa/include/defs/bfa_defs_rport.h     |    4 +-
 drivers/scsi/bfa/include/defs/bfa_defs_status.h    |   21 +-
 drivers/scsi/bfa/include/defs/bfa_defs_vf.h        |   29 +--
 drivers/scsi/bfa/include/fcs/bfa_fcs.h             |   39 ++--
 drivers/scsi/bfa/include/fcs/bfa_fcs_fabric.h      |    5 +-
 drivers/scsi/bfa/include/fcs/bfa_fcs_lport.h       |   25 +-
 drivers/scsi/bfa/include/fcs/bfa_fcs_rport.h       |    3 +-
 drivers/scsi/bfa/include/fcs/bfa_fcs_vport.h       |    6 +-
 drivers/scsi/bfa/include/log/bfa_log_hal.h         |    6 +
 drivers/scsi/bfa/include/log/bfa_log_linux.h       |   38 ++-
 drivers/scsi/bfa/include/protocol/ct.h             |   56 ++--
 drivers/scsi/bfa/include/protocol/fc.h             |  131 +++++-----
 drivers/scsi/bfa/include/protocol/fc_sp.h          |   27 +-
 drivers/scsi/bfa/include/protocol/fcp.h            |   19 +-
 drivers/scsi/bfa/include/protocol/fdmi.h           |   12 +-
 drivers/scsi/bfa/include/protocol/pcifw.h          |   75 -----
 drivers/scsi/bfa/include/protocol/scsi.h           |  133 +++++-----
 drivers/scsi/bfa/include/protocol/types.h          |    1 -
 51 files changed, 1238 insertions(+), 1122 deletions(-)
 create mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_fcport.h
 delete mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_im_common.h
 delete mode 100644 drivers/scsi/bfa/include/defs/bfa_defs_im_team.h
 delete mode 100644 drivers/scsi/bfa/include/protocol/pcifw.h

diff --git a/drivers/scsi/bfa/include/aen/bfa_aen.h b/drivers/scsi/bfa/include/aen/bfa_aen.h
index d9cbc2a..6abbab0 100644
--- a/drivers/scsi/bfa/include/aen/bfa_aen.h
+++ b/drivers/scsi/bfa/include/aen/bfa_aen.h
@@ -18,21 +18,24 @@
 #define __BFA_AEN_H__
 
 #include "defs/bfa_defs_aen.h"
+#include "defs/bfa_defs_status.h"
+#include "cs/bfa_debug.h"
 
-#define BFA_AEN_MAX_ENTRY   512
+#define BFA_AEN_MAX_ENTRY	512
 
-extern s32 bfa_aen_max_cfg_entry;
+extern int bfa_aen_max_cfg_entry;
 struct bfa_aen_s {
 	void		*bfad;
-	s32		max_entry;
-	s32		write_index;
-	s32		read_index;
-	u32	bfad_num;
-	u32	seq_num;
+	int		max_entry;
+	int		write_index;
+	int		read_index;
+	int		bfad_num;
+	int		seq_num;
 	void		(*aen_cb_notify)(void *bfad);
 	void		(*gettimeofday)(struct bfa_timeval_s *tv);
-	struct bfa_trc_mod_s 	*trcmod;
-	struct bfa_aen_entry_s	list[BFA_AEN_MAX_ENTRY]; /* Must be the last */
+	struct bfa_trc_mod_s *trcmod;
+	int		app_ri[BFA_AEN_MAX_APP]; /* For multiclient support */
+	struct bfa_aen_entry_s list[BFA_AEN_MAX_ENTRY]; /* Must be the last */
 };
 
 
@@ -45,48 +48,49 @@ bfa_aen_set_max_cfg_entry(int max_entry)
 	bfa_aen_max_cfg_entry = max_entry;
 }
 
-static inline s32
+static inline int
 bfa_aen_get_max_cfg_entry(void)
 {
 	return bfa_aen_max_cfg_entry;
 }
 
-static inline s32
+static inline int
 bfa_aen_get_meminfo(void)
 {
 	return sizeof(struct bfa_aen_entry_s) * bfa_aen_get_max_cfg_entry();
 }
 
-static inline s32
+static inline int
 bfa_aen_get_wi(struct bfa_aen_s *aen)
 {
 	return aen->write_index;
 }
 
-static inline s32
+static inline int
 bfa_aen_get_ri(struct bfa_aen_s *aen)
 {
 	return aen->read_index;
 }
 
-static inline s32
-bfa_aen_fetch_count(struct bfa_aen_s *aen, s32 read_index)
+static inline int
+bfa_aen_fetch_count(struct bfa_aen_s *aen, enum bfa_aen_app  app_id)
 {
-	return ((aen->write_index + aen->max_entry) - read_index)
+	bfa_assert((app_id < BFA_AEN_MAX_APP) && (app_id >= bfa_aen_app_bcu));
+	return ((aen->write_index + aen->max_entry) - aen->app_ri[app_id])
 		% aen->max_entry;
 }
 
-s32 bfa_aen_init(struct bfa_aen_s *aen, struct bfa_trc_mod_s *trcmod,
-		void *bfad, u32 inst_id, void (*aen_cb_notify)(void *),
+int bfa_aen_init(struct bfa_aen_s *aen, struct bfa_trc_mod_s *trcmod,
+		void *bfad, int bfad_num, void (*aen_cb_notify)(void *),
 		void (*gettimeofday)(struct bfa_timeval_s *));
 
-s32 bfa_aen_post(struct bfa_aen_s *aen, enum bfa_aen_category aen_category,
+void bfa_aen_post(struct bfa_aen_s *aen, enum bfa_aen_category aen_category,
 		     int aen_type, union bfa_aen_data_u *aen_data);
 
-s32 bfa_aen_fetch(struct bfa_aen_s *aen, struct bfa_aen_entry_s *aen_entry,
-		      s32 entry_space, s32 rii, s32 *ri_arr,
-		      s32 ri_arr_cnt);
+bfa_status_t bfa_aen_fetch(struct bfa_aen_s *aen,
+			struct bfa_aen_entry_s *aen_entry,
+			int entry_req, enum bfa_aen_app app_id, int *entry_ret);
 
-s32 bfa_aen_get_inst(struct bfa_aen_s *aen);
+int bfa_aen_get_inst(struct bfa_aen_s *aen);
 
 #endif /* __BFA_AEN_H__ */
diff --git a/drivers/scsi/bfa/include/bfa.h b/drivers/scsi/bfa/include/bfa.h
index d4bc0d9..3c35379 100644
--- a/drivers/scsi/bfa/include/bfa.h
+++ b/drivers/scsi/bfa/include/bfa.h
@@ -38,12 +38,10 @@ struct bfa_pcidev_s;
  * PCI devices supported by the current BFA
  */
 struct bfa_pciid_s {
-	u16        device_id;
-	u16        vendor_id;
+	u16	device_id;
+	u16	vendor_id;
 };
 
-extern char     bfa_version[];
-
 /**
  * BFA Power Mgmt Commands
  */
@@ -58,18 +56,18 @@ enum bfa_pm_cmd {
  * BFA memory resources
  */
 enum bfa_mem_type {
-	BFA_MEM_TYPE_KVA = 1,	/*! Kernel Virtual Memory *(non-dma-able) */
-	BFA_MEM_TYPE_DMA = 2,	/*! DMA-able memory */
+	BFA_MEM_TYPE_KVA = 1,	/*  Kernel Virtual Memory *(non-dma-able) */
+	BFA_MEM_TYPE_DMA = 2,	/*  DMA-able memory */
 	BFA_MEM_TYPE_MAX = BFA_MEM_TYPE_DMA,
 };
 
 struct bfa_mem_elem_s {
 	enum bfa_mem_type mem_type;	/*  see enum bfa_mem_type 	*/
-	u32        mem_len;	/*  Total Length in Bytes	*/
-	u8       	*kva;		/*  kernel virtual address	*/
-	u64        dma;		/*  dma address if DMA memory	*/
-	u8       	*kva_curp;	/*  kva allocation cursor	*/
-	u64        dma_curp;	/*  dma allocation cursor	*/
+	u32	mem_len;	/*  Total Length in Bytes	*/
+	u8		*kva;		/*  kernel virtual address	*/
+	u64	dma;		/*  dma address if DMA memory	*/
+	u8		*kva_curp;	/*  kva allocation cursor	*/
+	u64	dma_curp;	/*  dma allocation cursor	*/
 };
 
 struct bfa_meminfo_s {
@@ -86,8 +84,8 @@ struct bfa_meminfo_s {
  * Generic Scatter Gather Element used by driver
  */
 struct bfa_sge_s {
-	u32        sg_len;
-	void           *sg_addr;
+	u32	sg_len;
+	void		*sg_addr;
 };
 
 #define bfa_sge_to_be(__sge) do {                                          \
@@ -106,6 +104,26 @@ struct bfa_sge_s {
 	bfa_ioc_fetch_stats(&(__bfa)->ioc, __ioc_stats)
 #define bfa_ioc_clear_stats(__bfa)	\
 	bfa_ioc_clr_stats(&(__bfa)->ioc)
+#define bfa_get_nports(__bfa)	\
+	bfa_ioc_get_nports(&(__bfa)->ioc)
+#define bfa_get_adapter_manufacturer(__bfa, __manufacturer)	\
+	bfa_ioc_get_adapter_manufacturer(&(__bfa)->ioc, __manufacturer)
+#define bfa_get_adapter_model(__bfa, __model)	\
+	bfa_ioc_get_adapter_model(&(__bfa)->ioc, __model)
+#define bfa_get_adapter_serial_num(__bfa, __serial_num)	\
+	bfa_ioc_get_adapter_serial_num(&(__bfa)->ioc, __serial_num)
+#define bfa_get_adapter_fw_ver(__bfa, __fw_ver)	\
+	bfa_ioc_get_adapter_fw_ver(&(__bfa)->ioc, __fw_ver)
+#define bfa_get_adapter_optrom_ver(__bfa, __optrom_ver)	\
+	bfa_ioc_get_adapter_optrom_ver(&(__bfa)->ioc, __optrom_ver)
+#define bfa_get_pci_chip_rev(__bfa, __chip_rev)	\
+	bfa_ioc_get_pci_chip_rev(&(__bfa)->ioc, __chip_rev)
+#define bfa_get_ioc_state(__bfa)	\
+	bfa_ioc_get_state(&(__bfa)->ioc)
+#define bfa_get_type(__bfa)	\
+	bfa_ioc_get_type(&(__bfa)->ioc)
+#define bfa_get_mac(__bfa)	\
+	bfa_ioc_get_mac(&(__bfa)->ioc)
 
 /*
  * bfa API functions
@@ -136,7 +154,7 @@ void bfa_isr_enable(struct bfa_s *bfa);
 void bfa_isr_disable(struct bfa_s *bfa);
 void bfa_msix_getvecs(struct bfa_s *bfa, u32 *msix_vecs_bmap,
 			u32 *num_vecs, u32 *max_vec_bit);
-#define bfa_msix(__bfa, __vec) ((__bfa)->msix.handler[__vec](__bfa, __vec))
+#define bfa_msix(__bfa, __vec)	((__bfa)->msix.handler[__vec](__bfa, __vec))
 
 void bfa_comp_deq(struct bfa_s *bfa, struct list_head *comp_q);
 void bfa_comp_process(struct bfa_s *bfa, struct list_head *comp_q);
@@ -161,16 +179,17 @@ bfa_status_t bfa_iocfc_israttr_set(struct bfa_s *bfa,
 void bfa_iocfc_enable(struct bfa_s *bfa);
 void bfa_iocfc_disable(struct bfa_s *bfa);
 void bfa_ioc_auto_recover(bfa_boolean_t auto_recover);
+void bfa_chip_reset(struct bfa_s *bfa);
 void bfa_cb_ioc_disable(void *bfad);
 void bfa_timer_tick(struct bfa_s *bfa);
 #define bfa_timer_start(_bfa, _timer, _timercb, _arg, _timeout)	\
 	bfa_timer_begin(&(_bfa)->timer_mod, _timer, _timercb, _arg, _timeout)
-
 /*
  * BFA debug API functions
  */
 bfa_status_t bfa_debug_fwtrc(struct bfa_s *bfa, void *trcdata, int *trclen);
 bfa_status_t bfa_debug_fwsave(struct bfa_s *bfa, void *trcdata, int *trclen);
+void bfa_debug_fwsave_clear(struct bfa_s *bfa);
 
 #include "bfa_priv.h"
 
diff --git a/drivers/scsi/bfa/include/bfa_fcpim.h b/drivers/scsi/bfa/include/bfa_fcpim.h
index 0478979..0667ba2 100644
--- a/drivers/scsi/bfa/include/bfa_fcpim.h
+++ b/drivers/scsi/bfa/include/bfa_fcpim.h
@@ -40,7 +40,7 @@ u16	bfa_fcpim_path_tov_get(struct bfa_s *bfa);
 void		bfa_fcpim_qdepth_set(struct bfa_s *bfa, u16 q_depth);
 u16	bfa_fcpim_qdepth_get(struct bfa_s *bfa);
 bfa_status_t bfa_fcpim_get_modstats(struct bfa_s *bfa,
-			struct bfa_fcpim_stats_s *modstats);
+				struct bfa_fcpim_stats_s *modstats);
 bfa_status_t bfa_fcpim_clr_modstats(struct bfa_s *bfa);
 
 /*
diff --git a/drivers/scsi/bfa/include/bfa_svc.h b/drivers/scsi/bfa/include/bfa_svc.h
index 268d956..bf3f480 100644
--- a/drivers/scsi/bfa/include/bfa_svc.h
+++ b/drivers/scsi/bfa/include/bfa_svc.h
@@ -26,6 +26,7 @@ struct bfa_fcxp_s;
 #include <defs/bfa_defs_pport.h>
 #include <defs/bfa_defs_rport.h>
 #include <defs/bfa_defs_qos.h>
+#include <defs/bfa_defs_fcport.h>
 #include <cs/bfa_sm.h>
 #include <bfa.h>
 
@@ -33,14 +34,14 @@ struct bfa_fcxp_s;
  * 		BFA rport information.
  */
 struct bfa_rport_info_s {
-	u16        max_frmsz;	/*  max rcv pdu size               */
-	u32        pid:24,		/*  remote port ID                 */
-			lp_tag:8;
-	u32        local_pid:24,	/*  local port ID		    */
+	u16	max_frmsz;	/*  max rcv pdu size		    */
+	u32	pid:24,		/*  remote port ID		    */
+			lp_tag:8;	/*  tag			    */
+	u32	local_pid:24,	/*  local port ID		    */
 			cisc:8;		/*  CIRO supported		    */
-	u8         fc_class;	/*  supported FC classes. enum fc_cos */
-	u8         vf_en;		/*  virtual fabric enable          */
-	u16        vf_id;		/*  virtual fabric ID              */
+	u8		fc_class;	/*  supported FC classes. enum fc_cos */
+	u8		vf_en;		/*  virtual fabric enable	    */
+	u16	vf_id;		/*  virtual fabric ID		    */
 	enum bfa_pport_speed speed;	/*  Rport's current speed	    */
 };
 
@@ -48,20 +49,20 @@ struct bfa_rport_info_s {
  * BFA rport data structure
  */
 struct bfa_rport_s {
-	struct list_head        qe;	  /*  queue element */
-	bfa_sm_t	      sm; 	  /*  state machine */
-	struct bfa_s          *bfa;	  /*  backpointer to BFA */
-	void                  *rport_drv; /*  fcs/driver rport object */
-	u16              fw_handle; /*  firmware rport handle */
-	u16              rport_tag; /*  BFA rport tag */
-	struct bfa_rport_info_s rport_info; /*  rport info from *fcs/driver */
-	struct bfa_reqq_wait_s reqq_wait; /*  to wait for room in reqq */
-	struct bfa_cb_qe_s    hcb_qe;	 /*  BFA callback qelem */
-	struct bfa_rport_hal_stats_s stats; /*  BFA rport statistics  */
-	struct bfa_rport_qos_attr_s  qos_attr;
+	struct list_head	qe;		/*  queue element */
+	bfa_sm_t	sm; 		/*  state machine */
+	struct bfa_s	*bfa;		/*  backpointer to BFA		    */
+	void		*rport_drv;	/*  fcs/driver rport object	    */
+	u16	fw_handle;	/*  firmware rport handle	    */
+	u16	rport_tag;	/*  BFA rport tag		    */
+	struct bfa_rport_info_s rport_info; /*  rport info from fcs/driver */
+	struct bfa_reqq_wait_s reqq_wait; /*  to wait for room in reqq     */
+	struct bfa_cb_qe_s hcb_qe;	/*  BFA callback qelem		    */
+	struct bfa_rport_hal_stats_s stats; /*  BFA rport statistics	    */
+	struct bfa_rport_qos_attr_s qos_attr;
 	union a {
-		bfa_status_t    status;	 /*  f/w status */
-		void            *fw_msg; /*  QoS scn event */
+		bfa_status_t	status;	/*  f/w status */
+		void		*fw_msg; /*  QoS scn event		    */
 	} event_arg;
 };
 #define BFA_RPORT_FC_COS(_rport)	((_rport)->rport_info.fc_class)
@@ -80,9 +81,9 @@ typedef void (*bfa_cb_fcxp_send_t) (void *bfad_fcxp, struct bfa_fcxp_s *fcxp,
 typedef void (*bfa_fcxp_alloc_cbfn_t) (void *cbarg, struct bfa_fcxp_s *fcxp);
 
 struct bfa_fcxp_wqe_s {
-	struct list_head         qe;
-	bfa_fcxp_alloc_cbfn_t  alloc_cbfn;
-	void           *alloc_cbarg;
+	struct list_head		qe;
+	bfa_fcxp_alloc_cbfn_t	alloc_cbfn;
+	void			*alloc_cbarg;
 };
 
 typedef u64 (*bfa_fcxp_get_sgaddr_t) (void *bfad_fcxp, int sgeid);
@@ -94,24 +95,24 @@ typedef u32 (*bfa_fcxp_get_sglen_t) (void *bfad_fcxp, int sgeid);
  * @todo private
  */
 struct bfa_uf_buf_s {
-	u8         d[BFA_UF_BUFSZ];
+	u8		d[BFA_UF_BUFSZ];
 };
 
 
 struct bfa_uf_s {
-	struct list_head	qe;		/*  queue element	  */
-	struct bfa_s	*bfa;		/*  bfa instance	  */
-	u16        uf_tag;		/*  identifying tag f/w messages */
-	u16        vf_id;
-	u16        src_rport_handle;
-	u16        rsvd;
-	u8        	*data_ptr;
-	u16        data_len;	/*  actual receive length	  */
-	u16        pb_len;		/*  posted buffer length	  */
-	void           	*buf_kva;	/*  buffer virtual address	  */
-	u64        buf_pa;		/*  buffer physical address	  */
-	struct bfa_cb_qe_s    hcb_qe;	/*  comp: BFA comp qelem	  */
-	struct bfa_sge_s   	sges[BFI_SGE_INLINE_MAX];
+	struct list_head	qe;		/*  queue element */
+	struct bfa_s	*bfa;		/*  bfa instance		*/
+	u16	uf_tag;		/*  identifying tag fw msgs	*/
+	u16	vf_id;
+	u16	src_rport_handle;
+	u16	rsvd;
+	u8		*data_ptr;
+	u16	data_len;	/*  actual receive length	*/
+	u16	pb_len;		/*  posted buffer length	*/
+	void		*buf_kva;	/*  buffer virtual address	*/
+	u64	buf_pa;		/*  buffer physical address	*/
+	struct bfa_cb_qe_s hcb_qe;	/*  comp: BFA comp qelem	*/
+	struct bfa_sge_s sges[BFI_SGE_INLINE_MAX];
 };
 
 typedef void (*bfa_cb_pport_t) (void *cbarg, enum bfa_status status);
@@ -127,12 +128,12 @@ struct bfa_lps_s {
 	u8		reqq;		/*  lport request queue	*/
 	u8		alpa;		/*  ALPA for loop topologies	*/
 	u32	lp_pid;		/*  lport port ID		*/
-	bfa_boolean_t	fdisc;		/*  send FDISC instead of FLOGI*/
+	bfa_boolean_t	fdisc;		/*  snd FDISC instead of FLOGI	*/
 	bfa_boolean_t	auth_en;	/*  enable authentication	*/
 	bfa_boolean_t	auth_req;	/*  authentication required	*/
 	bfa_boolean_t	npiv_en;	/*  NPIV is allowed by peer	*/
 	bfa_boolean_t	fport;		/*  attached peer is F_PORT	*/
-	bfa_boolean_t	brcd_switch;/*  attached peer is brcd switch	*/
+	bfa_boolean_t	brcd_switch;	/*  attached peer is brcd sw	*/
 	bfa_status_t	status;		/*  login status		*/
 	u16	pdusz;		/*  max receive PDU size 	*/
 	u16	pr_bbcred;	/*  BB_CREDIT from peer 	*/
@@ -142,69 +143,77 @@ struct bfa_lps_s {
 	wwn_t		nwwn;		/*  node wwn of lport		*/
 	wwn_t		pr_pwwn;	/*  port wwn of lport peer	*/
 	wwn_t		pr_nwwn;	/*  node wwn of lport peer	*/
-	mac_t		lp_mac;		/*  fpma/spma MAC for lport	*/
-	mac_t		fcf_mac;	/*  FCF MAC of lport		*/
+	struct mac_s	lp_mac;		/*  fpma/spma MAC for lport	*/
+	struct mac_s	fcf_mac;	/*  FCF MAC of lport		*/
 	struct bfa_reqq_wait_s	wqe;	/*  request wait queue element	*/
 	void		*uarg;		/*  user callback arg		*/
 	struct bfa_cb_qe_s hcb_qe;	/*  comp: callback qelem	*/
 	struct bfi_lps_login_rsp_s *loginrsp;
-	bfa_eproto_status_t	ext_status;
+	bfa_eproto_status_t ext_status;
 };
 
+#define BFA_FCPORT(_bfa)	(&((_bfa)->modules.port))
+
 /*
  * bfa pport API functions
  */
-bfa_status_t bfa_pport_enable(struct bfa_s *bfa);
-bfa_status_t bfa_pport_disable(struct bfa_s *bfa);
-bfa_status_t bfa_pport_cfg_speed(struct bfa_s *bfa,
+bfa_status_t bfa_fcport_enable(struct bfa_s *bfa);
+bfa_status_t bfa_fcport_disable(struct bfa_s *bfa);
+bfa_status_t bfa_fcport_cfg_speed(struct bfa_s *bfa,
 			enum bfa_pport_speed speed);
-enum bfa_pport_speed bfa_pport_get_speed(struct bfa_s *bfa);
-bfa_status_t bfa_pport_cfg_topology(struct bfa_s *bfa,
+enum bfa_pport_speed bfa_fcport_get_speed(struct bfa_s *bfa);
+bfa_status_t bfa_fcport_cfg_topology(struct bfa_s *bfa,
 			enum bfa_pport_topology topo);
-enum bfa_pport_topology bfa_pport_get_topology(struct bfa_s *bfa);
-bfa_status_t bfa_pport_cfg_hardalpa(struct bfa_s *bfa, u8 alpa);
-bfa_boolean_t bfa_pport_get_hardalpa(struct bfa_s *bfa, u8 *alpa);
-u8 bfa_pport_get_myalpa(struct bfa_s *bfa);
-bfa_status_t bfa_pport_clr_hardalpa(struct bfa_s *bfa);
-bfa_status_t bfa_pport_cfg_maxfrsize(struct bfa_s *bfa, u16 maxsize);
-u16 bfa_pport_get_maxfrsize(struct bfa_s *bfa);
-u32 bfa_pport_mypid(struct bfa_s *bfa);
-u8 bfa_pport_get_rx_bbcredit(struct bfa_s *bfa);
-bfa_status_t bfa_pport_trunk_enable(struct bfa_s *bfa, u8 bitmap);
-bfa_status_t bfa_pport_trunk_disable(struct bfa_s *bfa);
-bfa_boolean_t bfa_pport_trunk_query(struct bfa_s *bfa, u32 *bitmap);
-void bfa_pport_get_attr(struct bfa_s *bfa, struct bfa_pport_attr_s *attr);
-wwn_t bfa_pport_get_wwn(struct bfa_s *bfa, bfa_boolean_t node);
-bfa_status_t bfa_pport_get_stats(struct bfa_s *bfa,
-			union bfa_pport_stats_u *stats,
-			bfa_cb_pport_t cbfn, void *cbarg);
-bfa_status_t bfa_pport_clear_stats(struct bfa_s *bfa, bfa_cb_pport_t cbfn,
-			void *cbarg);
-void bfa_pport_event_register(struct bfa_s *bfa,
+enum bfa_pport_topology bfa_fcport_get_topology(struct bfa_s *bfa);
+bfa_status_t bfa_fcport_cfg_hardalpa(struct bfa_s *bfa, u8 alpa);
+bfa_boolean_t bfa_fcport_get_hardalpa(struct bfa_s *bfa, u8 *alpa);
+u8 bfa_fcport_get_myalpa(struct bfa_s *bfa);
+bfa_status_t bfa_fcport_clr_hardalpa(struct bfa_s *bfa);
+bfa_status_t bfa_fcport_cfg_maxfrsize(struct bfa_s *bfa, u16 maxsize);
+u16 bfa_fcport_get_maxfrsize(struct bfa_s *bfa);
+u32 bfa_fcport_mypid(struct bfa_s *bfa);
+u8 bfa_fcport_get_rx_bbcredit(struct bfa_s *bfa);
+bfa_status_t bfa_fcport_trunk_enable(struct bfa_s *bfa, u8 bitmap);
+bfa_status_t bfa_fcport_trunk_disable(struct bfa_s *bfa);
+bfa_boolean_t bfa_fcport_trunk_query(struct bfa_s *bfa, u32 *bitmap);
+void bfa_fcport_get_attr(struct bfa_s *bfa, struct bfa_pport_attr_s *attr);
+wwn_t bfa_fcport_get_wwn(struct bfa_s *bfa, bfa_boolean_t node);
+void bfa_fcport_event_register(struct bfa_s *bfa,
 			void (*event_cbfn) (void *cbarg,
 			bfa_pport_event_t event), void *event_cbarg);
-bfa_boolean_t bfa_pport_is_disabled(struct bfa_s *bfa);
-void bfa_pport_cfg_qos(struct bfa_s *bfa, bfa_boolean_t on_off);
-void bfa_pport_cfg_ratelim(struct bfa_s *bfa, bfa_boolean_t on_off);
-bfa_status_t bfa_pport_cfg_ratelim_speed(struct bfa_s *bfa,
+bfa_boolean_t bfa_fcport_is_disabled(struct bfa_s *bfa);
+void bfa_fcport_cfg_qos(struct bfa_s *bfa, bfa_boolean_t on_off);
+void bfa_fcport_cfg_ratelim(struct bfa_s *bfa, bfa_boolean_t on_off);
+bfa_status_t bfa_fcport_cfg_ratelim_speed(struct bfa_s *bfa,
 			enum bfa_pport_speed speed);
-enum bfa_pport_speed bfa_pport_get_ratelim_speed(struct bfa_s *bfa);
+enum bfa_pport_speed bfa_fcport_get_ratelim_speed(struct bfa_s *bfa);
 
-void bfa_pport_set_tx_bbcredit(struct bfa_s *bfa, u16 tx_bbcredit);
-void bfa_pport_busy(struct bfa_s *bfa, bfa_boolean_t status);
-void bfa_pport_beacon(struct bfa_s *bfa, bfa_boolean_t beacon,
+void bfa_fcport_set_tx_bbcredit(struct bfa_s *bfa, u16 tx_bbcredit);
+void bfa_fcport_busy(struct bfa_s *bfa, bfa_boolean_t status);
+void bfa_fcport_beacon(struct bfa_s *bfa, bfa_boolean_t beacon,
 			bfa_boolean_t link_e2e_beacon);
 void bfa_cb_pport_event(void *cbarg, bfa_pport_event_t event);
-void bfa_pport_qos_get_attr(struct bfa_s *bfa, struct bfa_qos_attr_s *qos_attr);
-void bfa_pport_qos_get_vc_attr(struct bfa_s *bfa,
+void bfa_fcport_qos_get_attr(struct bfa_s *bfa,
+			struct bfa_qos_attr_s *qos_attr);
+void bfa_fcport_qos_get_vc_attr(struct bfa_s *bfa,
 			struct bfa_qos_vc_attr_s *qos_vc_attr);
-bfa_status_t bfa_pport_get_qos_stats(struct bfa_s *bfa,
-			union bfa_pport_stats_u *stats,
+bfa_status_t bfa_fcport_get_qos_stats(struct bfa_s *bfa,
+			union bfa_fcport_stats_u *stats,
+			bfa_cb_pport_t cbfn, void *cbarg);
+bfa_status_t bfa_fcport_clear_qos_stats(struct bfa_s *bfa, bfa_cb_pport_t cbfn,
+			void *cbarg);
+bfa_status_t bfa_fcport_get_fcoe_stats(struct bfa_s *bfa,
+			union bfa_fcport_stats_u *stats,
 			bfa_cb_pport_t cbfn, void *cbarg);
-bfa_status_t bfa_pport_clear_qos_stats(struct bfa_s *bfa, bfa_cb_pport_t cbfn,
+bfa_status_t bfa_fcport_clear_fcoe_stats(struct bfa_s *bfa, bfa_cb_pport_t cbfn,
 			void *cbarg);
-bfa_boolean_t     bfa_pport_is_ratelim(struct bfa_s *bfa);
-bfa_boolean_t	bfa_pport_is_linkup(struct bfa_s *bfa);
+bfa_boolean_t     bfa_fcport_is_ratelim(struct bfa_s *bfa);
+bfa_boolean_t	bfa_fcport_is_linkup(struct bfa_s *bfa);
+bfa_status_t bfa_fcport_get_stats(struct bfa_s *bfa,
+		union bfa_fcport_stats_u *stats,
+		bfa_cb_pport_t cbfn, void *cbarg);
+bfa_status_t bfa_fcport_clear_stats(struct bfa_s *bfa, bfa_cb_pport_t cbfn,
+		void *cbarg);
 
 /*
  * bfa rport API functions
@@ -249,16 +258,16 @@ void *bfa_fcxp_get_rspbuf(struct bfa_fcxp_s *fcxp);
 
 void bfa_fcxp_free(struct bfa_fcxp_s *fcxp);
 
-void bfa_fcxp_send(struct bfa_fcxp_s *fcxp,
-			struct bfa_rport_s *rport, u16 vf_id, u8 lp_tag,
+void bfa_fcxp_send(struct bfa_fcxp_s *fcxp, struct bfa_rport_s *rport,
+			u16 vf_id, u8 lp_tag,
 			bfa_boolean_t cts, enum fc_cos cos,
 			u32 reqlen, struct fchs_s *fchs,
 			bfa_cb_fcxp_send_t cbfn,
 			void *cbarg,
 			u32 rsp_maxlen, u8 rsp_timeout);
 bfa_status_t bfa_fcxp_abort(struct bfa_fcxp_s *fcxp);
-u32        bfa_fcxp_get_reqbufsz(struct bfa_fcxp_s *fcxp);
-u32	bfa_fcxp_get_maxrsp(struct bfa_s *bfa);
+u32 bfa_fcxp_get_reqbufsz(struct bfa_fcxp_s *fcxp);
+u32 bfa_fcxp_get_maxrsp(struct bfa_s *bfa);
 
 static inline void *
 bfa_uf_get_frmbuf(struct bfa_uf_s *uf)
@@ -293,13 +302,15 @@ void bfa_uf_free(struct bfa_uf_s *uf);
  * bfa lport service api
  */
 
+u32 bfa_lps_get_max_vport(struct bfa_s *bfa);
 struct bfa_lps_s *bfa_lps_alloc(struct bfa_s *bfa);
 void bfa_lps_delete(struct bfa_lps_s *lps);
 void bfa_lps_discard(struct bfa_lps_s *lps);
-void bfa_lps_flogi(struct bfa_lps_s *lps, void *uarg, u8 alpa, u16 pdusz,
-		   wwn_t pwwn, wwn_t nwwn, bfa_boolean_t auth_en);
-void bfa_lps_fdisc(struct bfa_lps_s *lps, void *uarg, u16 pdusz, wwn_t pwwn,
-		   wwn_t nwwn);
+void bfa_lps_flogi(struct bfa_lps_s *lps, void *uarg, u8 alpa,
+			u16 pdusz, wwn_t pwwn, wwn_t nwwn,
+			bfa_boolean_t auth_en);
+void bfa_lps_fdisc(struct bfa_lps_s *lps, void *uarg, u16 pdusz,
+			wwn_t pwwn, wwn_t nwwn);
 void bfa_lps_flogo(struct bfa_lps_s *lps);
 void bfa_lps_fdisclogo(struct bfa_lps_s *lps);
 u8 bfa_lps_get_tag(struct bfa_lps_s *lps);
@@ -315,10 +326,11 @@ wwn_t bfa_lps_get_peer_pwwn(struct bfa_lps_s *lps);
 wwn_t bfa_lps_get_peer_nwwn(struct bfa_lps_s *lps);
 u8 bfa_lps_get_lsrjt_rsn(struct bfa_lps_s *lps);
 u8 bfa_lps_get_lsrjt_expl(struct bfa_lps_s *lps);
+struct mac_s bfa_lps_get_lp_mac(struct bfa_lps_s *lps);
 void bfa_cb_lps_flogi_comp(void *bfad, void *uarg, bfa_status_t status);
 void bfa_cb_lps_flogo_comp(void *bfad, void *uarg);
 void bfa_cb_lps_fdisc_comp(void *bfad, void *uarg, bfa_status_t status);
 void bfa_cb_lps_fdisclogo_comp(void *bfad, void *uarg);
+void bfa_cb_lps_cvl_event(void *bfad, void *uarg);
 
 #endif /* __BFA_SVC_H__ */
-
diff --git a/drivers/scsi/bfa/include/bfa_timer.h b/drivers/scsi/bfa/include/bfa_timer.h
index e407103..5972b68 100644
--- a/drivers/scsi/bfa/include/bfa_timer.h
+++ b/drivers/scsi/bfa/include/bfa_timer.h
@@ -30,8 +30,8 @@ typedef void (*bfa_timer_cbfn_t)(void *);
 struct bfa_timer_s {
 	struct list_head	qe;
 	bfa_timer_cbfn_t timercb;
-	void            *arg;
-	int             timeout;	/**< in millisecs. */
+	void		*arg;
+	int		timeout;	/**< in millisecs. */
 };
 
 /**
@@ -41,7 +41,7 @@ struct bfa_timer_mod_s {
 	struct list_head timer_q;
 };
 
-#define BFA_TIMER_FREQ 500 /**< specified in millisecs */
+#define BFA_TIMER_FREQ 200 /**< specified in millisecs */
 
 void bfa_timer_beat(struct bfa_timer_mod_s *mod);
 void bfa_timer_init(struct bfa_timer_mod_s *mod);
diff --git a/drivers/scsi/bfa/include/bfi/bfi.h b/drivers/scsi/bfa/include/bfi/bfi.h
index 7042c18..3aca92c 100644
--- a/drivers/scsi/bfa/include/bfi/bfi.h
+++ b/drivers/scsi/bfa/include/bfi/bfi.h
@@ -27,14 +27,14 @@
  * Msg header common to all msgs
  */
 struct bfi_mhdr_s {
-	u8         msg_class;	/*  @ref bfi_mclass_t	    */
-	u8         msg_id;		/*  msg opcode with in the class   */
+	u8		msg_class;	/*  @ref bfi_mclass_t		    */
+	u8		msg_id;		/*  msg opcode with in the class   */
 	union {
 		struct {
-			u8         rsvd;
-			u8         lpu_id;	/*  msg destination	    */
+			u8	rsvd;
+			u8	lpu_id;	/*  msg destination		    */
 		} h2i;
-		u16        i2htok;	/*  token in msgs to host	    */
+		u16	i2htok;	/*  token in msgs to host	    */
 	} mtag;
 };
 
@@ -71,11 +71,11 @@ struct bfi_mhdr_s {
  * SG Flags
  */
 enum {
-	BFI_SGE_DATA	= 0,	/*  data address, not last	     */
+	BFI_SGE_DATA		= 0,	/*  data address, not last	     */
 	BFI_SGE_DATA_CPL	= 1,	/*  data addr, last in current page */
 	BFI_SGE_DATA_LAST	= 3,	/*  data address, last		     */
-	BFI_SGE_LINK	= 2,	/*  link address		     */
-	BFI_SGE_PGDLEN	= 2,	/*  cumulative data length for page */
+	BFI_SGE_LINK		= 2,	/*  link address		     */
+	BFI_SGE_PGDLEN		= 2,	/*  cumulative data length for page */
 };
 
 /**
@@ -83,8 +83,8 @@ enum {
  */
 union bfi_addr_u {
 	struct {
-		u32        addr_lo;
-		u32        addr_hi;
+		u32	addr_lo;
+		u32	addr_hi;
 	} a32;
 };
 
@@ -93,11 +93,11 @@ union bfi_addr_u {
  */
 struct bfi_sge_s {
 #ifdef __BIGENDIAN
-	u32        flags:2,
+	u32	flags:2,
 			rsvd:2,
 			sg_len:28;
 #else
-	u32        sg_len:28,
+	u32	sg_len:28,
 			rsvd:2,
 			flags:2;
 #endif
@@ -143,10 +143,10 @@ enum bfi_mclass {
 	BFI_MC_IOC		= 1,	/*  IO Controller (IOC)	    */
 	BFI_MC_DIAG		= 2,	/*  Diagnostic Msgs		    */
 	BFI_MC_FLASH		= 3,	/*  Flash message class	    */
-	BFI_MC_CEE		= 4,
-	BFI_MC_FC_PORT		= 5,	/*  FC port		   	    */
+	BFI_MC_CEE		= 4,	/*  CEE			    */
+	BFI_MC_FCPORT		= 5,	/*  FC port			    */
 	BFI_MC_IOCFC		= 6,	/*  FC - IO Controller (IOC)	    */
-	BFI_MC_LL		= 7,	/*  Link Layer		 	    */
+	BFI_MC_LL		= 7,	/*  Link Layer			    */
 	BFI_MC_UF		= 8,	/*  Unsolicited frame receive	    */
 	BFI_MC_FCXP		= 9,	/*  FC Transport		    */
 	BFI_MC_LPS		= 10,	/*  lport fc login services	    */
@@ -171,4 +171,3 @@ enum bfi_mclass {
 #pragma pack()
 
 #endif /* __BFI_H__ */
-
diff --git a/drivers/scsi/bfa/include/bfi/bfi_cbreg.h b/drivers/scsi/bfa/include/bfi/bfi_cbreg.h
index b3bb52b..86ca461 100644
--- a/drivers/scsi/bfa/include/bfi/bfi_cbreg.h
+++ b/drivers/scsi/bfa/include/bfi/bfi_cbreg.h
@@ -177,6 +177,21 @@
 #define __PSS_LMEM_INIT_EN               0x00000100
 #define __PSS_LPU1_RESET                 0x00000002
 #define __PSS_LPU0_RESET                 0x00000001
+#define PSS_ERR_STATUS_REG               0x00018810
+#define __PSS_LMEM1_CORR_ERR             0x00000800
+#define __PSS_LMEM0_CORR_ERR             0x00000400
+#define __PSS_LMEM1_UNCORR_ERR           0x00000200
+#define __PSS_LMEM0_UNCORR_ERR           0x00000100
+#define __PSS_BAL_PERR                   0x00000080
+#define __PSS_DIP_IF_ERR                 0x00000040
+#define __PSS_IOH_IF_ERR                 0x00000020
+#define __PSS_TDS_IF_ERR                 0x00000010
+#define __PSS_RDS_IF_ERR                 0x00000008
+#define __PSS_SGM_IF_ERR                 0x00000004
+#define __PSS_LPU1_RAM_ERR               0x00000002
+#define __PSS_LPU0_RAM_ERR               0x00000001
+#define ERR_SET_REG                      0x00018818
+#define __PSS_ERR_STATUS_SET             0x00000fff
 
 
 /*
diff --git a/drivers/scsi/bfa/include/bfi/bfi_ctreg.h b/drivers/scsi/bfa/include/bfi/bfi_ctreg.h
index d3caa58..2ba8256 100644
--- a/drivers/scsi/bfa/include/bfi/bfi_ctreg.h
+++ b/drivers/scsi/bfa/include/bfi/bfi_ctreg.h
@@ -430,6 +430,31 @@ enum {
 #define __PSS_LMEM_INIT_EN               0x00000100
 #define __PSS_LPU1_RESET                 0x00000002
 #define __PSS_LPU0_RESET                 0x00000001
+#define PSS_ERR_STATUS_REG               0x00018810
+#define __PSS_LPU1_TCM_READ_ERR          0x00200000
+#define __PSS_LPU0_TCM_READ_ERR          0x00100000
+#define __PSS_LMEM5_CORR_ERR             0x00080000
+#define __PSS_LMEM4_CORR_ERR             0x00040000
+#define __PSS_LMEM3_CORR_ERR             0x00020000
+#define __PSS_LMEM2_CORR_ERR             0x00010000
+#define __PSS_LMEM1_CORR_ERR             0x00008000
+#define __PSS_LMEM0_CORR_ERR             0x00004000
+#define __PSS_LMEM5_UNCORR_ERR           0x00002000
+#define __PSS_LMEM4_UNCORR_ERR           0x00001000
+#define __PSS_LMEM3_UNCORR_ERR           0x00000800
+#define __PSS_LMEM2_UNCORR_ERR           0x00000400
+#define __PSS_LMEM1_UNCORR_ERR           0x00000200
+#define __PSS_LMEM0_UNCORR_ERR           0x00000100
+#define __PSS_BAL_PERR                   0x00000080
+#define __PSS_DIP_IF_ERR                 0x00000040
+#define __PSS_IOH_IF_ERR                 0x00000020
+#define __PSS_TDS_IF_ERR                 0x00000010
+#define __PSS_RDS_IF_ERR                 0x00000008
+#define __PSS_SGM_IF_ERR                 0x00000004
+#define __PSS_LPU1_RAM_ERR               0x00000002
+#define __PSS_LPU0_RAM_ERR               0x00000001
+#define ERR_SET_REG                      0x00018818
+#define __PSS_ERR_STATUS_SET             0x003fffff
 #define HQM_QSET0_RXQ_DRBL_P0            0x00038000
 #define __RXQ0_ADD_VECTORS_P             0x80000000
 #define __RXQ0_STOP_P                    0x40000000
@@ -516,29 +541,29 @@ enum {
 #define RME_CI_PTR_Q(__n) \
 	(RME_CI_PTR_Q0 + (__n) * (RME_CI_PTR_Q1 - RME_CI_PTR_Q0))
 #define HQM_QSET_RXQ_DRBL_P0(__n) \
-	(HQM_QSET0_RXQ_DRBL_P0 + (__n) * (HQM_QSET1_RXQ_DRBL_P0 - \
-	HQM_QSET0_RXQ_DRBL_P0))
+	(HQM_QSET0_RXQ_DRBL_P0 +  \
+		(__n) * (HQM_QSET1_RXQ_DRBL_P0 - HQM_QSET0_RXQ_DRBL_P0))
 #define HQM_QSET_TXQ_DRBL_P0(__n) \
-	(HQM_QSET0_TXQ_DRBL_P0 + (__n) * (HQM_QSET1_TXQ_DRBL_P0 - \
-	HQM_QSET0_TXQ_DRBL_P0))
+	(HQM_QSET0_TXQ_DRBL_P0 +  \
+		(__n) * (HQM_QSET1_TXQ_DRBL_P0 - HQM_QSET0_TXQ_DRBL_P0))
 #define HQM_QSET_IB_DRBL_1_P0(__n) \
-	(HQM_QSET0_IB_DRBL_1_P0 + (__n) * (HQM_QSET1_IB_DRBL_1_P0 - \
-	HQM_QSET0_IB_DRBL_1_P0))
+	(HQM_QSET0_IB_DRBL_1_P0 +  \
+		(__n) * (HQM_QSET1_IB_DRBL_1_P0 - HQM_QSET0_IB_DRBL_1_P0))
 #define HQM_QSET_IB_DRBL_2_P0(__n) \
-	(HQM_QSET0_IB_DRBL_2_P0 + (__n) * (HQM_QSET1_IB_DRBL_2_P0 - \
-	HQM_QSET0_IB_DRBL_2_P0))
+	(HQM_QSET0_IB_DRBL_2_P0 +  \
+		(__n) * (HQM_QSET1_IB_DRBL_2_P0 - HQM_QSET0_IB_DRBL_2_P0))
 #define HQM_QSET_RXQ_DRBL_P1(__n) \
-	(HQM_QSET0_RXQ_DRBL_P1 + (__n) * (HQM_QSET1_RXQ_DRBL_P1 - \
-	HQM_QSET0_RXQ_DRBL_P1))
+	(HQM_QSET0_RXQ_DRBL_P1 +  \
+		(__n) * (HQM_QSET1_RXQ_DRBL_P1 - HQM_QSET0_RXQ_DRBL_P1))
 #define HQM_QSET_TXQ_DRBL_P1(__n) \
-	(HQM_QSET0_TXQ_DRBL_P1 + (__n) * (HQM_QSET1_TXQ_DRBL_P1 - \
-	HQM_QSET0_TXQ_DRBL_P1))
+	(HQM_QSET0_TXQ_DRBL_P1 +  \
+		(__n) * (HQM_QSET1_TXQ_DRBL_P1 - HQM_QSET0_TXQ_DRBL_P1))
 #define HQM_QSET_IB_DRBL_1_P1(__n) \
-	(HQM_QSET0_IB_DRBL_1_P1 + (__n) * (HQM_QSET1_IB_DRBL_1_P1 - \
-	HQM_QSET0_IB_DRBL_1_P1))
+	(HQM_QSET0_IB_DRBL_1_P1 +  \
+		(__n) * (HQM_QSET1_IB_DRBL_1_P1 - HQM_QSET0_IB_DRBL_1_P1))
 #define HQM_QSET_IB_DRBL_2_P1(__n) \
-	(HQM_QSET0_IB_DRBL_2_P1 + (__n) * (HQM_QSET1_IB_DRBL_2_P1 - \
-	HQM_QSET0_IB_DRBL_2_P1))
+	(HQM_QSET0_IB_DRBL_2_P1 +  \
+		(__n) * (HQM_QSET1_IB_DRBL_2_P1 - HQM_QSET0_IB_DRBL_2_P1))
 
 #define CPE_Q_NUM(__fn, __q)  (((__fn) << 2) + (__q))
 #define RME_Q_NUM(__fn, __q)  (((__fn) << 2) + (__q))
@@ -589,6 +614,7 @@ enum {
 #define __HFN_INT_MBOX_LPU1                0x00200000U
 #define __HFN_INT_MBOX1_LPU0               0x00400000U
 #define __HFN_INT_MBOX1_LPU1               0x00800000U
+#define __HFN_INT_LL_HALT                  0x01000000U
 #define __HFN_INT_CPE_MASK                 0x000000ffU
 #define __HFN_INT_RME_MASK                 0x0000ff00U
 
diff --git a/drivers/scsi/bfa/include/bfi/bfi_ioc.h b/drivers/scsi/bfa/include/bfi/bfi_ioc.h
index 96ef056..b933217 100644
--- a/drivers/scsi/bfa/include/bfi/bfi_ioc.h
+++ b/drivers/scsi/bfa/include/bfi/bfi_ioc.h
@@ -24,11 +24,11 @@
 #pragma pack(1)
 
 enum bfi_ioc_h2i_msgs {
-	BFI_IOC_H2I_ENABLE_REQ 		= 1,
-	BFI_IOC_H2I_DISABLE_REQ 	= 2,
-	BFI_IOC_H2I_GETATTR_REQ 	= 3,
-	BFI_IOC_H2I_DBG_SYNC	 	= 4,
-	BFI_IOC_H2I_DBG_DUMP	 	= 5,
+	BFI_IOC_H2I_ENABLE_REQ		= 1,
+	BFI_IOC_H2I_DISABLE_REQ		= 2,
+	BFI_IOC_H2I_GETATTR_REQ		= 3,
+	BFI_IOC_H2I_DBG_SYNC		= 4,
+	BFI_IOC_H2I_DBG_DUMP		= 5,
 };
 
 enum bfi_ioc_i2h_msgs {
@@ -48,30 +48,30 @@ struct bfi_ioc_getattr_req_s {
 };
 
 struct bfi_ioc_attr_s {
-	wwn_t           mfg_wwn;
-	mac_t		mfg_mac;
+	wwn_t		mfg_wwn;
+	struct mac_s	mfg_mac;
 	u16	rsvd_a;
-	char            brcd_serialnum[STRSZ(BFA_MFG_SERIALNUM_SIZE)];
-	u8         pcie_gen;
-	u8         pcie_lanes_orig;
-	u8         pcie_lanes;
-	u8         rx_bbcredit;	/*  receive buffer credits */
-	u32        adapter_prop;	/*  adapter properties     */
-	u16        maxfrsize;	/*  max receive frame size */
-	char         	asic_rev;
-	u8         rsvd_b;
-	char            fw_version[BFA_VERSION_LEN];
-	char            optrom_version[BFA_VERSION_LEN];
-	struct bfa_mfg_vpd_s	vpd;
+	char		brcd_serialnum[STRSZ(BFA_MFG_SERIALNUM_SIZE)];
+	u8		pcie_gen;
+	u8		pcie_lanes_orig;
+	u8		pcie_lanes;
+	u8		rx_bbcredit;	/*  receive buffer credits */
+	u32	adapter_prop;	/*  adapter properties     */
+	u16	maxfrsize;	/*  max receive frame size */
+	char		asic_rev;
+	u8		rsvd_b;
+	char		fw_version[BFA_VERSION_LEN];
+	char		optrom_version[BFA_VERSION_LEN];
+	struct		bfa_mfg_vpd_s	vpd;
 };
 
 /**
  * BFI_IOC_I2H_GETATTR_REPLY message
  */
 struct bfi_ioc_getattr_reply_s {
-	struct bfi_mhdr_s  mh;		/*  Common msg header          */
-	u8		status;	/*  cfg reply status           */
-	u8		rsvd[3];
+	struct	bfi_mhdr_s	mh;	/*  Common msg header		*/
+	u8			status;	/*  cfg reply status		*/
+	u8			rsvd[3];
 };
 
 /**
@@ -89,21 +89,21 @@ struct bfi_ioc_getattr_reply_s {
 #define BFI_IOC_FW_SIGNATURE	(0xbfadbfad)
 #define BFI_IOC_MD5SUM_SZ	4
 struct bfi_ioc_image_hdr_s {
-	u32        signature;	/*  constant signature */
-	u32        rsvd_a;
-	u32        exec;		/*  exec vector        */
-	u32        param;		/*  parameters         */
-	u32        rsvd_b[4];
-	u32        md5sum[BFI_IOC_MD5SUM_SZ];
+	u32	signature;	/*  constant signature */
+	u32	rsvd_a;
+	u32	exec;		/*  exec vector	*/
+	u32	param;		/*  parameters		*/
+	u32	rsvd_b[4];
+	u32	md5sum[BFI_IOC_MD5SUM_SZ];
 };
 
 /**
  *  BFI_IOC_I2H_READY_EVENT message
  */
 struct bfi_ioc_rdy_event_s {
-	struct bfi_mhdr_s  mh;			/*  common msg header */
-	u8         init_status;	/*  init event status */
-	u8         rsvd[3];
+	struct bfi_mhdr_s	mh;		/*  common msg header */
+	u8			init_status;	/*  init event status */
+	u8			rsvd[3];
 };
 
 struct bfi_ioc_hbeat_s {
@@ -115,46 +115,46 @@ struct bfi_ioc_hbeat_s {
  * IOC hardware/firmware state
  */
 enum bfi_ioc_state {
-	BFI_IOC_UNINIT 	 = 0,		/*  not initialized                 */
-	BFI_IOC_INITING 	 = 1,	/*  h/w is being initialized        */
-	BFI_IOC_HWINIT 	 = 2,		/*  h/w is initialized              */
-	BFI_IOC_CFG 	 = 3,		/*  IOC configuration in progress   */
-	BFI_IOC_OP 		 = 4,	/*  IOC is operational              */
-	BFI_IOC_DISABLING 	 = 5,	/*  IOC is being disabled           */
-	BFI_IOC_DISABLED 	 = 6,	/*  IOC is disabled                 */
-	BFI_IOC_CFG_DISABLED = 7,	/*  IOC is being disabled;transient */
-	BFI_IOC_HBFAIL       = 8,	/*  IOC heart-beat failure          */
-	BFI_IOC_MEMTEST      = 9,	/*  IOC is doing memtest            */
+	BFI_IOC_UNINIT		= 0,	/*  not initialized		     */
+	BFI_IOC_INITING		= 1,	/*  h/w is being initialized	     */
+	BFI_IOC_HWINIT		= 2,	/*  h/w is initialized		     */
+	BFI_IOC_CFG		= 3,	/*  IOC configuration in progress   */
+	BFI_IOC_OP		= 4,	/*  IOC is operational		     */
+	BFI_IOC_DISABLING	= 5,	/*  IOC is being disabled	     */
+	BFI_IOC_DISABLED	= 6,	/*  IOC is disabled		     */
+	BFI_IOC_CFG_DISABLED	= 7,	/*  IOC is being disabled;transient */
+	BFI_IOC_FAIL		= 8,	/*  IOC heart-beat failure	     */
+	BFI_IOC_MEMTEST		= 9,	/*  IOC is doing memtest	     */
 };
 
 #define BFI_IOC_ENDIAN_SIG  0x12345678
 
 enum {
-	BFI_ADAPTER_TYPE_FC   = 0x01,		/*  FC adapters           */
-	BFI_ADAPTER_TYPE_MK   = 0x0f0000,	/*  adapter type mask     */
-	BFI_ADAPTER_TYPE_SH   = 16,	        /*  adapter type shift    */
-	BFI_ADAPTER_NPORTS_MK = 0xff00,		/*  number of ports mask  */
-	BFI_ADAPTER_NPORTS_SH = 8,	        /*  number of ports shift */
-	BFI_ADAPTER_SPEED_MK  = 0xff,		/*  adapter speed mask    */
-	BFI_ADAPTER_SPEED_SH  = 0,	        /*  adapter speed shift   */
-	BFI_ADAPTER_PROTO     = 0x100000,	/*  prototype adapaters   */
-	BFI_ADAPTER_TTV       = 0x200000,	/*  TTV debug capable     */
-	BFI_ADAPTER_UNSUPP    = 0x400000,	/*  unknown adapter type  */
+	BFI_ADAPTER_TYPE_FC	= 0x01,		/*  FC adapters	   */
+	BFI_ADAPTER_TYPE_MK	= 0x0f0000,	/*  adapter type mask     */
+	BFI_ADAPTER_TYPE_SH	= 16,	        /*  adapter type shift    */
+	BFI_ADAPTER_NPORTS_MK	= 0xff00,	/*  number of ports mask  */
+	BFI_ADAPTER_NPORTS_SH	= 8,	        /*  number of ports shift */
+	BFI_ADAPTER_SPEED_MK	= 0xff,		/*  adapter speed mask    */
+	BFI_ADAPTER_SPEED_SH	= 0,	        /*  adapter speed shift   */
+	BFI_ADAPTER_PROTO	= 0x100000,	/*  prototype adapaters   */
+	BFI_ADAPTER_TTV		= 0x200000,	/*  TTV debug capable     */
+	BFI_ADAPTER_UNSUPP	= 0x400000,	/*  unknown adapter type  */
 };
 
-#define BFI_ADAPTER_GETP(__prop, __adap_prop)          		\
-    (((__adap_prop) & BFI_ADAPTER_ ## __prop ## _MK) >>         \
-     BFI_ADAPTER_ ## __prop ## _SH)
-#define BFI_ADAPTER_SETP(__prop, __val)         		\
-    ((__val) << BFI_ADAPTER_ ## __prop ## _SH)
-#define BFI_ADAPTER_IS_PROTO(__adap_type)   			\
-    ((__adap_type) & BFI_ADAPTER_PROTO)
-#define BFI_ADAPTER_IS_TTV(__adap_type)     			\
-    ((__adap_type) & BFI_ADAPTER_TTV)
-#define BFI_ADAPTER_IS_UNSUPP(__adap_type)  			\
-    ((__adap_type) & BFI_ADAPTER_UNSUPP)
-#define BFI_ADAPTER_IS_SPECIAL(__adap_type)                     \
-    ((__adap_type) & (BFI_ADAPTER_TTV | BFI_ADAPTER_PROTO |     \
+#define BFI_ADAPTER_GETP(__prop, __adap_prop)			\
+	(((__adap_prop) & BFI_ADAPTER_ ## __prop ## _MK) >>	\
+		BFI_ADAPTER_ ## __prop ## _SH)
+#define BFI_ADAPTER_SETP(__prop, __val)				\
+	((__val) << BFI_ADAPTER_ ## __prop ## _SH)
+#define BFI_ADAPTER_IS_PROTO(__adap_type)			\
+	((__adap_type) & BFI_ADAPTER_PROTO)
+#define BFI_ADAPTER_IS_TTV(__adap_type)				\
+	((__adap_type) & BFI_ADAPTER_TTV)
+#define BFI_ADAPTER_IS_UNSUPP(__adap_type)			\
+	((__adap_type) & BFI_ADAPTER_UNSUPP)
+#define BFI_ADAPTER_IS_SPECIAL(__adap_type)			\
+	((__adap_type) & (BFI_ADAPTER_TTV | BFI_ADAPTER_PROTO |	\
 			BFI_ADAPTER_UNSUPP))
 
 /**
@@ -163,16 +163,16 @@ enum {
 struct bfi_ioc_ctrl_req_s {
 	struct bfi_mhdr_s	mh;
 	u8			ioc_class;
-	u8         	rsvd[3];
+	u8			rsvd[3];
 };
 
 /**
  * BFI_IOC_I2H_ENABLE_REPLY & BFI_IOC_I2H_DISABLE_REPLY messages
  */
 struct bfi_ioc_ctrl_reply_s {
-	struct bfi_mhdr_s  mh;		/*  Common msg header     */
-	u8         status;		/*  enable/disable status */
-	u8         rsvd[3];
+	struct bfi_mhdr_s	mh;		/*  Common msg header     */
+	u8			status;		/*  enable/disable status */
+	u8			rsvd[3];
 };
 
 #define BFI_IOC_MSGSZ   8
@@ -180,23 +180,22 @@ struct bfi_ioc_ctrl_reply_s {
  * H2I Messages
  */
 union bfi_ioc_h2i_msg_u {
-	struct bfi_mhdr_s 	mh;
-	struct bfi_ioc_ctrl_req_s enable_req;
-	struct bfi_ioc_ctrl_req_s disable_req;
-	struct bfi_ioc_getattr_req_s getattr_req;
-	u32       		mboxmsg[BFI_IOC_MSGSZ];
+	struct bfi_mhdr_s 		mh;
+	struct bfi_ioc_ctrl_req_s	enable_req;
+	struct bfi_ioc_ctrl_req_s	disable_req;
+	struct bfi_ioc_getattr_req_s	getattr_req;
+	u32			mboxmsg[BFI_IOC_MSGSZ];
 };
 
 /**
  * I2H Messages
  */
 union bfi_ioc_i2h_msg_u {
-	struct bfi_mhdr_s      	mh;
+	struct bfi_mhdr_s		mh;
 	struct bfi_ioc_rdy_event_s 	rdy_event;
-	u32       		mboxmsg[BFI_IOC_MSGSZ];
+	u32			mboxmsg[BFI_IOC_MSGSZ];
 };
 
 #pragma pack()
 
 #endif /* __BFI_IOC_H__ */
-
diff --git a/drivers/scsi/bfa/include/bfi/bfi_lps.h b/drivers/scsi/bfa/include/bfi/bfi_lps.h
index c59d47b..1214899 100644
--- a/drivers/scsi/bfa/include/bfi/bfi_lps.h
+++ b/drivers/scsi/bfa/include/bfi/bfi_lps.h
@@ -30,6 +30,7 @@ enum bfi_lps_h2i_msgs {
 enum bfi_lps_i2h_msgs {
 	BFI_LPS_H2I_LOGIN_RSP	= BFA_I2HM(1),
 	BFI_LPS_H2I_LOGOUT_RSP	= BFA_I2HM(2),
+	BFI_LPS_H2I_CVL_EVENT	= BFA_I2HM(3),
 };
 
 struct bfi_lps_login_req_s {
@@ -57,8 +58,8 @@ struct bfi_lps_login_rsp_s {
 	u8		npiv_en;
 	u32	lp_pid:24;
 	u32	auth_req:8;
-	mac_t		lp_mac;
-	mac_t		fcf_mac;
+	struct mac_s	lp_mac;
+	struct mac_s	fcf_mac;
 	u8		ext_status;
 	u8  	brcd_switch;/*  attached peer is brcd switch	*/
 };
@@ -77,6 +78,12 @@ struct bfi_lps_logout_rsp_s {
 	u8		rsvd[2];
 };
 
+struct bfi_lps_cvl_event_s {
+	struct bfi_mhdr_s  mh;		/*  common msg header		*/
+	u8		lp_tag;
+	u8		rsvd[3];
+};
+
 union bfi_lps_h2i_msg_u {
 	struct bfi_mhdr_s		*msg;
 	struct bfi_lps_login_req_s	*login_req;
@@ -87,6 +94,7 @@ union bfi_lps_i2h_msg_u {
 	struct bfi_msg_s		*msg;
 	struct bfi_lps_login_rsp_s	*login_rsp;
 	struct bfi_lps_logout_rsp_s	*logout_rsp;
+	struct bfi_lps_cvl_event_s	*cvl_event;
 };
 
 #pragma pack()
diff --git a/drivers/scsi/bfa/include/bfi/bfi_pport.h b/drivers/scsi/bfa/include/bfi/bfi_pport.h
index c96d246..50dcf45 100644
--- a/drivers/scsi/bfa/include/bfi/bfi_pport.h
+++ b/drivers/scsi/bfa/include/bfi/bfi_pport.h
@@ -22,163 +22,97 @@
 
 #pragma pack(1)
 
-enum bfi_pport_h2i {
-	BFI_PPORT_H2I_ENABLE_REQ		= (1),
-	BFI_PPORT_H2I_DISABLE_REQ		= (2),
-	BFI_PPORT_H2I_GET_STATS_REQ		= (3),
-	BFI_PPORT_H2I_CLEAR_STATS_REQ	= (4),
-	BFI_PPORT_H2I_SET_SVC_PARAMS_REQ	= (5),
-	BFI_PPORT_H2I_ENABLE_RX_VF_TAG_REQ	= (6),
-	BFI_PPORT_H2I_ENABLE_TX_VF_TAG_REQ	= (7),
-	BFI_PPORT_H2I_GET_QOS_STATS_REQ		= (8),
-	BFI_PPORT_H2I_CLEAR_QOS_STATS_REQ	= (9),
+enum bfi_fcport_h2i {
+	BFI_FCPORT_H2I_ENABLE_REQ		= (1),
+	BFI_FCPORT_H2I_DISABLE_REQ		= (2),
+	BFI_FCPORT_H2I_SET_SVC_PARAMS_REQ	= (3),
+	BFI_FCPORT_H2I_STATS_GET_REQ		= (4),
+	BFI_FCPORT_H2I_STATS_CLEAR_REQ		= (5),
 };
 
-enum bfi_pport_i2h {
-	BFI_PPORT_I2H_ENABLE_RSP		= BFA_I2HM(1),
-	BFI_PPORT_I2H_DISABLE_RSP		= BFA_I2HM(2),
-	BFI_PPORT_I2H_GET_STATS_RSP		= BFA_I2HM(3),
-	BFI_PPORT_I2H_CLEAR_STATS_RSP	= BFA_I2HM(4),
-	BFI_PPORT_I2H_SET_SVC_PARAMS_RSP	= BFA_I2HM(5),
-	BFI_PPORT_I2H_ENABLE_RX_VF_TAG_RSP	= BFA_I2HM(6),
-	BFI_PPORT_I2H_ENABLE_TX_VF_TAG_RSP	= BFA_I2HM(7),
-	BFI_PPORT_I2H_EVENT			= BFA_I2HM(8),
-	BFI_PPORT_I2H_GET_QOS_STATS_RSP		= BFA_I2HM(9),
-	BFI_PPORT_I2H_CLEAR_QOS_STATS_RSP	= BFA_I2HM(10),
+enum bfi_fcport_i2h {
+	BFI_FCPORT_I2H_ENABLE_RSP		= BFA_I2HM(1),
+	BFI_FCPORT_I2H_DISABLE_RSP		= BFA_I2HM(2),
+	BFI_FCPORT_I2H_SET_SVC_PARAMS_RSP	= BFA_I2HM(3),
+	BFI_FCPORT_I2H_STATS_GET_RSP		= BFA_I2HM(4),
+	BFI_FCPORT_I2H_STATS_CLEAR_RSP		= BFA_I2HM(5),
+	BFI_FCPORT_I2H_EVENT			= BFA_I2HM(6),
 };
 
 /**
  * Generic REQ type
  */
-struct bfi_pport_generic_req_s {
+struct bfi_fcport_req_s {
 	struct bfi_mhdr_s  mh;		/*  msg header			    */
-	u32        msgtag;		/*  msgtag for reply		    */
+	u32	   msgtag;	/*  msgtag for reply		    */
 };
 
 /**
  * Generic RSP type
  */
-struct bfi_pport_generic_rsp_s {
+struct bfi_fcport_rsp_s {
 	struct bfi_mhdr_s  mh;		/*  common msg header		    */
-	u8         status;		/*  port enable status		    */
-	u8         rsvd[3];
-	u32        msgtag;		/*  msgtag for reply		    */
+	u8		   status;	/*  port enable status		    */
+	u8		   rsvd[3];
+	u32	   msgtag;	/*  msgtag for reply		    */
 };
 
 /**
- * BFI_PPORT_H2I_ENABLE_REQ
+ * BFI_FCPORT_H2I_ENABLE_REQ
  */
-struct bfi_pport_enable_req_s {
+struct bfi_fcport_enable_req_s {
 	struct bfi_mhdr_s  mh;		/*  msg header			    */
-	u32        rsvd1;
-	wwn_t           nwwn;		/*  node wwn of physical port	    */
-	wwn_t           pwwn;		/*  port wwn of physical port	    */
-	struct bfa_pport_cfg_s port_cfg;	/*  port configuration	    */
-	union bfi_addr_u  stats_dma_addr;	/*  DMA address for stats  */
-	u32        msgtag;		/*  msgtag for reply		    */
-	u32        rsvd2;
+	u32	   rsvd1;
+	wwn_t		   nwwn;	/*  node wwn of physical port	    */
+	wwn_t		   pwwn;	/*  port wwn of physical port	    */
+	struct bfa_pport_cfg_s port_cfg; /*  port configuration	    */
+	union bfi_addr_u   stats_dma_addr; /*  DMA address for stats	    */
+	u32	   msgtag;	/*  msgtag for reply		    */
+	u32	   rsvd2;
 };
 
 /**
- * BFI_PPORT_I2H_ENABLE_RSP
+ * BFI_FCPORT_H2I_SET_SVC_PARAMS_REQ
  */
-#define bfi_pport_enable_rsp_t struct bfi_pport_generic_rsp_s
-
-/**
- * BFI_PPORT_H2I_DISABLE_REQ
- */
-#define bfi_pport_disable_req_t struct bfi_pport_generic_req_s
-
-/**
- * BFI_PPORT_I2H_DISABLE_RSP
- */
-#define bfi_pport_disable_rsp_t struct bfi_pport_generic_rsp_s
-
-/**
- * BFI_PPORT_H2I_GET_STATS_REQ
- */
-#define bfi_pport_get_stats_req_t struct bfi_pport_generic_req_s
-
-/**
- * BFI_PPORT_I2H_GET_STATS_RSP
- */
-#define bfi_pport_get_stats_rsp_t struct bfi_pport_generic_rsp_s
-
-/**
- * BFI_PPORT_H2I_CLEAR_STATS_REQ
- */
-#define bfi_pport_clear_stats_req_t struct bfi_pport_generic_req_s
-
-/**
- * BFI_PPORT_I2H_CLEAR_STATS_RSP
- */
-#define bfi_pport_clear_stats_rsp_t struct bfi_pport_generic_rsp_s
-
-/**
- * BFI_PPORT_H2I_GET_QOS_STATS_REQ
- */
-#define bfi_pport_get_qos_stats_req_t struct bfi_pport_generic_req_s
-
-/**
- * BFI_PPORT_H2I_GET_QOS_STATS_RSP
- */
-#define bfi_pport_get_qos_stats_rsp_t struct bfi_pport_generic_rsp_s
-
-/**
- * BFI_PPORT_H2I_CLEAR_QOS_STATS_REQ
- */
-#define bfi_pport_clear_qos_stats_req_t struct bfi_pport_generic_req_s
-
-/**
- * BFI_PPORT_H2I_CLEAR_QOS_STATS_RSP
- */
-#define bfi_pport_clear_qos_stats_rsp_t struct bfi_pport_generic_rsp_s
-
-/**
- * BFI_PPORT_H2I_SET_SVC_PARAMS_REQ
- */
-struct bfi_pport_set_svc_params_req_s {
+struct bfi_fcport_set_svc_params_req_s {
 	struct bfi_mhdr_s  mh;		/*  msg header */
-	u16        tx_bbcredit;	/*  Tx credits */
-	u16        rsvd;
+	u16	   tx_bbcredit;	/*  Tx credits */
+	u16	   rsvd;
 };
 
 /**
- * BFI_PPORT_I2H_SET_SVC_PARAMS_RSP
- */
-
-/**
- * BFI_PPORT_I2H_EVENT
+ * BFI_FCPORT_I2H_EVENT
  */
-struct bfi_pport_event_s {
+struct bfi_fcport_event_s {
 	struct bfi_mhdr_s 	mh;	/*  common msg header */
 	struct bfa_pport_link_s	link_state;
 };
 
-union bfi_pport_h2i_msg_u {
+/**
+ * fcport H2I message
+ */
+union bfi_fcport_h2i_msg_u {
 	struct bfi_mhdr_s			*mhdr;
-	struct bfi_pport_enable_req_s		*penable;
-	struct bfi_pport_generic_req_s		*pdisable;
-	struct bfi_pport_generic_req_s		*pgetstats;
-	struct bfi_pport_generic_req_s		*pclearstats;
-	struct bfi_pport_set_svc_params_req_s	*psetsvcparams;
-	struct bfi_pport_get_qos_stats_req_s	*pgetqosstats;
-	struct bfi_pport_generic_req_s		*pclearqosstats;
+	struct bfi_fcport_enable_req_s		*penable;
+	struct bfi_fcport_req_s			*pdisable;
+	struct bfi_fcport_set_svc_params_req_s	*psetsvcparams;
+	struct bfi_fcport_req_s			*pstatsget;
+	struct bfi_fcport_req_s			*pstatsclear;
 };
 
-union bfi_pport_i2h_msg_u {
+/**
+ * fcport I2H message
+ */
+union bfi_fcport_i2h_msg_u {
 	struct bfi_msg_s			*msg;
-	struct bfi_pport_generic_rsp_s		*enable_rsp;
-	struct bfi_pport_disable_rsp_s		*disable_rsp;
-	struct bfi_pport_generic_rsp_s		*getstats_rsp;
-	struct bfi_pport_clear_stats_rsp_s	*clearstats_rsp;
-	struct bfi_pport_set_svc_params_rsp_s	*setsvcparasm_rsp;
-	struct bfi_pport_get_qos_stats_rsp_s	*getqosstats_rsp;
-	struct bfi_pport_clear_qos_stats_rsp_s	*clearqosstats_rsp;
-	struct bfi_pport_event_s		*event;
+	struct bfi_fcport_rsp_s			*penable_rsp;
+	struct bfi_fcport_rsp_s			*pdisable_rsp;
+	struct bfi_fcport_rsp_s			*psetsvcparams_rsp;
+	struct bfi_fcport_rsp_s			*pstatsget_rsp;
+	struct bfi_fcport_rsp_s			*pstatsclear_rsp;
+	struct bfi_fcport_event_s		*event;
 };
 
 #pragma pack()
 
 #endif /* __BFI_PPORT_H__ */
-
diff --git a/drivers/scsi/bfa/include/cna/bfa_cna_trcmod.h b/drivers/scsi/bfa/include/cna/bfa_cna_trcmod.h
index 43ba706..d74fad4 100644
--- a/drivers/scsi/bfa/include/cna/bfa_cna_trcmod.h
+++ b/drivers/scsi/bfa/include/cna/bfa_cna_trcmod.h
@@ -31,6 +31,10 @@
 enum {
 	BFA_TRC_CNA_CEE		= 1,
 	BFA_TRC_CNA_PORT	= 2,
+	BFA_TRC_CNA_IOC		= 3,
+	BFA_TRC_CNA_DIAG	= 4,
+	BFA_TRC_CNA_IOC_CB	= 5,
+	BFA_TRC_CNA_IOC_CT	= 6,
 };
 
 #endif /* __BFA_CNA_TRCMOD_H__ */
diff --git a/drivers/scsi/bfa/include/cna/cee/bfa_cee.h b/drivers/scsi/bfa/include/cna/cee/bfa_cee.h
index 77f297f..bd76dd3 100644
--- a/drivers/scsi/bfa/include/cna/cee/bfa_cee.h
+++ b/drivers/scsi/bfa/include/cna/cee/bfa_cee.h
@@ -61,17 +61,15 @@ struct bfa_cee_s {
 
 u32 bfa_cee_meminfo(void);
 void bfa_cee_mem_claim(struct bfa_cee_s *cee, u8 *dma_kva,
-			 u64 dma_pa);
+    u64 dma_pa);
 void bfa_cee_attach(struct bfa_cee_s *cee, struct bfa_ioc_s *ioc, void *dev,
-			struct bfa_trc_mod_s *trcmod,
-			struct bfa_log_mod_s *logmod);
+    struct bfa_trc_mod_s *trcmod, struct bfa_log_mod_s *logmod);
 void bfa_cee_detach(struct bfa_cee_s *cee);
 bfa_status_t bfa_cee_get_attr(struct bfa_cee_s *cee,
-			 struct bfa_cee_attr_s *attr,
-			bfa_cee_get_attr_cbfn_t cbfn, void *cbarg);
+    struct bfa_cee_attr_s *attr, bfa_cee_get_attr_cbfn_t cbfn, void *cbarg);
 bfa_status_t bfa_cee_get_stats(struct bfa_cee_s *cee,
-			struct bfa_cee_stats_s *stats,
-			bfa_cee_get_stats_cbfn_t cbfn, void *cbarg);
+    struct bfa_cee_stats_s *stats, bfa_cee_get_stats_cbfn_t cbfn, void *cbarg);
 bfa_status_t bfa_cee_reset_stats(struct bfa_cee_s *cee,
-			bfa_cee_reset_stats_cbfn_t cbfn, void *cbarg);
+    bfa_cee_reset_stats_cbfn_t cbfn, void *cbarg);
+
 #endif /* __BFA_CEE_H__ */
diff --git a/drivers/scsi/bfa/include/cna/port/bfa_port.h b/drivers/scsi/bfa/include/cna/port/bfa_port.h
index 7cbf17d..18ef82f 100644
--- a/drivers/scsi/bfa/include/cna/port/bfa_port.h
+++ b/drivers/scsi/bfa/include/cna/port/bfa_port.h
@@ -23,47 +23,47 @@
 #include <cs/bfa_trc.h>
 #include <cs/bfa_log.h>
 
-typedef void    (*bfa_port_stats_cbfn_t) (void *dev, bfa_status_t status);
-typedef void    (*bfa_port_endis_cbfn_t) (void *dev, bfa_status_t status);
+typedef void (*bfa_port_stats_cbfn_t) (void *dev, bfa_status_t status);
+typedef void (*bfa_port_endis_cbfn_t) (void *dev, bfa_status_t status);
 
 struct bfa_port_s {
-	void           *dev;
-	struct bfa_ioc_s *ioc;
-	struct bfa_trc_mod_s *trcmod;
-	struct bfa_log_mod_s *logmod;
-	u32        msgtag;
-	bfa_boolean_t   stats_busy;
-	struct bfa_mbox_cmd_s stats_mb;
-	bfa_port_stats_cbfn_t stats_cbfn;
-	void           *stats_cbarg;
-	bfa_status_t    stats_status;
-	union bfa_pport_stats_u *stats;
-	struct bfa_dma_s stats_dma;
-	bfa_boolean_t   endis_pending;
-	struct bfa_mbox_cmd_s endis_mb;
-	bfa_port_endis_cbfn_t endis_cbfn;
-	void           *endis_cbarg;
-	bfa_status_t    endis_status;
-	struct bfa_ioc_hbfail_notify_s hbfail;
+	void				*dev;
+	struct bfa_ioc_s		*ioc;
+	struct bfa_trc_mod_s 		*trcmod;
+	struct bfa_log_mod_s		*logmod;
+	u32			msgtag;
+	bfa_boolean_t			stats_busy;
+	struct bfa_mbox_cmd_s 		stats_mb;
+	bfa_port_stats_cbfn_t		stats_cbfn;
+	void				*stats_cbarg;
+	bfa_status_t			stats_status;
+	union bfa_pport_stats_u		*stats;
+	struct bfa_dma_s		stats_dma;
+	bfa_boolean_t			endis_pending;
+	struct bfa_mbox_cmd_s		endis_mb;
+	bfa_port_endis_cbfn_t		endis_cbfn;
+	void				*endis_cbarg;
+	bfa_status_t			endis_status;
+	struct bfa_ioc_hbfail_notify_s	hbfail;
 };
 
-void            bfa_port_attach(struct bfa_port_s *port, struct bfa_ioc_s *ioc,
+void	     bfa_port_attach(struct bfa_port_s *port, struct bfa_ioc_s *ioc,
 				void *dev, struct bfa_trc_mod_s *trcmod,
 				struct bfa_log_mod_s *logmod);
-void            bfa_port_detach(struct bfa_port_s *port);
-void            bfa_port_hbfail(void *arg);
+void	     bfa_port_detach(struct bfa_port_s *port);
+void	     bfa_port_hbfail(void *arg);
 
-bfa_status_t    bfa_port_get_stats(struct bfa_port_s *port,
-				   union bfa_pport_stats_u *stats,
+bfa_status_t bfa_port_get_stats(struct bfa_port_s *port,
+				 union bfa_pport_stats_u *stats,
+				 bfa_port_stats_cbfn_t cbfn, void *cbarg);
+bfa_status_t bfa_port_clear_stats(struct bfa_port_s *port,
 				   bfa_port_stats_cbfn_t cbfn, void *cbarg);
-bfa_status_t    bfa_port_clear_stats(struct bfa_port_s *port,
-				     bfa_port_stats_cbfn_t cbfn, void *cbarg);
-bfa_status_t    bfa_port_enable(struct bfa_port_s *port,
-				bfa_port_endis_cbfn_t cbfn, void *cbarg);
-bfa_status_t    bfa_port_disable(struct bfa_port_s *port,
-				 bfa_port_endis_cbfn_t cbfn, void *cbarg);
-u32        bfa_port_meminfo(void);
-void            bfa_port_mem_claim(struct bfa_port_s *port, u8 *dma_kva,
-				   u64 dma_pa);
+bfa_status_t bfa_port_enable(struct bfa_port_s *port,
+			      bfa_port_endis_cbfn_t cbfn, void *cbarg);
+bfa_status_t bfa_port_disable(struct bfa_port_s *port,
+			       bfa_port_endis_cbfn_t cbfn, void *cbarg);
+u32     bfa_port_meminfo(void);
+void	     bfa_port_mem_claim(struct bfa_port_s *port,
+				 u8 *dma_kva, u64 dma_pa);
 
-#endif /* __BFA_PORT_H__ */
+#endif	/* __BFA_PORT_H__ */
diff --git a/drivers/scsi/bfa/include/cna/pstats/ethport_defs.h b/drivers/scsi/bfa/include/cna/pstats/ethport_defs.h
index 1563ee5..520fde9 100644
--- a/drivers/scsi/bfa/include/cna/pstats/ethport_defs.h
+++ b/drivers/scsi/bfa/include/cna/pstats/ethport_defs.h
@@ -27,7 +27,6 @@ struct bnad_drv_stats {
 	u64 udpcsum_offload;
 	u64 csum_help;
 	u64 csum_help_err;
-
 	u64 hw_stats_updates;
 	u64 netif_rx_schedule;
 	u64 netif_rx_complete;
diff --git a/drivers/scsi/bfa/include/cna/pstats/phyport_defs.h b/drivers/scsi/bfa/include/cna/pstats/phyport_defs.h
index eb75480..15c7ba5 100644
--- a/drivers/scsi/bfa/include/cna/pstats/phyport_defs.h
+++ b/drivers/scsi/bfa/include/cna/pstats/phyport_defs.h
@@ -20,199 +20,183 @@
 #define BNA_TXF_ID_MAX  	64
 #define BNA_RXF_ID_MAX  	64
 
-/*
- * Statistics
- */
+/* Statistics */
 
-/*
- * TxF Frame Statistics
- */
+/* TxF Frame Statistics */
 struct bna_stats_txf {
-	u64        ucast_octets;
-	u64        ucast;
-	u64        ucast_vlan;
+	u64 ucast_octets;
+	u64 ucast;
+	u64 ucast_vlan;
 
-	u64        mcast_octets;
-	u64        mcast;
-	u64        mcast_vlan;
+	u64 mcast_octets;
+	u64 mcast;
+	u64 mcast_vlan;
 
-	u64        bcast_octets;
-	u64        bcast;
-	u64        bcast_vlan;
+	u64 bcast_octets;
+	u64 bcast;
+	u64 bcast_vlan;
 
-	u64        errors;
-	u64        filter_vlan;	/* frames filtered due to VLAN */
-	u64        filter_mac_sa;	/* frames filtered due to SA check */
+	u64 errors;
+	u64 filter_vlan;      /* frames filtered due to VLAN */
+	u64 filter_mac_sa;    /* frames filtered due to SA check */
 };
 
-/*
- * RxF Frame Statistics
- */
+
+/* RxF Frame Statistics */
 struct bna_stats_rxf {
-	u64        ucast_octets;
-	u64        ucast;
-	u64        ucast_vlan;
-
-	u64        mcast_octets;
-	u64        mcast;
-	u64        mcast_vlan;
-
-	u64        bcast_octets;
-	u64        bcast;
-	u64        bcast_vlan;
-	u64        frame_drops;
+	u64 ucast_octets;
+	u64 ucast;
+	u64 ucast_vlan;
+
+	u64 mcast_octets;
+	u64 mcast;
+	u64 mcast_vlan;
+
+	u64 bcast_octets;
+	u64 bcast;
+	u64 bcast_vlan;
+	u64 frame_drops;
 };
 
-/*
- * FC Tx Frame Statistics
- */
+
+/* FC Tx Frame Statistics */
 struct bna_stats_fc_tx {
-	u64        txf_ucast_octets;
-	u64        txf_ucast;
-	u64        txf_ucast_vlan;
+	u64 txf_ucast_octets;
+	u64 txf_ucast;
+	u64 txf_ucast_vlan;
 
-	u64        txf_mcast_octets;
-	u64        txf_mcast;
-	u64        txf_mcast_vlan;
+	u64 txf_mcast_octets;
+	u64 txf_mcast;
+	u64 txf_mcast_vlan;
 
-	u64        txf_bcast_octets;
-	u64        txf_bcast;
-	u64        txf_bcast_vlan;
+	u64 txf_bcast_octets;
+	u64 txf_bcast;
+	u64 txf_bcast_vlan;
 
-	u64        txf_parity_errors;
-	u64        txf_timeout;
-	u64        txf_fid_parity_errors;
+	u64 txf_parity_errors;
+	u64 txf_timeout;
+	u64 txf_fid_parity_errors;
 };
 
-/*
- * FC Rx Frame Statistics
- */
+
+/* FC Rx Frame Statistics */
 struct bna_stats_fc_rx {
-	u64        rxf_ucast_octets;
-	u64        rxf_ucast;
-	u64        rxf_ucast_vlan;
+	u64 rxf_ucast_octets;
+	u64 rxf_ucast;
+	u64 rxf_ucast_vlan;
 
-	u64        rxf_mcast_octets;
-	u64        rxf_mcast;
-	u64        rxf_mcast_vlan;
+	u64 rxf_mcast_octets;
+	u64 rxf_mcast;
+	u64 rxf_mcast_vlan;
 
-	u64        rxf_bcast_octets;
-	u64        rxf_bcast;
-	u64        rxf_bcast_vlan;
+	u64 rxf_bcast_octets;
+	u64 rxf_bcast;
+	u64 rxf_bcast_vlan;
 };
 
-/*
- * RAD Frame Statistics
- */
+
+/* RAD Frame Statistics */
 struct cna_stats_rad {
-	u64        rx_frames;
-	u64        rx_octets;
-	u64        rx_vlan_frames;
+	u64 rx_frames;
+	u64 rx_octets;
+	u64 rx_vlan_frames;
 
-	u64        rx_ucast;
-	u64        rx_ucast_octets;
-	u64        rx_ucast_vlan;
+	u64 rx_ucast;
+	u64 rx_ucast_octets;
+	u64 rx_ucast_vlan;
 
-	u64        rx_mcast;
-	u64        rx_mcast_octets;
-	u64        rx_mcast_vlan;
+	u64 rx_mcast;
+	u64 rx_mcast_octets;
+	u64 rx_mcast_vlan;
 
-	u64        rx_bcast;
-	u64        rx_bcast_octets;
-	u64        rx_bcast_vlan;
+	u64 rx_bcast;
+	u64 rx_bcast_octets;
+	u64 rx_bcast_vlan;
 
-	u64        rx_drops;
+	u64 rx_drops;
 };
 
-/*
- * BPC Tx Registers
- */
+
+/* BPC Tx Registers */
 struct cna_stats_bpc_tx {
-	u64        tx_pause[8];
-	u64        tx_zero_pause[8];	/*  Pause cancellation */
-	u64        tx_first_pause[8];	/*  Pause initiation rather
-						 *than retention */
+	u64 tx_pause[8];
+	u64 tx_zero_pause[8]; /*  Pause cancellation */
+	u64 tx_first_pause[8];/*  Pause initiation rather than retention*/
 };
 
-/*
- * BPC Rx Registers
- */
+
+/* BPC Rx Registers */
 struct cna_stats_bpc_rx {
-	u64        rx_pause[8];
-	u64        rx_zero_pause[8];	/*  Pause cancellation */
-	u64        rx_first_pause[8];	/*  Pause initiation rather
-						 *than retention */
+	u64 rx_pause[8];
+	u64 rx_zero_pause[8]; /*  Pause cancellation */
+	u64 rx_first_pause[8];/*  Pause initiation rather than retention*/
 };
 
-/*
- * MAC Rx Statistics
- */
+
+/* MAC Rx Statistics */
 struct cna_stats_mac_rx {
-	u64        frame_64;	/* both rx and tx counter */
-	u64        frame_65_127;	/* both rx and tx counter */
-	u64        frame_128_255;	/* both rx and tx counter */
-	u64        frame_256_511;	/* both rx and tx counter */
-	u64        frame_512_1023;	/* both rx and tx counter */
-	u64        frame_1024_1518;	/* both rx and tx counter */
-	u64        frame_1518_1522;	/* both rx and tx counter */
-	u64        rx_bytes;
-	u64        rx_packets;
-	u64        rx_fcs_error;
-	u64        rx_multicast;
-	u64        rx_broadcast;
-	u64        rx_control_frames;
-	u64        rx_pause;
-	u64        rx_unknown_opcode;
-	u64        rx_alignment_error;
-	u64        rx_frame_length_error;
-	u64        rx_code_error;
-	u64        rx_carrier_sense_error;
-	u64        rx_undersize;
-	u64        rx_oversize;
-	u64        rx_fragments;
-	u64        rx_jabber;
-	u64        rx_drop;
+	u64 frame_64;		/* both rx and tx counter */
+	u64 frame_65_127;		/* both rx and tx counter */
+	u64 frame_128_255;		/* both rx and tx counter */
+	u64 frame_256_511;		/* both rx and tx counter */
+	u64 frame_512_1023;	/* both rx and tx counter */
+	u64 frame_1024_1518;	/* both rx and tx counter */
+	u64 frame_1518_1522;	/* both rx and tx counter */
+	u64 rx_bytes;
+	u64 rx_packets;
+	u64 rx_fcs_error;
+	u64 rx_multicast;
+	u64 rx_broadcast;
+	u64 rx_control_frames;
+	u64 rx_pause;
+	u64 rx_unknown_opcode;
+	u64 rx_alignment_error;
+	u64 rx_frame_length_error;
+	u64 rx_code_error;
+	u64 rx_carrier_sense_error;
+	u64 rx_undersize;
+	u64 rx_oversize;
+	u64 rx_fragments;
+	u64 rx_jabber;
+	u64 rx_drop;
 };
 
-/*
- * MAC Tx Statistics
- */
+
+/* MAC Tx Statistics */
 struct cna_stats_mac_tx {
-	u64        tx_bytes;
-	u64        tx_packets;
-	u64        tx_multicast;
-	u64        tx_broadcast;
-	u64        tx_pause;
-	u64        tx_deferral;
-	u64        tx_excessive_deferral;
-	u64        tx_single_collision;
-	u64        tx_muliple_collision;
-	u64        tx_late_collision;
-	u64        tx_excessive_collision;
-	u64        tx_total_collision;
-	u64        tx_pause_honored;
-	u64        tx_drop;
-	u64        tx_jabber;
-	u64        tx_fcs_error;
-	u64        tx_control_frame;
-	u64        tx_oversize;
-	u64        tx_undersize;
-	u64        tx_fragments;
+	u64 tx_bytes;
+	u64 tx_packets;
+	u64 tx_multicast;
+	u64 tx_broadcast;
+	u64 tx_pause;
+	u64 tx_deferral;
+	u64 tx_excessive_deferral;
+	u64 tx_single_collision;
+	u64 tx_muliple_collision;
+	u64 tx_late_collision;
+	u64 tx_excessive_collision;
+	u64 tx_total_collision;
+	u64 tx_pause_honored;
+	u64 tx_drop;
+	u64 tx_jabber;
+	u64 tx_fcs_error;
+	u64 tx_control_frame;
+	u64 tx_oversize;
+	u64 tx_undersize;
+	u64 tx_fragments;
 };
 
-/*
- * Complete statistics
- */
+/* Complete statistics */
 struct bna_stats {
-	struct cna_stats_mac_rx mac_rx_stats;
-	struct cna_stats_bpc_rx bpc_rx_stats;
-	struct cna_stats_rad rad_stats;
-	struct bna_stats_fc_rx fc_rx_stats;
-	struct cna_stats_mac_tx mac_tx_stats;
-	struct cna_stats_bpc_tx bpc_tx_stats;
-	struct bna_stats_fc_tx fc_tx_stats;
-	struct bna_stats_rxf rxf_stats[BNA_TXF_ID_MAX];
-	struct bna_stats_txf txf_stats[BNA_RXF_ID_MAX];
+	struct cna_stats_mac_rx	mac_rx_stats;
+	struct cna_stats_bpc_rx	bpc_rx_stats;
+	struct cna_stats_rad	rad_stats;
+	struct bna_stats_fc_rx	fc_rx_stats;
+	struct cna_stats_mac_tx	mac_tx_stats;
+	struct cna_stats_bpc_tx	bpc_tx_stats;
+	struct bna_stats_fc_tx	fc_tx_stats;
+	struct bna_stats_rxf	rxf_stats[BNA_TXF_ID_MAX];
+	struct bna_stats_txf	txf_stats[BNA_RXF_ID_MAX];
 };
 
 #endif
diff --git a/drivers/scsi/bfa/include/cs/bfa_log.h b/drivers/scsi/bfa/include/cs/bfa_log.h
index 761cbe2..bc334e0 100644
--- a/drivers/scsi/bfa/include/cs/bfa_log.h
+++ b/drivers/scsi/bfa/include/cs/bfa_log.h
@@ -157,7 +157,7 @@ typedef void (*bfa_log_cb_t)(struct bfa_log_mod_s *log_mod, u32 msg_id,
 
 
 struct bfa_log_mod_s {
-	char		instance_info[16];	/*  instance info */
+	char		instance_info[BFA_STRING_32];	/*  instance info */
 	int		log_level[BFA_LOG_MODULE_ID_MAX + 1];
 						/*  log level for modules */
 	bfa_log_cb_t	cbfn; 			/*  callback function */
diff --git a/drivers/scsi/bfa/include/cs/bfa_plog.h b/drivers/scsi/bfa/include/cs/bfa_plog.h
index 670f86e..3a90b40 100644
--- a/drivers/scsi/bfa/include/cs/bfa_plog.h
+++ b/drivers/scsi/bfa/include/cs/bfa_plog.h
@@ -80,7 +80,8 @@ enum bfa_plog_mid {
 	BFA_PL_MID_HAL_FCXP 	= 4,
 	BFA_PL_MID_HAL_UF 	= 5,
 	BFA_PL_MID_FCS 		= 6,
-	BFA_PL_MID_MAX 		= 7
+	BFA_PL_MID_LPS		= 7,
+	BFA_PL_MID_MAX 		= 8
 };
 
 #define BFA_PL_MID_STRLEN    8
@@ -118,7 +119,11 @@ enum bfa_plog_eid {
 	BFA_PL_EID_RSCN 		= 17,
 	BFA_PL_EID_DEBUG 		= 18,
 	BFA_PL_EID_MISC 		= 19,
-	BFA_PL_EID_MAX 			= 20
+	BFA_PL_EID_FIP_FCF_DISC		= 20,
+	BFA_PL_EID_FIP_FCF_CVL		= 21,
+	BFA_PL_EID_LOGIN		= 22,
+	BFA_PL_EID_LOGO			= 23,
+	BFA_PL_EID_MAX 			= 24
 };
 
 #define BFA_PL_ENAME_STRLEN    	8
diff --git a/drivers/scsi/bfa/include/cs/bfa_sm.h b/drivers/scsi/bfa/include/cs/bfa_sm.h
index b0a92ba..0eaa4da 100644
--- a/drivers/scsi/bfa/include/cs/bfa_sm.h
+++ b/drivers/scsi/bfa/include/cs/bfa_sm.h
@@ -24,6 +24,15 @@
 
 typedef void (*bfa_sm_t)(void *sm, int event);
 
+/**
+ * oc - object class eg. bfa_ioc
+ * st - state, eg. reset
+ * otype - object type, eg. struct bfa_ioc_s
+ * etype - object type, eg. enum ioc_event
+ */
+#define bfa_sm_state_decl(oc, st, otype, etype)		\
+	static void oc ## _sm_ ## st(otype * fsm, etype event)
+
 #define bfa_sm_set_state(_sm, _state)	((_sm)->sm = (bfa_sm_t)(_state))
 #define bfa_sm_send_event(_sm, _event)	((_sm)->sm((_sm), (_event)))
 #define bfa_sm_get_state(_sm)		((_sm)->sm)
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_aen.h b/drivers/scsi/bfa/include/defs/bfa_defs_aen.h
index 4c81a61..894f6c8 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_aen.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_aen.h
@@ -30,6 +30,16 @@
 #include <defs/bfa_defs_audit.h>
 #include <defs/bfa_defs_ethport.h>
 
+#define BFA_AEN_MAX_APP         5
+
+enum bfa_aen_app {
+	bfa_aen_app_bcu = 0,	/* No thread for bcu */
+	bfa_aen_app_hcm = 1,
+	bfa_aen_app_cim = 2,
+	bfa_aen_app_snia = 3,
+	bfa_aen_app_test = 4,	/* To be removed after unit test */
+};
+
 enum bfa_aen_category {
 	BFA_AEN_CAT_ADAPTER 	= 1,
 	BFA_AEN_CAT_PORT 	= 2,
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_auth.h b/drivers/scsi/bfa/include/defs/bfa_defs_auth.h
index dd19c83..0f70c9a 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_auth.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_auth.h
@@ -23,6 +23,7 @@
 #define PRIVATE_KEY			19009
 #define KEY_LEN				32399
 #define BFA_AUTH_SECRET_STRING_LEN	256
+#define BFA_AUTH_FAIL_NO_PASSWORD	0xFE
 #define BFA_AUTH_FAIL_TIMEOUT		0xFF
 
 /**
@@ -41,6 +42,27 @@ enum bfa_auth_status {
 	BFA_AUTH_STATUS_UNKNOWN = 9,	/*  authentication status unknown */
 };
 
+enum bfa_auth_rej_code {
+	BFA_AUTH_RJT_CODE_AUTH_FAILURE   = 1, /* auth failure */
+	BFA_AUTH_RJT_CODE_LOGICAL_ERR    = 2, /* logical error */
+};
+
+/**
+ * Authentication reject codes
+ */
+enum bfa_auth_rej_code_exp {
+	BFA_AUTH_MECH_NOT_USABLE	= 1, /* auth. mechanism not usable */
+	BFA_AUTH_DH_GROUP_NOT_USABLE	= 2, /* DH Group not usable */
+	BFA_AUTH_HASH_FUNC_NOT_USABLE	= 3, /* hash Function not usable */
+	BFA_AUTH_AUTH_XACT_STARTED	= 4, /* auth xact started */
+	BFA_AUTH_AUTH_FAILED		= 5, /* auth failed */
+	BFA_AUTH_INCORRECT_PLD		= 6, /* incorrect payload */
+	BFA_AUTH_INCORRECT_PROTO_MSG	= 7, /* incorrect proto msg */
+	BFA_AUTH_RESTART_AUTH_PROTO	= 8, /* restart auth protocol */
+	BFA_AUTH_AUTH_CONCAT_NOT_SUPP	= 9, /* auth concat not supported */
+	BFA_AUTH_PROTO_VER_NOT_SUPP	= 10,/* proto version not supported */
+};
+
 struct auth_proto_stats_s {
 	u32        auth_rjts;
 	u32        auth_negs;
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_cee.h b/drivers/scsi/bfa/include/defs/bfa_defs_cee.h
index 520a22f..c14e5f6 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_cee.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_cee.h
@@ -28,10 +28,6 @@
 
 #define BFA_CEE_LLDP_MAX_STRING_LEN (128)
 
-
-/* FIXME: this is coming from the protocol spec. Can the host & apps share the
-   protocol .h files ?
- */
 #define BFA_CEE_LLDP_SYS_CAP_OTHER       0x0001
 #define BFA_CEE_LLDP_SYS_CAP_REPEATER    0x0002
 #define BFA_CEE_LLDP_SYS_CAP_MAC_BRIDGE  0x0004
@@ -40,9 +36,9 @@
 #define BFA_CEE_LLDP_SYS_CAP_TELEPHONE 	 0x0020
 #define BFA_CEE_LLDP_SYS_CAP_DOCSIS_CD   0x0040
 #define BFA_CEE_LLDP_SYS_CAP_STATION     0x0080
-#define BFA_CEE_LLDP_SYS_CAP_CVLAN	     0x0100
-#define BFA_CEE_LLDP_SYS_CAP_SVLAN 	     0x0200
-#define BFA_CEE_LLDP_SYS_CAP_TPMR		 0x0400
+#define BFA_CEE_LLDP_SYS_CAP_CVLAN	 0x0100
+#define BFA_CEE_LLDP_SYS_CAP_SVLAN	 0x0200
+#define BFA_CEE_LLDP_SYS_CAP_TPMR	 0x0400
 
 
 /* LLDP string type */
@@ -72,8 +68,7 @@ enum bfa_cee_dcbx_version_e {
 };
 
 enum bfa_cee_lls_e {
-	CEE_LLS_DOWN_NO_TLV = 0, /* LLS is down because the TLV not sent by
-				  * the peer */
+	CEE_LLS_DOWN_NO_TLV = 0, /* LLS is down bcoz TLV not sent by the peer */
 	CEE_LLS_DOWN        = 1, /* LLS is down as advertised by the peer */
 	CEE_LLS_UP          = 2,
 };
@@ -83,20 +78,20 @@ struct bfa_cee_dcbx_cfg_s {
 	u8 pgid[8];
 	u8 pg_percentage[8];
 	u8 pfc_enabled;          /* bitmap of priorties with PFC enabled */
-	u8 fcoe_user_priority;   /* bitmap of priorities used for FcoE
-				       * traffic */
-	u8 dcbx_version;	/* operating version:CEE or preCEE */
-	u8 lls_fcoe;	/* FCoE Logical Link Status */
-	u8 lls_lan;	/* LAN Logical Link Status */
+	u8 fcoe_user_priority;  /* bitmap of priorities for FcoE traffic */
+	u8 dcbx_version;		  /* operating version:CEE or preCEE */
+	u8 lls_fcoe;			  /* FCoE Logical Link Status */
+	u8 lls_lan;			  /* LAN Logical Link Status */
 	u8 rsvd[3];
 };
 
 /* CEE status */
 /* Making this to tri-state for the benefit of port list command */
 enum bfa_cee_status_e {
-    CEE_PHY_DOWN = 0,
+    CEE_UP = 0,
     CEE_PHY_UP = 1,
-    CEE_UP = 2,
+	CEE_LOOPBACK = 2,
+    CEE_PHY_DOWN = 3,
 };
 
 /* CEE Query */
@@ -105,9 +100,10 @@ struct bfa_cee_attr_s {
 	u8                   error_reason;
 	struct bfa_cee_lldp_cfg_s lldp_remote;
 	struct bfa_cee_dcbx_cfg_s dcbx_remote;
-	mac_t src_mac;
+	struct mac_s src_mac;
 	u8 link_speed;
-	u8 filler[3];
+	u8 nw_priority;
+	u8 filler[2];
 };
 
 
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_driver.h b/drivers/scsi/bfa/include/defs/bfa_defs_driver.h
index 5704980..13a7bb5 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_driver.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_driver.h
@@ -34,6 +34,10 @@
     u64    output_req;
     u64    input_words;
     u64    output_words;
+	u16	link_up;
+	u16	link_down;
+	u16	bootlun_online;
+	u16	bootlun_offline;
 } bfa_driver_stats_t;
 
 
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_ethport.h b/drivers/scsi/bfa/include/defs/bfa_defs_ethport.h
index 79f9b3e..a7af9c2 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_ethport.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_ethport.h
@@ -19,6 +19,7 @@
 #define __BFA_DEFS_ETHPORT_H__
 
 #include <defs/bfa_defs_status.h>
+#include <defs/bfa_defs_port.h>
 #include <protocol/types.h>
 #include <cna/pstats/phyport_defs.h>
 #include <cna/pstats/ethport_defs.h>
@@ -86,13 +87,21 @@ enum bfa_ethport_aen_event {
 	BFA_ETHPORT_AEN_LINKUP = 1, /*  Base Port Ethernet link up event */
 	BFA_ETHPORT_AEN_LINKDOWN = 2, /*  Base Port Ethernet link down event */
 	BFA_ETHPORT_AEN_ENABLE = 3, /*  Base Port Ethernet link enable event */
-	BFA_ETHPORT_AEN_DISABLE = 4, /*  Base Port Ethernet link disable
-				      * event */
+	BFA_ETHPORT_AEN_DISABLE = 4,/*  Base Port Ethernet link disable event*/
 };
 
 struct bfa_ethport_aen_data_s {
-	mac_t mac;	/*  MAC address of the physical port */
+	struct mac_s mac;	/*  MAC address of the physical port */
 };
 
+/**
+ * 		Ethernet port attribute values.
+ */
+struct bfa_ethport_attr_s {
+	u32 mtu; /*  maximum transfer unit */
+	enum bfa_pport_speed speed_supported; /*  supported speeds */
+	enum bfa_pport_states port_state; /*  current port state */
+	enum bfa_pport_speed speed; /*  current speed */
+};
 
 #endif /* __BFA_DEFS_ETHPORT_H__ */
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_fcport.h b/drivers/scsi/bfa/include/defs/bfa_defs_fcport.h
new file mode 100644
index 0000000..a07ef4a
--- /dev/null
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_fcport.h
@@ -0,0 +1,94 @@
+/*
+ * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
+ * All rights reserved
+ * www.brocade.com
+ *
+ *  bfa_defs_fcport.h
+ *
+ * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License (GPL) Version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+#ifndef __BFA_DEFS_FCPORT_H__
+#define __BFA_DEFS_FCPORT_H__
+
+#include <defs/bfa_defs_types.h>
+#include <protocol/types.h>
+
+#pragma pack(1)
+
+/**
+ * FCoE statistics
+ */
+struct bfa_fcoe_stats_s {
+	u64	secs_reset;	/*  Seconds since stats reset	     */
+	u64	cee_linkups;	/*  CEE link up		     */
+	u64	cee_linkdns;	/*  CEE link down		     */
+	u64	fip_linkups;	/*  FIP link up		     */
+	u64	fip_linkdns;	/*  FIP link down		     */
+	u64	fip_fails;	/*  FIP failures		     */
+	u64	mac_invalids;	/*  Invalid mac assignments	     */
+	u64	vlan_req;	/*  Vlan requests		     */
+	u64	vlan_notify;	/*  Vlan notifications		     */
+	u64	vlan_err;	/*  Vlan notification errors	     */
+	u64	vlan_timeouts;	/*  Vlan request timeouts	     */
+	u64	vlan_invalids;	/*  Vlan invalids		     */
+	u64	disc_req;	/*  Discovery requests		     */
+	u64	disc_rsp;	/*  Discovery responses	     */
+	u64	disc_err;	/*  Discovery error frames	     */
+	u64	disc_unsol;	/*  Discovery unsolicited	     */
+	u64	disc_timeouts;	/*  Discovery timeouts		     */
+	u64	disc_fcf_unavail; /*  Discovery FCF not avail	     */
+	u64	linksvc_unsupp;	/*  FIP link service req unsupp.    */
+	u64	linksvc_err;	/*  FIP link service req errors     */
+	u64	logo_req;	/*  FIP logo			     */
+	u64	clrvlink_req;	/*  Clear virtual link requests     */
+	u64	op_unsupp;	/*  FIP operation unsupp.	     */
+	u64	untagged;	/*  FIP untagged frames	     */
+	u64	txf_ucast;	/*  Tx FCoE unicast frames	     */
+	u64	txf_ucast_vlan;	/*  Tx FCoE unicast vlan frames     */
+	u64	txf_ucast_octets; /*  Tx FCoE unicast octets	     */
+	u64	txf_mcast;	/*  Tx FCoE mutlicast frames	     */
+	u64	txf_mcast_vlan;	/*  Tx FCoE mutlicast vlan frames   */
+	u64	txf_mcast_octets; /*  Tx FCoE multicast octets	     */
+	u64	txf_bcast;	/*  Tx FCoE broadcast frames	     */
+	u64	txf_bcast_vlan;	/*  Tx FCoE broadcast vlan frames   */
+	u64	txf_bcast_octets; /*  Tx FCoE broadcast octets	     */
+	u64	txf_timeout;	/*  Tx timeouts		     */
+	u64	txf_parity_errors; /*  Transmit parity err	     */
+	u64	txf_fid_parity_errors; /*  Transmit FID parity err  */
+	u64	tx_pause;	/*  Tx pause frames		     */
+	u64	tx_zero_pause;	/*  Tx zero pause frames	     */
+	u64	tx_first_pause;	/*  Tx first pause frames	     */
+	u64	rx_pause;	/*  Rx pause frames		     */
+	u64	rx_zero_pause;	/*  Rx zero pause frames	     */
+	u64	rx_first_pause;	/*  Rx first pause frames	     */
+	u64	rxf_ucast_octets; /*  Rx unicast octets	     */
+	u64	rxf_ucast;	/*  Rx unicast frames		     */
+	u64	rxf_ucast_vlan;	/*  Rx unicast vlan frames	     */
+	u64	rxf_mcast_octets; /*  Rx multicast octets	     */
+	u64	rxf_mcast;	/*  Rx multicast frames	     */
+	u64	rxf_mcast_vlan;	/*  Rx multicast vlan frames	     */
+	u64	rxf_bcast_octets; /*  Rx broadcast octests	     */
+	u64	rxf_bcast;	/*  Rx broadcast frames	     */
+	u64	rxf_bcast_vlan;	/*  Rx broadcast vlan frames	     */
+};
+
+/**
+ * QoS or FCoE stats (fcport stats excluding physical FC port stats)
+ */
+union bfa_fcport_stats_u {
+	struct bfa_qos_stats_s	fcqos;
+	struct bfa_fcoe_stats_s	fcoe;
+};
+
+#pragma pack()
+
+#endif  /* __BFA_DEFS_FCPORT_H__ */
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_im_common.h b/drivers/scsi/bfa/include/defs/bfa_defs_im_common.h
deleted file mode 100644
index 9ccf53b..0000000
--- a/drivers/scsi/bfa/include/defs/bfa_defs_im_common.h
+++ /dev/null
@@ -1,32 +0,0 @@
-/*
- * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
- * All rights reserved
- * www.brocade.com
- *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License (GPL) Version 2 as
- * published by the Free Software Foundation
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- */
-
-#ifndef __BFA_DEFS_IM_COMMON_H__
-#define __BFA_DEFS_IM_COMMON_H__
-
-#define	BFA_ADAPTER_NAME_LEN	256
-#define BFA_ADAPTER_GUID_LEN    256
-#define RESERVED_VLAN_NAME      L"PORT VLAN"
-#define PASSTHRU_VLAN_NAME      L"PASSTHRU VLAN"
-
-	u64	tx_pkt_cnt;
-	u64	rx_pkt_cnt;
-	u32	duration;
-	u8		status;
-} bfa_im_stats_t, *pbfa_im_stats_t;
-
-#endif /* __BFA_DEFS_IM_COMMON_H__ */
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_im_team.h b/drivers/scsi/bfa/include/defs/bfa_defs_im_team.h
deleted file mode 100644
index a486a7e..0000000
--- a/drivers/scsi/bfa/include/defs/bfa_defs_im_team.h
+++ /dev/null
@@ -1,72 +0,0 @@
-/*
- * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
- * All rights reserved
- * www.brocade.com
- *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License (GPL) Version 2 as
- * published by the Free Software Foundation
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- */
-
-#ifndef __BFA_DEFS_IM_TEAM_H__
-#define __BFA_DEFS_IM_TEAM_H__
-
-#include <protocol/types.h>
-
-#define	BFA_TEAM_MAX_PORTS	8
-#define	BFA_TEAM_NAME_LEN	256
-#define BFA_MAX_NUM_TEAMS	16
-#define BFA_TEAM_INVALID_DELAY -1
-
-	BFA_LACP_RATE_SLOW = 1,
-	BFA_LACP_RATE_FAST
-} bfa_im_lacp_rate_t;
-
-	BFA_TEAM_MODE_FAIL_OVER = 1,
-	BFA_TEAM_MODE_FAIL_BACK,
-	BFA_TEAM_MODE_LACP,
-	BFA_TEAM_MODE_NONE
-} bfa_im_team_mode_t;
-
-	BFA_XMIT_POLICY_L2 = 1,
-	BFA_XMIT_POLICY_L3_L4
-} bfa_im_xmit_policy_t;
-
-	bfa_im_team_mode_t     team_mode;
-	bfa_im_lacp_rate_t     lacp_rate;
-	bfa_im_xmit_policy_t   xmit_policy;
-	int   	          delay;
-	wchar_t    	  primary[BFA_ADAPTER_NAME_LEN];
-	wchar_t        	  preferred_primary[BFA_ADAPTER_NAME_LEN];
-	mac_t	          mac;
-	u16       	  num_ports;
-	u16          num_vlans;
-	u16 vlan_list[BFA_MAX_VLANS_PER_PORT];
-	wchar_t	 team_guid_list[BFA_TEAM_MAX_PORTS][BFA_ADAPTER_GUID_LEN];
-	wchar_t	 ioc_name_list[BFA_TEAM_MAX_PORTS][BFA_ADAPTER_NAME_LEN];
-} bfa_im_team_attr_t;
-
-	wchar_t		             team_name[BFA_TEAM_NAME_LEN];
-	bfa_im_xmit_policy_t	 xmit_policy;
-	int                 	 delay;
-	wchar_t                	 primary[BFA_ADAPTER_NAME_LEN];
-	wchar_t               	 preferred_primary[BFA_ADAPTER_NAME_LEN];
-} bfa_im_team_edit_t, *pbfa_im_team_edit_t;
-
-	wchar_t					team_name[BFA_TEAM_NAME_LEN];
-	bfa_im_team_mode_t      team_mode;
-	mac_t	               	mac;
-} bfa_im_team_info_t;
-
-	bfa_im_team_info_t 		team_info[BFA_MAX_NUM_TEAMS];
-	u16 				num_teams;
-} bfa_im_team_list_t, *pbfa_im_team_list_t;
-
-#endif /* __BFA_DEFS_IM_TEAM_H__ */
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_ioc.h b/drivers/scsi/bfa/include/defs/bfa_defs_ioc.h
index b1d532d..7441039 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_ioc.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_ioc.h
@@ -126,6 +126,7 @@ struct bfa_ioc_attr_s {
 	struct bfa_ioc_driver_attr_s 	driver_attr;	/*  driver attr    */
 	struct bfa_ioc_pci_attr_s	pci_attr;
 	u8				port_id;	/*  port number    */
+	u8				rsvd[7];	/*  64bit align    */
 };
 
 /**
@@ -143,9 +144,9 @@ enum bfa_ioc_aen_event {
  * BFA IOC level event data, now just a place holder
  */
 struct bfa_ioc_aen_data_s {
-	enum bfa_ioc_type_e ioc_type;
 	wwn_t	pwwn;
-	mac_t	mac;
+	s16 ioc_type;
+	struct mac_s	mac;
 };
 
 #endif /* __BFA_DEFS_IOC_H__ */
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_iocfc.h b/drivers/scsi/bfa/include/defs/bfa_defs_iocfc.h
index d76bcbd..bf7a83f 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_iocfc.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_iocfc.h
@@ -26,6 +26,8 @@
 
 #define BFA_IOCFC_INTR_DELAY	1125
 #define BFA_IOCFC_INTR_LATENCY	225
+#define BFA_IOCFCOE_INTR_DELAY	25
+#define BFA_IOCFCOE_INTR_LATENCY 5
 
 /**
  * Interrupt coalescing configuration.
@@ -50,7 +52,7 @@ struct bfa_iocfc_fwcfg_s {
 	u16        num_fcxp_reqs;	/*  unassisted FC exchanges	*/
 	u16        num_uf_bufs;	/*  unsolicited recv buffers	*/
 	u8		num_cqs;
-	u8		rsvd;
+	u8		rsvd[5];
 };
 
 struct bfa_iocfc_drvcfg_s {
@@ -224,18 +226,24 @@ struct bfa_fw_port_physm_stats_s {
 
 
 struct bfa_fw_fip_stats_s {
+    u32    vlan_req;           /*  vlan discovery requests             */
+    u32    vlan_notify;        /*  vlan notifications                  */
+    u32    vlan_err;           /*  vlan response error                 */
+    u32    vlan_timeouts;      /*  vlan disvoery timeouts              */
+    u32    vlan_invalids;      /*  invalid vlan in discovery advert.   */
     u32    disc_req;           /*  Discovery solicit requests          */
     u32    disc_rsp;           /*  Discovery solicit response          */
     u32    disc_err;           /*  Discovery advt. parse errors        */
     u32    disc_unsol;         /*  Discovery unsolicited               */
     u32    disc_timeouts;      /*  Discovery timeouts                  */
+    u32    disc_fcf_unavail;   /*  Discovery FCF Not Avail.            */
     u32    linksvc_unsupp;     /*  Unsupported link service req        */
     u32    linksvc_err;        /*  Parse error in link service req     */
     u32    logo_req;           /*  Number of FIP logos received        */
     u32    clrvlink_req;       /*  Clear virtual link req              */
     u32    op_unsupp;          /*  Unsupported FIP operation           */
     u32    untagged;           /*  Untagged frames (ignored)           */
-    u32    rsvd;
+    u32    invalid_version;    /*  Invalid FIP version                 */
 };
 
 
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_lport.h b/drivers/scsi/bfa/include/defs/bfa_defs_lport.h
index 7359f82..0220d51 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_lport.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_lport.h
@@ -59,8 +59,8 @@ enum bfa_lport_aen_event {
  */
 struct bfa_lport_aen_data_s {
 	u16        vf_id;	/*  vf_id of this logical port */
-	u16        rsvd;
-	enum bfa_port_role roles;	/*  Logical port mode,IM/TM/IP etc */
+	s16         roles;	/*  Logical port mode,IM/TM/IP etc */
+	u32        rsvd;
 	wwn_t           ppwwn;	/*  WWN of its physical port */
 	wwn_t           lpwwn;	/*  WWN of this logical port */
 };
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_mfg.h b/drivers/scsi/bfa/include/defs/bfa_defs_mfg.h
index 13fd4ab..bc61656 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_mfg.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_mfg.h
@@ -22,7 +22,47 @@
 /**
  * Manufacturing block version
  */
-#define BFA_MFG_VERSION				1
+#define BFA_MFG_VERSION				2
+
+/**
+ * Manufacturing block encrypted version
+ */
+#define BFA_MFG_ENC_VER				2
+
+/**
+ * Manufacturing block version 1 length
+ */
+#define BFA_MFG_VER1_LEN			128
+
+/**
+ * Manufacturing block header length
+ */
+#define BFA_MFG_HDR_LEN				4
+
+/**
+ * Checksum size
+ */
+#define BFA_MFG_CHKSUM_SIZE			16
+
+/**
+ * Manufacturing block encrypted version
+ */
+#define BFA_MFG_ENC_VER				2
+
+/**
+ * Manufacturing block version 1 length
+ */
+#define BFA_MFG_VER1_LEN			128
+
+/**
+ * Manufacturing block header length
+ */
+#define BFA_MFG_HDR_LEN				4
+
+/**
+ * Checksum size
+ */
+#define BFA_MFG_CHKSUM_SIZE			16
 
 /**
  * Manufacturing block format
@@ -30,29 +70,72 @@
 #define BFA_MFG_SERIALNUM_SIZE			11
 #define BFA_MFG_PARTNUM_SIZE			14
 #define BFA_MFG_SUPPLIER_ID_SIZE		10
-#define BFA_MFG_SUPPLIER_PARTNUM_SIZE	20
-#define BFA_MFG_SUPPLIER_SERIALNUM_SIZE	20
-#define BFA_MFG_SUPPLIER_REVISION_SIZE	4
+#define BFA_MFG_SUPPLIER_PARTNUM_SIZE		20
+#define BFA_MFG_SUPPLIER_SERIALNUM_SIZE		20
+#define BFA_MFG_SUPPLIER_REVISION_SIZE		4
 #define STRSZ(_n)	(((_n) + 4) & ~3)
 
 /**
+ * Manufacturing card type
+ */
+enum {
+	BFA_MFG_TYPE_CB_MAX  = 825,      /*  Crossbow card type max	*/
+	BFA_MFG_TYPE_FC8P2   = 825,      /*  8G 2port FC card		*/
+	BFA_MFG_TYPE_FC8P1   = 815,      /*  8G 1port FC card		*/
+	BFA_MFG_TYPE_FC4P2   = 425,      /*  4G 2port FC card		*/
+	BFA_MFG_TYPE_FC4P1   = 415,      /*  4G 1port FC card		*/
+	BFA_MFG_TYPE_CNA10P2 = 1020,     /*  10G 2port CNA card	*/
+	BFA_MFG_TYPE_CNA10P1 = 1010,     /*  10G 1port CNA card	*/
+};
+
+#pragma pack(1)
+
+/**
+ * Card type to port number conversion
+ */
+#define bfa_mfg_type2port_num(card_type) (((card_type) / 10) % 10)
+
+
+/**
+ * All numerical fields are in big-endian format.
+ */
+struct bfa_mfg_block_s {
+};
+
+/**
  * VPD data length
  */
-#define BFA_MFG_VPD_LEN     256
+#define BFA_MFG_VPD_LEN		512
+
+#define BFA_MFG_VPD_PCI_HDR_OFF		137
+#define BFA_MFG_VPD_PCI_VER_MASK	0x07	/*  version mask 3 bits */
+#define BFA_MFG_VPD_PCI_VDR_MASK	0xf8	/*  vendor mask 5 bits */
+
+/**
+ * VPD vendor tag
+ */
+enum {
+	BFA_MFG_VPD_UNKNOWN	= 0,     /*  vendor unknown 		*/
+	BFA_MFG_VPD_IBM 	= 1,     /*  vendor IBM 		*/
+	BFA_MFG_VPD_HP  	= 2,     /*  vendor HP  		*/
+	BFA_MFG_VPD_PCI_IBM 	= 0x08,  /*  PCI VPD IBM     		*/
+	BFA_MFG_VPD_PCI_HP  	= 0x10,  /*  PCI VPD HP		*/
+	BFA_MFG_VPD_PCI_BRCD 	= 0xf8,  /*  PCI VPD Brocade 		*/
+};
 
 /**
  * All numerical fields are in big-endian format.
  */
 struct bfa_mfg_vpd_s {
-    u8     version;    /*  vpd data version */
-    u8     vpd_sig[3]; /*  characters 'V', 'P', 'D' */
-    u8     chksum;     /*  u8 checksum */
-    u8     vendor;     /*  vendor */
-    u8     len;        /*  vpd data length excluding header */
-    u8     rsv;
-    u8     data[BFA_MFG_VPD_LEN];  /*  vpd data */
+	u8		version;	/*  vpd data version */
+	u8		vpd_sig[3];	/*  characters 'V', 'P', 'D' */
+	u8		chksum;		/*  u8 checksum */
+	u8		vendor;		/*  vendor */
+	u8 	len;		/*  vpd data length excluding header */
+	u8 	rsv;
+	u8		data[BFA_MFG_VPD_LEN];	/*  vpd data */
 };
 
-#pragma pack(1)
+#pragma pack()
 
 #endif /* __BFA_DEFS_MFG_H__ */
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_port.h b/drivers/scsi/bfa/include/defs/bfa_defs_port.h
index de0696c..48772bd 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_port.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_port.h
@@ -185,6 +185,8 @@ struct bfa_port_attr_s {
 	wwn_t		fabric_name; /*  attached switch's nwwn */
 	u8		fabric_ip_addr[BFA_FCS_FABRIC_IPADDR_SZ]; /*  attached
 							* fabric's ip addr */
+	struct mac_s    fpma_mac;	/*  Lport's FPMA Mac address */
+	u16	authfail;	/*  auth failed state */
 };
 
 /**
@@ -218,8 +220,7 @@ enum bfa_port_aen_event {
 	BFA_PORT_AEN_AUTH_OFF   = 10,	/*  Physical Port auth fail event */
 	BFA_PORT_AEN_DISCONNECT = 11,	/*  Physical Port disconnect event */
 	BFA_PORT_AEN_QOS_NEG    = 12,  	/*  Base Port QOS negotiation event */
-	BFA_PORT_AEN_FABRIC_NAME_CHANGE = 13, /*  Fabric Name/WWN change
-					       * event */
+	BFA_PORT_AEN_FABRIC_NAME_CHANGE = 13,/*  Fabric Name/WWN change event*/
 	BFA_PORT_AEN_SFP_ACCESS_ERROR = 14, /*  SFP read error event */
 	BFA_PORT_AEN_SFP_UNSUPPORT = 15, /*  Unsupported SFP event */
 };
@@ -232,14 +233,15 @@ enum bfa_port_aen_sfp_pom {
 };
 
 struct bfa_port_aen_data_s {
-	enum bfa_ioc_type_e ioc_type;
 	wwn_t           pwwn;	      /*  WWN of the physical port */
 	wwn_t           fwwn;	      /*  WWN of the fabric port */
-	mac_t           mac;	      /*  MAC addres of the ethernet port,
+	s32         phy_port_num; /*! For SFP related events */
+	s16         ioc_type;
+	s16         level;        /*  Only transitions will
+				       * be informed */
+	struct mac_s    mac;	      /*  MAC address of the ethernet port,
 				       * applicable to CNA port only */
-	int             phy_port_num; /*! For SFP related events */
-	enum bfa_port_aen_sfp_pom level; /*  Only transitions will
-					  * be informed */
+	s16         rsvd;
 };
 
 #endif /* __BFA_DEFS_PORT_H__ */
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_pport.h b/drivers/scsi/bfa/include/defs/bfa_defs_pport.h
index a000bc4..02cc039 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_pport.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_pport.h
@@ -61,7 +61,7 @@ enum bfa_pport_speed {
  * 		Port operational type (in sync with SNIA port type).
  */
 enum bfa_pport_type {
-	BFA_PPORT_TYPE_UNKNOWN = 1,	/*  port type is unkown */
+	BFA_PPORT_TYPE_UNKNOWN = 1,	/*  port type is unknown */
 	BFA_PPORT_TYPE_TRUNKED = 2,	/*  Trunked mode */
 	BFA_PPORT_TYPE_NPORT   = 5,	/*  P2P with switched fabric */
 	BFA_PPORT_TYPE_NLPORT  = 6,	/*  public loop */
@@ -201,10 +201,10 @@ struct bfa_pport_attr_s {
 	/*
 	 * Static fields
 	 */
-	wwn_t           nwwn;		/*  node wwn */
-	wwn_t           pwwn;		/*  port wwn */
-	enum fc_cos     cos_supported;	/*  supported class of services */
-	u32        rsvd;
+	wwn_t       nwwn;		/*  node wwn */
+	wwn_t       pwwn;		/*  port wwn */
+	enum fc_cos cos_supported;	/*  supported class of services */
+	u32    rsvd;
 	struct fc_symname_s    port_symname;	/*  port symbolic name */
 	enum bfa_pport_speed speed_supported; /*  supported speeds */
 	bfa_boolean_t   pbind_enabled;	/*  Will be set if Persistent binding
@@ -232,81 +232,87 @@ struct bfa_pport_attr_s {
 	u32        	pid;		/*  port ID */
 	enum bfa_pport_type 	port_type;	/*  current topology */
 	u32        	loopback;	/*  external loopback */
-	u32		rsvd1;
+	u32		authfail;	/*  auth fail state */
 	u32		rsvd2;		/*  padding for 64 bit */
 };
 
 /**
- * 		FC Port statistics.
+ * FC physical port statistics.
  */
 struct bfa_pport_fc_stats_s {
-	u64        secs_reset;	/*  seconds since stats is reset */
-	u64        tx_frames;	/*  transmitted frames */
-	u64        tx_words;	/*  transmitted words */
-	u64        rx_frames;	/*  received frames */
-	u64        rx_words;	/*  received words */
-	u64        lip_count;	/*  LIPs seen */
-	u64        nos_count;	/*  NOS count */
-	u64        error_frames;	/*  errored frames (sent?) */
-	u64        dropped_frames;	/*  dropped frames */
-	u64        link_failures;	/*  link failure count */
-	u64        loss_of_syncs;	/*  loss of sync count */
-	u64        loss_of_signals;/*  loss of signal count */
-	u64        primseq_errs;	/*  primitive sequence protocol */
-	u64        bad_os_count;	/*  invalid ordered set */
-	u64        err_enc_out;	/*  Encoding error outside frame */
-	u64        invalid_crcs;	/*  frames received with invalid CRC*/
-	u64	undersized_frm; /*  undersized frames */
-	u64	oversized_frm;	/*  oversized frames */
-	u64	bad_eof_frm;	/*  frames with bad EOF */
-	struct bfa_qos_stats_s	qos_stats;	/*  QoS statistics */
+	u64	secs_reset;	/*  Seconds since stats is reset     */
+	u64	tx_frames;	/*  Tx frames			      */
+	u64	tx_words;	/*  Tx words			      */
+	u64	tx_lip;		/*  TX LIP			      */
+	u64	tx_nos;		/*  Tx NOS			      */
+	u64	tx_ols;		/*  Tx OLS			      */
+	u64	tx_lr;		/*  Tx LR			      */
+	u64	tx_lrr;		/*  Tx LRR			      */
+	u64	rx_frames;	/*  Rx frames			      */
+	u64	rx_words;	/*  Rx words			      */
+	u64	lip_count;	/*  Rx LIP 			      */
+	u64	nos_count;	/*  Rx NOS			      */
+	u64	ols_count;	/*  Rx OLS			      */
+	u64	lr_count;	/*  Rx LR			      */
+	u64	lrr_count;	/*  Rx LRR			      */
+	u64	invalid_crcs;	/*  Rx CRC err frames		      */
+	u64	invalid_crc_gd_eof; /*  Rx CRC err good EOF frames   */
+	u64	undersized_frm; /*  Rx undersized frames	      */
+	u64	oversized_frm;  /*  Rx oversized frames	      */
+	u64	bad_eof_frm;	/*  Rx frames with bad EOF	      */
+	u64	error_frames;	/*  Errored frames		      */
+	u64	dropped_frames;	/*  Dropped frames		      */
+	u64	link_failures;	/*  Link Failure (LF) count	      */
+	u64	loss_of_syncs;	/*  Loss of sync count		      */
+	u64	loss_of_signals;/*  Loss of signal count	      */
+	u64	primseq_errs;	/*  Primitive sequence protocol err. */
+	u64	bad_os_count;	/*  Invalid ordered sets	      */
+	u64	err_enc_out;	/*  Encoding err nonframe_8b10b      */
+	u64	err_enc;	/*  Encoding err frame_8b10b	      */
 };
 
 /**
- * 		Eth Port statistics.
+ * Eth Physical Port statistics.
  */
 struct bfa_pport_eth_stats_s {
-	u64	secs_reset;	/*  seconds since stats is reset */
-	u64	frame_64;      /*  both rx and tx counter */
-	u64	frame_65_127;      /* both rx and tx counter */
-	u64	frame_128_255;     /* both rx and tx counter */
-	u64	frame_256_511;     /* both rx and tx counter */
-	u64	frame_512_1023;    /* both rx and tx counter */
-	u64	frame_1024_1518;   /* both rx and tx counter */
-	u64	frame_1519_1522;   /* both rx and tx counter */
-
-	u64	tx_bytes;
-	u64	tx_packets;
-	u64	tx_mcast_packets;
-	u64	tx_bcast_packets;
-	u64	tx_control_frame;
-	u64	tx_drop;
-	u64	tx_jabber;
-	u64	tx_fcs_error;
-	u64	tx_fragments;
-
-	u64	rx_bytes;
-	u64	rx_packets;
-	u64	rx_mcast_packets;
-	u64	rx_bcast_packets;
-	u64	rx_control_frames;
-	u64	rx_unknown_opcode;
-	u64	rx_drop;
-	u64	rx_jabber;
-	u64	rx_fcs_error;
-	u64	rx_alignment_error;
-	u64	rx_frame_length_error;
-	u64	rx_code_error;
-	u64	rx_fragments;
-
-	u64	rx_pause; /* BPC */
-	u64	rx_zero_pause; /*  BPC Pause cancellation */
-	u64	tx_pause;      /* BPC */
-	u64	tx_zero_pause; /*  BPC Pause cancellation */
-	u64	rx_fcoe_pause; /* BPC */
-	u64	rx_fcoe_zero_pause; /*  BPC Pause cancellation */
-	u64	tx_fcoe_pause;      /* BPC */
-	u64	tx_fcoe_zero_pause; /*  BPC Pause cancellation */
+	u64	secs_reset;	  /*  Seconds since stats is reset   */
+	u64	frame_64;	  /*  Frames 64 bytes		      */
+	u64	frame_65_127;	  /*  Frames 65-127 bytes	      */
+	u64	frame_128_255;	  /*  Frames 128-255 bytes	      */
+	u64	frame_256_511;	  /*  Frames 256-511 bytes	      */
+	u64	frame_512_1023;	  /*  Frames 512-1023 bytes	      */
+	u64	frame_1024_1518;  /*  Frames 1024-1518 bytes	      */
+	u64	frame_1519_1522;  /*  Frames 1519-1522 bytes	      */
+	u64	tx_bytes;	  /*  Tx bytes			      */
+	u64	tx_packets;	  /*  Tx packets		      */
+	u64	tx_mcast_packets; /*  Tx multicast packets	      */
+	u64	tx_bcast_packets; /*  Tx broadcast packets	      */
+	u64	tx_control_frame; /*  Tx control frame		      */
+	u64	tx_drop;	  /*  Tx drops			      */
+	u64	tx_jabber;	  /*  Tx jabber		      */
+	u64	tx_fcs_error;	  /*  Tx FCS error		      */
+	u64	tx_fragments;	  /*  Tx fragments		      */
+	u64	rx_bytes;	  /*  Rx bytes			      */
+	u64	rx_packets;	  /*  Rx packets		      */
+	u64	rx_mcast_packets; /*  Rx multicast packets	      */
+	u64	rx_bcast_packets; /*  Rx broadcast packets	      */
+	u64	rx_control_frames; /*  Rx control frames	      */
+	u64	rx_unknown_opcode; /*  Rx unknown opcode	      */
+	u64	rx_drop;	  /*  Rx drops			      */
+	u64	rx_jabber;	  /*  Rx jabber		      */
+	u64	rx_fcs_error;	  /*  Rx FCS errors		      */
+	u64	rx_alignment_error; /*  Rx alignment errors	      */
+	u64	rx_frame_length_error; /*  Rx frame len errors       */
+	u64	rx_code_error;	  /*  Rx code errors		      */
+	u64	rx_fragments;	  /*  Rx fragments		      */
+	u64	rx_pause;	  /*  Rx pause			      */
+	u64	rx_zero_pause;	  /*  Rx zero pause		      */
+	u64	tx_pause;	  /*  Tx pause			      */
+	u64	tx_zero_pause;	  /*  Tx zero pause		      */
+	u64	rx_fcoe_pause;	  /*  Rx fcoe pause		      */
+	u64	rx_fcoe_zero_pause; /*  Rx FCoE zero pause	      */
+	u64	tx_fcoe_pause;	  /*  Tx FCoE pause		      */
+	u64	tx_fcoe_zero_pause; /*  Tx FCoE zero pause	      */
 };
 
 /**
@@ -314,7 +320,7 @@ struct bfa_pport_eth_stats_s {
  */
 union bfa_pport_stats_u {
 	struct bfa_pport_fc_stats_s	fc;
-	struct bfa_pport_eth_stats_s 	eth;
+	struct bfa_pport_eth_stats_s	eth;
 };
 
 /**
@@ -347,6 +353,23 @@ struct bfa_pport_rnid_s {
 	u16          topologydiscoveryflags;
 };
 
+struct bfa_fcport_fcf_s {
+	wwn_t           name;           /*  FCF name                 */
+	wwn_t           fabric_name;    /*  Fabric Name              */
+	u8		fipenabled;	/*  FIP enabled or not       */
+	u8		fipfailed;	/*  FIP failed or not        */
+	u8		resv[2];
+	u8         pri;            /*  FCF priority             */
+	u8         version;        /*  FIP version used         */
+	u8         available;      /*  Available  for  login    */
+	u8         fka_disabled;   /*  FKA is disabled          */
+	u8         maxsz_verified; /*  FCoE max size verified   */
+	u8         fc_map[3];      /*  FC map                   */
+	u16        vlan;           /*  FCoE vlan tag/priority   */
+	u32        fka_adv_per;    /*  FIP  ka advert. period   */
+	struct mac_s    mac;            /*  FCF mac                  */
+};
+
 /**
  * 		Link state information
  */
@@ -355,7 +378,7 @@ struct bfa_pport_link_s {
 	u8         linkstate_rsn;	/*  bfa_pport_linkstate_rsn_t */
 	u8         topology;	/*  P2P/LOOP bfa_pport_topology */
 	u8         speed;		/*  Link speed (1/2/4/8 G) */
-	u32        linkstate_opt;	/*  Linkstate optional data (debug) */
+	u32        linkstate_opt;  /*  Linkstate optional data (debug) */
 	u8         trunked;	/*  Trunked or not (1 or 0) */
 	u8         resvd[3];
 	struct bfa_qos_attr_s  qos_attr;   /* QoS Attributes */
@@ -378,6 +401,7 @@ struct bfa_pport_link_s {
 			struct fc_alpabm_s     alpabm;	   /*  alpa bitmap */
 		} loop_info;
 	} tl;
+	struct bfa_fcport_fcf_s fcf;	/*  FCF information (for FCoE) */
 };
 
 #endif /* __BFA_DEFS_PPORT_H__ */
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_rport.h b/drivers/scsi/bfa/include/defs/bfa_defs_rport.h
index e0af59d..9f2faef 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_rport.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_rport.h
@@ -146,8 +146,8 @@ struct bfa_rport_qos_attr_s {
  * FCS remote port attributes returned in queries
  */
 struct bfa_rport_attr_s {
-	wwn_t           	nwwn;	/*  node wwn */
-	wwn_t           	pwwn;	/*  port wwn */
+	wwn_t       nwwn;		/*  node wwn */
+	wwn_t       pwwn;		/*  port wwn */
 	enum fc_cos cos_supported;	/*  supported class of services */
 	u32        	pid;	/*  port ID */
 	u32        	df_sz;	/*  Max payload size */
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_status.h b/drivers/scsi/bfa/include/defs/bfa_defs_status.h
index cdceaeb..1ff408d 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_status.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_status.h
@@ -178,10 +178,11 @@ enum bfa_status {
 	BFA_STATUS_IM_DUP_TEAM_NAME = 113, /*  Given team name already
 					    * exists */
 	BFA_STATUS_IM_ADAPT_ALREADY_IN_TEAM = 114, /*  Given adapter is part
-						    * of another team */
+						    * of another team or VLANS
+						    * exist */
 	BFA_STATUS_IM_ADAPT_HAS_VLANS = 115, /*  Adapter has VLANs configured.
-					      * Delete all VLANs before
-					      * creating team */
+					      * Delete all VLANs to become part
+					      * of team */
 	BFA_STATUS_IM_PVID_MISMATCH = 116, /*  Mismatching PVIDs configured
 					    * for adapters */
 	BFA_STATUS_IM_LINK_SPEED_MISMATCH = 117, /*  Mismatching link speeds
@@ -213,7 +214,8 @@ enum bfa_status {
 					     * loaded */
 	BFA_STATUS_CARD_TYPE_MISMATCH = 131, /*  Card type mismatch */
 	BFA_STATUS_BAD_ASICBLK = 132, /*  Bad ASIC block */
-	BFA_STATUS_NO_DRIVER = 133, /*  Storage/Ethernet driver not loaded */
+	BFA_STATUS_NO_DRIVER = 133, /*  Brocade adapter/driver not installed
+				     * or loaded */
 	BFA_STATUS_INVALID_MAC = 134, /*  Invalid mac address */
 	BFA_STATUS_IM_NO_VLAN = 135, /*  No VLANs configured on the adapter */
 	BFA_STATUS_IM_ETH_LB_FAILED = 136, /*  Ethernet loopback test failed */
@@ -228,8 +230,7 @@ enum bfa_status {
 	BFA_STATUS_IM_GET_INETCFG_FAILED = 142, /*  Acquiring Network Subsytem
 						 * handle Failed. Please try
 						 * after some time */
-	BFA_STATUS_IM_NOT_BOUND = 143, /*  Brocade 10G Ethernet Service is not
-					* Enabled on this port */
+	BFA_STATUS_IM_NOT_BOUND = 143, /*  IM driver is not active */
 	BFA_STATUS_INSUFFICIENT_PERMS = 144, /*  User doesn't have sufficient
 					      * permissions to execute the BCU
 					      * application */
@@ -242,6 +243,14 @@ enum bfa_status {
 					  * failed */
 	BFA_STATUS_IM_UNBIND_FAILED = 149, /* ! < IM Driver unbind operation
 					    * failed */
+	BFA_STATUS_IM_PORT_IN_TEAM = 150, /*  Port is already part of the
+					   * team */
+	BFA_STATUS_IM_VLAN_NOT_FOUND = 151, /*  VLAN ID doesn't exists */
+	BFA_STATUS_IM_TEAM_NOT_FOUND = 152, /*  Teaming configuration doesn't
+					     * exists */
+	BFA_STATUS_IM_TEAM_CFG_NOT_ALLOWED = 153, /*  Given settings are not
+						   * allowed for the current
+						   * Teaming mode */
 	BFA_STATUS_MAX_VAL		/*  Unknown error code */
 };
 #define bfa_status_t enum bfa_status
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_vf.h b/drivers/scsi/bfa/include/defs/bfa_defs_vf.h
index 3235be5..a4ce9a8 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_vf.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_vf.h
@@ -40,26 +40,21 @@ enum bfa_vf_state {
  * VF statistics
  */
 struct bfa_vf_stats_s {
-	u32        flogi_sent;	/*  Num FLOGIs sent 		*/
-	u32        flogi_rsp_err;	/*  FLOGI response errors 	*/
-	u32        flogi_acc_err;	/*  FLOGI accept errors 	*/
-	u32        flogi_accepts;	/*  FLOGI accepts received 	*/
-	u32        flogi_rejects;	/*  FLOGI rejects received 	*/
+	u32        flogi_sent;	/*  Num FLOGIs sent */
+	u32        flogi_rsp_err;	/*  FLOGI response errors */
+	u32        flogi_acc_err;	/*  FLOGI accept errors */
+	u32        flogi_accepts;	/*  FLOGI accepts received */
+	u32        flogi_rejects;	/*  FLOGI rejects received */
 	u32        flogi_unknown_rsp; /*  Unknown responses for FLOGI */
-	u32        flogi_alloc_wait; /*  Allocation waits prior to
-					   * sending FLOGI
-					   */
+	u32        flogi_alloc_wait;  /*  Allocation wait
+					    * prior to sending FLOGI */
 	u32        flogi_rcvd;	/*  FLOGIs received */
 	u32        flogi_rejected;	/*  Incoming FLOGIs rejected */
-	u32        fabric_onlines;	/*  Internal fabric online
-					 * notification sent to other
-					 * modules
-					 */
-	u32        fabric_offlines; /*  Internal fabric offline
-					  * notification sent to other
-					  * modules
-					  */
-	u32        resvd;
+	u32        fabric_onlines;	/*  Internal fabric online notification
+					 * sent to other modules */
+	u32        fabric_offlines; /*  Internal fabric offline notification
+					 * sent to other modules */
+	u32        resvd; /*  padding for 64 bit alignment */
 };
 
 /**
diff --git a/drivers/scsi/bfa/include/fcs/bfa_fcs.h b/drivers/scsi/bfa/include/fcs/bfa_fcs.h
index 627669c..fdefab2 100644
--- a/drivers/scsi/bfa/include/fcs/bfa_fcs.h
+++ b/drivers/scsi/bfa/include/fcs/bfa_fcs.h
@@ -24,50 +24,53 @@
 #include <bfa.h>
 #include <fcs/bfa_fcs_fabric.h>
 
-#define BFA_FCS_OS_STR_LEN  		64
+#define BFA_FCS_OS_STR_LEN		64
 
 struct bfa_fcs_stats_s {
 	struct {
-		u32        untagged; /*  untagged receive frames */
-		u32        tagged;	/*  tagged receive frames */
-		u32        vfid_unknown;	/*  VF id is unknown */
+		u32	untagged; /*  untagged receive frames */
+		u32	tagged;	/*  tagged receive frames */
+		u32	vfid_unknown;	/*  VF id is unknown */
 	} uf;
 };
 
 struct bfa_fcs_driver_info_s {
-	u8  version[BFA_VERSION_LEN];		/*  Driver Version */
-	u8  host_machine_name[BFA_FCS_OS_STR_LEN];
-	u8  host_os_name[BFA_FCS_OS_STR_LEN]; /*  OS name and version */
-	u8  host_os_patch[BFA_FCS_OS_STR_LEN];/*  patch or service pack */
-	u8  os_device_name[BFA_FCS_OS_STR_LEN]; /*  Driver Device Name */
+	u8	 version[BFA_VERSION_LEN];		/*  Driver Version */
+	u8	 host_machine_name[BFA_FCS_OS_STR_LEN];
+	u8	 host_os_name[BFA_FCS_OS_STR_LEN]; /*  OS name and version */
+	u8	 host_os_patch[BFA_FCS_OS_STR_LEN]; /*  patch or service pack */
+	u8	 os_device_name[BFA_FCS_OS_STR_LEN]; /*  Driver Device Name */
 };
 
 struct bfa_fcs_s {
-	struct bfa_s      *bfa;	/*  corresponding BFA bfa instance */
-	struct bfad_s         *bfad; /*  corresponding BDA driver instance */
+	struct bfa_s	  *bfa;	/*  corresponding BFA bfa instance */
+	struct bfad_s	      *bfad; /*  corresponding BDA driver instance */
 	struct bfa_log_mod_s  *logm;	/*  driver logging module instance */
 	struct bfa_trc_mod_s  *trcmod;	/*  tracing module */
 	struct bfa_aen_s      *aen;	/*  aen component */
-	bfa_boolean_t   vf_enabled;	/*  VF mode is enabled */
+	bfa_boolean_t	vf_enabled;	/*  VF mode is enabled */
+	bfa_boolean_t	fdmi_enabled;	/*  FDMI is enabled */
 	bfa_boolean_t min_cfg;		/* min cfg enabled/disabled */
-	u16        port_vfid;	/*  port default VF ID */
+	u16	port_vfid;	/*  port default VF ID */
 	struct bfa_fcs_driver_info_s driver_info;
 	struct bfa_fcs_fabric_s fabric; /*  base fabric state machine */
 	struct bfa_fcs_stats_s	stats;	/*  FCS statistics */
-	struct bfa_wc_s       	wc;	/*  waiting counter */
+	struct bfa_wc_s		wc;	/*  waiting counter */
 };
 
 /*
  * bfa fcs API functions
  */
-void bfa_fcs_init(struct bfa_fcs_s *fcs, struct bfa_s *bfa, struct bfad_s *bfad,
-			bfa_boolean_t min_cfg);
+void bfa_fcs_attach(struct bfa_fcs_s *fcs, struct bfa_s *bfa,
+			struct bfad_s *bfad, bfa_boolean_t min_cfg);
+void bfa_fcs_init(struct bfa_fcs_s *fcs);
 void bfa_fcs_driver_info_init(struct bfa_fcs_s *fcs,
-			struct bfa_fcs_driver_info_s *driver_info);
+			      struct bfa_fcs_driver_info_s *driver_info);
+void bfa_fcs_set_fdmi_param(struct bfa_fcs_s *fcs, bfa_boolean_t fdmi_enable);
 void bfa_fcs_exit(struct bfa_fcs_s *fcs);
 void bfa_fcs_trc_init(struct bfa_fcs_s *fcs, struct bfa_trc_mod_s *trcmod);
 void bfa_fcs_log_init(struct bfa_fcs_s *fcs, struct bfa_log_mod_s *logmod);
 void bfa_fcs_aen_init(struct bfa_fcs_s *fcs, struct bfa_aen_s *aen);
-void 	  	bfa_fcs_start(struct bfa_fcs_s *fcs);
+void bfa_fcs_start(struct bfa_fcs_s *fcs);
 
 #endif /* __BFA_FCS_H__ */
diff --git a/drivers/scsi/bfa/include/fcs/bfa_fcs_fabric.h b/drivers/scsi/bfa/include/fcs/bfa_fcs_fabric.h
index 08b79d5..c45042b 100644
--- a/drivers/scsi/bfa/include/fcs/bfa_fcs_fabric.h
+++ b/drivers/scsi/bfa/include/fcs/bfa_fcs_fabric.h
@@ -70,9 +70,8 @@ struct bfa_fcs_fabric_s {
 	struct bfa_wc_s        wc;	/*  wait counter for delete	*/
 	struct bfa_vf_stats_s  stats; 	/*  fabric/vf stats		*/
 	struct bfa_lps_s	*lps;	/*  lport login services	*/
-	u8	fabric_ip_addr[BFA_FCS_FABRIC_IPADDR_SZ];  /*  attached
-							    * fabric's ip addr
-							    */
+	u8	fabric_ip_addr[BFA_FCS_FABRIC_IPADDR_SZ];
+					/*  attached fabric's ip addr  */
 };
 
 #define bfa_fcs_fabric_npiv_capable(__f)    ((__f)->is_npiv)
diff --git a/drivers/scsi/bfa/include/fcs/bfa_fcs_lport.h b/drivers/scsi/bfa/include/fcs/bfa_fcs_lport.h
index 967ceb0..909818d 100644
--- a/drivers/scsi/bfa/include/fcs/bfa_fcs_lport.h
+++ b/drivers/scsi/bfa/include/fcs/bfa_fcs_lport.h
@@ -35,13 +35,6 @@ struct bfa_fcs_fabric_s;
 
 /*
 * @todo : need to move to a global config file.
- * Maximum Vports supported per physical port or vf.
- */
-#define BFA_FCS_MAX_VPORTS_SUPP_CB  255
-#define BFA_FCS_MAX_VPORTS_SUPP_CT  191
-
-/*
-* @todo : need to move to a global config file.
  * Maximum Rports supported per port (physical/logical).
  */
 #define BFA_FCS_MAX_RPORTS_SUPP  256	/* @todo : tentative value */
@@ -125,13 +118,13 @@ union bfa_fcs_port_topo_u {
 struct bfa_fcs_port_s {
 	struct list_head         qe;	/*  used by port/vport */
 	bfa_sm_t               sm;	/*  state machine */
-	struct bfa_fcs_fabric_s *fabric;/*  parent fabric */
-	struct bfa_port_cfg_s  port_cfg;/*  port configuration */
+	struct bfa_fcs_fabric_s *fabric;	/*  parent fabric */
+	struct bfa_port_cfg_s  port_cfg;	/*  port configuration */
 	struct bfa_timer_s link_timer;	/*  timer for link offline */
-	u32 pid:24;	/*  FC address */
-	u8  lp_tag;	/*  lport tag */
-	u16 num_rports;	/*  Num of r-ports */
-	struct list_head rport_q;	/*  queue of discovered r-ports */
+	u32        pid:24;		/*  FC address */
+	u8         lp_tag;		/*  lport tag */
+	u16        num_rports;	/*  Num of r-ports */
+	struct list_head	rport_q;/*  queue of discovered r-ports */
 	struct bfa_fcs_s *fcs;	/*  FCS instance */
 	union bfa_fcs_port_topo_u port_topo;	/*  fabric/loop/n2n details */
 	struct bfad_port_s *bfad_port;	/*  driver peer instance */
@@ -200,6 +193,8 @@ bfa_fcs_port_get_drvport(struct bfa_fcs_port_s *port)
 /**
  * bfa fcs port public functions
  */
+
+bfa_boolean_t   bfa_fcs_port_is_online(struct bfa_fcs_port_s *port);
 void bfa_fcs_cfg_base_port(struct bfa_fcs_s *fcs,
 			struct bfa_port_cfg_s *port_cfg);
 struct bfa_fcs_port_s *bfa_fcs_get_base_port(struct bfa_fcs_s *fcs);
@@ -219,8 +214,8 @@ void bfa_fcs_port_get_attr(struct bfa_fcs_port_s *port,
 void bfa_fcs_port_get_stats(struct bfa_fcs_port_s *fcs_port,
 			struct bfa_port_stats_s *port_stats);
 void bfa_fcs_port_clear_stats(struct bfa_fcs_port_s *fcs_port);
-enum bfa_pport_speed bfa_fcs_port_get_rport_max_speed(
-			struct bfa_fcs_port_s *port);
+enum bfa_pport_speed
+bfa_fcs_port_get_rport_max_speed(struct bfa_fcs_port_s *port);
 void bfa_fcs_port_enable_ipfc_roles(struct bfa_fcs_port_s *fcs_port);
 void bfa_fcs_port_disable_ipfc_roles(struct bfa_fcs_port_s *fcs_port);
 
diff --git a/drivers/scsi/bfa/include/fcs/bfa_fcs_rport.h b/drivers/scsi/bfa/include/fcs/bfa_fcs_rport.h
index 702b95b..a9e7667 100644
--- a/drivers/scsi/bfa/include/fcs/bfa_fcs_rport.h
+++ b/drivers/scsi/bfa/include/fcs/bfa_fcs_rport.h
@@ -99,6 +99,7 @@ struct bfa_fcs_rport_s *bfa_fcs_rport_lookup(struct bfa_fcs_port_s *port,
 struct bfa_fcs_rport_s *bfa_fcs_rport_lookup_by_nwwn(
 			struct bfa_fcs_port_s *port, wwn_t rnwwn);
 void bfa_fcs_rport_set_del_timeout(u8 rport_tmo);
+
 void bfa_fcs_rport_set_speed(struct bfa_fcs_rport_s *rport,
-			enum bfa_pport_speed speed);
+				enum bfa_pport_speed speed);
 #endif /* __BFA_FCS_RPORT_H__ */
diff --git a/drivers/scsi/bfa/include/fcs/bfa_fcs_vport.h b/drivers/scsi/bfa/include/fcs/bfa_fcs_vport.h
index cd33f2c..78811e4 100644
--- a/drivers/scsi/bfa/include/fcs/bfa_fcs_vport.h
+++ b/drivers/scsi/bfa/include/fcs/bfa_fcs_vport.h
@@ -29,13 +29,13 @@
 #include <fcb/bfa_fcb_vport.h>
 
 struct bfa_fcs_vport_s {
-	struct list_head		qe;		/*  queue elem	 */
+	struct list_head	qe;		/*  queue elem	*/
 	bfa_sm_t		sm;		/*  state machine	*/
 	bfa_fcs_lport_t		lport;		/*  logical port	*/
-	struct bfa_timer_s	timer;		/*  general purpose timer */
+	struct bfa_timer_s	timer;		/*  general purpose timer*/
 	struct bfad_vport_s	*vport_drv;	/*  Driver private	*/
 	struct bfa_vport_stats_s vport_stats;	/*  vport statistics	*/
-	struct bfa_lps_s	*lps;		/*  Lport login service */
+	struct bfa_lps_s	*lps;		/*  Lport login service*/
 	int			fdisc_retries;
 };
 
diff --git a/drivers/scsi/bfa/include/log/bfa_log_hal.h b/drivers/scsi/bfa/include/log/bfa_log_hal.h
index 0412aea..5f8f5e3 100644
--- a/drivers/scsi/bfa/include/log/bfa_log_hal.h
+++ b/drivers/scsi/bfa/include/log/bfa_log_hal.h
@@ -27,4 +27,10 @@
 	(((u32) BFA_LOG_HAL_ID << BFA_LOG_MODID_OFFSET) | 3)
 #define BFA_LOG_HAL_SM_ASSERT \
 	(((u32) BFA_LOG_HAL_ID << BFA_LOG_MODID_OFFSET) | 4)
+#define BFA_LOG_HAL_DRIVER_ERROR \
+	(((u32) BFA_LOG_HAL_ID << BFA_LOG_MODID_OFFSET) | 5)
+#define BFA_LOG_HAL_DRIVER_CONFIG_ERROR \
+	(((u32) BFA_LOG_HAL_ID << BFA_LOG_MODID_OFFSET) | 6)
+#define BFA_LOG_HAL_MBOX_ERROR \
+	(((u32) BFA_LOG_HAL_ID << BFA_LOG_MODID_OFFSET) | 7)
 #endif
diff --git a/drivers/scsi/bfa/include/log/bfa_log_linux.h b/drivers/scsi/bfa/include/log/bfa_log_linux.h
index 317c054..cd0c54c 100644
--- a/drivers/scsi/bfa/include/log/bfa_log_linux.h
+++ b/drivers/scsi/bfa/include/log/bfa_log_linux.h
@@ -20,25 +20,41 @@
 #define	__BFA_LOG_LINUX_H__
 #include  <cs/bfa_log.h>
 #define BFA_LOG_LINUX_DEVICE_CLAIMED \
-		(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 1)
+	(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 1)
 #define BFA_LOG_LINUX_HASH_INIT_FAILED \
-		(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 2)
+	(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 2)
 #define BFA_LOG_LINUX_SYSFS_FAILED \
-		(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 3)
+	(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 3)
 #define BFA_LOG_LINUX_MEM_ALLOC_FAILED \
-		(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 4)
+	(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 4)
 #define BFA_LOG_LINUX_DRIVER_REGISTRATION_FAILED \
-		(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 5)
+	(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 5)
 #define BFA_LOG_LINUX_ITNIM_FREE \
-		(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 6)
+	(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 6)
 #define BFA_LOG_LINUX_ITNIM_ONLINE \
-		(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 7)
+	(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 7)
 #define BFA_LOG_LINUX_ITNIM_OFFLINE \
-		(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 8)
+	(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 8)
 #define BFA_LOG_LINUX_SCSI_HOST_FREE \
-		(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 9)
+	(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 9)
 #define BFA_LOG_LINUX_SCSI_ABORT \
-		(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 10)
+	(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 10)
 #define BFA_LOG_LINUX_SCSI_ABORT_COMP \
-		(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 11)
+	(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 11)
+#define BFA_LOG_LINUX_DRIVER_CONFIG_ERROR \
+	(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 12)
+#define BFA_LOG_LINUX_BNA_STATE_MACHINE \
+	(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 13)
+#define BFA_LOG_LINUX_IOC_ERROR \
+	(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 14)
+#define BFA_LOG_LINUX_RESOURCE_ALLOC_ERROR \
+	(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 15)
+#define BFA_LOG_LINUX_RING_BUFFER_ERROR \
+	(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 16)
+#define BFA_LOG_LINUX_DRIVER_ERROR \
+	(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 17)
+#define BFA_LOG_LINUX_DRIVER_DIAG \
+	(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 18)
+#define BFA_LOG_LINUX_DRIVER_AEN \
+	(((u32) BFA_LOG_LINUX_ID << BFA_LOG_MODID_OFFSET) | 19)
 #endif
diff --git a/drivers/scsi/bfa/include/protocol/ct.h b/drivers/scsi/bfa/include/protocol/ct.h
index c8648bc..72da96e 100644
--- a/drivers/scsi/bfa/include/protocol/ct.h
+++ b/drivers/scsi/bfa/include/protocol/ct.h
@@ -22,7 +22,7 @@
 
 #pragma pack(1)
 
-struct ct_hdr_s{
+struct ct_hdr_s {
 	u32	rev_id:8;	/* Revision of the CT */
 	u32	in_id:24;	/* Initiator Id */
 	u32	gs_type:8;	/* Generic service Type */
@@ -37,6 +37,7 @@ struct ct_hdr_s{
 	u32	vendor_unq:8;	/* vendor unique */
 };
 
+
 /*
  * defines for the Revision
  */
@@ -159,19 +160,20 @@ enum {
 	GS_RFF_ID	= 0x021F,	/* Register FC4 Feature		*/
 };
 
-struct fcgs_id_req_s{
+struct fcgs_id_req_s {
 	u32	rsvd:8;
 	u32	dap:24;	/* port identifier */
 };
+
 #define fcgs_gpnid_req_t struct fcgs_id_req_s
 #define fcgs_gnnid_req_t struct fcgs_id_req_s
 #define fcgs_gspnid_req_t struct fcgs_id_req_s
 
-struct fcgs_gidpn_req_s{
+struct fcgs_gidpn_req_s {
 	wwn_t	port_name;	/* port wwn */
 };
 
-struct fcgs_gidpn_resp_s{
+struct fcgs_gidpn_resp_s {
 	u32	rsvd:8;
 	u32	dap:24;	/* port identifier */
 };
@@ -192,23 +194,23 @@ struct fcgs_rftid_req_s {
 #define FC_GS_FCP_FC4_FEATURE_INITIATOR  0x02
 #define FC_GS_FCP_FC4_FEATURE_TARGET	 0x01
 
-struct fcgs_rffid_req_s{
+struct fcgs_rffid_req_s {
     u32    rsvd:8;
     u32    dap:24;		/* port identifier	*/
     u32    rsvd1:16;
-    u32    fc4ftr_bits:8;	/* fc4 feature bits	*/
-    u32    fc4_type:8;	/* corresponding FC4 Type */
+    u32    fc4ftr_bits:8;		/* fc4 feature bits	*/
+    u32    fc4_type:8;		/* corresponding FC4 Type */
 };
 
 /**
  * GID_FT Request
  */
-struct fcgs_gidft_req_s{
+struct fcgs_gidft_req_s {
 	u8	reserved;
 	u8	domain_id;	/* domain, 0 - all fabric */
 	u8	area_id;	/* area, 0 - whole domain */
 	u8	fc4_type;	/* FC_TYPE_FCP for SCSI devices */
-};				/* GID_FT Request */
+};						/* GID_FT Request */
 
 /**
  * GID_FT Response
@@ -217,12 +219,12 @@ struct fcgs_gidft_resp_s {
 	u8		last:1;	/* last port identifier flag */
 	u8		reserved:7;
 	u32	pid:24;	/* port identifier */
-};				/* GID_FT Response */
+};						/* GID_FT Response */
 
 /**
  * RSPN_ID
  */
-struct fcgs_rspnid_req_s{
+struct fcgs_rspnid_req_s {
 	u32	rsvd:8;
 	u32	dap:24;		/* port identifier */
 	u8		spn_len;	/* symbolic port name length */
@@ -232,7 +234,7 @@ struct fcgs_rspnid_req_s{
 /**
  * RPN_ID
  */
-struct fcgs_rpnid_req_s{
+struct fcgs_rpnid_req_s {
 	u32	rsvd:8;
 	u32	port_id:24;
 	wwn_t		port_name;
@@ -241,7 +243,7 @@ struct fcgs_rpnid_req_s{
 /**
  * RNN_ID
  */
-struct fcgs_rnnid_req_s{
+struct fcgs_rnnid_req_s {
 	u32	rsvd:8;
 	u32	port_id:24;
 	wwn_t		node_name;
@@ -250,7 +252,7 @@ struct fcgs_rnnid_req_s{
 /**
  * RCS_ID
  */
-struct fcgs_rcsid_req_s{
+struct fcgs_rcsid_req_s {
 	u32	rsvd:8;
 	u32	port_id:24;
 	u32	cos;
@@ -259,7 +261,7 @@ struct fcgs_rcsid_req_s{
 /**
  * RPT_ID
  */
-struct fcgs_rptid_req_s{
+struct fcgs_rptid_req_s {
 	u32	rsvd:8;
 	u32	port_id:24;
 	u32	port_type:8;
@@ -269,7 +271,7 @@ struct fcgs_rptid_req_s{
 /**
  * GA_NXT Request
  */
-struct fcgs_ganxt_req_s{
+struct fcgs_ganxt_req_s {
 	u32	rsvd:8;
 	u32	port_id:24;
 };
@@ -277,7 +279,7 @@ struct fcgs_ganxt_req_s{
 /**
  * GA_NXT Response
  */
-struct fcgs_ganxt_rsp_s{
+struct fcgs_ganxt_rsp_s {
 	u32	port_type:8;	/* Port Type */
 	u32	port_id:24;	/* Port Identifier */
 	wwn_t		port_name;	/* Port Name */
@@ -321,7 +323,7 @@ enum {
 /*
 * Port Value : Could be a Port id or wwn
  */
-union fcgs_port_val_u{
+union fcgs_port_val_u {
 	u32	nport_id;
 	wwn_t		nport_wwn;
 };
@@ -355,7 +357,7 @@ enum {
 /*
  * Ftrace Request
  */
-struct fcgs_ftrace_req_s{
+struct fcgs_ftrace_req_s {
 	u32	revision;
 	u16	src_port_tag;	/* Source Port tag */
 	u16	src_port_len;	/* Source Port len */
@@ -372,7 +374,7 @@ struct fcgs_ftrace_req_s{
 /*
  * Path info structure
  */
-struct fcgs_ftrace_path_info_s{
+struct fcgs_ftrace_path_info_s {
 	wwn_t		switch_name;		/* Switch WWN */
 	u32	domain_id;
 	wwn_t		ingress_port_name;	/* Ingress ports wwn */
@@ -388,7 +390,7 @@ struct fcgs_ftrace_path_info_s{
 /*
  * Ftrace Acc Response
  */
-struct fcgs_ftrace_resp_s{
+struct fcgs_ftrace_resp_s {
 	u32	revision;
 	u32	token;
 	u8		vendor_id[8];		/* T10 Vendor Identifier */
@@ -409,7 +411,7 @@ struct fcgs_ftrace_resp_s{
 /*
  * FC Ping Request
  */
-struct fcgs_fcping_req_s{
+struct fcgs_fcping_req_s {
 	u32	revision;
 	u16	port_tag;
 	u16	port_len;	/* Port len */
@@ -420,7 +422,7 @@ struct fcgs_fcping_req_s{
 /*
  * FC Ping Response
  */
-struct fcgs_fcping_resp_s{
+struct fcgs_fcping_resp_s {
 	u32	token;
 };
 
@@ -435,26 +437,26 @@ enum {
  * ZS GZME request
  */
 #define ZS_GZME_ZNAMELEN	32
-struct zs_gzme_req_s{
+struct zs_gzme_req_s {
 	u8	znamelen;
 	u8	rsvd[3];
 	u8	zname[ZS_GZME_ZNAMELEN];
 };
 
-enum zs_mbr_type{
+enum zs_mbr_type {
 	ZS_MBR_TYPE_PWWN	= 1,
 	ZS_MBR_TYPE_DOMPORT	= 2,
 	ZS_MBR_TYPE_PORTID	= 3,
 	ZS_MBR_TYPE_NWWN	= 4,
 };
 
-struct zs_mbr_wwn_s{
+struct  zs_mbr_wwn_s {
 	u8	mbr_type;
 	u8	rsvd[3];
 	wwn_t	wwn;
 };
 
-struct zs_query_resp_s{
+struct zs_query_resp_s {
 	u32	nmbrs;	/*  number of zone members */
 	struct zs_mbr_wwn_s	mbr[1];
 };
diff --git a/drivers/scsi/bfa/include/protocol/fc.h b/drivers/scsi/bfa/include/protocol/fc.h
index 14969ee..8da7d34 100644
--- a/drivers/scsi/bfa/include/protocol/fc.h
+++ b/drivers/scsi/bfa/include/protocol/fc.h
@@ -50,6 +50,11 @@ struct fchs_s {
 
 	u32        ro;		/* relative offset */
 };
+
+#define FC_SOF_LEN		4
+#define FC_EOF_LEN		4
+#define FC_CRC_LEN		4
+
 /*
  * Fibre Channel BB_E Header Structure
  */
@@ -138,7 +143,7 @@ enum {
 	FC_TYPE_MAX		= 256,	/* 256 FC-4 types */
 };
 
-struct fc_fc4types_s{
+struct fc_fc4types_s {
 	u8         bits[FC_TYPE_MAX / 8];
 };
 
@@ -196,9 +201,9 @@ enum {
 /*
  * generic ELS command
  */
-struct fc_els_cmd_s{
-	u32        els_code:8;	/* ELS Command Code */
-	u32        reserved:24;
+struct fc_els_cmd_s {
+u32        els_code:8;	/* ELS Command Code */
+u32        reserved:24;
 };
 
 /*
@@ -267,7 +272,7 @@ enum {
  * N_Port PLOGI Common Service Parameters.
  * FC-PH-x. Figure-76. pg. 308.
  */
-struct fc_plogi_csp_s{
+struct fc_plogi_csp_s {
 	u8         verhi;	/* FC-PH high version */
 	u8         verlo;	/* FC-PH low version */
 	u16        bbcred;	/* BB_Credit */
@@ -321,7 +326,7 @@ struct fc_plogi_csp_s{
  * N_Port PLOGI Class Specific Parameters.
  * FC-PH-x. Figure 78. pg. 318.
  */
-struct fc_plogi_clp_s{
+struct fc_plogi_clp_s {
 #ifdef __BIGENDIAN
 	u32        class_valid:1;
 	u32        intermix:1;	/* class intermix supported if set =1.
@@ -356,14 +361,15 @@ struct fc_plogi_clp_s{
 	u32        reserved8:16;
 };
 
-#define FLOGI_VVL_BRCD    0x42524344 /* ASCII value for each character in
-				      * string "BRCD" */
+#define FLOGI_VVL_BRCD    0x42524344 /* ASCII value for each character
+				      * in string "BRCD"
+				      */
 
 /*
  * PLOGI els command and reply payload
  */
-struct fc_logi_s{
-	struct fc_els_cmd_s els_cmd;	/* ELS command code */
+struct fc_logi_s {
+	struct fc_els_cmd_s    els_cmd;	/* ELS command code */
 	struct fc_plogi_csp_s  csp;		/* common service params */
 	wwn_t           port_name;
 	wwn_t           node_name;
@@ -377,7 +383,7 @@ struct fc_logi_s{
 /*
  * LOGO els command payload
  */
-struct fc_logo_s{
+struct fc_logo_s {
 	struct fc_els_cmd_s    els_cmd;	/* ELS command code */
 	u32        res1:8;
 	u32        nport_id:24;	/* N_Port identifier of source */
@@ -400,7 +406,7 @@ struct fc_adisc_s {
 /*
  * Exchange status block
  */
-struct fc_exch_status_blk_s{
+struct fc_exch_status_blk_s {
 	u32        oxid:16;
 	u32        rxid:16;
 	u32        res1:8;
@@ -429,9 +435,9 @@ struct fc_res_s {
 /*
  * RES els accept payload
  */
-struct fc_res_acc_s{
-	struct fc_els_cmd_s els_cmd;	/* ELS command code */
-	struct fc_exch_status_blk_s fc_exch_blk; /* Exchange status block */
+struct fc_res_acc_s {
+	struct fc_els_cmd_s	els_cmd;	/* ELS command code */
+	struct fc_exch_status_blk_s fc_exch_blk;/* Exchange status block */
 };
 
 /*
@@ -485,7 +491,7 @@ struct fc_rsi_s {
  * structure for PRLI paramater pages, both request & response
  * see FC-PH-X table 113 & 115 for explanation also FCP table 8
  */
-struct fc_prli_params_s{
+struct fc_prli_params_s {
 	u32        reserved:16;
 #ifdef __BIGENDIAN
 	u32        reserved1:5;
@@ -526,7 +532,7 @@ enum {
 	FC_PRLI_ACC_PREDEF_IMG = 0x5,	/* predefined image - no prli needed */
 };
 
-struct fc_prli_params_page_s{
+struct fc_prli_params_page_s {
 	u32        type:8;
 	u32        codext:8;
 #ifdef __BIGENDIAN
@@ -546,13 +552,13 @@ struct fc_prli_params_page_s{
 
 	u32        origprocas;
 	u32        rspprocas;
-	struct fc_prli_params_s  servparams;
+	struct fc_prli_params_s servparams;
 };
 
 /*
  * PRLI request and accept payload, FC-PH-X tables 112 & 114
  */
-struct fc_prli_s{
+struct fc_prli_s {
 	u32        command:8;
 	u32        pglen:8;
 	u32        pagebytes:16;
@@ -562,7 +568,7 @@ struct fc_prli_s{
 /*
  * PRLO logout params page
  */
-struct fc_prlo_params_page_s{
+struct fc_prlo_params_page_s {
 	u32        type:8;
 	u32        type_ext:8;
 #ifdef __BIGENDIAN
@@ -587,7 +593,7 @@ struct fc_prlo_params_page_s{
 /*
  * PRLO els command payload
  */
-struct fc_prlo_s{
+struct fc_prlo_s {
 	u32        	command:8;
 	u32        	page_len:8;
 	u32        	payload_len:16;
@@ -597,7 +603,7 @@ struct fc_prlo_s{
 /*
  * PRLO Logout response parameter page
  */
-struct fc_prlo_acc_params_page_s{
+struct fc_prlo_acc_params_page_s {
 	u32        type:8;
 	u32        type_ext:8;
 
@@ -623,7 +629,7 @@ struct fc_prlo_acc_params_page_s{
 /*
  * PRLO els command ACC payload
  */
-struct fc_prlo_acc_s{
+struct fc_prlo_acc_s {
 	u32        command:8;
 	u32        page_len:8;
 	u32        payload_len:16;
@@ -645,7 +651,7 @@ enum {
 	FC_VU_SCR_REG_FUNC_FABRIC_NAME_CHANGE = 0x01
 };
 
-struct fc_scr_s{
+struct fc_scr_s {
 	u32 command:8;
 	u32 res:24;
 	u32 vu_reg_func:8; /* Vendor Unique Registrations */
@@ -717,7 +723,7 @@ enum {
 /*
  * RRQ els command payload
  */
-struct fc_rrq_s{
+struct fc_rrq_s {
 	struct fc_els_cmd_s    els_cmd;	/* ELS command code */
 	u32        res1:8;
 	u32        s_id:24;	/* exchange originator S_ID */
@@ -731,7 +737,7 @@ struct fc_rrq_s{
 /*
  * ABTS BA_ACC reply payload
  */
-struct fc_ba_acc_s{
+struct fc_ba_acc_s {
 	u32        seq_id_valid:8;	/* set to 0x00 for Abort Exchange */
 	u32        seq_id:8;	/* invalid for Abort Exchange */
 	u32        res2:16;
@@ -744,7 +750,7 @@ struct fc_ba_acc_s{
 /*
  * ABTS BA_RJT reject payload
  */
-struct fc_ba_rjt_s{
+struct fc_ba_rjt_s {
 	u32        res1:8;		/* Reserved */
 	u32        reason_code:8;	/* reason code for reject */
 	u32        reason_expl:8;	/* reason code explanation */
@@ -754,9 +760,9 @@ struct fc_ba_rjt_s{
 /*
  * TPRLO logout parameter page
  */
-struct fc_tprlo_params_page_s{
-	u32        type:8;
-	u32        type_ext:8;
+struct fc_tprlo_params_page_s {
+u32        type:8;
+u32        type_ext:8;
 
 #ifdef __BIGENDIAN
 	u32        opa_valid:1;
@@ -782,7 +788,7 @@ struct fc_tprlo_params_page_s{
 /*
  * TPRLO ELS command payload
  */
-struct fc_tprlo_s{
+struct fc_tprlo_s {
 	u32        command:8;
 	u32        page_len:8;
 	u32        payload_len:16;
@@ -790,7 +796,7 @@ struct fc_tprlo_s{
 	struct fc_tprlo_params_page_s tprlo_params[1];
 };
 
-enum fc_tprlo_type{
+enum fc_tprlo_type {
 	FC_GLOBAL_LOGO = 1,
 	FC_TPR_LOGO
 };
@@ -798,7 +804,7 @@ enum fc_tprlo_type{
 /*
  * TPRLO els command ACC payload
  */
-struct fc_tprlo_acc_s{
+struct fc_tprlo_acc_s {
 	u32	command:8;
 	u32	page_len:8;
 	u32	payload_len:16;
@@ -810,21 +816,21 @@ struct fc_tprlo_acc_s{
  */
 #define FC_RSCN_PGLEN	0x4
 
-enum fc_rscn_format{
+enum fc_rscn_format {
 	FC_RSCN_FORMAT_PORTID	= 0x0,
 	FC_RSCN_FORMAT_AREA	= 0x1,
 	FC_RSCN_FORMAT_DOMAIN	= 0x2,
 	FC_RSCN_FORMAT_FABRIC	= 0x3,
 };
 
-struct fc_rscn_event_s{
+struct fc_rscn_event_s {
 	u32        format:2;
 	u32        qualifier:4;
 	u32        resvd:2;
 	u32        portid:24;
 };
 
-struct fc_rscn_pl_s{
+struct fc_rscn_pl_s {
 	u8         command;
 	u8         pagelen;
 	u16        payldlen;
@@ -863,7 +869,7 @@ struct fc_echo_s {
 /*
  * RNID els command payload
  */
-struct fc_rnid_cmd_s{
+struct fc_rnid_cmd_s {
 	struct fc_els_cmd_s    els_cmd;
 	u32        node_id_data_format:8;
 	u32        reserved:24;
@@ -873,12 +879,12 @@ struct fc_rnid_cmd_s{
  * RNID els response payload
  */
 
-struct fc_rnid_common_id_data_s{
+struct fc_rnid_common_id_data_s {
 	wwn_t           port_name;
 	wwn_t           node_name;
 };
 
-struct fc_rnid_general_topology_data_s{
+struct fc_rnid_general_topology_data_s {
 	u32        vendor_unique[4];
 	u32        asso_type;
 	u32        phy_port_num;
@@ -891,7 +897,7 @@ struct fc_rnid_general_topology_data_s{
 	u32        vendor_specific:16;
 };
 
-struct fc_rnid_acc_s{
+struct fc_rnid_acc_s {
 	struct fc_els_cmd_s    els_cmd;
 	u32        node_id_data_format:8;
 	u32        common_id_data_length:8;
@@ -915,7 +921,7 @@ struct fc_rnid_acc_s{
 #define RNID_ASSOCIATED_TYPE_VIRTUALIZATION_DEVICE      0x00000003
 #define RNID_ASSOCIATED_TYPE_MULTI_FUNCTION_DEVICE      0x000000FF
 
-enum fc_rpsc_speed_cap{
+enum fc_rpsc_speed_cap {
 	RPSC_SPEED_CAP_1G = 0x8000,
 	RPSC_SPEED_CAP_2G = 0x4000,
 	RPSC_SPEED_CAP_4G = 0x2000,
@@ -926,7 +932,7 @@ enum fc_rpsc_speed_cap{
 	RPSC_SPEED_CAP_UNKNOWN = 0x0001,
 };
 
-enum fc_rpsc_op_speed_s{
+enum fc_rpsc_op_speed_s {
 	RPSC_OP_SPEED_1G = 0x8000,
 	RPSC_OP_SPEED_2G = 0x4000,
 	RPSC_OP_SPEED_4G = 0x2000,
@@ -937,24 +943,24 @@ enum fc_rpsc_op_speed_s{
 	RPSC_OP_SPEED_NOT_EST = 0x0001,	/*! speed not established */
 };
 
-struct fc_rpsc_speed_info_s{
-	u16        port_speed_cap;	/*! see fc_rpsc_speed_cap_t */
-	u16        port_op_speed;	/*! see fc_rpsc_op_speed_t */
+struct fc_rpsc_speed_info_s {
+	u16        port_speed_cap;	/*! see struct fc_rpsc_speed_cap */
+	u16        port_op_speed;	/*! see enum fc_rpsc_op_speed_s */
 };
 
-enum link_e2e_beacon_subcmd{
+enum link_e2e_beacon_subcmd {
 	LINK_E2E_BEACON_ON = 1,
 	LINK_E2E_BEACON_OFF = 2
 };
 
-enum beacon_type{
+enum beacon_type {
 	BEACON_TYPE_NORMAL	= 1,	/*! Normal Beaconing. Green */
 	BEACON_TYPE_WARN	= 2,	/*! Warning Beaconing. Yellow/Amber */
 	BEACON_TYPE_CRITICAL	= 3	/*! Critical Beaconing. Red */
 };
 
 struct link_e2e_beacon_param_s {
-	u8         beacon_type;	/* Beacon Type. See beacon_type_t */
+	u8         beacon_type;	/* Beacon Type. See enum beacon_type */
 	u8         beacon_frequency;
 					/* Beacon frequency. Number of blinks
 					 * per 10 seconds
@@ -975,10 +981,10 @@ struct link_e2e_beacon_param_s {
 /*
  * Link E2E beacon request/good response format. For LS_RJTs use fc_ls_rjt_t
  */
-struct link_e2e_beacon_req_s{
+struct link_e2e_beacon_req_s {
 	u32        ls_code;	/*! FC_ELS_E2E_LBEACON in requests *
 					 *or FC_ELS_ACC in good replies */
-	u32        ls_sub_cmd;	/*! See link_e2e_beacon_subcmd_t */
+	u32        ls_sub_cmd;	/*! See enum link_e2e_beacon_subcmd */
 	struct link_e2e_beacon_param_s beacon_parm;
 };
 
@@ -987,14 +993,14 @@ struct link_e2e_beacon_req_s{
  * all the ports within that domain (TODO - I don't think FOS implements
  * this...).
  */
-struct fc_rpsc_cmd_s{
+struct fc_rpsc_cmd_s {
 	struct fc_els_cmd_s    els_cmd;
 };
 
 /*
  * RPSC Acc
  */
-struct fc_rpsc_acc_s{
+struct fc_rpsc_acc_s {
 	u32        command:8;
 	u32        rsvd:8;
 	u32        num_entries:16;
@@ -1007,7 +1013,7 @@ struct fc_rpsc_acc_s{
  */
 #define FC_BRCD_TOKEN    0x42524344
 
-struct fc_rpsc2_cmd_s{
+struct fc_rpsc2_cmd_s {
 	struct fc_els_cmd_s    els_cmd;
 	u32       	token;
 	u16     	resvd;
@@ -1018,18 +1024,17 @@ struct fc_rpsc2_cmd_s{
 	} pid_list[1];
 };
 
-enum fc_rpsc2_port_type{
+enum fc_rpsc2_port_type {
 	RPSC2_PORT_TYPE_UNKNOWN = 0,
 	RPSC2_PORT_TYPE_NPORT   = 1,
 	RPSC2_PORT_TYPE_NLPORT  = 2,
 	RPSC2_PORT_TYPE_NPIV_PORT  = 0x5f,
 	RPSC2_PORT_TYPE_NPORT_TRUNK  = 0x6f,
 };
-
 /*
  * RPSC2 portInfo entry structure
  */
-struct fc_rpsc2_port_info_s{
+struct fc_rpsc2_port_info_s {
     u32    pid;        /* PID */
     u16    resvd1;
     u16    index;      /* port number / index */
@@ -1041,17 +1046,17 @@ struct fc_rpsc2_port_info_s{
 /*
  * RPSC2 Accept payload
  */
-struct fc_rpsc2_acc_s{
+struct fc_rpsc2_acc_s {
 	u8        els_cmd;
 	u8        resvd;
-	u16       num_pids;  /* Number of pids in the request */
-	struct fc_rpsc2_port_info_s  port_info[1];    /* port information */
+    u16       num_pids;  /* Number of pids in the request */
+    struct fc_rpsc2_port_info_s  port_info[1];    /* port information */
 };
 
 /**
  * bit fields so that multiple classes can be specified
  */
-enum fc_cos{
+enum fc_cos {
 	FC_CLASS_2	= 0x04,
 	FC_CLASS_3	= 0x08,
 	FC_CLASS_2_3	= 0x0C,
@@ -1060,11 +1065,11 @@ enum fc_cos{
 /*
  * symbolic name
  */
-struct fc_symname_s{
+struct fc_symname_s {
 	u8         symname[FC_SYMNAME_MAX];
 };
 
-struct fc_alpabm_s{
+struct fc_alpabm_s {
 	u8         alpa_bm[FC_ALPA_MAX / 8];
 };
 
@@ -1088,7 +1093,7 @@ struct fc_alpabm_s{
  * Virtual Fabric Tagging header format
  * @caution This is defined only in BIG ENDIAN format.
  */
-struct fc_vft_s{
+struct fc_vft_s {
 	u32        r_ctl:8;
 	u32        ver:2;
 	u32        type:4;
diff --git a/drivers/scsi/bfa/include/protocol/fc_sp.h b/drivers/scsi/bfa/include/protocol/fc_sp.h
index 55bb0b3..37f5da6 100644
--- a/drivers/scsi/bfa/include/protocol/fc_sp.h
+++ b/drivers/scsi/bfa/include/protocol/fc_sp.h
@@ -22,7 +22,7 @@
 
 #pragma pack(1)
 
-enum auth_els_flags{
+enum auth_els_flags {
 	FC_AUTH_ELS_MORE_FRAGS_FLAG 	= 0x80,	/*! bit-7. More Fragments
 						 * Follow
 						 */
@@ -30,7 +30,7 @@ enum auth_els_flags{
 	FC_AUTH_ELS_SEQ_NUM_FLAG 	= 0x01 	/*! bit-0. Sequence Number */
 };
 
-enum auth_msg_codes{
+enum auth_msg_codes {
 	FC_AUTH_MC_AUTH_RJT		= 0x0A,	/*! Auth Reject */
 	FC_AUTH_MC_AUTH_NEG 		= 0x0B, /*! Auth Negotiate */
 	FC_AUTH_MC_AUTH_DONE 		= 0x0C, /*! Auth Done */
@@ -53,7 +53,7 @@ enum auth_msg_codes{
 	FC_AUTH_MC_IKE_INFO 		= 0x25, /*! IKE informational */
 };
 
-enum auth_proto_version{
+enum auth_proto_version {
 	FC_AUTH_PROTO_VER_1 	= 1,	/*! Protocol Version 1 */
 };
 
@@ -77,7 +77,7 @@ enum {
 	FC_START_TXN_ID         = 2,	/*! Starting transaction ID */
 };
 
-enum auth_proto_id{
+enum auth_proto_id {
 	FC_AUTH_PROTO_DHCHAP		= 0x00000001,
 	FC_AUTH_PROTO_FCAP 		= 0x00000002,
 	FC_AUTH_PROTO_FCPAP 		= 0x00000003,
@@ -85,20 +85,19 @@ enum auth_proto_id{
 	FC_AUTH_PROTO_IKEv2_AUTH 	= 0x00000005,
 };
 
-struct auth_name_s{
+struct auth_name_s {
 	u16	name_tag;	/*! Name Tag = 1 for Authentication */
 	u16	name_len;	/*! Name Length = 8 for Authentication
 					 */
 	wwn_t		name;  		/*! Name. TODO - is this PWWN */
 };
 
-
-enum auth_hash_func{
+enum auth_hash_func {
 	FC_AUTH_HASH_FUNC_MD5 		= 0x00000005,
 	FC_AUTH_HASH_FUNC_SHA_1 	= 0x00000006,
 };
 
-enum auth_dh_gid{
+enum auth_dh_gid {
 	FC_AUTH_DH_GID_0_DHG_NULL	= 0x00000000,
 	FC_AUTH_DH_GID_1_DHG_1024	= 0x00000001,
 	FC_AUTH_DH_GID_2_DHG_1280	= 0x00000002,
@@ -127,7 +126,6 @@ enum auth_neg_param_tags {
 	FC_AUTH_NEG_DHCHAP_DHG_ID_LIST 	= 0x0002,
 };
 
-
 struct dhchap_param_format_s {
 	u16	tag;		/*! Parameter Tag. See
 					 * auth_neg_param_tags_t
@@ -148,11 +146,11 @@ struct auth_proto_params_s {
 };
 
 struct auth_neg_msg_s {
-	struct auth_name_s	auth_ini_name;
+	struct auth_name_s		auth_ini_name;
 	u32		usable_auth_protos;
-	struct auth_proto_params_s proto_params[1]; /*! (1..usable_auth_proto)
-						     * protocol params
-						     */
+	struct auth_proto_params_s proto_params[1];/*! (1..usable_auth_proto)
+						    * protocol params
+						    */
 };
 
 struct auth_dh_val_s {
@@ -173,7 +171,6 @@ struct auth_dhchap_chal_msg_s {
 	/* ...followed by variable Challenge length/value and DH length/value */
 };
 
-
 enum auth_rjt_codes {
 	FC_AUTH_RJT_CODE_AUTH_FAILURE 	= 0x01,
 	FC_AUTH_RJT_CODE_LOGICAL_ERR	= 0x02,
@@ -184,7 +181,7 @@ enum auth_rjt_code_exps {
 	FC_AUTH_CEXP_DH_GROUP_NOT_USABLE 	= 0x02,
 	FC_AUTH_CEXP_HASH_FUNC_NOT_USABLE 	= 0x03,
 	FC_AUTH_CEXP_AUTH_XACT_STARTED		= 0x04,
-	FC_AUTH_CEXP_AUTH_FAILED 		= 0x05,
+	FC_AUTH_CEXP_AUTH_FAILED 			= 0x05,
 	FC_AUTH_CEXP_INCORRECT_PLD 		= 0x06,
 	FC_AUTH_CEXP_INCORRECT_PROTO_MSG 	= 0x07,
 	FC_AUTH_CEXP_RESTART_AUTH_PROTO 	= 0x08,
diff --git a/drivers/scsi/bfa/include/protocol/fcp.h b/drivers/scsi/bfa/include/protocol/fcp.h
index 9ade68a..1358101 100644
--- a/drivers/scsi/bfa/include/protocol/fcp.h
+++ b/drivers/scsi/bfa/include/protocol/fcp.h
@@ -31,7 +31,7 @@ enum {
 /*
  * SRR FC-4 LS payload
  */
-struct fc_srr_s{
+struct fc_srr_s {
 	u32	ls_cmd;
 	u32        ox_id:16;	/* ox-id */
 	u32        rx_id:16;	/* rx-id */
@@ -40,14 +40,13 @@ struct fc_srr_s{
 	u32        res:24;
 };
 
-
 /*
  * FCP_CMND definitions
  */
 #define FCP_CMND_CDB_LEN    16
 #define FCP_CMND_LUN_LEN    8
 
-struct fcp_cmnd_s{
+struct fcp_cmnd_s {
 	lun_t           lun;		/* 64-bit LU number */
 	u8         crn;		/* command reference number */
 #ifdef __BIGENDIAN
@@ -81,7 +80,7 @@ struct fcp_cmnd_s{
 /*
  * fcp_cmnd_t.iodir field values
  */
-enum fcp_iodir{
+enum fcp_iodir {
 	FCP_IODIR_NONE	= 0,
 	FCP_IODIR_WRITE = 1,
 	FCP_IODIR_READ	= 2,
@@ -105,7 +104,7 @@ enum {
 #ifndef BIT
 #define BIT(_x)	(1 << (_x))
 #endif
-enum fcp_tm_cmnd{
+enum fcp_tm_cmnd {
 	FCP_TM_ABORT_TASK_SET	= BIT(1),
 	FCP_TM_CLEAR_TASK_SET	= BIT(2),
 	FCP_TM_LUN_RESET	= BIT(4),
@@ -116,7 +115,7 @@ enum fcp_tm_cmnd{
 /*
  * FCP_XFER_RDY IU defines
  */
-struct fcp_xfer_rdy_s{
+struct fcp_xfer_rdy_s {
 	u32        data_ro;
 	u32        burst_len;
 	u32        reserved;
@@ -125,7 +124,7 @@ struct fcp_xfer_rdy_s{
 /*
  * FCP_RSP residue flags
  */
-enum fcp_residue{
+enum fcp_residue {
 	FCP_NO_RESIDUE = 0,	/* no residue */
 	FCP_RESID_OVER = 1,	/* more data left that was not sent */
 	FCP_RESID_UNDER = 2,	/* less data than requested */
@@ -140,13 +139,13 @@ enum {
 	FCP_RSPINFO_TM_FAILED = 5,
 };
 
-struct fcp_rspinfo_s{
+struct fcp_rspinfo_s {
 	u32        res0:24;
 	u32        rsp_code:8;	/* response code (as above) */
 	u32        res1;
 };
 
-struct fcp_resp_s{
+struct fcp_resp_s {
 	u32        reserved[2];	/* 2 words reserved */
 	u16        reserved2;
 #ifdef __BIGENDIAN
@@ -176,7 +175,7 @@ struct fcp_resp_s{
 #define fcp_snsinfo(__fcprsp)	(((u8 *)fcp_rspinfo(__fcprsp)) + 	\
 						fcp_rsplen(__fcprsp))
 
-struct fcp_cmnd_fr_s{
+struct fcp_cmnd_fr_s {
 	struct fchs_s          fchs;
 	struct fcp_cmnd_s      fcp;
 };
diff --git a/drivers/scsi/bfa/include/protocol/fdmi.h b/drivers/scsi/bfa/include/protocol/fdmi.h
index 6c05c26..ef43209 100644
--- a/drivers/scsi/bfa/include/protocol/fdmi.h
+++ b/drivers/scsi/bfa/include/protocol/fdmi.h
@@ -112,7 +112,7 @@ struct fdmi_attr_s {
  * HBA Attribute Block
  */
 struct fdmi_hba_attr_s {
-	u32        attr_count;	/* # of attributes */
+	u32        attr_count;		/* # of attributes */
 	struct fdmi_attr_s     hba_attr;	/* n attributes */
 };
 
@@ -128,7 +128,7 @@ struct fdmi_port_list_s {
  * Port Attribute Block
  */
 struct fdmi_port_attr_s {
-	u32        attr_count;	/* # of attributes */
+	u32        attr_count;		/* # of attributes */
 	struct fdmi_attr_s     port_attr;	/* n attributes */
 };
 
@@ -136,7 +136,7 @@ struct fdmi_port_attr_s {
  * FDMI Register HBA Attributes
  */
 struct fdmi_rhba_s {
-	wwn_t           hba_id;		/* HBA Identifier */
+	wwn_t           hba_id;			/* HBA Identifier */
 	struct fdmi_port_list_s port_list;	/* Registered Port List */
 	struct fdmi_hba_attr_s hba_attr_blk;	/* HBA attribute block */
 };
@@ -145,8 +145,8 @@ struct fdmi_rhba_s {
  * FDMI Register Port
  */
 struct fdmi_rprt_s {
-	wwn_t           hba_id;		/* HBA Identifier */
-	wwn_t           port_name;	/* Port wwn */
+	wwn_t           hba_id;			/* HBA Identifier */
+	wwn_t           port_name;		/* Port wwn */
 	struct fdmi_port_attr_s port_attr_blk;	/* Port Attr Block */
 };
 
@@ -154,7 +154,7 @@ struct fdmi_rprt_s {
  * FDMI Register Port Attributes
  */
 struct fdmi_rpa_s {
-	wwn_t           port_name;	/* port wwn */
+	wwn_t           port_name;		/* port wwn */
 	struct fdmi_port_attr_s port_attr_blk;	/* Port Attr Block */
 };
 
diff --git a/drivers/scsi/bfa/include/protocol/pcifw.h b/drivers/scsi/bfa/include/protocol/pcifw.h
deleted file mode 100644
index 6830dc3..0000000
--- a/drivers/scsi/bfa/include/protocol/pcifw.h
+++ /dev/null
@@ -1,75 +0,0 @@
-/*
- * Copyright (c) 2005-2009 Brocade Communications Systems, Inc.
- * All rights reserved
- * www.brocade.com
- *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License (GPL) Version 2 as
- * published by the Free Software Foundation
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- */
-
-/**
- *  pcifw.h PCI FW related headers
- */
-
-#ifndef __PCIFW_H__
-#define __PCIFW_H__
-
-#pragma pack(1)
-
-struct pnp_hdr_s{
-  u32	signature;	/* "$PnP" */
-  u8	rev;		/* Struct revision */
-  u8 	len;		/* Header structure len in multiples
-				 * of 16 bytes */
-  u16  off;		/* Offset to next header 00 if none */
-  u8	rsvd;		/* Reserved byte */
-  u8	cksum;		/* 8-bit checksum for this header */
-  u32	pnp_dev_id;	/* PnP Device Id */
-  u16  mfstr;		/* Pointer to manufacturer string */
-  u16	prstr;		/* Pointer to product string */
-  u8	devtype[3];	/* Device Type Code */
-  u8	devind;		/* Device Indicator */
-  u16	bcventr;	/* Bootstrap entry vector */
-  u16	rsvd2;		/* Reserved */
-  u16  sriv;		/* Static resource information vector */
-};
-
-struct pci_3_0_ds_s{
- u32	sig;   		/* Signature "PCIR" */
- u16	vendid;		/* Vendor ID */
- u16	devid;		/* Device ID */
- u16	devlistoff;	/* Device List Offset */
- u16	len;		/* PCI Data Structure Length */
- u8	rev;		/* PCI Data Structure Revision */
- u8	clcode[3];	/* Class Code */
- u16	imglen;		/* Code image length in multiples of
-				 * 512 bytes */
- u16	coderev;	/* Revision level of code/data */
- u8	codetype;	/* Code type 0x00 - BIOS */
- u8	indr;		/* Last image indicator */
- u16	mrtimglen;	/* Max Run Time Image Length */
- u16	cuoff;		/* Config Utility Code Header Offset */
- u16	dmtfclp;	/* DMTF CLP entry point offset */
-};
-
-struct pci_optrom_hdr_s{
- u16	sig;		/* Signature 0x55AA */
- u8	len;		/* Option ROM length in units of 512 bytes */
- u8	inivec[3];	/* Initialization vector */
- u8	rsvd[16];	/* Reserved field */
- u16	verptr;		/* Pointer to version string - private */
- u16	pcids;		/* Pointer to PCI data structure */
- u16	pnphdr;		/* Pointer to PnP expansion header */
-};
-
-#pragma pack()
-
-#endif
diff --git a/drivers/scsi/bfa/include/protocol/scsi.h b/drivers/scsi/bfa/include/protocol/scsi.h
index b220e6b..df35f26 100644
--- a/drivers/scsi/bfa/include/protocol/scsi.h
+++ b/drivers/scsi/bfa/include/protocol/scsi.h
@@ -26,7 +26,7 @@
  * generic SCSI cdb definition
  */
 #define SCSI_MAX_CDBLEN     16
-struct scsi_cdb_s{
+struct scsi_cdb_s {
 	u8         scsi_cdb[SCSI_MAX_CDBLEN];
 };
 
@@ -34,7 +34,7 @@ struct scsi_cdb_s{
  * scsi lun serial number definition
  */
 #define SCSI_LUN_SN_LEN     32
-struct scsi_lun_sn_s{
+struct scsi_lun_sn_s {
 	u8         lun_sn[SCSI_LUN_SN_LEN];
 };
 
@@ -81,7 +81,7 @@ enum {
 /*
  * SCSI START_STOP_UNIT command
  */
-struct scsi_start_stop_unit_s{
+struct scsi_start_stop_unit_s {
 	u8         opcode;
 #ifdef __BIGENDIAN
 	u8         lun:3;
@@ -111,7 +111,7 @@ struct scsi_start_stop_unit_s{
 /*
  * SCSI SEND_DIAGNOSTIC command
  */
-struct scsi_send_diagnostic_s{
+struct scsi_send_diagnostic_s {
 	u8         opcode;
 #ifdef __BIGENDIAN
 	u8         self_test_code:3;
@@ -138,7 +138,7 @@ struct scsi_send_diagnostic_s{
 /*
  * SCSI READ10/WRITE10 commands
  */
-struct scsi_rw10_s{
+struct scsi_rw10_s {
 	u8         opcode;
 #ifdef __BIGENDIAN
 	u8         lun:3;
@@ -184,7 +184,7 @@ struct scsi_rw10_s{
 /*
  * SCSI READ6/WRITE6 commands
  */
-struct scsi_rw6_s{
+struct scsi_rw6_s {
 	u8         opcode;
 #ifdef __BIGENDIAN
 	u8         lun:3;
@@ -211,7 +211,7 @@ struct scsi_rw6_s{
 /*
  * SCSI sequential (TAPE) wrtie command
  */
-struct scsi_tape_wr_s{
+struct scsi_tape_wr_s {
 	u8         opcode;
 #ifdef __BIGENDIAN
 	u8         rsvd:7;
@@ -244,7 +244,7 @@ struct scsi_tape_wr_s{
 /*
  * SCSI sense data format
  */
-struct scsi_sense_s{
+struct scsi_sense_s {
 #ifdef __BIGENDIAN
 	u8         valid:1;
 	u8         rsp_code:7;
@@ -386,7 +386,7 @@ struct scsi_sense_s{
  * SCSI INQUIRY
  * ------------------------------------------------------------*/
 
-struct scsi_inquiry_s{
+struct scsi_inquiry_s {
 	u8         opcode;
 #ifdef __BIGENDIAN
 	u8         lun:3;
@@ -405,19 +405,19 @@ struct scsi_inquiry_s{
 	u8         control;
 };
 
-struct scsi_inquiry_vendor_s{
+struct scsi_inquiry_vendor_s {
 	u8         vendor_id[8];
 };
 
-struct scsi_inquiry_prodid_s{
+struct scsi_inquiry_prodid_s {
 	u8         product_id[16];
 };
 
-struct scsi_inquiry_prodrev_s{
+struct scsi_inquiry_prodrev_s {
 	u8         product_rev[4];
 };
 
-struct scsi_inquiry_data_s{
+struct scsi_inquiry_data_s {
 #ifdef __BIGENDIAN
 	u8         peripheral_qual:3;	/* peripheral qualifier */
 	u8         device_type:5;		/* peripheral device type */
@@ -541,7 +541,7 @@ struct scsi_inquiry_data_s{
 /*
  * supported vital product data pages
  */
-struct scsi_inq_page_vpd_pages_s{
+struct scsi_inq_page_vpd_pages_s {
 #ifdef __BIGENDIAN
 	u8         peripheral_qual:3;
 	u8         device_type:5;
@@ -560,11 +560,11 @@ struct scsi_inq_page_vpd_pages_s{
  */
 #define SCSI_INQ_USN_LEN 32
 
-struct scsi_inq_usn_s{
+struct scsi_inq_usn_s {
 	char            usn[SCSI_INQ_USN_LEN];
 };
 
-struct scsi_inq_page_usn_s{
+struct scsi_inq_page_usn_s {
 #ifdef __BIGENDIAN
 	u8         peripheral_qual:3;
 	u8         device_type:5;
@@ -597,7 +597,7 @@ enum {
 	SCSI_INQ_ID_TYPE_OTHER = 4,
 };
 
-struct scsi_inq_dip_desc_s{
+struct scsi_inq_dip_desc_s {
 #ifdef __BIGENDIAN
 	u8         res0:4;
 	u8         code_set:4;
@@ -619,7 +619,7 @@ struct scsi_inq_dip_desc_s{
 /*
  * Device indentification page
  */
-struct scsi_inq_page_dev_ident_s{
+struct scsi_inq_page_dev_ident_s {
 #ifdef __BIGENDIAN
 	u8         peripheral_qual:3;
 	u8         device_type:5;
@@ -638,7 +638,7 @@ struct scsi_inq_page_dev_ident_s{
  * ------------------------------------------------------------
  */
 
-struct scsi_read_capacity_s{
+struct scsi_read_capacity_s {
 	u8         opcode;
 #ifdef __BIGENDIAN
 	u8         lun:3;
@@ -665,12 +665,12 @@ struct scsi_read_capacity_s{
 	u8         control;
 };
 
-struct scsi_read_capacity_data_s{
+struct scsi_read_capacity_data_s {
 	u32        max_lba;	/* maximum LBA available */
 	u32        block_length;	/* in bytes */
 };
 
-struct scsi_read_capacity16_data_s{
+struct scsi_read_capacity16_data_s {
 	u64        lba;	/* maximum LBA available */
 	u32        block_length;	/* in bytes */
 #ifdef __BIGENDIAN
@@ -678,18 +678,19 @@ struct scsi_read_capacity16_data_s{
 			p_type:3,
 			prot_en:1;
 	u8		reserved2:4,
-			lb_pbe:4;	/* logical blocks per physical block
-					 * exponent */
+			lb_pbe:4;	/* logical blocks per
+					 * physical block exponent */
 	u16	reserved3:2,
-			lba_align:14;	/* lowest aligned logical block
-					 * address */
+			lba_align:14;	/* lowest aligned logical
+					 * block address */
 #else
-	u16	lba_align:14,	/* lowest aligned logical block
-					 * address */
-			reserved3:2;
-	u8		lb_pbe:4,	/* logical blocks per physical block
-					 * exponent */
-			reserved2:4;
+	u16	lba_align:14,
+			reserved3:2;	/* lowest aligned logical
+					 * block address */
+
+	u8		lb_pbe:4,
+			reserved2:4;	/* logical blocks per
+					 * physical block exponent */
 	u8		prot_en:1,
 			p_type:3,
 			reserved1:4;
@@ -703,7 +704,7 @@ struct scsi_read_capacity16_data_s{
  * ------------------------------------------------------------
  */
 
-struct scsi_report_luns_s{
+struct scsi_report_luns_s {
 	u8         opcode;		/* A0h - REPORT LUNS opCode */
 	u8         reserved1[5];
 	u8         alloc_length[4];/* allocation length MSB first */
@@ -722,7 +723,7 @@ struct scsi_report_luns_s{
     (rl)->alloc_length[3] = (alloc_len) & 0xFF;     			\
 }
 
-struct scsi_report_luns_data_s{
+struct scsi_report_luns_data_s {
 	u32        lun_list_length;	/* length of LUN list length */
 	u32        reserved;
 	lun_t           lun[1];			/* first LUN in lun list */
@@ -741,7 +742,7 @@ enum {
 /*
  * SCSI Mode Select(6) cdb
  */
-struct scsi_mode_select6_s{
+struct scsi_mode_select6_s {
 	u8         opcode;
 #ifdef __BIGENDIAN
 	u8         reserved1:3;
@@ -762,7 +763,7 @@ struct scsi_mode_select6_s{
 /*
  * SCSI Mode Select(10) cdb
  */
-struct scsi_mode_select10_s{
+struct scsi_mode_select10_s {
 	u8         opcode;
 #ifdef __BIGENDIAN
 	u8         reserved1:3;
@@ -784,7 +785,7 @@ struct scsi_mode_select10_s{
 /*
  * SCSI Mode Sense(6) cdb
  */
-struct scsi_mode_sense6_s{
+struct scsi_mode_sense6_s {
 	u8         opcode;
 #ifdef __BIGENDIAN
 	u8         reserved1:4;
@@ -809,7 +810,7 @@ struct scsi_mode_sense6_s{
 /*
  * SCSI Mode Sense(10) cdb
  */
-struct scsi_mode_sense10_s{
+struct scsi_mode_sense10_s {
 	u8         opcode;
 #ifdef __BIGENDIAN
 	u8         reserved1:3;
@@ -877,7 +878,7 @@ struct scsi_mode_sense10_s{
 /*
  * mode parameter header
  */
-struct scsi_mode_param_header6_s{
+struct scsi_mode_param_header6_s {
 	u8         mode_datalen;
 	u8         medium_type;
 
@@ -901,7 +902,7 @@ struct scsi_mode_param_header6_s{
 	u8         block_desclen;
 };
 
-struct scsi_mode_param_header10_s{
+struct scsi_mode_param_header10_s {
 	u32        mode_datalen:16;
 	u32        medium_type:8;
 
@@ -936,7 +937,7 @@ struct scsi_mode_param_header10_s{
 /*
  * mode parameter block descriptor
  */
-struct scsi_mode_param_desc_s{
+struct scsi_mode_param_desc_s {
 	u32        nblks;
 	u32        density_code:8;
 	u32        block_length:24;
@@ -945,7 +946,7 @@ struct scsi_mode_param_desc_s{
 /*
  * Disconnect-reconnect mode page format
  */
-struct scsi_mp_disc_recn_s{
+struct scsi_mp_disc_recn_s {
 #ifdef __BIGENDIAN
 	u8         ps:1;
 	u8         reserved1:1;
@@ -991,7 +992,7 @@ struct scsi_mp_disc_recn_s{
 /*
  * SCSI format device mode page
  */
-struct scsi_mp_format_device_s{
+struct scsi_mp_format_device_s {
 #ifdef __BIGENDIAN
 	u32        ps:1;
 	u32        reserved1:1;
@@ -1035,7 +1036,7 @@ struct scsi_mp_format_device_s{
 /*
  * SCSI rigid disk device geometry page
  */
-struct scsi_mp_rigid_device_geometry_s{
+struct scsi_mp_rigid_device_geometry_s {
 #ifdef __BIGENDIAN
 	u32        ps:1;
 	u32        reserved1:1;
@@ -1081,7 +1082,7 @@ struct scsi_mp_rigid_device_geometry_s{
 /*
  * SCSI caching mode page
  */
-struct scsi_mp_caching_s{
+struct scsi_mp_caching_s {
 #ifdef __BIGENDIAN
 	u8         ps:1;
 	u8         res1:1;
@@ -1144,7 +1145,7 @@ struct scsi_mp_caching_s{
 /*
  * SCSI control mode page
  */
-struct scsi_mp_control_page_s{
+struct scsi_mp_control_page_s {
 #ifdef __BIGENDIAN
 u8         ps:1;
 u8         reserved1:1;
@@ -1211,7 +1212,7 @@ u8         ps:1;
 /*
  * SCSI medium types supported mode page
  */
-struct scsi_mp_medium_types_sup_s{
+struct scsi_mp_medium_types_sup_s {
 #ifdef __BIGENDIAN
 	u8         ps:1;
 	u8         reserved1:1;
@@ -1233,7 +1234,7 @@ struct scsi_mp_medium_types_sup_s{
 /*
  * SCSI informational exception control mode page
  */
-struct scsi_mp_info_excpt_cntl_s{
+struct scsi_mp_info_excpt_cntl_s {
 #ifdef __BIGENDIAN
 	u8         ps:1;
 	u8         reserved1:1;
@@ -1302,7 +1303,7 @@ struct scsi_mp_info_excpt_cntl_s{
 /*
  * SCSI flexible disk page
  */
-struct scsi_mp_flexible_disk_s{
+struct scsi_mp_flexible_disk_s {
 #ifdef __BIGENDIAN
 	u8         ps:1;
 	u8         reserved1:1;
@@ -1388,42 +1389,42 @@ struct scsi_mp_flexible_disk_s{
 	u8         reserved5[2];
 };
 
-struct scsi_mode_page_format_data6_s{
+struct scsi_mode_page_format_data6_s {
 	struct scsi_mode_param_header6_s mph;	/* mode page header */
 	struct scsi_mode_param_desc_s desc;	/* block descriptor */
 	struct scsi_mp_format_device_s format;	/* format device data */
 };
 
-struct scsi_mode_page_format_data10_s{
+struct scsi_mode_page_format_data10_s {
 	struct scsi_mode_param_header10_s mph;	/* mode page header */
 	struct scsi_mode_param_desc_s desc;	/* block descriptor */
 	struct scsi_mp_format_device_s format;	/* format device data */
 };
 
-struct scsi_mode_page_rdg_data6_s{
+struct scsi_mode_page_rdg_data6_s {
 	struct scsi_mode_param_header6_s mph;	/* mode page header */
 	struct scsi_mode_param_desc_s desc;	/* block descriptor */
 	struct scsi_mp_rigid_device_geometry_s rdg;
-					/* rigid geometry data */
+						/* rigid geometry data */
 };
 
-struct scsi_mode_page_rdg_data10_s{
+struct scsi_mode_page_rdg_data10_s {
 	struct scsi_mode_param_header10_s mph;	/* mode page header */
 	struct scsi_mode_param_desc_s desc;	/* block descriptor */
 	struct scsi_mp_rigid_device_geometry_s rdg;
-					/* rigid geometry data */
+						/* rigid geometry data */
 };
 
-struct scsi_mode_page_cache6_s{
+struct scsi_mode_page_cache6_s {
 	struct scsi_mode_param_header6_s mph;	/* mode page header */
 	struct scsi_mode_param_desc_s desc;	/* block descriptor */
-	struct scsi_mp_caching_s cache;	/* cache page data */
+	struct scsi_mp_caching_s cache;		/* cache page data */
 };
 
-struct scsi_mode_page_cache10_s{
+struct scsi_mode_page_cache10_s {
 	struct scsi_mode_param_header10_s mph;	/* mode page header */
 	struct scsi_mode_param_desc_s desc;	/* block descriptor */
-	struct scsi_mp_caching_s cache;	/* cache page data */
+	struct scsi_mp_caching_s cache;		/* cache page data */
 };
 
 /* --------------------------------------------------------------
@@ -1434,7 +1435,7 @@ struct scsi_mode_page_cache10_s{
 /*
  * Format Unit CDB
  */
-struct scsi_format_unit_s{
+struct scsi_format_unit_s {
 	u8         opcode;
 #ifdef __BIGENDIAN
 	u8         res1:3;
@@ -1464,7 +1465,7 @@ struct scsi_format_unit_s{
 /*
  * h
  */
-struct scsi_reserve6_s{
+struct scsi_reserve6_s {
 	u8         opcode;
 #ifdef __BIGENDIAN
 	u8         reserved:3;
@@ -1483,7 +1484,7 @@ struct scsi_reserve6_s{
 /*
  * h
  */
-struct scsi_release6_s{
+struct scsi_release6_s {
 	u8         opcode;
 #ifdef __BIGENDIAN
 	u8         reserved1:3;
@@ -1502,7 +1503,7 @@ struct scsi_release6_s{
 /*
  * h
  */
-struct scsi_reserve10_s{
+struct scsi_reserve10_s {
 	u8         opcode;
 #ifdef __BIGENDIAN
 	u8         reserved1:3;
@@ -1526,7 +1527,7 @@ struct scsi_reserve10_s{
 	u8         control;
 };
 
-struct scsi_release10_s{
+struct scsi_release10_s {
 	u8         opcode;
 #ifdef __BIGENDIAN
 	u8         reserved1:3;
@@ -1550,7 +1551,7 @@ struct scsi_release10_s{
 	u8         control;
 };
 
-struct scsi_verify10_s{
+struct scsi_verify10_s {
 	u8         opcode;
 #ifdef __BIGENDIAN
 	u8         lun:3;
@@ -1575,7 +1576,7 @@ struct scsi_verify10_s{
 	u8         control_byte;
 };
 
-struct scsi_request_sense_s{
+struct scsi_request_sense_s {
 	u8         opcode;
 #ifdef __BIGENDIAN
 	u8         lun:3;
@@ -1616,7 +1617,7 @@ struct scsi_request_sense_s{
 /*
  * SCSI WRITE-VERIFY(10) command
  */
-struct scsi_write_verify10_s{
+struct scsi_write_verify10_s {
 	u8         opcode;
 #ifdef __BIGENDIAN
 	u8         reserved1:3;
diff --git a/drivers/scsi/bfa/include/protocol/types.h b/drivers/scsi/bfa/include/protocol/types.h
index 2875a6c..7408c93 100644
--- a/drivers/scsi/bfa/include/protocol/types.h
+++ b/drivers/scsi/bfa/include/protocol/types.h
@@ -35,7 +35,6 @@
 
 #define MAC_ADDRLEN	(6)
 struct mac_s { u8 mac[MAC_ADDRLEN]; };
-#define mac_t struct mac_s
 
 #pragma pack()
 
-- 
1.6.5.2


From: akpm@linux-foundation.org
Subject: [patch 10/17] scsi: replace __inline with inline
Date: Fri, 28 Mar 2008 14:48:38 -0700
Message-ID: <200803282148.m2SLmdUl012243@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757309AbYC1VtT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Mar 2008 17:49:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, harvey.harrison@gmail.com

From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aic7xxx/aic79xx_core.c   |   14 -
 drivers/scsi/aic7xxx/aic79xx_inline.h |  218 ++++++++++++------------
 drivers/scsi/aic7xxx/aic79xx_osm.c    |    4 
 drivers/scsi/aic7xxx/aic79xx_osm.h    |  110 ++++++------
 drivers/scsi/aic7xxx/aic79xx_pci.c    |    2 
 drivers/scsi/aic7xxx/aic7xxx_inline.h |  126 ++++++-------
 drivers/scsi/aic7xxx/aic7xxx_osm.c    |    8 
 drivers/scsi/aic7xxx/aic7xxx_osm.h    |  100 +++++------
 drivers/scsi/aic7xxx/aic7xxx_pci.c    |    2 
 drivers/scsi/aic7xxx/aiclib.h         |    4 
 drivers/scsi/sym53c8xx_2/sym_glue.h   |    6 
 drivers/scsi/sym53c8xx_2/sym_hipd.c   |    2 
 drivers/scsi/sym53c8xx_2/sym_hipd.h   |    6 
 drivers/scsi/sym53c8xx_2/sym_malloc.c |    2 
 drivers/scsi/sym53c8xx_2/sym_misc.h   |   18 -
 15 files changed, 311 insertions(+), 311 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic79xx_core.c~scsi-replace-__inline-with-inline drivers/scsi/aic7xxx/aic79xx_core.c
--- a/drivers/scsi/aic7xxx/aic79xx_core.c~scsi-replace-__inline-with-inline
+++ a/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -268,7 +268,7 @@ static int		ahd_match_scb(struct ahd_sof
 
 /******************************** Private Inlines *****************************/
 
-static __inline void
+static inline void
 ahd_assert_atn(struct ahd_softc *ahd)
 {
 	ahd_outb(ahd, SCSISIGO, ATNO);
@@ -280,7 +280,7 @@ ahd_assert_atn(struct ahd_softc *ahd)
  * are currently in a packetized transfer.  We could
  * just as easily be sending or receiving a message.
  */
-static __inline int
+static inline int
 ahd_currently_packetized(struct ahd_softc *ahd)
 {
 	ahd_mode_state	 saved_modes;
@@ -303,7 +303,7 @@ ahd_currently_packetized(struct ahd_soft
 	return (packetized);
 }
 
-static __inline int
+static inline int
 ahd_set_active_fifo(struct ahd_softc *ahd)
 {
 	u_int active_fifo;
@@ -320,7 +320,7 @@ ahd_set_active_fifo(struct ahd_softc *ah
 	}
 }
 
-static __inline void
+static inline void
 ahd_unbusy_tcl(struct ahd_softc *ahd, u_int tcl)
 {
 	ahd_busy_tcl(ahd, tcl, SCB_LIST_NULL);
@@ -330,7 +330,7 @@ ahd_unbusy_tcl(struct ahd_softc *ahd, u_
  * Determine whether the sequencer reported a residual
  * for this SCB/transaction.
  */
-static __inline void
+static inline void
 ahd_update_residual(struct ahd_softc *ahd, struct scb *scb)
 {
 	uint32_t sgptr;
@@ -340,7 +340,7 @@ ahd_update_residual(struct ahd_softc *ah
 		ahd_calc_residual(ahd, scb);
 }
 
-static __inline void
+static inline void
 ahd_complete_scb(struct ahd_softc *ahd, struct scb *scb)
 {
 	uint32_t sgptr;
@@ -7209,7 +7209,7 @@ ahd_resume(struct ahd_softc *ahd)
  * scbid that should be restored once manipualtion
  * of the TCL entry is complete.
  */
-static __inline u_int
+static inline u_int
 ahd_index_busy_tcl(struct ahd_softc *ahd, u_int *saved_scbid, u_int tcl)
 {
 	/*
diff -puN drivers/scsi/aic7xxx/aic79xx_inline.h~scsi-replace-__inline-with-inline drivers/scsi/aic7xxx/aic79xx_inline.h
--- a/drivers/scsi/aic7xxx/aic79xx_inline.h~scsi-replace-__inline-with-inline
+++ a/drivers/scsi/aic7xxx/aic79xx_inline.h
@@ -46,37 +46,37 @@
 #define _AIC79XX_INLINE_H_
 
 /******************************** Debugging ***********************************/
-static __inline char *ahd_name(struct ahd_softc *ahd);
+static inline char *ahd_name(struct ahd_softc *ahd);
 
-static __inline char *
+static inline char *
 ahd_name(struct ahd_softc *ahd)
 {
 	return (ahd->name);
 }
 
 /************************ Sequencer Execution Control *************************/
-static __inline void ahd_known_modes(struct ahd_softc *ahd,
+static inline void ahd_known_modes(struct ahd_softc *ahd,
 				     ahd_mode src, ahd_mode dst);
-static __inline ahd_mode_state ahd_build_mode_state(struct ahd_softc *ahd,
+static inline ahd_mode_state ahd_build_mode_state(struct ahd_softc *ahd,
 						    ahd_mode src,
 						    ahd_mode dst);
-static __inline void ahd_extract_mode_state(struct ahd_softc *ahd,
+static inline void ahd_extract_mode_state(struct ahd_softc *ahd,
 					    ahd_mode_state state,
 					    ahd_mode *src, ahd_mode *dst);
-static __inline void ahd_set_modes(struct ahd_softc *ahd, ahd_mode src,
+static inline void ahd_set_modes(struct ahd_softc *ahd, ahd_mode src,
 				   ahd_mode dst);
-static __inline void ahd_update_modes(struct ahd_softc *ahd);
-static __inline void ahd_assert_modes(struct ahd_softc *ahd, ahd_mode srcmode,
+static inline void ahd_update_modes(struct ahd_softc *ahd);
+static inline void ahd_assert_modes(struct ahd_softc *ahd, ahd_mode srcmode,
 				      ahd_mode dstmode, const char *file,
 				      int line);
-static __inline ahd_mode_state ahd_save_modes(struct ahd_softc *ahd);
-static __inline void ahd_restore_modes(struct ahd_softc *ahd,
+static inline ahd_mode_state ahd_save_modes(struct ahd_softc *ahd);
+static inline void ahd_restore_modes(struct ahd_softc *ahd,
 				       ahd_mode_state state);
-static __inline int  ahd_is_paused(struct ahd_softc *ahd);
-static __inline void ahd_pause(struct ahd_softc *ahd);
-static __inline void ahd_unpause(struct ahd_softc *ahd);
+static inline int  ahd_is_paused(struct ahd_softc *ahd);
+static inline void ahd_pause(struct ahd_softc *ahd);
+static inline void ahd_unpause(struct ahd_softc *ahd);
 
-static __inline void
+static inline void
 ahd_known_modes(struct ahd_softc *ahd, ahd_mode src, ahd_mode dst)
 {
 	ahd->src_mode = src;
@@ -85,13 +85,13 @@ ahd_known_modes(struct ahd_softc *ahd, a
 	ahd->saved_dst_mode = dst;
 }
 
-static __inline ahd_mode_state
+static inline ahd_mode_state
 ahd_build_mode_state(struct ahd_softc *ahd, ahd_mode src, ahd_mode dst)
 {
 	return ((src << SRC_MODE_SHIFT) | (dst << DST_MODE_SHIFT));
 }
 
-static __inline void
+static inline void
 ahd_extract_mode_state(struct ahd_softc *ahd, ahd_mode_state state,
 		       ahd_mode *src, ahd_mode *dst)
 {
@@ -99,7 +99,7 @@ ahd_extract_mode_state(struct ahd_softc 
 	*dst = (state & DST_MODE) >> DST_MODE_SHIFT;
 }
 
-static __inline void
+static inline void
 ahd_set_modes(struct ahd_softc *ahd, ahd_mode src, ahd_mode dst)
 {
 	if (ahd->src_mode == src && ahd->dst_mode == dst)
@@ -117,7 +117,7 @@ ahd_set_modes(struct ahd_softc *ahd, ahd
 	ahd->dst_mode = dst;
 }
 
-static __inline void
+static inline void
 ahd_update_modes(struct ahd_softc *ahd)
 {
 	ahd_mode_state mode_ptr;
@@ -133,7 +133,7 @@ ahd_update_modes(struct ahd_softc *ahd)
 	ahd_known_modes(ahd, src, dst);
 }
 
-static __inline void
+static inline void
 ahd_assert_modes(struct ahd_softc *ahd, ahd_mode srcmode,
 		 ahd_mode dstmode, const char *file, int line)
 {
@@ -146,7 +146,7 @@ ahd_assert_modes(struct ahd_softc *ahd, 
 #endif
 }
 
-static __inline ahd_mode_state
+static inline ahd_mode_state
 ahd_save_modes(struct ahd_softc *ahd)
 {
 	if (ahd->src_mode == AHD_MODE_UNKNOWN
@@ -156,7 +156,7 @@ ahd_save_modes(struct ahd_softc *ahd)
 	return (ahd_build_mode_state(ahd, ahd->src_mode, ahd->dst_mode));
 }
 
-static __inline void
+static inline void
 ahd_restore_modes(struct ahd_softc *ahd, ahd_mode_state state)
 {
 	ahd_mode src;
@@ -173,7 +173,7 @@ ahd_restore_modes(struct ahd_softc *ahd,
  * Determine whether the sequencer has halted code execution.
  * Returns non-zero status if the sequencer is stopped.
  */
-static __inline int
+static inline int
 ahd_is_paused(struct ahd_softc *ahd)
 {
 	return ((ahd_inb(ahd, HCNTRL) & PAUSE) != 0);
@@ -186,7 +186,7 @@ ahd_is_paused(struct ahd_softc *ahd)
  * cleared in the SEQCTL register.  The sequencer may use PAUSEDIS
  * for critical sections.
  */
-static __inline void
+static inline void
 ahd_pause(struct ahd_softc *ahd)
 {
 	ahd_outb(ahd, HCNTRL, ahd->pause);
@@ -209,7 +209,7 @@ ahd_pause(struct ahd_softc *ahd)
  * into our interrupt handler and dealing with this new
  * condition.
  */
-static __inline void
+static inline void
 ahd_unpause(struct ahd_softc *ahd)
 {
 	/*
@@ -230,17 +230,17 @@ ahd_unpause(struct ahd_softc *ahd)
 }
 
 /*********************** Scatter Gather List Handling *************************/
-static __inline void	*ahd_sg_setup(struct ahd_softc *ahd, struct scb *scb,
+static inline void	*ahd_sg_setup(struct ahd_softc *ahd, struct scb *scb,
 				      void *sgptr, dma_addr_t addr,
 				      bus_size_t len, int last);
-static __inline void	 ahd_setup_scb_common(struct ahd_softc *ahd,
+static inline void	 ahd_setup_scb_common(struct ahd_softc *ahd,
 					      struct scb *scb);
-static __inline void	 ahd_setup_data_scb(struct ahd_softc *ahd,
+static inline void	 ahd_setup_data_scb(struct ahd_softc *ahd,
 					    struct scb *scb);
-static __inline void	 ahd_setup_noxfer_scb(struct ahd_softc *ahd,
+static inline void	 ahd_setup_noxfer_scb(struct ahd_softc *ahd,
 					      struct scb *scb);
 
-static __inline void *
+static inline void *
 ahd_sg_setup(struct ahd_softc *ahd, struct scb *scb,
 	     void *sgptr, dma_addr_t addr, bus_size_t len, int last)
 {
@@ -264,7 +264,7 @@ ahd_sg_setup(struct ahd_softc *ahd, stru
 	}
 }
 
-static __inline void
+static inline void
 ahd_setup_scb_common(struct ahd_softc *ahd, struct scb *scb)
 {
 	/* XXX Handle target mode SCBs. */
@@ -285,7 +285,7 @@ ahd_setup_scb_common(struct ahd_softc *a
 		    ahd_htole32(scb->sense_busaddr);
 }
 
-static __inline void
+static inline void
 ahd_setup_data_scb(struct ahd_softc *ahd, struct scb *scb)
 {
 	/*
@@ -322,7 +322,7 @@ ahd_setup_data_scb(struct ahd_softc *ahd
 	scb->hscb->sgptr = ahd_htole32(scb->sg_list_busaddr|SG_FULL_RESID);
 }
 
-static __inline void
+static inline void
 ahd_setup_noxfer_scb(struct ahd_softc *ahd, struct scb *scb)
 {
 	scb->hscb->sgptr = ahd_htole32(SG_LIST_NULL);
@@ -331,26 +331,26 @@ ahd_setup_noxfer_scb(struct ahd_softc *a
 }
 
 /************************** Memory mapping routines ***************************/
-static __inline size_t	ahd_sg_size(struct ahd_softc *ahd);
-static __inline void *
+static inline size_t	ahd_sg_size(struct ahd_softc *ahd);
+static inline void *
 			ahd_sg_bus_to_virt(struct ahd_softc *ahd,
 					   struct scb *scb,
 					   uint32_t sg_busaddr);
-static __inline uint32_t
+static inline uint32_t
 			ahd_sg_virt_to_bus(struct ahd_softc *ahd,
 					   struct scb *scb,
 					   void *sg);
-static __inline void	ahd_sync_scb(struct ahd_softc *ahd,
+static inline void	ahd_sync_scb(struct ahd_softc *ahd,
 				     struct scb *scb, int op);
-static __inline void	ahd_sync_sglist(struct ahd_softc *ahd,
+static inline void	ahd_sync_sglist(struct ahd_softc *ahd,
 					struct scb *scb, int op);
-static __inline void	ahd_sync_sense(struct ahd_softc *ahd,
+static inline void	ahd_sync_sense(struct ahd_softc *ahd,
 				       struct scb *scb, int op);
-static __inline uint32_t
+static inline uint32_t
 			ahd_targetcmd_offset(struct ahd_softc *ahd,
 					     u_int index);
 
-static __inline size_t
+static inline size_t
 ahd_sg_size(struct ahd_softc *ahd)
 {
 	if ((ahd->flags & AHD_64BIT_ADDRESSING) != 0)
@@ -358,7 +358,7 @@ ahd_sg_size(struct ahd_softc *ahd)
 	return (sizeof(struct ahd_dma_seg));
 }
 
-static __inline void *
+static inline void *
 ahd_sg_bus_to_virt(struct ahd_softc *ahd, struct scb *scb, uint32_t sg_busaddr)
 {
 	dma_addr_t sg_offset;
@@ -368,7 +368,7 @@ ahd_sg_bus_to_virt(struct ahd_softc *ahd
 	return ((uint8_t *)scb->sg_list + sg_offset);
 }
 
-static __inline uint32_t
+static inline uint32_t
 ahd_sg_virt_to_bus(struct ahd_softc *ahd, struct scb *scb, void *sg)
 {
 	dma_addr_t sg_offset;
@@ -380,7 +380,7 @@ ahd_sg_virt_to_bus(struct ahd_softc *ahd
 	return (scb->sg_list_busaddr + sg_offset);
 }
 
-static __inline void
+static inline void
 ahd_sync_scb(struct ahd_softc *ahd, struct scb *scb, int op)
 {
 	ahd_dmamap_sync(ahd, ahd->scb_data.hscb_dmat,
@@ -389,7 +389,7 @@ ahd_sync_scb(struct ahd_softc *ahd, stru
 			/*len*/sizeof(*scb->hscb), op);
 }
 
-static __inline void
+static inline void
 ahd_sync_sglist(struct ahd_softc *ahd, struct scb *scb, int op)
 {
 	if (scb->sg_count == 0)
@@ -401,7 +401,7 @@ ahd_sync_sglist(struct ahd_softc *ahd, s
 			/*len*/ahd_sg_size(ahd) * scb->sg_count, op);
 }
 
-static __inline void
+static inline void
 ahd_sync_sense(struct ahd_softc *ahd, struct scb *scb, int op)
 {
 	ahd_dmamap_sync(ahd, ahd->scb_data.sense_dmat,
@@ -410,7 +410,7 @@ ahd_sync_sense(struct ahd_softc *ahd, st
 			/*len*/AHD_SENSE_BUFSIZE, op);
 }
 
-static __inline uint32_t
+static inline uint32_t
 ahd_targetcmd_offset(struct ahd_softc *ahd, u_int index)
 {
 	return (((uint8_t *)&ahd->targetcmds[index])
@@ -418,48 +418,48 @@ ahd_targetcmd_offset(struct ahd_softc *a
 }
 
 /*********************** Miscellaneous Support Functions ***********************/
-static __inline struct ahd_initiator_tinfo *
+static inline struct ahd_initiator_tinfo *
 			ahd_fetch_transinfo(struct ahd_softc *ahd,
 					    char channel, u_int our_id,
 					    u_int remote_id,
 					    struct ahd_tmode_tstate **tstate);
-static __inline uint16_t
+static inline uint16_t
 			ahd_inw(struct ahd_softc *ahd, u_int port);
-static __inline void	ahd_outw(struct ahd_softc *ahd, u_int port,
+static inline void	ahd_outw(struct ahd_softc *ahd, u_int port,
 				 u_int value);
-static __inline uint32_t
+static inline uint32_t
 			ahd_inl(struct ahd_softc *ahd, u_int port);
-static __inline void	ahd_outl(struct ahd_softc *ahd, u_int port,
+static inline void	ahd_outl(struct ahd_softc *ahd, u_int port,
 				 uint32_t value);
-static __inline uint64_t
+static inline uint64_t
 			ahd_inq(struct ahd_softc *ahd, u_int port);
-static __inline void	ahd_outq(struct ahd_softc *ahd, u_int port,
+static inline void	ahd_outq(struct ahd_softc *ahd, u_int port,
 				 uint64_t value);
-static __inline u_int	ahd_get_scbptr(struct ahd_softc *ahd);
-static __inline void	ahd_set_scbptr(struct ahd_softc *ahd, u_int scbptr);
-static __inline u_int	ahd_get_hnscb_qoff(struct ahd_softc *ahd);
-static __inline void	ahd_set_hnscb_qoff(struct ahd_softc *ahd, u_int value);
-static __inline u_int	ahd_get_hescb_qoff(struct ahd_softc *ahd);
-static __inline void	ahd_set_hescb_qoff(struct ahd_softc *ahd, u_int value);
-static __inline u_int	ahd_get_snscb_qoff(struct ahd_softc *ahd);
-static __inline void	ahd_set_snscb_qoff(struct ahd_softc *ahd, u_int value);
-static __inline u_int	ahd_get_sescb_qoff(struct ahd_softc *ahd);
-static __inline void	ahd_set_sescb_qoff(struct ahd_softc *ahd, u_int value);
-static __inline u_int	ahd_get_sdscb_qoff(struct ahd_softc *ahd);
-static __inline void	ahd_set_sdscb_qoff(struct ahd_softc *ahd, u_int value);
-static __inline u_int	ahd_inb_scbram(struct ahd_softc *ahd, u_int offset);
-static __inline u_int	ahd_inw_scbram(struct ahd_softc *ahd, u_int offset);
-static __inline uint32_t
+static inline u_int	ahd_get_scbptr(struct ahd_softc *ahd);
+static inline void	ahd_set_scbptr(struct ahd_softc *ahd, u_int scbptr);
+static inline u_int	ahd_get_hnscb_qoff(struct ahd_softc *ahd);
+static inline void	ahd_set_hnscb_qoff(struct ahd_softc *ahd, u_int value);
+static inline u_int	ahd_get_hescb_qoff(struct ahd_softc *ahd);
+static inline void	ahd_set_hescb_qoff(struct ahd_softc *ahd, u_int value);
+static inline u_int	ahd_get_snscb_qoff(struct ahd_softc *ahd);
+static inline void	ahd_set_snscb_qoff(struct ahd_softc *ahd, u_int value);
+static inline u_int	ahd_get_sescb_qoff(struct ahd_softc *ahd);
+static inline void	ahd_set_sescb_qoff(struct ahd_softc *ahd, u_int value);
+static inline u_int	ahd_get_sdscb_qoff(struct ahd_softc *ahd);
+static inline void	ahd_set_sdscb_qoff(struct ahd_softc *ahd, u_int value);
+static inline u_int	ahd_inb_scbram(struct ahd_softc *ahd, u_int offset);
+static inline u_int	ahd_inw_scbram(struct ahd_softc *ahd, u_int offset);
+static inline uint32_t
 			ahd_inl_scbram(struct ahd_softc *ahd, u_int offset);
-static __inline uint64_t
+static inline uint64_t
 			ahd_inq_scbram(struct ahd_softc *ahd, u_int offset);
-static __inline void	ahd_swap_with_next_hscb(struct ahd_softc *ahd,
+static inline void	ahd_swap_with_next_hscb(struct ahd_softc *ahd,
 						struct scb *scb);
-static __inline void	ahd_queue_scb(struct ahd_softc *ahd, struct scb *scb);
-static __inline uint8_t *
+static inline void	ahd_queue_scb(struct ahd_softc *ahd, struct scb *scb);
+static inline uint8_t *
 			ahd_get_sense_buf(struct ahd_softc *ahd,
 					  struct scb *scb);
-static __inline uint32_t
+static inline uint32_t
 			ahd_get_sense_bufaddr(struct ahd_softc *ahd,
 					      struct scb *scb);
 
@@ -467,7 +467,7 @@ static __inline uint32_t
  * Return pointers to the transfer negotiation information
  * for the specified our_id/remote_id pair.
  */
-static __inline struct ahd_initiator_tinfo *
+static inline struct ahd_initiator_tinfo *
 ahd_fetch_transinfo(struct ahd_softc *ahd, char channel, u_int our_id,
 		    u_int remote_id, struct ahd_tmode_tstate **tstate)
 {
@@ -489,7 +489,7 @@ do {								\
 	dst->hscb->lun = src->hscb->lun;			\
 } while (0)
 
-static __inline uint16_t
+static inline uint16_t
 ahd_inw(struct ahd_softc *ahd, u_int port)
 {
 	/*
@@ -501,7 +501,7 @@ ahd_inw(struct ahd_softc *ahd, u_int por
 	return r | ahd_inb(ahd, port);
 }
 
-static __inline void
+static inline void
 ahd_outw(struct ahd_softc *ahd, u_int port, u_int value)
 {
 	/*
@@ -512,7 +512,7 @@ ahd_outw(struct ahd_softc *ahd, u_int po
 	ahd_outb(ahd, port+1, (value >> 8) & 0xFF);
 }
 
-static __inline uint32_t
+static inline uint32_t
 ahd_inl(struct ahd_softc *ahd, u_int port)
 {
 	return ((ahd_inb(ahd, port))
@@ -521,7 +521,7 @@ ahd_inl(struct ahd_softc *ahd, u_int por
 	      | (ahd_inb(ahd, port+3) << 24));
 }
 
-static __inline void
+static inline void
 ahd_outl(struct ahd_softc *ahd, u_int port, uint32_t value)
 {
 	ahd_outb(ahd, port, (value) & 0xFF);
@@ -530,7 +530,7 @@ ahd_outl(struct ahd_softc *ahd, u_int po
 	ahd_outb(ahd, port+3, ((value) >> 24) & 0xFF);
 }
 
-static __inline uint64_t
+static inline uint64_t
 ahd_inq(struct ahd_softc *ahd, u_int port)
 {
 	return ((ahd_inb(ahd, port))
@@ -543,7 +543,7 @@ ahd_inq(struct ahd_softc *ahd, u_int por
 	      | (((uint64_t)ahd_inb(ahd, port+7)) << 56));
 }
 
-static __inline void
+static inline void
 ahd_outq(struct ahd_softc *ahd, u_int port, uint64_t value)
 {
 	ahd_outb(ahd, port, value & 0xFF);
@@ -556,7 +556,7 @@ ahd_outq(struct ahd_softc *ahd, u_int po
 	ahd_outb(ahd, port+7, (value >> 56) & 0xFF);
 }
 
-static __inline u_int
+static inline u_int
 ahd_get_scbptr(struct ahd_softc *ahd)
 {
 	AHD_ASSERT_MODES(ahd, ~(AHD_MODE_UNKNOWN_MSK|AHD_MODE_CFG_MSK),
@@ -564,7 +564,7 @@ ahd_get_scbptr(struct ahd_softc *ahd)
 	return (ahd_inb(ahd, SCBPTR) | (ahd_inb(ahd, SCBPTR + 1) << 8));
 }
 
-static __inline void
+static inline void
 ahd_set_scbptr(struct ahd_softc *ahd, u_int scbptr)
 {
 	AHD_ASSERT_MODES(ahd, ~(AHD_MODE_UNKNOWN_MSK|AHD_MODE_CFG_MSK),
@@ -573,31 +573,31 @@ ahd_set_scbptr(struct ahd_softc *ahd, u_
 	ahd_outb(ahd, SCBPTR+1, (scbptr >> 8) & 0xFF);
 }
 
-static __inline u_int
+static inline u_int
 ahd_get_hnscb_qoff(struct ahd_softc *ahd)
 {
 	return (ahd_inw_atomic(ahd, HNSCB_QOFF));
 }
 
-static __inline void
+static inline void
 ahd_set_hnscb_qoff(struct ahd_softc *ahd, u_int value)
 {
 	ahd_outw_atomic(ahd, HNSCB_QOFF, value);
 }
 
-static __inline u_int
+static inline u_int
 ahd_get_hescb_qoff(struct ahd_softc *ahd)
 {
 	return (ahd_inb(ahd, HESCB_QOFF));
 }
 
-static __inline void
+static inline void
 ahd_set_hescb_qoff(struct ahd_softc *ahd, u_int value)
 {
 	ahd_outb(ahd, HESCB_QOFF, value);
 }
 
-static __inline u_int
+static inline u_int
 ahd_get_snscb_qoff(struct ahd_softc *ahd)
 {
 	u_int oldvalue;
@@ -608,35 +608,35 @@ ahd_get_snscb_qoff(struct ahd_softc *ahd
 	return (oldvalue);
 }
 
-static __inline void
+static inline void
 ahd_set_snscb_qoff(struct ahd_softc *ahd, u_int value)
 {
 	AHD_ASSERT_MODES(ahd, AHD_MODE_CCHAN_MSK, AHD_MODE_CCHAN_MSK);
 	ahd_outw(ahd, SNSCB_QOFF, value);
 }
 
-static __inline u_int
+static inline u_int
 ahd_get_sescb_qoff(struct ahd_softc *ahd)
 {
 	AHD_ASSERT_MODES(ahd, AHD_MODE_CCHAN_MSK, AHD_MODE_CCHAN_MSK);
 	return (ahd_inb(ahd, SESCB_QOFF));
 }
 
-static __inline void
+static inline void
 ahd_set_sescb_qoff(struct ahd_softc *ahd, u_int value)
 {
 	AHD_ASSERT_MODES(ahd, AHD_MODE_CCHAN_MSK, AHD_MODE_CCHAN_MSK);
 	ahd_outb(ahd, SESCB_QOFF, value);
 }
 
-static __inline u_int
+static inline u_int
 ahd_get_sdscb_qoff(struct ahd_softc *ahd)
 {
 	AHD_ASSERT_MODES(ahd, AHD_MODE_CCHAN_MSK, AHD_MODE_CCHAN_MSK);
 	return (ahd_inb(ahd, SDSCB_QOFF) | (ahd_inb(ahd, SDSCB_QOFF + 1) << 8));
 }
 
-static __inline void
+static inline void
 ahd_set_sdscb_qoff(struct ahd_softc *ahd, u_int value)
 {
 	AHD_ASSERT_MODES(ahd, AHD_MODE_CCHAN_MSK, AHD_MODE_CCHAN_MSK);
@@ -644,7 +644,7 @@ ahd_set_sdscb_qoff(struct ahd_softc *ahd
 	ahd_outb(ahd, SDSCB_QOFF+1, (value >> 8) & 0xFF);
 }
 
-static __inline u_int
+static inline u_int
 ahd_inb_scbram(struct ahd_softc *ahd, u_int offset)
 {
 	u_int value;
@@ -669,28 +669,28 @@ ahd_inb_scbram(struct ahd_softc *ahd, u_
 	return (value);
 }
 
-static __inline u_int
+static inline u_int
 ahd_inw_scbram(struct ahd_softc *ahd, u_int offset)
 {
 	return (ahd_inb_scbram(ahd, offset)
 	      | (ahd_inb_scbram(ahd, offset+1) << 8));
 }
 
-static __inline uint32_t
+static inline uint32_t
 ahd_inl_scbram(struct ahd_softc *ahd, u_int offset)
 {
 	return (ahd_inw_scbram(ahd, offset)
 	      | (ahd_inw_scbram(ahd, offset+2) << 16));
 }
 
-static __inline uint64_t
+static inline uint64_t
 ahd_inq_scbram(struct ahd_softc *ahd, u_int offset)
 {
 	return (ahd_inl_scbram(ahd, offset)
 	      | ((uint64_t)ahd_inl_scbram(ahd, offset+4)) << 32);
 }
 
-static __inline struct scb *
+static inline struct scb *
 ahd_lookup_scb(struct ahd_softc *ahd, u_int tag)
 {
 	struct scb* scb;
@@ -704,7 +704,7 @@ ahd_lookup_scb(struct ahd_softc *ahd, u_
 	return (scb);
 }
 
-static __inline void
+static inline void
 ahd_swap_with_next_hscb(struct ahd_softc *ahd, struct scb *scb)
 {
 	struct	 hardware_scb *q_hscb;
@@ -743,7 +743,7 @@ ahd_swap_with_next_hscb(struct ahd_softc
 /*
  * Tell the sequencer about a new transaction to execute.
  */
-static __inline void
+static inline void
 ahd_queue_scb(struct ahd_softc *ahd, struct scb *scb)
 {
 	ahd_swap_with_next_hscb(ahd, scb);
@@ -788,25 +788,25 @@ ahd_queue_scb(struct ahd_softc *ahd, str
 	ahd_set_hnscb_qoff(ahd, ahd->qinfifonext);
 }
 
-static __inline uint8_t *
+static inline uint8_t *
 ahd_get_sense_buf(struct ahd_softc *ahd, struct scb *scb)
 {
 	return (scb->sense_data);
 }
 
-static __inline uint32_t
+static inline uint32_t
 ahd_get_sense_bufaddr(struct ahd_softc *ahd, struct scb *scb)
 {
 	return (scb->sense_busaddr);
 }
 
 /************************** Interrupt Processing ******************************/
-static __inline void	ahd_sync_qoutfifo(struct ahd_softc *ahd, int op);
-static __inline void	ahd_sync_tqinfifo(struct ahd_softc *ahd, int op);
-static __inline u_int	ahd_check_cmdcmpltqueues(struct ahd_softc *ahd);
-static __inline int	ahd_intr(struct ahd_softc *ahd);
+static inline void	ahd_sync_qoutfifo(struct ahd_softc *ahd, int op);
+static inline void	ahd_sync_tqinfifo(struct ahd_softc *ahd, int op);
+static inline u_int	ahd_check_cmdcmpltqueues(struct ahd_softc *ahd);
+static inline int	ahd_intr(struct ahd_softc *ahd);
 
-static __inline void
+static inline void
 ahd_sync_qoutfifo(struct ahd_softc *ahd, int op)
 {
 	ahd_dmamap_sync(ahd, ahd->shared_data_dmat, ahd->shared_data_map.dmamap,
@@ -814,7 +814,7 @@ ahd_sync_qoutfifo(struct ahd_softc *ahd,
 			/*len*/AHD_SCB_MAX * sizeof(struct ahd_completion), op);
 }
 
-static __inline void
+static inline void
 ahd_sync_tqinfifo(struct ahd_softc *ahd, int op)
 {
 #ifdef AHD_TARGET_MODE
@@ -834,7 +834,7 @@ ahd_sync_tqinfifo(struct ahd_softc *ahd,
  */
 #define AHD_RUN_QOUTFIFO 0x1
 #define AHD_RUN_TQINFIFO 0x2
-static __inline u_int
+static inline u_int
 ahd_check_cmdcmpltqueues(struct ahd_softc *ahd)
 {
 	u_int retval;
@@ -864,7 +864,7 @@ ahd_check_cmdcmpltqueues(struct ahd_soft
 /*
  * Catch an interrupt from the adapter
  */
-static __inline int
+static inline int
 ahd_intr(struct ahd_softc *ahd)
 {
 	u_int	intstat;
diff -puN drivers/scsi/aic7xxx/aic79xx_osm.c~scsi-replace-__inline-with-inline drivers/scsi/aic7xxx/aic79xx_osm.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c~scsi-replace-__inline-with-inline
+++ a/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -370,9 +370,9 @@ static int ahd_linux_unit;
 
 
 /****************************** Inlines ***************************************/
-static __inline void ahd_linux_unmap_scb(struct ahd_softc*, struct scb*);
+static inline void ahd_linux_unmap_scb(struct ahd_softc*, struct scb*);
 
-static __inline void
+static inline void
 ahd_linux_unmap_scb(struct ahd_softc *ahd, struct scb *scb)
 {
 	struct scsi_cmnd *cmd;
diff -puN drivers/scsi/aic7xxx/aic79xx_osm.h~scsi-replace-__inline-with-inline drivers/scsi/aic7xxx/aic79xx_osm.h
--- a/drivers/scsi/aic7xxx/aic79xx_osm.h~scsi-replace-__inline-with-inline
+++ a/drivers/scsi/aic7xxx/aic79xx_osm.h
@@ -223,10 +223,10 @@ typedef struct timer_list ahd_timer_t;
 #define ahd_timer_init init_timer
 #define ahd_timer_stop del_timer_sync
 typedef void ahd_linux_callback_t (u_long);  
-static __inline void ahd_timer_reset(ahd_timer_t *timer, int usec,
+static inline void ahd_timer_reset(ahd_timer_t *timer, int usec,
 				     ahd_callback_t *func, void *arg);
 
-static __inline void
+static inline void
 ahd_timer_reset(ahd_timer_t *timer, int usec, ahd_callback_t *func, void *arg)
 {
 	struct ahd_softc *ahd;
@@ -386,8 +386,8 @@ struct ahd_platform_data {
 #define malloc(size, type, flags) kmalloc(size, flags)
 #define free(ptr, type) kfree(ptr)
 
-static __inline void ahd_delay(long);
-static __inline void
+static inline void ahd_delay(long);
+static inline void
 ahd_delay(long usec)
 {
 	/*
@@ -403,17 +403,17 @@ ahd_delay(long usec)
 
 
 /***************************** Low Level I/O **********************************/
-static __inline uint8_t ahd_inb(struct ahd_softc * ahd, long port);
-static __inline uint16_t ahd_inw_atomic(struct ahd_softc * ahd, long port);
-static __inline void ahd_outb(struct ahd_softc * ahd, long port, uint8_t val);
-static __inline void ahd_outw_atomic(struct ahd_softc * ahd,
+static inline uint8_t ahd_inb(struct ahd_softc * ahd, long port);
+static inline uint16_t ahd_inw_atomic(struct ahd_softc * ahd, long port);
+static inline void ahd_outb(struct ahd_softc * ahd, long port, uint8_t val);
+static inline void ahd_outw_atomic(struct ahd_softc * ahd,
 				     long port, uint16_t val);
-static __inline void ahd_outsb(struct ahd_softc * ahd, long port,
+static inline void ahd_outsb(struct ahd_softc * ahd, long port,
 			       uint8_t *, int count);
-static __inline void ahd_insb(struct ahd_softc * ahd, long port,
+static inline void ahd_insb(struct ahd_softc * ahd, long port,
 			       uint8_t *, int count);
 
-static __inline uint8_t
+static inline uint8_t
 ahd_inb(struct ahd_softc * ahd, long port)
 {
 	uint8_t x;
@@ -427,7 +427,7 @@ ahd_inb(struct ahd_softc * ahd, long por
 	return (x);
 }
 
-static __inline uint16_t
+static inline uint16_t
 ahd_inw_atomic(struct ahd_softc * ahd, long port)
 {
 	uint8_t x;
@@ -441,7 +441,7 @@ ahd_inw_atomic(struct ahd_softc * ahd, l
 	return (x);
 }
 
-static __inline void
+static inline void
 ahd_outb(struct ahd_softc * ahd, long port, uint8_t val)
 {
 	if (ahd->tags[0] == BUS_SPACE_MEMIO) {
@@ -452,7 +452,7 @@ ahd_outb(struct ahd_softc * ahd, long po
 	mb();
 }
 
-static __inline void
+static inline void
 ahd_outw_atomic(struct ahd_softc * ahd, long port, uint16_t val)
 {
 	if (ahd->tags[0] == BUS_SPACE_MEMIO) {
@@ -463,7 +463,7 @@ ahd_outw_atomic(struct ahd_softc * ahd, 
 	mb();
 }
 
-static __inline void
+static inline void
 ahd_outsb(struct ahd_softc * ahd, long port, uint8_t *array, int count)
 {
 	int i;
@@ -477,7 +477,7 @@ ahd_outsb(struct ahd_softc * ahd, long p
 		ahd_outb(ahd, port, *array++);
 }
 
-static __inline void
+static inline void
 ahd_insb(struct ahd_softc * ahd, long port, uint8_t *array, int count)
 {
 	int i;
@@ -504,19 +504,19 @@ struct info_str {
 };
 
 /******************************** Locking *************************************/
-static __inline void
+static inline void
 ahd_lockinit(struct ahd_softc *ahd)
 {
 	spin_lock_init(&ahd->platform_data->spin_lock);
 }
 
-static __inline void
+static inline void
 ahd_lock(struct ahd_softc *ahd, unsigned long *flags)
 {
 	spin_lock_irqsave(&ahd->platform_data->spin_lock, *flags);
 }
 
-static __inline void
+static inline void
 ahd_unlock(struct ahd_softc *ahd, unsigned long *flags)
 {
 	spin_unlock_irqrestore(&ahd->platform_data->spin_lock, *flags);
@@ -593,10 +593,10 @@ void			 ahd_linux_pci_exit(void);
 int			 ahd_pci_map_registers(struct ahd_softc *ahd);
 int			 ahd_pci_map_int(struct ahd_softc *ahd);
 
-static __inline uint32_t ahd_pci_read_config(ahd_dev_softc_t pci,
+static inline uint32_t ahd_pci_read_config(ahd_dev_softc_t pci,
 					     int reg, int width);
 
-static __inline uint32_t
+static inline uint32_t
 ahd_pci_read_config(ahd_dev_softc_t pci, int reg, int width)
 {
 	switch (width) {
@@ -626,11 +626,11 @@ ahd_pci_read_config(ahd_dev_softc_t pci,
 	}
 }
 
-static __inline void ahd_pci_write_config(ahd_dev_softc_t pci,
+static inline void ahd_pci_write_config(ahd_dev_softc_t pci,
 					  int reg, uint32_t value,
 					  int width);
 
-static __inline void
+static inline void
 ahd_pci_write_config(ahd_dev_softc_t pci, int reg, uint32_t value, int width)
 {
 	switch (width) {
@@ -649,29 +649,29 @@ ahd_pci_write_config(ahd_dev_softc_t pci
 	}
 }
 
-static __inline int ahd_get_pci_function(ahd_dev_softc_t);
-static __inline int
+static inline int ahd_get_pci_function(ahd_dev_softc_t);
+static inline int
 ahd_get_pci_function(ahd_dev_softc_t pci)
 {
 	return (PCI_FUNC(pci->devfn));
 }
 
-static __inline int ahd_get_pci_slot(ahd_dev_softc_t);
-static __inline int
+static inline int ahd_get_pci_slot(ahd_dev_softc_t);
+static inline int
 ahd_get_pci_slot(ahd_dev_softc_t pci)
 {
 	return (PCI_SLOT(pci->devfn));
 }
 
-static __inline int ahd_get_pci_bus(ahd_dev_softc_t);
-static __inline int
+static inline int ahd_get_pci_bus(ahd_dev_softc_t);
+static inline int
 ahd_get_pci_bus(ahd_dev_softc_t pci)
 {
 	return (pci->bus->number);
 }
 
-static __inline void ahd_flush_device_writes(struct ahd_softc *);
-static __inline void
+static inline void ahd_flush_device_writes(struct ahd_softc *);
+static inline void
 ahd_flush_device_writes(struct ahd_softc *ahd)
 {
 	/* XXX Is this sufficient for all architectures??? */
@@ -683,29 +683,29 @@ int	ahd_linux_proc_info(struct Scsi_Host
 			    off_t, int, int);
 
 /*********************** Transaction Access Wrappers **************************/
-static __inline void ahd_cmd_set_transaction_status(struct scsi_cmnd *, uint32_t);
-static __inline void ahd_set_transaction_status(struct scb *, uint32_t);
-static __inline void ahd_cmd_set_scsi_status(struct scsi_cmnd *, uint32_t);
-static __inline void ahd_set_scsi_status(struct scb *, uint32_t);
-static __inline uint32_t ahd_cmd_get_transaction_status(struct scsi_cmnd *cmd);
-static __inline uint32_t ahd_get_transaction_status(struct scb *);
-static __inline uint32_t ahd_cmd_get_scsi_status(struct scsi_cmnd *cmd);
-static __inline uint32_t ahd_get_scsi_status(struct scb *);
-static __inline void ahd_set_transaction_tag(struct scb *, int, u_int);
-static __inline u_long ahd_get_transfer_length(struct scb *);
-static __inline int ahd_get_transfer_dir(struct scb *);
-static __inline void ahd_set_residual(struct scb *, u_long);
-static __inline void ahd_set_sense_residual(struct scb *scb, u_long resid);
-static __inline u_long ahd_get_residual(struct scb *);
-static __inline u_long ahd_get_sense_residual(struct scb *);
-static __inline int ahd_perform_autosense(struct scb *);
-static __inline uint32_t ahd_get_sense_bufsize(struct ahd_softc *,
+static inline void ahd_cmd_set_transaction_status(struct scsi_cmnd *, uint32_t);
+static inline void ahd_set_transaction_status(struct scb *, uint32_t);
+static inline void ahd_cmd_set_scsi_status(struct scsi_cmnd *, uint32_t);
+static inline void ahd_set_scsi_status(struct scb *, uint32_t);
+static inline uint32_t ahd_cmd_get_transaction_status(struct scsi_cmnd *cmd);
+static inline uint32_t ahd_get_transaction_status(struct scb *);
+static inline uint32_t ahd_cmd_get_scsi_status(struct scsi_cmnd *cmd);
+static inline uint32_t ahd_get_scsi_status(struct scb *);
+static inline void ahd_set_transaction_tag(struct scb *, int, u_int);
+static inline u_long ahd_get_transfer_length(struct scb *);
+static inline int ahd_get_transfer_dir(struct scb *);
+static inline void ahd_set_residual(struct scb *, u_long);
+static inline void ahd_set_sense_residual(struct scb *scb, u_long resid);
+static inline u_long ahd_get_residual(struct scb *);
+static inline u_long ahd_get_sense_residual(struct scb *);
+static inline int ahd_perform_autosense(struct scb *);
+static inline uint32_t ahd_get_sense_bufsize(struct ahd_softc *,
 					       struct scb *);
-static __inline void ahd_notify_xfer_settings_change(struct ahd_softc *,
+static inline void ahd_notify_xfer_settings_change(struct ahd_softc *,
 						     struct ahd_devinfo *);
-static __inline void ahd_platform_scb_free(struct ahd_softc *ahd,
+static inline void ahd_platform_scb_free(struct ahd_softc *ahd,
 					   struct scb *scb);
-static __inline void ahd_freeze_scb(struct scb *scb);
+static inline void ahd_freeze_scb(struct scb *scb);
 
 static __inline
 void ahd_cmd_set_transaction_status(struct scsi_cmnd *cmd, uint32_t status)
@@ -813,20 +813,20 @@ int ahd_perform_autosense(struct scb *sc
 	return (1);
 }
 
-static __inline uint32_t
+static inline uint32_t
 ahd_get_sense_bufsize(struct ahd_softc *ahd, struct scb *scb)
 {
 	return (sizeof(struct scsi_sense_data));
 }
 
-static __inline void
+static inline void
 ahd_notify_xfer_settings_change(struct ahd_softc *ahd,
 				struct ahd_devinfo *devinfo)
 {
 	/* Nothing to do here for linux */
 }
 
-static __inline void
+static inline void
 ahd_platform_scb_free(struct ahd_softc *ahd, struct scb *scb)
 {
 	ahd->flags &= ~AHD_RESOURCE_SHORTAGE;
@@ -837,7 +837,7 @@ void	ahd_platform_free(struct ahd_softc 
 void	ahd_platform_init(struct ahd_softc *ahd);
 void	ahd_platform_freeze_devq(struct ahd_softc *ahd, struct scb *scb);
 
-static __inline void
+static inline void
 ahd_freeze_scb(struct scb *scb)
 {
 	if ((scb->io_ctx->result & (CAM_DEV_QFRZN << 16)) == 0) {
diff -puN drivers/scsi/aic7xxx/aic79xx_pci.c~scsi-replace-__inline-with-inline drivers/scsi/aic7xxx/aic79xx_pci.c
--- a/drivers/scsi/aic7xxx/aic79xx_pci.c~scsi-replace-__inline-with-inline
+++ a/drivers/scsi/aic7xxx/aic79xx_pci.c
@@ -51,7 +51,7 @@
 
 #include "aic79xx_pci.h"
 
-static __inline uint64_t
+static inline uint64_t
 ahd_compose_id(u_int device, u_int vendor, u_int subdevice, u_int subvendor)
 {
 	uint64_t id;
diff -puN drivers/scsi/aic7xxx/aic7xxx_inline.h~scsi-replace-__inline-with-inline drivers/scsi/aic7xxx/aic7xxx_inline.h
--- a/drivers/scsi/aic7xxx/aic7xxx_inline.h~scsi-replace-__inline-with-inline
+++ a/drivers/scsi/aic7xxx/aic7xxx_inline.h
@@ -46,10 +46,10 @@
 #define _AIC7XXX_INLINE_H_
 
 /************************* Sequencer Execution Control ************************/
-static __inline void ahc_pause_bug_fix(struct ahc_softc *ahc);
-static __inline int  ahc_is_paused(struct ahc_softc *ahc);
-static __inline void ahc_pause(struct ahc_softc *ahc);
-static __inline void ahc_unpause(struct ahc_softc *ahc);
+static inline void ahc_pause_bug_fix(struct ahc_softc *ahc);
+static inline int  ahc_is_paused(struct ahc_softc *ahc);
+static inline void ahc_pause(struct ahc_softc *ahc);
+static inline void ahc_unpause(struct ahc_softc *ahc);
 
 /*
  * Work around any chip bugs related to halting sequencer execution.
@@ -59,7 +59,7 @@ static __inline void ahc_unpause(struct 
  * manual pause while accessing scb ram, accesses to certain registers
  * will hang the system (infinite pci retries).
  */
-static __inline void
+static inline void
 ahc_pause_bug_fix(struct ahc_softc *ahc)
 {
 	if ((ahc->features & AHC_ULTRA2) != 0)
@@ -70,7 +70,7 @@ ahc_pause_bug_fix(struct ahc_softc *ahc)
  * Determine whether the sequencer has halted code execution.
  * Returns non-zero status if the sequencer is stopped.
  */
-static __inline int
+static inline int
 ahc_is_paused(struct ahc_softc *ahc)
 {
 	return ((ahc_inb(ahc, HCNTRL) & PAUSE) != 0);
@@ -83,7 +83,7 @@ ahc_is_paused(struct ahc_softc *ahc)
  * cleared in the SEQCTL register.  The sequencer may use PAUSEDIS
  * for critical sections.
  */
-static __inline void
+static inline void
 ahc_pause(struct ahc_softc *ahc)
 {
 	ahc_outb(ahc, HCNTRL, ahc->pause);
@@ -108,7 +108,7 @@ ahc_pause(struct ahc_softc *ahc)
  * into our interrupt handler and dealing with this new
  * condition.
  */
-static __inline void
+static inline void
 ahc_unpause(struct ahc_softc *ahc)
 {
 	if ((ahc_inb(ahc, INTSTAT) & (SCSIINT | SEQINT | BRKADRINT)) == 0)
@@ -116,14 +116,14 @@ ahc_unpause(struct ahc_softc *ahc)
 }
 
 /*********************** Untagged Transaction Routines ************************/
-static __inline void	ahc_freeze_untagged_queues(struct ahc_softc *ahc);
-static __inline void	ahc_release_untagged_queues(struct ahc_softc *ahc);
+static inline void	ahc_freeze_untagged_queues(struct ahc_softc *ahc);
+static inline void	ahc_release_untagged_queues(struct ahc_softc *ahc);
 
 /*
  * Block our completion routine from starting the next untagged
  * transaction for this target or target lun.
  */
-static __inline void
+static inline void
 ahc_freeze_untagged_queues(struct ahc_softc *ahc)
 {
 	if ((ahc->flags & AHC_SCB_BTT) == 0)
@@ -136,7 +136,7 @@ ahc_freeze_untagged_queues(struct ahc_so
  * to be acquired recursively.  Once the count drops to zero, the
  * transaction queues will be run.
  */
-static __inline void
+static inline void
 ahc_release_untagged_queues(struct ahc_softc *ahc)
 {
 	if ((ahc->flags & AHC_SCB_BTT) == 0) {
@@ -147,23 +147,23 @@ ahc_release_untagged_queues(struct ahc_s
 }
 
 /************************** Memory mapping routines ***************************/
-static __inline struct ahc_dma_seg *
+static inline struct ahc_dma_seg *
 			ahc_sg_bus_to_virt(struct scb *scb,
 					   uint32_t sg_busaddr);
-static __inline uint32_t
+static inline uint32_t
 			ahc_sg_virt_to_bus(struct scb *scb,
 					   struct ahc_dma_seg *sg);
-static __inline uint32_t
+static inline uint32_t
 			ahc_hscb_busaddr(struct ahc_softc *ahc, u_int index);
-static __inline void	ahc_sync_scb(struct ahc_softc *ahc,
+static inline void	ahc_sync_scb(struct ahc_softc *ahc,
 				     struct scb *scb, int op);
-static __inline void	ahc_sync_sglist(struct ahc_softc *ahc,
+static inline void	ahc_sync_sglist(struct ahc_softc *ahc,
 					struct scb *scb, int op);
-static __inline uint32_t
+static inline uint32_t
 			ahc_targetcmd_offset(struct ahc_softc *ahc,
 					     u_int index);
 
-static __inline struct ahc_dma_seg *
+static inline struct ahc_dma_seg *
 ahc_sg_bus_to_virt(struct scb *scb, uint32_t sg_busaddr)
 {
 	int sg_index;
@@ -175,7 +175,7 @@ ahc_sg_bus_to_virt(struct scb *scb, uint
 	return (&scb->sg_list[sg_index]);
 }
 
-static __inline uint32_t
+static inline uint32_t
 ahc_sg_virt_to_bus(struct scb *scb, struct ahc_dma_seg *sg)
 {
 	int sg_index;
@@ -186,14 +186,14 @@ ahc_sg_virt_to_bus(struct scb *scb, stru
 	return (scb->sg_list_phys + (sg_index * sizeof(*scb->sg_list)));
 }
 
-static __inline uint32_t
+static inline uint32_t
 ahc_hscb_busaddr(struct ahc_softc *ahc, u_int index)
 {
 	return (ahc->scb_data->hscb_busaddr
 		+ (sizeof(struct hardware_scb) * index));
 }
 
-static __inline void
+static inline void
 ahc_sync_scb(struct ahc_softc *ahc, struct scb *scb, int op)
 {
 	ahc_dmamap_sync(ahc, ahc->scb_data->hscb_dmat,
@@ -202,7 +202,7 @@ ahc_sync_scb(struct ahc_softc *ahc, stru
 			/*len*/sizeof(*scb->hscb), op);
 }
 
-static __inline void
+static inline void
 ahc_sync_sglist(struct ahc_softc *ahc, struct scb *scb, int op)
 {
 	if (scb->sg_count == 0)
@@ -214,16 +214,16 @@ ahc_sync_sglist(struct ahc_softc *ahc, s
 			/*len*/sizeof(struct ahc_dma_seg) * scb->sg_count, op);
 }
 
-static __inline uint32_t
+static inline uint32_t
 ahc_targetcmd_offset(struct ahc_softc *ahc, u_int index)
 {
 	return (((uint8_t *)&ahc->targetcmds[index]) - ahc->qoutfifo);
 }
 
 /******************************** Debugging ***********************************/
-static __inline char *ahc_name(struct ahc_softc *ahc);
+static inline char *ahc_name(struct ahc_softc *ahc);
 
-static __inline char *
+static inline char *
 ahc_name(struct ahc_softc *ahc)
 {
 	return (ahc->name);
@@ -231,35 +231,35 @@ ahc_name(struct ahc_softc *ahc)
 
 /*********************** Miscellaneous Support Functions ***********************/
 
-static __inline void	ahc_update_residual(struct ahc_softc *ahc,
+static inline void	ahc_update_residual(struct ahc_softc *ahc,
 					    struct scb *scb);
-static __inline struct ahc_initiator_tinfo *
+static inline struct ahc_initiator_tinfo *
 			ahc_fetch_transinfo(struct ahc_softc *ahc,
 					    char channel, u_int our_id,
 					    u_int remote_id,
 					    struct ahc_tmode_tstate **tstate);
-static __inline uint16_t
+static inline uint16_t
 			ahc_inw(struct ahc_softc *ahc, u_int port);
-static __inline void	ahc_outw(struct ahc_softc *ahc, u_int port,
+static inline void	ahc_outw(struct ahc_softc *ahc, u_int port,
 				 u_int value);
-static __inline uint32_t
+static inline uint32_t
 			ahc_inl(struct ahc_softc *ahc, u_int port);
-static __inline void	ahc_outl(struct ahc_softc *ahc, u_int port,
+static inline void	ahc_outl(struct ahc_softc *ahc, u_int port,
 				 uint32_t value);
-static __inline uint64_t
+static inline uint64_t
 			ahc_inq(struct ahc_softc *ahc, u_int port);
-static __inline void	ahc_outq(struct ahc_softc *ahc, u_int port,
+static inline void	ahc_outq(struct ahc_softc *ahc, u_int port,
 				 uint64_t value);
-static __inline struct scb*
+static inline struct scb*
 			ahc_get_scb(struct ahc_softc *ahc);
-static __inline void	ahc_free_scb(struct ahc_softc *ahc, struct scb *scb);
-static __inline void	ahc_swap_with_next_hscb(struct ahc_softc *ahc,
+static inline void	ahc_free_scb(struct ahc_softc *ahc, struct scb *scb);
+static inline void	ahc_swap_with_next_hscb(struct ahc_softc *ahc,
 						struct scb *scb);
-static __inline void	ahc_queue_scb(struct ahc_softc *ahc, struct scb *scb);
-static __inline struct scsi_sense_data *
+static inline void	ahc_queue_scb(struct ahc_softc *ahc, struct scb *scb);
+static inline struct scsi_sense_data *
 			ahc_get_sense_buf(struct ahc_softc *ahc,
 					  struct scb *scb);
-static __inline uint32_t
+static inline uint32_t
 			ahc_get_sense_bufaddr(struct ahc_softc *ahc,
 					      struct scb *scb);
 
@@ -267,7 +267,7 @@ static __inline uint32_t
  * Determine whether the sequencer reported a residual
  * for this SCB/transaction.
  */
-static __inline void
+static inline void
 ahc_update_residual(struct ahc_softc *ahc, struct scb *scb)
 {
 	uint32_t sgptr;
@@ -281,7 +281,7 @@ ahc_update_residual(struct ahc_softc *ah
  * Return pointers to the transfer negotiation information
  * for the specified our_id/remote_id pair.
  */
-static __inline struct ahc_initiator_tinfo *
+static inline struct ahc_initiator_tinfo *
 ahc_fetch_transinfo(struct ahc_softc *ahc, char channel, u_int our_id,
 		    u_int remote_id, struct ahc_tmode_tstate **tstate)
 {
@@ -297,21 +297,21 @@ ahc_fetch_transinfo(struct ahc_softc *ah
 	return (&(*tstate)->transinfo[remote_id]);
 }
 
-static __inline uint16_t
+static inline uint16_t
 ahc_inw(struct ahc_softc *ahc, u_int port)
 {
 	uint16_t r = ahc_inb(ahc, port+1) << 8;
 	return r | ahc_inb(ahc, port);
 }
 
-static __inline void
+static inline void
 ahc_outw(struct ahc_softc *ahc, u_int port, u_int value)
 {
 	ahc_outb(ahc, port, value & 0xFF);
 	ahc_outb(ahc, port+1, (value >> 8) & 0xFF);
 }
 
-static __inline uint32_t
+static inline uint32_t
 ahc_inl(struct ahc_softc *ahc, u_int port)
 {
 	return ((ahc_inb(ahc, port))
@@ -320,7 +320,7 @@ ahc_inl(struct ahc_softc *ahc, u_int por
 	      | (ahc_inb(ahc, port+3) << 24));
 }
 
-static __inline void
+static inline void
 ahc_outl(struct ahc_softc *ahc, u_int port, uint32_t value)
 {
 	ahc_outb(ahc, port, (value) & 0xFF);
@@ -329,7 +329,7 @@ ahc_outl(struct ahc_softc *ahc, u_int po
 	ahc_outb(ahc, port+3, ((value) >> 24) & 0xFF);
 }
 
-static __inline uint64_t
+static inline uint64_t
 ahc_inq(struct ahc_softc *ahc, u_int port)
 {
 	return ((ahc_inb(ahc, port))
@@ -342,7 +342,7 @@ ahc_inq(struct ahc_softc *ahc, u_int por
 	      | (((uint64_t)ahc_inb(ahc, port+7)) << 56));
 }
 
-static __inline void
+static inline void
 ahc_outq(struct ahc_softc *ahc, u_int port, uint64_t value)
 {
 	ahc_outb(ahc, port, value & 0xFF);
@@ -358,7 +358,7 @@ ahc_outq(struct ahc_softc *ahc, u_int po
 /*
  * Get a free scb. If there are none, see if we can allocate a new SCB.
  */
-static __inline struct scb *
+static inline struct scb *
 ahc_get_scb(struct ahc_softc *ahc)
 {
 	struct scb *scb;
@@ -376,7 +376,7 @@ ahc_get_scb(struct ahc_softc *ahc)
 /*
  * Return an SCB resource to the free list.
  */
-static __inline void
+static inline void
 ahc_free_scb(struct ahc_softc *ahc, struct scb *scb)
 {       
 	struct hardware_scb *hscb;
@@ -393,7 +393,7 @@ ahc_free_scb(struct ahc_softc *ahc, stru
 	ahc_platform_scb_free(ahc, scb);
 }
 
-static __inline struct scb *
+static inline struct scb *
 ahc_lookup_scb(struct ahc_softc *ahc, u_int tag)
 {
 	struct scb* scb;
@@ -405,7 +405,7 @@ ahc_lookup_scb(struct ahc_softc *ahc, u_
 	return (scb);
 }
 
-static __inline void
+static inline void
 ahc_swap_with_next_hscb(struct ahc_softc *ahc, struct scb *scb)
 {
 	struct hardware_scb *q_hscb;
@@ -445,7 +445,7 @@ ahc_swap_with_next_hscb(struct ahc_softc
 /*
  * Tell the sequencer about a new transaction to execute.
  */
-static __inline void
+static inline void
 ahc_queue_scb(struct ahc_softc *ahc, struct scb *scb)
 {
 	ahc_swap_with_next_hscb(ahc, scb);
@@ -485,7 +485,7 @@ ahc_queue_scb(struct ahc_softc *ahc, str
 	}
 }
 
-static __inline struct scsi_sense_data *
+static inline struct scsi_sense_data *
 ahc_get_sense_buf(struct ahc_softc *ahc, struct scb *scb)
 {
 	int offset;
@@ -494,7 +494,7 @@ ahc_get_sense_buf(struct ahc_softc *ahc,
 	return (&ahc->scb_data->sense[offset]);
 }
 
-static __inline uint32_t
+static inline uint32_t
 ahc_get_sense_bufaddr(struct ahc_softc *ahc, struct scb *scb)
 {
 	int offset;
@@ -505,19 +505,19 @@ ahc_get_sense_bufaddr(struct ahc_softc *
 }
 
 /************************** Interrupt Processing ******************************/
-static __inline void	ahc_sync_qoutfifo(struct ahc_softc *ahc, int op);
-static __inline void	ahc_sync_tqinfifo(struct ahc_softc *ahc, int op);
-static __inline u_int	ahc_check_cmdcmpltqueues(struct ahc_softc *ahc);
-static __inline int	ahc_intr(struct ahc_softc *ahc);
+static inline void	ahc_sync_qoutfifo(struct ahc_softc *ahc, int op);
+static inline void	ahc_sync_tqinfifo(struct ahc_softc *ahc, int op);
+static inline u_int	ahc_check_cmdcmpltqueues(struct ahc_softc *ahc);
+static inline int	ahc_intr(struct ahc_softc *ahc);
 
-static __inline void
+static inline void
 ahc_sync_qoutfifo(struct ahc_softc *ahc, int op)
 {
 	ahc_dmamap_sync(ahc, ahc->shared_data_dmat, ahc->shared_data_dmamap,
 			/*offset*/0, /*len*/256, op);
 }
 
-static __inline void
+static inline void
 ahc_sync_tqinfifo(struct ahc_softc *ahc, int op)
 {
 #ifdef AHC_TARGET_MODE
@@ -537,7 +537,7 @@ ahc_sync_tqinfifo(struct ahc_softc *ahc,
  */
 #define AHC_RUN_QOUTFIFO 0x1
 #define AHC_RUN_TQINFIFO 0x2
-static __inline u_int
+static inline u_int
 ahc_check_cmdcmpltqueues(struct ahc_softc *ahc)
 {
 	u_int retval;
@@ -566,7 +566,7 @@ ahc_check_cmdcmpltqueues(struct ahc_soft
 /*
  * Catch an interrupt from the adapter
  */
-static __inline int
+static inline int
 ahc_intr(struct ahc_softc *ahc)
 {
 	u_int	intstat;
diff -puN drivers/scsi/aic7xxx/aic7xxx_osm.c~scsi-replace-__inline-with-inline drivers/scsi/aic7xxx/aic7xxx_osm.c
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c~scsi-replace-__inline-with-inline
+++ a/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -389,13 +389,13 @@ static int ahc_linux_unit;
 
 
 /********************************* Inlines ************************************/
-static __inline void ahc_linux_unmap_scb(struct ahc_softc*, struct scb*);
+static inline void ahc_linux_unmap_scb(struct ahc_softc*, struct scb*);
 
-static __inline int ahc_linux_map_seg(struct ahc_softc *ahc, struct scb *scb,
+static inline int ahc_linux_map_seg(struct ahc_softc *ahc, struct scb *scb,
 		 		      struct ahc_dma_seg *sg,
 				      dma_addr_t addr, bus_size_t len);
 
-static __inline void
+static inline void
 ahc_linux_unmap_scb(struct ahc_softc *ahc, struct scb *scb)
 {
 	struct scsi_cmnd *cmd;
@@ -406,7 +406,7 @@ ahc_linux_unmap_scb(struct ahc_softc *ah
 	scsi_dma_unmap(cmd);
 }
 
-static __inline int
+static inline int
 ahc_linux_map_seg(struct ahc_softc *ahc, struct scb *scb,
 		  struct ahc_dma_seg *sg, dma_addr_t addr, bus_size_t len)
 {
diff -puN drivers/scsi/aic7xxx/aic7xxx_osm.h~scsi-replace-__inline-with-inline drivers/scsi/aic7xxx/aic7xxx_osm.h
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.h~scsi-replace-__inline-with-inline
+++ a/drivers/scsi/aic7xxx/aic7xxx_osm.h
@@ -230,7 +230,7 @@ int	ahc_dmamap_unload(struct ahc_softc *
 #include "aic7xxx.h"
 
 /***************************** Timer Facilities *******************************/
-static __inline void
+static inline void
 ahc_scb_timer_reset(struct scb *scb, u_int usec)
 {
 }
@@ -375,8 +375,8 @@ struct ahc_platform_data {
 #define malloc(size, type, flags) kmalloc(size, flags)
 #define free(ptr, type) kfree(ptr)
 
-static __inline void ahc_delay(long);
-static __inline void
+static inline void ahc_delay(long);
+static inline void
 ahc_delay(long usec)
 {
 	/*
@@ -392,14 +392,14 @@ ahc_delay(long usec)
 
 
 /***************************** Low Level I/O **********************************/
-static __inline uint8_t ahc_inb(struct ahc_softc * ahc, long port);
-static __inline void ahc_outb(struct ahc_softc * ahc, long port, uint8_t val);
-static __inline void ahc_outsb(struct ahc_softc * ahc, long port,
+static inline uint8_t ahc_inb(struct ahc_softc * ahc, long port);
+static inline void ahc_outb(struct ahc_softc * ahc, long port, uint8_t val);
+static inline void ahc_outsb(struct ahc_softc * ahc, long port,
 			       uint8_t *, int count);
-static __inline void ahc_insb(struct ahc_softc * ahc, long port,
+static inline void ahc_insb(struct ahc_softc * ahc, long port,
 			       uint8_t *, int count);
 
-static __inline uint8_t
+static inline uint8_t
 ahc_inb(struct ahc_softc * ahc, long port)
 {
 	uint8_t x;
@@ -413,7 +413,7 @@ ahc_inb(struct ahc_softc * ahc, long por
 	return (x);
 }
 
-static __inline void
+static inline void
 ahc_outb(struct ahc_softc * ahc, long port, uint8_t val)
 {
 	if (ahc->tag == BUS_SPACE_MEMIO) {
@@ -424,7 +424,7 @@ ahc_outb(struct ahc_softc * ahc, long po
 	mb();
 }
 
-static __inline void
+static inline void
 ahc_outsb(struct ahc_softc * ahc, long port, uint8_t *array, int count)
 {
 	int i;
@@ -438,7 +438,7 @@ ahc_outsb(struct ahc_softc * ahc, long p
 		ahc_outb(ahc, port, *array++);
 }
 
-static __inline void
+static inline void
 ahc_insb(struct ahc_softc * ahc, long port, uint8_t *array, int count)
 {
 	int i;
@@ -470,19 +470,19 @@ void	ahc_format_transinfo(struct info_st
 /******************************** Locking *************************************/
 /* Lock protecting internal data structures */
 
-static __inline void
+static inline void
 ahc_lockinit(struct ahc_softc *ahc)
 {
 	spin_lock_init(&ahc->platform_data->spin_lock);
 }
 
-static __inline void
+static inline void
 ahc_lock(struct ahc_softc *ahc, unsigned long *flags)
 {
 	spin_lock_irqsave(&ahc->platform_data->spin_lock, *flags);
 }
 
-static __inline void
+static inline void
 ahc_unlock(struct ahc_softc *ahc, unsigned long *flags)
 {
 	spin_unlock_irqrestore(&ahc->platform_data->spin_lock, *flags);
@@ -555,10 +555,10 @@ void			 ahc_linux_pci_exit(void);
 int			 ahc_pci_map_registers(struct ahc_softc *ahc);
 int			 ahc_pci_map_int(struct ahc_softc *ahc);
 
-static __inline uint32_t ahc_pci_read_config(ahc_dev_softc_t pci,
+static inline uint32_t ahc_pci_read_config(ahc_dev_softc_t pci,
 					     int reg, int width);
 
-static __inline uint32_t
+static inline uint32_t
 ahc_pci_read_config(ahc_dev_softc_t pci, int reg, int width)
 {
 	switch (width) {
@@ -588,11 +588,11 @@ ahc_pci_read_config(ahc_dev_softc_t pci,
 	}
 }
 
-static __inline void ahc_pci_write_config(ahc_dev_softc_t pci,
+static inline void ahc_pci_write_config(ahc_dev_softc_t pci,
 					  int reg, uint32_t value,
 					  int width);
 
-static __inline void
+static inline void
 ahc_pci_write_config(ahc_dev_softc_t pci, int reg, uint32_t value, int width)
 {
 	switch (width) {
@@ -611,22 +611,22 @@ ahc_pci_write_config(ahc_dev_softc_t pci
 	}
 }
 
-static __inline int ahc_get_pci_function(ahc_dev_softc_t);
-static __inline int
+static inline int ahc_get_pci_function(ahc_dev_softc_t);
+static inline int
 ahc_get_pci_function(ahc_dev_softc_t pci)
 {
 	return (PCI_FUNC(pci->devfn));
 }
 
-static __inline int ahc_get_pci_slot(ahc_dev_softc_t);
-static __inline int
+static inline int ahc_get_pci_slot(ahc_dev_softc_t);
+static inline int
 ahc_get_pci_slot(ahc_dev_softc_t pci)
 {
 	return (PCI_SLOT(pci->devfn));
 }
 
-static __inline int ahc_get_pci_bus(ahc_dev_softc_t);
-static __inline int
+static inline int ahc_get_pci_bus(ahc_dev_softc_t);
+static inline int
 ahc_get_pci_bus(ahc_dev_softc_t pci)
 {
 	return (pci->bus->number);
@@ -639,8 +639,8 @@ static inline void ahc_linux_pci_exit(vo
 }
 #endif
 
-static __inline void ahc_flush_device_writes(struct ahc_softc *);
-static __inline void
+static inline void ahc_flush_device_writes(struct ahc_softc *);
+static inline void
 ahc_flush_device_writes(struct ahc_softc *ahc)
 {
 	/* XXX Is this sufficient for all architectures??? */
@@ -653,29 +653,29 @@ int	ahc_linux_proc_info(struct Scsi_Host
 
 /*************************** Domain Validation ********************************/
 /*********************** Transaction Access Wrappers *************************/
-static __inline void ahc_cmd_set_transaction_status(struct scsi_cmnd *, uint32_t);
-static __inline void ahc_set_transaction_status(struct scb *, uint32_t);
-static __inline void ahc_cmd_set_scsi_status(struct scsi_cmnd *, uint32_t);
-static __inline void ahc_set_scsi_status(struct scb *, uint32_t);
-static __inline uint32_t ahc_cmd_get_transaction_status(struct scsi_cmnd *cmd);
-static __inline uint32_t ahc_get_transaction_status(struct scb *);
-static __inline uint32_t ahc_cmd_get_scsi_status(struct scsi_cmnd *cmd);
-static __inline uint32_t ahc_get_scsi_status(struct scb *);
-static __inline void ahc_set_transaction_tag(struct scb *, int, u_int);
-static __inline u_long ahc_get_transfer_length(struct scb *);
-static __inline int ahc_get_transfer_dir(struct scb *);
-static __inline void ahc_set_residual(struct scb *, u_long);
-static __inline void ahc_set_sense_residual(struct scb *scb, u_long resid);
-static __inline u_long ahc_get_residual(struct scb *);
-static __inline u_long ahc_get_sense_residual(struct scb *);
-static __inline int ahc_perform_autosense(struct scb *);
-static __inline uint32_t ahc_get_sense_bufsize(struct ahc_softc *,
+static inline void ahc_cmd_set_transaction_status(struct scsi_cmnd *, uint32_t);
+static inline void ahc_set_transaction_status(struct scb *, uint32_t);
+static inline void ahc_cmd_set_scsi_status(struct scsi_cmnd *, uint32_t);
+static inline void ahc_set_scsi_status(struct scb *, uint32_t);
+static inline uint32_t ahc_cmd_get_transaction_status(struct scsi_cmnd *cmd);
+static inline uint32_t ahc_get_transaction_status(struct scb *);
+static inline uint32_t ahc_cmd_get_scsi_status(struct scsi_cmnd *cmd);
+static inline uint32_t ahc_get_scsi_status(struct scb *);
+static inline void ahc_set_transaction_tag(struct scb *, int, u_int);
+static inline u_long ahc_get_transfer_length(struct scb *);
+static inline int ahc_get_transfer_dir(struct scb *);
+static inline void ahc_set_residual(struct scb *, u_long);
+static inline void ahc_set_sense_residual(struct scb *scb, u_long resid);
+static inline u_long ahc_get_residual(struct scb *);
+static inline u_long ahc_get_sense_residual(struct scb *);
+static inline int ahc_perform_autosense(struct scb *);
+static inline uint32_t ahc_get_sense_bufsize(struct ahc_softc *,
 					       struct scb *);
-static __inline void ahc_notify_xfer_settings_change(struct ahc_softc *,
+static inline void ahc_notify_xfer_settings_change(struct ahc_softc *,
 						     struct ahc_devinfo *);
-static __inline void ahc_platform_scb_free(struct ahc_softc *ahc,
+static inline void ahc_platform_scb_free(struct ahc_softc *ahc,
 					   struct scb *scb);
-static __inline void ahc_freeze_scb(struct scb *scb);
+static inline void ahc_freeze_scb(struct scb *scb);
 
 static __inline
 void ahc_cmd_set_transaction_status(struct scsi_cmnd *cmd, uint32_t status)
@@ -783,20 +783,20 @@ int ahc_perform_autosense(struct scb *sc
 	return (1);
 }
 
-static __inline uint32_t
+static inline uint32_t
 ahc_get_sense_bufsize(struct ahc_softc *ahc, struct scb *scb)
 {
 	return (sizeof(struct scsi_sense_data));
 }
 
-static __inline void
+static inline void
 ahc_notify_xfer_settings_change(struct ahc_softc *ahc,
 				struct ahc_devinfo *devinfo)
 {
 	/* Nothing to do here for linux */
 }
 
-static __inline void
+static inline void
 ahc_platform_scb_free(struct ahc_softc *ahc, struct scb *scb)
 {
 }
@@ -805,7 +805,7 @@ int	ahc_platform_alloc(struct ahc_softc 
 void	ahc_platform_free(struct ahc_softc *ahc);
 void	ahc_platform_freeze_devq(struct ahc_softc *ahc, struct scb *scb);
 
-static __inline void
+static inline void
 ahc_freeze_scb(struct scb *scb)
 {
 	if ((scb->io_ctx->result & (CAM_DEV_QFRZN << 16)) == 0) {
diff -puN drivers/scsi/aic7xxx/aic7xxx_pci.c~scsi-replace-__inline-with-inline drivers/scsi/aic7xxx/aic7xxx_pci.c
--- a/drivers/scsi/aic7xxx/aic7xxx_pci.c~scsi-replace-__inline-with-inline
+++ a/drivers/scsi/aic7xxx/aic7xxx_pci.c
@@ -54,7 +54,7 @@
 
 #include "aic7xxx_pci.h"
 
-static __inline uint64_t
+static inline uint64_t
 ahc_compose_id(u_int device, u_int vendor, u_int subdevice, u_int subvendor)
 {
 	uint64_t id;
diff -puN drivers/scsi/aic7xxx/aiclib.h~scsi-replace-__inline-with-inline drivers/scsi/aic7xxx/aiclib.h
--- a/drivers/scsi/aic7xxx/aiclib.h~scsi-replace-__inline-with-inline
+++ a/drivers/scsi/aic7xxx/aiclib.h
@@ -133,7 +133,7 @@ struct scsi_sense_data
 #define SCSI_STATUS_TASK_ABORTED	0x40
 
 /************************* Large Disk Handling ********************************/
-static __inline int
+static inline int
 aic_sector_div(sector_t capacity, int heads, int sectors)
 {
 	/* ugly, ugly sector_div calling convention.. */
@@ -141,7 +141,7 @@ aic_sector_div(sector_t capacity, int he
 	return (int)capacity;
 }
 
-static __inline uint32_t
+static inline uint32_t
 scsi_4btoul(uint8_t *bytes)
 {
 	uint32_t rv;
diff -puN drivers/scsi/sym53c8xx_2/sym_glue.h~scsi-replace-__inline-with-inline drivers/scsi/sym53c8xx_2/sym_glue.h
--- a/drivers/scsi/sym53c8xx_2/sym_glue.h~scsi-replace-__inline-with-inline
+++ a/drivers/scsi/sym53c8xx_2/sym_glue.h
@@ -234,7 +234,7 @@ static inline struct sym_hcb * sym_get_h
 /*
  *  Set the status field of a CAM CCB.
  */
-static __inline void 
+static inline void
 sym_set_cam_status(struct scsi_cmnd *cmd, int status)
 {
 	cmd->result &= ~(0xff  << 16);
@@ -244,7 +244,7 @@ sym_set_cam_status(struct scsi_cmnd *cmd
 /*
  *  Get the status field of a CAM CCB.
  */
-static __inline int 
+static inline int
 sym_get_cam_status(struct scsi_cmnd *cmd)
 {
 	return host_byte(cmd->result);
@@ -253,7 +253,7 @@ sym_get_cam_status(struct scsi_cmnd *cmd
 /*
  *  Build CAM result for a successful IO and for a failed IO.
  */
-static __inline void sym_set_cam_result_ok(struct sym_ccb *cp, struct scsi_cmnd *cmd, int resid)
+static inline void sym_set_cam_result_ok(struct sym_ccb *cp, struct scsi_cmnd *cmd, int resid)
 {
 	scsi_set_resid(cmd, resid);
 	cmd->result = (((DID_OK) << 16) + ((cp->ssss_status) & 0x7f));
diff -puN drivers/scsi/sym53c8xx_2/sym_hipd.c~scsi-replace-__inline-with-inline drivers/scsi/sym53c8xx_2/sym_hipd.c
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c~scsi-replace-__inline-with-inline
+++ a/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -602,7 +602,7 @@ sym_getsync(struct sym_hcb *np, u_char d
 /*
  *  Set initial io register bits from burst code.
  */
-static __inline void sym_init_burst(struct sym_hcb *np, u_char bc)
+static inline void sym_init_burst(struct sym_hcb *np, u_char bc)
 {
 	np->rv_ctest4	&= ~0x80;
 	np->rv_dmode	&= ~(0x3 << 6);
diff -puN drivers/scsi/sym53c8xx_2/sym_hipd.h~scsi-replace-__inline-with-inline drivers/scsi/sym53c8xx_2/sym_hipd.h
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.h~scsi-replace-__inline-with-inline
+++ a/drivers/scsi/sym53c8xx_2/sym_hipd.h
@@ -1092,7 +1092,7 @@ do {									\
 #elif SYM_CONF_DMA_ADDRESSING_MODE == 2
 #define DMA_DAC_MASK	DMA_64BIT_MASK
 int sym_lookup_dmap(struct sym_hcb *np, u32 h, int s);
-static __inline void 
+static inline void
 sym_build_sge(struct sym_hcb *np, struct sym_tblmove *data, u64 badd, int len)
 {
 	u32 h = (badd>>32);
@@ -1197,7 +1197,7 @@ dma_addr_t __vtobus(m_pool_ident_t dev_d
 
 #define sym_m_pool_match(mp_id1, mp_id2)	(mp_id1 == mp_id2)
 
-static __inline void *sym_m_get_dma_mem_cluster(m_pool_p mp, m_vtob_p vbp)
+static inline void *sym_m_get_dma_mem_cluster(m_pool_p mp, m_vtob_p vbp)
 {
 	void *vaddr = NULL;
 	dma_addr_t baddr = 0;
@@ -1211,7 +1211,7 @@ static __inline void *sym_m_get_dma_mem_
 	return vaddr;
 }
 
-static __inline void sym_m_free_dma_mem_cluster(m_pool_p mp, m_vtob_p vbp)
+static inline void sym_m_free_dma_mem_cluster(m_pool_p mp, m_vtob_p vbp)
 {
 	dma_free_coherent(mp->dev_dmat, SYM_MEM_CLUSTER_SIZE, vbp->vaddr,
 			vbp->baddr);
diff -puN drivers/scsi/sym53c8xx_2/sym_malloc.c~scsi-replace-__inline-with-inline drivers/scsi/sym53c8xx_2/sym_malloc.c
--- a/drivers/scsi/sym53c8xx_2/sym_malloc.c~scsi-replace-__inline-with-inline
+++ a/drivers/scsi/sym53c8xx_2/sym_malloc.c
@@ -262,7 +262,7 @@ static void ___free_dma_mem_cluster(m_po
 #endif
 
 /* Fetch the memory pool for a given pool id (i.e. DMA constraints) */
-static __inline m_pool_p ___get_dma_pool(m_pool_ident_t dev_dmat)
+static inline m_pool_p ___get_dma_pool(m_pool_ident_t dev_dmat)
 {
 	m_pool_p mp;
 	for (mp = mp0.next;
diff -puN drivers/scsi/sym53c8xx_2/sym_misc.h~scsi-replace-__inline-with-inline drivers/scsi/sym53c8xx_2/sym_misc.h
--- a/drivers/scsi/sym53c8xx_2/sym_misc.h~scsi-replace-__inline-with-inline
+++ a/drivers/scsi/sym53c8xx_2/sym_misc.h
@@ -52,17 +52,17 @@ typedef struct sym_quehead {
 	(ptr)->flink = (ptr); (ptr)->blink = (ptr); \
 } while (0)
 
-static __inline struct sym_quehead *sym_que_first(struct sym_quehead *head)
+static inline struct sym_quehead *sym_que_first(struct sym_quehead *head)
 {
 	return (head->flink == head) ? 0 : head->flink;
 }
 
-static __inline struct sym_quehead *sym_que_last(struct sym_quehead *head)
+static inline struct sym_quehead *sym_que_last(struct sym_quehead *head)
 {
 	return (head->blink == head) ? 0 : head->blink;
 }
 
-static __inline void __sym_que_add(struct sym_quehead * new,
+static inline void __sym_que_add(struct sym_quehead * new,
 	struct sym_quehead * blink,
 	struct sym_quehead * flink)
 {
@@ -72,19 +72,19 @@ static __inline void __sym_que_add(struc
 	blink->flink	= new;
 }
 
-static __inline void __sym_que_del(struct sym_quehead * blink,
+static inline void __sym_que_del(struct sym_quehead * blink,
 	struct sym_quehead * flink)
 {
 	flink->blink = blink;
 	blink->flink = flink;
 }
 
-static __inline int sym_que_empty(struct sym_quehead *head)
+static inline int sym_que_empty(struct sym_quehead *head)
 {
 	return head->flink == head;
 }
 
-static __inline void sym_que_splice(struct sym_quehead *list,
+static inline void sym_que_splice(struct sym_quehead *list,
 	struct sym_quehead *head)
 {
 	struct sym_quehead *first = list->flink;
@@ -101,7 +101,7 @@ static __inline void sym_que_splice(stru
 	}
 }
 
-static __inline void sym_que_move(struct sym_quehead *orig,
+static inline void sym_que_move(struct sym_quehead *orig,
 	struct sym_quehead *dest)
 {
 	struct sym_quehead *first, *last;
@@ -131,7 +131,7 @@ static __inline void sym_que_move(struct
 
 #define sym_insque_head(new, head)	__sym_que_add(new, head, (head)->flink)
 
-static __inline struct sym_quehead *sym_remque_head(struct sym_quehead *head)
+static inline struct sym_quehead *sym_remque_head(struct sym_quehead *head)
 {
 	struct sym_quehead *elem = head->flink;
 
@@ -144,7 +144,7 @@ static __inline struct sym_quehead *sym_
 
 #define sym_insque_tail(new, head)	__sym_que_add(new, (head)->blink, head)
 
-static __inline struct sym_quehead *sym_remque_tail(struct sym_quehead *head)
+static inline struct sym_quehead *sym_remque_tail(struct sym_quehead *head)
 {
 	struct sym_quehead *elem = head->blink;
 
_

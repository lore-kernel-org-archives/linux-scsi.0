From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] available spell fixes
Date: Thu, 06 Feb 2003 13:54:47 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030206053821.2572A2C2AF@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: Mitchell Blank <mitch@sfgoth.com>, linux-atm-general@lists.sourceforge.net, dledford@redhat.com, jgarzik@pobox.com, linux-scsi@vger.kernel.org

From:  <alfre@ibd.es>

  Against vanilla 2.4.20, spell fixes for 'available'.
  
  Regrads - alfredo
  
  --
  Alfredo Sanjuan
  <alfre@ibd.es>
  

--- trivial-2.4.21-pre4/drivers/atm/iphase.c.orig	2003-02-06 13:53:36.000000000 +1100
+++ trivial-2.4.21-pre4/drivers/atm/iphase.c	2003-02-06 13:53:36.000000000 +1100
@@ -1889,7 +1889,7 @@
                     return -EINVAL; 
                 }
                 if (vcc->qos.txtp.max_pcr > iadev->LineRate) {
-                   IF_CBR(printk("PCR is not availble\n");)
+                   IF_CBR(printk("PCR is not available\n");)
                    return -1;
                 }
                 vc->type = CBR;
@@ -1899,7 +1899,7 @@
                 }
        } 
 	else  
-           printk("iadev:  Non UBR, ABR and CBR traffic not supportedn"); 
+           printk("iadev:  Non UBR, ABR and CBR traffic not supported\n"); 
         
         iadev->testTable[vcc->vci]->vc_status |= VC_ACTIVE;
 	IF_EVENT(printk("ia open_tx returning \n");)  
--- trivial-2.4.21-pre4/drivers/ieee1394/dv1394.h.orig	2003-02-06 13:53:36.000000000 +1100
+++ trivial-2.4.21-pre4/drivers/ieee1394/dv1394.h	2003-02-06 13:53:36.000000000 +1100
@@ -175,7 +175,7 @@
    where copy_DV_frame() reads or writes on the dv1394 file descriptor
    (read/write mode) or copies data to/from the mmap ringbuffer and
    then calls ioctl(DV1394_SUBMIT_FRAMES) to notify dv1394 that new
-   frames are availble (mmap mode).
+   frames are available (mmap mode).
 
    reset_dv1394() is called in the event of a buffer
    underflow/overflow or a halt in the DV stream (e.g. due to a 1394
--- trivial-2.4.21-pre4/drivers/md/lvm.c.orig	2003-02-06 13:53:36.000000000 +1100
+++ trivial-2.4.21-pre4/drivers/md/lvm.c	2003-02-06 13:53:36.000000000 +1100
@@ -2405,7 +2405,7 @@
 		}
 	}
 
-	/* save availiable i/o statistic data */
+	/* save available i/o statistic data */
 	if (old_lv->lv_stripes < 2) {	/* linear logical volume */
 		end = min(old_lv->lv_current_le, new_lv->lv_current_le);
 		for (l = 0; l < end; l++) {
--- trivial-2.4.21-pre4/drivers/net/saa9730.c.orig	2003-02-06 13:53:36.000000000 +1100
+++ trivial-2.4.21-pre4/drivers/net/saa9730.c	2003-02-06 13:53:36.000000000 +1100
@@ -265,7 +265,7 @@
 	lp->NextRcvPacketIndex = 0;
 	lp->NextRcvToUseIsA = 1;
 
-	/* Set current buffer index & next availble packet index */
+	/* Set current buffer index & next available packet index */
 	lp->NextTxmPacketIndex = 0;
 	lp->NextTxmBufferIndex = 0;
 	lp->PendingTxmPacketIndex = 0;
@@ -520,7 +520,7 @@
 	lp->NextRcvPacketIndex = 0;
 	lp->NextRcvToUseIsA = 1;
 
-	/* Set current buffer index & next availble packet index */
+	/* Set current buffer index & next available packet index */
 	lp->NextTxmPacketIndex = 0;
 	lp->NextTxmBufferIndex = 0;
 	lp->PendingTxmPacketIndex = 0;
--- trivial-2.4.21-pre4/drivers/net/wan/comx-hw-munich.c.orig	2003-02-06 13:53:36.000000000 +1100
+++ trivial-2.4.21-pre4/drivers/net/wan/comx-hw-munich.c	2003-02-06 13:53:36.000000000 +1100
@@ -269,7 +269,7 @@
 				   - Path Code Violations >1, but <320
 				   - not a Severely Errored Second
 				   - no AIS
-				   - not incremented during an Unavailabla Second                       */
+				   - not incremented during an Unavailable Second                       */
       severely_err_secs,	/* Severely Errored Second:
 				   - CRC4: >=832 Path COde Violations || >0 Out Of Frame defects
 				   - noCRC4: >=2048 Line Code Violations
--- trivial-2.4.21-pre4/drivers/scsi/aic7xxx/aic7xxx.h.orig	2003-02-06 13:53:36.000000000 +1100
+++ trivial-2.4.21-pre4/drivers/scsi/aic7xxx/aic7xxx.h	2003-02-06 13:53:36.000000000 +1100
@@ -362,7 +362,7 @@
 
 /*
  * The driver keeps up to MAX_SCB scb structures per card in memory.  The SCB
- * consists of a "hardware SCB" mirroring the fields availible on the card
+ * consists of a "hardware SCB" mirroring the fields available on the card
  * and additional information the kernel stores for each transaction.
  *
  * To minimize space utilization, a portion of the hardware scb stores
--- trivial-2.4.21-pre4/drivers/scsi/aic7xxx/aic7xxx_core.c.orig	2003-02-06 13:53:36.000000000 +1100
+++ trivial-2.4.21-pre4/drivers/scsi/aic7xxx/aic7xxx_core.c	2003-02-06 13:53:36.000000000 +1100
@@ -388,7 +388,7 @@
 
 	ahc_dump_card_state(ahc);
 
-	/* Tell everyone that this HBA is no longer availible */
+	/* Tell everyone that this HBA is no longer available */
 	ahc_abort_scbs(ahc, CAM_TARGET_WILDCARD, ALL_CHANNELS,
 		       CAM_LUN_WILDCARD, SCB_LIST_NULL, ROLE_UNKNOWN,
 		       CAM_NO_HBA);
@@ -2748,9 +2748,9 @@
 	targ_scsirate = tinfo->scsirate;
 
 	/*
-	 * Parse as much of the message as is availible,
+	 * Parse as much of the message as is available,
 	 * rejecting it if we don't support it.  When
-	 * the entire message is availible and has been
+	 * the entire message is available and has been
 	 * handled, return MSGLOOP_MSGCOMPLETE, indicating
 	 * that we have parsed an entire message.
 	 *
--- trivial-2.4.21-pre4/drivers/scsi/aic7xxx_old.c.orig	2003-02-06 13:53:36.000000000 +1100
+++ trivial-2.4.21-pre4/drivers/scsi/aic7xxx_old.c	2003-02-06 13:53:36.000000000 +1100
@@ -5435,9 +5435,9 @@
   target_mask = (0x01 << tindex);
 
   /*
-   * Parse as much of the message as is availible,
+   * Parse as much of the message as is available,
    * rejecting it if we don't support it.  When
-   * the entire message is availible and has been
+   * the entire message is available and has been
    * handled, return TRUE indicating that we have
    * parsed an entire message.
    */
--- trivial-2.4.21-pre4/drivers/scsi/ips.c.orig	2003-02-06 13:53:36.000000000 +1100
+++ trivial-2.4.21-pre4/drivers/scsi/ips.c	2003-02-06 13:53:37.000000000 +1100
@@ -7211,7 +7211,7 @@
 /*     Assumes that ips_read_adapter_status() is called first filling in     */
 /*     the data for SubSystem Parameters.                                    */
 /*     Called from ips_write_driver_status() so it also assumes NVRAM Page 5 */
-/*     Data is availaible.                                                   */
+/*     Data is available.                                                   */
 /*                                                                           */
 /*---------------------------------------------------------------------------*/
 static void ips_version_check(ips_ha_t *ha, int intr) {
--- trivial-2.4.21-pre4/drivers/scsi/pcmcia/nsp_cs.c.orig	2003-02-06 13:53:36.000000000 +1100
+++ trivial-2.4.21-pre4/drivers/scsi/pcmcia/nsp_cs.c	2003-02-06 13:53:37.000000000 +1100
@@ -707,7 +707,7 @@
 		ocount			 += res;
 		//DEBUG(0, " ptr=0x%p this_residual=0x%x ocount=0x%x\n", SCpnt->SCp.ptr, SCpnt->SCp.this_residual, ocount);
 
-		/* go to next scatter list if availavle */
+		/* go to next scatter list if available */
 		if (SCpnt->SCp.this_residual	== 0 &&
 		    SCpnt->SCp.buffers_residual != 0 ) {
 			//DEBUG(0, " scatterlist next timeout=%d\n", time_out);
@@ -780,7 +780,7 @@
 		SCpnt->SCp.this_residual -= res;
 		ocount			 += res;
 
-		/* go to next scatter list if availavle */
+		/* go to next scatter list if available */
 		if (SCpnt->SCp.this_residual	== 0 &&
 		    SCpnt->SCp.buffers_residual != 0 ) {
 			//DEBUG(0, " scatterlist next\n");
--- trivial-2.4.21-pre4/net/ipv6/af_inet6.c.orig	2003-02-06 13:53:36.000000000 +1100
+++ trivial-2.4.21-pre4/net/ipv6/af_inet6.c	2003-02-06 13:53:37.000000000 +1100
@@ -623,7 +623,7 @@
 	/*
 	 *	ipngwg API draft makes clear that the correct semantics
 	 *	for TCP and UDP is to consider one TCP and UDP instance
-	 *	in a host availiable by both INET and INET6 APIs and
+	 *	in a host available by both INET and INET6 APIs and
 	 *	able to communicate via both network protocols.
 	 */
 
--- trivial-2.4.21-pre4/net/ipv6/ip6_output.c.orig	2003-02-06 13:53:36.000000000 +1100
+++ trivial-2.4.21-pre4/net/ipv6/ip6_output.c	2003-02-06 13:53:37.000000000 +1100
@@ -563,7 +563,7 @@
 		if (err) {
 #if IP6_DEBUG >= 2
 			printk(KERN_DEBUG "ip6_build_xmit: "
-			       "no availiable source address\n");
+			       "no available source address\n");
 #endif
 			goto out;
 		}
-- 
  Don't blame me: the Monkey is driving
  File: =?ISO-8859-1?Q?Alfredo_Sanju=C3=A1n?= <alfre@ibd.es>: [TRIVIAL] available spell fixes

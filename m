From: Stephen Degler <stephen@degler.net>
Subject: Re: Problem with Adaptec 39320A Ultra320 SCSI adapter driver
Date: Thu, 10 Aug 2006 21:40:46 -0400
Message-ID: <44DBE01E.1050504@degler.net>
References: <3a1eedb70608101101g16527d76ka1d088930a39f365@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060900080609000100030104"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from crusoe.degler.net ([66.114.64.229]:47562 "EHLO
	crusoe.degler.net") by vger.kernel.org with ESMTP id S932205AbWHKBme
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Aug 2006 21:42:34 -0400
In-Reply-To: <3a1eedb70608101101g16527d76ka1d088930a39f365@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jassduec@gmail.com
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------060900080609000100030104
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

jassduec@gmail.com wrote:
> Hi All,
>
> I am running CentOS 4.3 with linux kernel 2.6.9-34.0.2.ELsmp. I am
> using Adaptec 39320A Ultra320 SCSI adapter for connecting to 840 SATA
> RAID Array from gateway. When the system boots, i am getting the
> following errors. Though the kernel is able to identify the LUNs from
> the array, i was wondering what is the cause of the error message. Any
> reply in this regard would be highly appreciated.
>
> Thanks in advance
>

Most likely you need a kernel with the "slowcrc" fixes for the aic79xx 
driver.  I'm not sure if CentOS has them integrated yet. adding 
aic79xx=slowcrc on such a kernel will most likely resolve this for you.  
One of the patches on this list posted by Hannes Reinecke  applied 
cleanly to 2.6.14.2, It may work for you if you need to recompile.
 
skd


> ########################Error Message########################
>
>
> scsi2 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 1.3.11
>        <Adaptec 39320A Ultra320 SCSI adapter>
>        aic7902: Ultra320 Wide Channel A, SCSI Id=7, PCI-X 50-66Mhz, 
> 512 SCBs
>
> (scsi2:A:4:0): Unexpected busfree in Message-out phase, 1 SCBs
> aborted, PRGMCNT == 0x19a
>>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
> scsi2: Dumping Card State at program address 0x198 Mode 0x33
> Card was paused
> HS_MAILBOX[0x0] INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11]
> DFFSTAT[0x33] SCSISIGI[0x0] SCSIPHASE[0x0] SCSIBUS[0x0]
> LASTPHASE[0xa0] SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0]
> SEQINTCTL[0x0] SEQ_FLAGS[0x40] SEQ_FLAGS2[0x0] SSTAT0[0x0]
> SSTAT1[0x8] SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0]
> SIMODE1[0xac] LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0]
> LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x0]
>
> SCB Count = 4 CMDS_PENDING = 1 LASTSCB 0xffff CURRSCB 0x3 NEXTSCB 0x0
> qinstart = 12 qinfifonext = 12
> QINFIFO:
> WAITING_TID_QUEUES:
> Pending list:
> Total 0
> Kernel Free SCB list: 3 2 1 0
> Sequencer Complete DMA-inprog list:
> Sequencer Complete list:
> Sequencer DMA-Up and Complete list:
>
> scsi2: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
> scsi2: FIFO1 Free, LONGJMP == 0x8063, SCB 0x3
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
> LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
> 0x0 0x0 0x0 0x0
> scsi2: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
> scsi2: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
> SIMODE0[0xc]
> CCSCBCTL[0x4]
> scsi2: REG0 == 0x3, SINDEX = 0x107, DINDEX = 0xe1
> scsi2: SCBPTR == 0x3, SCB_NEXT == 0xff00, SCB_NEXT2 == 0xff3b
> CDB 3b a 0 0 0 0
> STACK: 0x10c 0x0 0x0 0x0 0x0 0x0 0x0 0x0
> <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
> DevQ(0:4:0): 0 waiting
> scsi2: Transmission error detected
> LQISTAT1[0x0] LASTPHASE[0xe0] SCSISIGI[0x60] PERRDIAG[0xd1]
>>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
> scsi2: Dumping Card State at program address 0x198 Mode 0x11
> Card was paused
> HS_MAILBOX[0x0] INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11]
> DFFSTAT[0x19] SCSISIGI[0x74] SCSIPHASE[0x2] SCSIBUS[0x0]
> LASTPHASE[0xe0] SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0]
> SEQINTCTL[0x0] SEQ_FLAGS[0x0] SEQ_FLAGS2[0x0] SSTAT0[0x2]
> SSTAT1[0x19] SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0x0]
> SIMODE1[0xac] LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0]
> LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x0]
>
> SCB Count = 4 CMDS_PENDING = 1 LASTSCB 0xffff CURRSCB 0x3 NEXTSCB 0x0
> qinstart = 27 qinfifonext = 27
> QINFIFO:
> WAITING_TID_QUEUES:
> Pending list:
>  3 FIFO_USE[0x0] SCB_CONTROL[0x40] SCB_SCSIID[0x47]
> Total 1
> Kernel Free SCB list: 2 1 0
> Sequencer Complete DMA-inprog list:
> Sequencer Complete list:
> Sequencer DMA-Up and Complete list:
>
> scsi2: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
> scsi2: FIFO1 Active, LONGJMP == 0x8063, SCB 0x3
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x88]
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
> SOFFCNT[0x0] MDFFSTAT[0x4] SHADDR = 0x00, SHCNT = 0x0
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
> LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
> 0x0 0x0 0x0 0x0
> scsi2: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
> scsi2: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
> SIMODE0[0xc]
> CCSCBCTL[0x4]
> scsi2: REG0 == 0x3, SINDEX = 0x1ba, DINDEX = 0x1ba
> scsi2: SCBPTR == 0x3, SCB_NEXT == 0xffc0, SCB_NEXT2 == 0xff3b
> CDB 12 0 0 0 24 0
> STACK: 0xc9 0x0 0x0 0x0 0x0 0x0 0x0 0x0
> <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
> DevQ(0:4:0): 0 waiting
> scsi2:0:4:0: Attempting to abort cmd f7dadc80: 0x12 0x0 0x0 0x0 0x24 0x0
> scsi2: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
> scsi2: Dumping Card State at program address 0x26 Mode 0x22
> Card was paused
> HS_MAILBOX[0x0] INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11]
> DFFSTAT[0x19] SCSISIGI[0x74] SCSIPHASE[0x2] SCSIBUS[0x0]
> LASTPHASE[0x60] SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0]
> SEQINTCTL[0x0] SEQ_FLAGS[0x20] SEQ_FLAGS2[0x0] SSTAT0[0x0]
> SSTAT1[0x9] SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0x0]
> SIMODE1[0xac] LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0]
> LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x0]
>
> SCB Count = 4 CMDS_PENDING = 1 LASTSCB 0xffff CURRSCB 0x3 NEXTSCB 0x0
> qinstart = 27 qinfifonext = 27
> QINFIFO:
> WAITING_TID_QUEUES:
> Pending list:
>  3 FIFO_USE[0x0] SCB_CONTROL[0x40] SCB_SCSIID[0x47]
> Total 1
> Kernel Free SCB list: 2 1 0
> Sequencer Complete DMA-inprog list:
> Sequencer Complete list:
> Sequencer DMA-Up and Complete list:
>
> scsi2: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]
> SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
> SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
> HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
> scsi2: FIFO1 Active, LONGJMP == 0x8063, SCB 0x3
> SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x28] DFSTATUS[0x80]
> SG_CACHE_SHADOW[0xa] SG_STATE[0x0] DFFSXFRCTL[0x0]
> SOFFCNT[0x0] MDFFSTAT[0xc] SHADDR = 0x03bee80, SHCNT = 0x24
> HADDR = 0x03bee80, HCNT = 0x24 CCSGCTL[0x10]
> LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
> 0x0 0x0 0x0 0x0
> scsi2: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
> scsi2: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
> SIMODE0[0xc]
> CCSCBCTL[0x4]
> scsi2: REG0 == 0x3, SINDEX = 0x1ba, DINDEX = 0x1ba
> scsi2: SCBPTR == 0xff03, SCB_NEXT == 0xff00, SCB_NEXT2 == 0x0
> CDB 3 1 0 0 0 0
> STACK: 0x1f2 0x0 0x0 0x0 0x0 0x0 0x0 0x0
> <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
> DevQ(0:4:0): 0 waiting
> scsi2:0:4:0: Device is active, asserting ATN
> Recovery code sleeping
> Recovery code awake
> Timer Expired
> Recovery code sleeping
> Recovery code awake
> Timer Expired
> scsi2: Device reset returning 0x2003
> Recovery SCB completes
> Recovery SCB completes
>  Vendor: Gateway   Model: 840 SATA RAID     Rev:
>  Type:   Direct-Access                      ANSI SCSI revision: 03
> scsi2:A:4:0: Tagged Queuing enabled.  Depth 4
> SCSI device sdc: 1940115456 512-byte hdwr sectors (993339 MB)
> SCSI device sdc: drive cache: write back
> SCSI device sdc: 1940115456 512-byte hdwr sectors (993339 MB)
> SCSI device sdc: drive cache: write back
> sdc: sdc1
> Attached scsi disk sdc at scsi2, channel 0, id 4, lun 0
>  Vendor: Gateway   Model: 840 SATA RAID     Rev:
>  Type:   Direct-Access                      ANSI SCSI revision: 03
> scsi2:A:4:1: Tagged Queuing enabled.  Depth 4
> SCSI device sdd: 2424655872 512-byte hdwr sectors (1241424 MB)
> SCSI device sdd: drive cache: write back
> SCSI device sdd: 2424655872 512-byte hdwr sectors (1241424 MB)
> SCSI device sdd: drive cache: write back
> sdd: sdd1
> Attached scsi disk sdd at scsi2, channel 0, id 4, lun 1
>  Vendor: Gateway   Model: 840 SATA RAID     Rev:
>  Type:   Processor                          ANSI SCSI revision: 03
> scsi2:A:4:2: Tagged Queuing enabled.  Depth 4
> scsi3 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 1.3.11
>        <Adaptec 39320A Ultra320 SCSI adapter>
>        aic7902: Ultra320 Wide Channel B, SCSI Id=7, PCI-X 50-66Mhz, 
> 512 SCBs
>
>
> ########################################################################
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


--------------060900080609000100030104
Content-Type: text/plain;
 name="0003-aic79xx-slowcrc-fix"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0003-aic79xx-slowcrc-fix"

diff --git a/drivers/scsi/aic7xxx/aic79xx.h b/drivers/scsi/aic7xxx/aic79xx.h
--- a/drivers/scsi/aic7xxx/aic79xx.h
+++ b/drivers/scsi/aic7xxx/aic79xx.h
@@ -37,7 +37,7 @@
  * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  * POSSIBILITY OF SUCH DAMAGES.
  *
- * $Id: //depot/aic7xxx/aic7xxx/aic79xx.h#108 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic79xx.h#109 $
  *
  * $FreeBSD$
  */
@@ -222,6 +222,7 @@ typedef enum {
 typedef enum {
 	AHD_FENONE		= 0x00000,
 	AHD_WIDE  		= 0x00001,/* Wide Channel */
+	AHD_AIC79XXB_SLOWCRC    = 0x00002,/* SLOWCRC bit should be set */
 	AHD_MULTI_FUNC		= 0x00100,/* Multi-Function/Channel Device */
 	AHD_TARGETMODE		= 0x01000,/* Has tested target mode support */
 	AHD_MULTIROLE		= 0x02000,/* Space for two roles at a time */
diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -3332,6 +3332,15 @@ ahd_update_neg_table(struct ahd_softc *a
 		con_opts |= WIDEXFER;
 
 	/*
+	 * Slow down our CRC interval to be
+	 * compatible with packetized U320 devices
+	 * that can't handle a CRC at full speed
+	 */
+	if (ahd->features & AHD_AIC79XXB_SLOWCRC) {
+		con_opts |= ENSLOWCRC;
+	}
+
+	/*
 	 * During packetized transfers, the target will
 	 * give us the oportunity to send command packets
 	 * without us asserting attention.
@@ -6740,6 +6749,18 @@ ahd_chip_init(struct ahd_softc *ahd)
 
 	ahd_loadseq(ahd);
 	ahd_set_modes(ahd, AHD_MODE_SCSI, AHD_MODE_SCSI);
+
+	if (ahd->features & AHD_AIC79XXB_SLOWCRC) {
+		u_int negodat3 = ahd_inb(ahd, NEGCONOPTS);
+
+		negodat3 |= ENSLOWCRC;
+		ahd_outb(ahd, NEGCONOPTS, negodat3);
+		negodat3 = ahd_inb(ahd, NEGCONOPTS);
+		if (!(negodat3 & ENSLOWCRC))
+			printf("aic79xx: failed to set the SLOWCRC bit\n");
+		else
+			printf("aic79xx: SLOWCRC bit set\n");
+	}
 }
 
 /*
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -314,6 +314,21 @@ static uint32_t aic79xx_seltime;
  */
 uint32_t aic79xx_periodic_otag;
 
+/* Some storage boxes are using an LSI chip which has a bug making it
+ * impossible to use aic79xx Rev B chip in 320 speeds.  The following
+ * storage boxes have been reported to be buggy:
+ * EonStor 3U 16-Bay: U16U-G3A3
+ * EonStor 2U 12-Bay: U12U-G3A3
+ * SentinelRAID: 2500F R5 / R6
+ * SentinelRAID: 2500F R1
+ * SentinelRAID: 2500F/1500F
+ * SentinelRAID: 150F
+ * 
+ * To get around this LSI bug, you can set your board to 160 mode
+ * or you can enable the SLOWCRC bit.
+ */
+uint32_t aic79xx_slowcrc;
+
 /*
  * Module information and settable options.
  */
@@ -343,6 +358,7 @@ MODULE_PARM_DESC(aic79xx,
 "	amplitude:<int>		Set the signal amplitude (0-7).\n"
 "	seltime:<int>		Selection Timeout:\n"
 "				(0/256ms,1/128ms,2/64ms,3/32ms)\n"
+"	slowcrc			Turn on the SLOWCRC bit (Rev B only)\n"		 
 "\n"
 "	Sample /etc/modprobe.conf line:\n"
 "		Enable verbose logging\n"
@@ -1003,6 +1019,7 @@ aic79xx_setup(char *s)
 		{ "slewrate", NULL },
 		{ "precomp", NULL },
 		{ "amplitude", NULL },
+		{ "slowcrc", &aic79xx_slowcrc },
 	};
 
 	end = strchr(s, '\0');
diff --git a/drivers/scsi/aic7xxx/aic79xx_pci.c b/drivers/scsi/aic7xxx/aic79xx_pci.c
--- a/drivers/scsi/aic7xxx/aic79xx_pci.c
+++ b/drivers/scsi/aic7xxx/aic79xx_pci.c
@@ -38,7 +38,7 @@
  * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  * POSSIBILITY OF SUCH DAMAGES.
  *
- * $Id: //depot/aic7xxx/aic7xxx/aic79xx_pci.c#89 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic79xx_pci.c#92 $
  */
 
 #ifdef __linux__
@@ -950,12 +950,19 @@ ahd_aic790X_setup(struct ahd_softc *ahd)
 		if ((ahd->flags & AHD_HP_BOARD) == 0)
 			AHD_SET_SLEWRATE(ahd, AHD_SLEWRATE_DEF_REVA);
 	} else {
+		/* This is revision B and newer. */
+		extern uint32_t aic79xx_slowcrc;
 		u_int devconfig1;
 
 		ahd->features |= AHD_RTI|AHD_NEW_IOCELL_OPTS
-			      |  AHD_NEW_DFCNTRL_OPTS|AHD_FAST_CDB_DELIVERY;
+			      |  AHD_NEW_DFCNTRL_OPTS|AHD_FAST_CDB_DELIVERY
+			      |  AHD_BUSFREEREV_BUG;
 		ahd->bugs |= AHD_LQOOVERRUN_BUG|AHD_EARLY_REQ_BUG;
 
+		/* If the user requested the the SLOWCRC bit to be set. */
+		if (aic79xx_slowcrc)
+			ahd->features |= AHD_AIC79XXB_SLOWCRC;
+
 		/*
 		 * Some issues have been resolved in the 7901B.
 		 */

--------------060900080609000100030104--

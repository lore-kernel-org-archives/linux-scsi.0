From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: [ANNOUNCE] Adaptec SAS/SATA device driver [19/27]
Date: Thu, 17 Feb 2005 12:37:18 -0500
Message-ID: <4214D64E.5040102@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from magic.adaptec.com ([216.52.22.17]:28562 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262333AbVBQRh3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 12:37:29 -0500
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id j1HHbMr31441
	for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2005 09:37:22 -0800
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id j1HHbLb21436
	for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2005 09:37:21 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hardware registers macro definitions.  Part 2/2.

+#define	LmMnSATAFS(LinkNum, Mode)	LmSEQ_PHY_REG(Mode, LinkNum, 0x7E)
+#define	LmMnXMTSIZE(LinkNum, Mode)	LmSEQ_PHY_REG(Mode, LinkNum, 0x93)
+
+/* mode 0 */
+#define LmMnFRMERR(LinkNum, Mode)	LmSEQ_PHY_REG(Mode, LinkNum, 0xB0)
+
+#define		LmACRCERR		0x00000800   
+#define		LmPHYOVRN		0x00000400  
+#define		LmOBOVRN		0x00000200   
+#define 	LmMnZERODATA		0x00000100  
+#define		LmSATAINTLK		0x00000080   
+#define		LmMnCRCERR		0x00000020  
+#define		LmRRDYOVRN		0x00000010 
+#define		LmMISSSOAF		0x00000008   
+#define		LmMISSSOF		0x00000004  
+#define		LmMISSEOAF		0x00000002 
+#define		LmMISSEOF		0x00000001
+#define 	LmMnFRMERR_INIT		0xFFFFFFFF
+
+#define LmFRMERREN(LinkNum)		LmSEQ_PHY_REG(0, LinkNum, 0xB4)
+
+#define 	EN_LmACRCERR		0x00000800
+#define 	EN_LmPHYOVRN		0x00000400
+#define 	EN_LmOBOVRN		0x00000200 
+#define 	EN_LmMnZERODATA		0x00000100 
+#define 	EN_LmSATAINTLK		0x00000080
+#define 	EN_LmFRMBAD		0x00000040
+#define 	EN_LmMnCRCERR		0x00000020
+#define 	EN_LmRRDYOVRN		0x00000010
+#define 	EN_LmMISSSOAF		0x00000008
+#define 	EN_LmMISSSOF		0x00000004
+#define 	EN_LmMISSEOAF		0x00000002 
+#define 	EN_LmMISSEOF		0x00000001  
+
+#define 	LmFRMERREN_MASK  	(EN_LmSATAINTLK | EN_LmMnCRCERR | \
+					 EN_LmRRDYOVRN | EN_LmMISSSOF | \
+					 EN_LmMISSEOAF | EN_LmMISSEOF | \
+					 EN_LmACRCERR | LmPHYOVRN | \
+					 EN_LmOBOVRN | EN_LmMnZERODATA)
+
+#define LmHWTSTATEN(LinkNum)		LmSEQ_PHY_REG(0, LinkNum, 0xC5)
+                                 
+#define		EN_LmDONETO		0x80  
+#define		EN_LmINVDISP		0x40 
+#define		EN_LmINVDW		0x20     
+#define		EN_LmDWSEVENT		0x08    
+#define		EN_LmCRTTTO		0x04    
+#define		EN_LmANTTTO		0x02     
+#define		EN_LmBITLTTO		0x01
+
+#define		LmHWTSTATEN_MASK	(EN_LmINVDISP | EN_LmINVDW | \
+					 EN_LmDWSEVENT | EN_LmCRTTTO | \
+					 EN_LmANTTTO | EN_LmDONETO | \
+					 EN_LmBITLTTO)
+
+#define LmHWTSTAT(LinkNum) 		LmSEQ_PHY_REG(0, LinkNum, 0xC7)
+        
+#define		LmDONETO		0x80 
+#define		LmINVDISP		0x40   
+#define		LmINVDW			0x20  
+#define		LmDWSEVENT		0x08 
+#define		LmCRTTTO		0x04
+#define		LmANTTTO		0x02
+#define		LmBITLTTO		0x01
+
+#define		LmHWTSTAT_MASK		0xFF
+
+#define LmMnDATABUFADR(LinkNum, Mode)	LmSEQ_PHY_REG(Mode, LinkNum, 0xC8)
+#define		LmDATABUFADR_MASK	0x0FFF
+
+#define LmMnDATABUF(LinkNum, Mode)	LmSEQ_PHY_REG(Mode, LinkNum, 0xCA)
+
+#define	LmPRMSTAT0EN(LinkNum)		LmSEQ_PHY_REG(0, LinkNum, 0xE0)        
+
+#define 	EN_LmUNKNOWNP 		0x20000000  
+#define 	EN_LmBREAK		0x10000000   
+#define 	EN_LmDONE		0x08000000  
+#define 	EN_LmOPENACPT		0x04000000 
+#define 	EN_LmOPENRJCT		0x02000000  
+#define 	EN_LmOPENRTRY		0x01000000 
+#define 	EN_LmCLOSERV1		0x00800000
+#define 	EN_LmCLOSERV0		0x00400000   
+#define 	EN_LmCLOSENORM		0x00200000  
+#define 	EN_LmCLOSECLAF		0x00100000 
+#define 	EN_LmNOTIFYRV2		0x00080000   
+#define 	EN_LmNOTIFYRV1		0x00040000  
+#define 	EN_LmNOTIFYRV0		0x00020000 
+#define 	EN_LmNOTIFYSPIN		0x00010000
+#define 	EN_LmBROADRV4		0x00008000   
+#define 	EN_LmBROADRV3		0x00004000  
+#define 	EN_LmBROADRV2		0x00002000 
+#define 	EN_LmBROADRV1		0x00001000   
+#define 	EN_LmBROADRV0		0x00000800  
+#define 	EN_LmBROADRVCH1		0x00000400 
+#define 	EN_LmBROADRVCH0		0x00000200  
+#define 	EN_LmBROADCH		0x00000100   
+#define 	EN_LmAIPRVWP		0x00000080  
+#define 	EN_LmAIPWP		0x00000040   
+#define 	EN_LmAIPWD		0x00000020   
+#define 	EN_LmAIPWC		0x00000010  
+#define 	EN_LmAIPRV2		0x00000008  
+#define 	EN_LmAIPRV1		0x00000004   
+#define 	EN_LmAIPRV0		0x00000002  
+#define 	EN_LmAIPNRML		0x00000001 
+
+#define		LmPRMSTAT0EN_MASK	(EN_LmUNKNOWNP | EN_LmBREAK | \
+					 EN_LmDONE | EN_LmOPENACPT | \
+					 EN_LmOPENRJCT | EN_LmOPENRTRY | \
+					 EN_LmCLOSERV1 | EN_LmCLOSERV0 | \
+					 EN_LmCLOSENORM | EN_LmCLOSECLAF | \
+					 EN_LmBROADRV4 | EN_LmBROADRV3 | \
+					 EN_LmBROADRV2 | EN_LmBROADRV1 | \
+					 EN_LmBROADRV0 | EN_LmBROADRVCH1 | \
+					 EN_LmBROADRVCH0 | EN_LmBROADCH | \
+					 EN_LmAIPRVWP | EN_LmAIPWP | \
+					 EN_LmAIPWD | EN_LmAIPWC | \
+					 EN_LmAIPRV2 | EN_LmAIPRV1 | \
+					 EN_LmAIPRV0 | EN_LmAIPNRML)
+
+#define LmPRMSTAT1EN(LinkNum) 		LmSEQ_PHY_REG(0, LinkNum, 0xE4)        
+
+#define		EN_LmXRDY		0x00040000   
+#define		EN_LmSYNCSRST		0x00020000  
+#define		EN_LmSYNC		0x00010000 
+#define 	EN_LmXHOLD		0x00008000
+#define 	EN_LmRRDY		0x00004000   
+#define 	EN_LmHOLD		0x00002000  
+#define 	EN_LmROK		0x00001000 
+#define 	EN_LmRIP		0x00000800
+#define 	EN_LmCRBLK		0x00000400   
+#define 	EN_LmACK		0x00000200  
+#define 	EN_LmNAK		0x00000100 
+#define 	EN_LmHARDRST		0x00000080
+#define 	EN_LmERROR		0x00000040   
+#define 	EN_LmRERR		0x00000020  
+#define 	EN_LmPMREQP		0x00000010 
+#define 	EN_LmPMREQS		0x00000008
+#define 	EN_LmPMACK		0x00000004   
+#define 	EN_LmPMNAK		0x00000002  
+#define 	EN_LmDMAT		0x00000001 
+
+#define LmPRMSTAT1EN_MASK		(EN_LmHARDRST | \
+					 EN_LmDMAT | EN_LmSYNCSRST | \
+					 EN_LmPMREQP | EN_LmPMREQS | \
+					 EN_LmPMACK | EN_LmPMNAK)
+
+#define LmSMSTATE(LinkNum) 		LmSEQ_PHY_REG(0, LinkNum, 0xE8)        
+
+#define LmSMSTATEBRK(LinkNum) 		LmSEQ_PHY_REG(0, LinkNum, 0xEC)        
+
+#define LmSMDBGCTL(LinkNum) 		LmSEQ_PHY_REG(0, LinkNum, 0xF0)        
+
+
+/* 
+ * LmSEQ CIO Bus Mode 3 Register.
+ * Mode 3: Configuration and Setup, IOP Context SCB.	 
+ */
+#define LmM3SATATIMER(LinkNum) 		LmSEQ_PHY_REG(3, LinkNum, 0x48)
+ 
+#define LmM3INTVEC0(LinkNum)		LmSEQ_PHY_REG(3, LinkNum, 0x90)
+
+#define LmM3INTVEC1(LinkNum)		LmSEQ_PHY_REG(3, LinkNum, 0x92)
+
+#define LmM3INTVEC2(LinkNum)		LmSEQ_PHY_REG(3, LinkNum, 0x94)
+
+#define LmM3INTVEC3(LinkNum)		LmSEQ_PHY_REG(3, LinkNum, 0x96)
+
+#define LmM3INTVEC4(LinkNum)		LmSEQ_PHY_REG(3, LinkNum, 0x98)
+
+#define LmM3INTVEC5(LinkNum)		LmSEQ_PHY_REG(3, LinkNum, 0x9A)
+
+#define LmM3INTVEC6(LinkNum)		LmSEQ_PHY_REG(3, LinkNum, 0x9C)
+
+#define LmM3INTVEC7(LinkNum)		LmSEQ_PHY_REG(3, LinkNum, 0x9E)
+                          
+#define LmM3INTVEC8(LinkNum)		LmSEQ_PHY_REG(3, LinkNum, 0xA4)
+
+#define LmM3INTVEC9(LinkNum)		LmSEQ_PHY_REG(3, LinkNum, 0xA6)
+
+#define LmM3INTVEC10(LinkNum)		LmSEQ_PHY_REG(3, LinkNum, 0xB0)
+
+#define LmM3FRMGAP(LinkNum)		LmSEQ_PHY_REG(3, LinkNum, 0xB4)
+
+#define LmBITL_TIMER(LinkNum) 		LmSEQ_PHY_REG(0, LinkNum, 0xA2)
+
+#define LmWWN(LinkNum) 			LmSEQ_PHY_REG(0, LinkNum, 0xA8)
+
+
+/* 
+ * LmSEQ CIO Bus Mode 5 Registers.
+ * Mode 5: Phy/OOB Control and Status.	 
+ */
+#define LmSEQ_OOB_REG(phy_id, reg)	LmSEQ_PHY_REG(5, (phy_id), (reg))
+
+#define OOB_BFLTR	0x100
+
+#define		BFLTR_THR_MASK		0xF0       
+#define		BFLTR_TC_MASK		0x0F
+
+#define OOB_INIT_MIN	0x102
+
+#define OOB_INIT_MAX	0x104
+
+#define OOB_INIT_NEG	0x106
+
+#define	OOB_SAS_MIN	0x108
+
+#define OOB_SAS_MAX	0x10A
+
+#define OOB_SAS_NEG	0x10C
+
+#define OOB_WAKE_MIN	0x10E
+
+#define OOB_WAKE_MAX	0x110
+
+#define OOB_WAKE_NEG	0x112
+
+#define OOB_IDLE_MAX	0x114
+
+#define OOB_BURST_MAX	0x116
+
+#define OOB_DATA_KBITS	0x126
+
+#define OOB_ALIGN_0_DATA	0x12C
+
+#define OOB_ALIGN_1_DATA	0x130
+
+#define D10_2_DATA_k		0x00
+#define SYNC_DATA_k		0x02
+#define ALIGN_1_DATA_k		0x04
+#define ALIGN_0_DATA_k		0x08
+#define BURST_DATA_k		0x10
+
+#define OOB_PHY_RESET_COUNT	0x13C
+
+#define OOB_SIG_GEN	0x140
+
+#define		START_OOB		0x80
+#define		START_DWS		0x40
+#define		ALIGN_CNT3		0x30
+#define 	ALIGN_CNT2		0x20
+#define 	ALIGN_CNT1		0x10
+#define 	ALIGN_CNT4		0x00
+#define		STOP_DWS		0x08
+#define		SEND_COMSAS		0x04
+#define		SEND_COMINIT		0x02
+#define		SEND_COMWAKE		0x01
+
+#define OOB_XMIT	0x141
+
+#define		TX_ENABLE		0x80
+#define		XMIT_OOB_BURST		0x10
+#define		XMIT_D10_2		0x08
+#define		XMIT_SYNC		0x04
+#define		XMIT_ALIGN_1		0x02
+#define		XMIT_ALIGN_0		0x01
+
+#define FUNCTION_MASK	0x142
+
+#define		SAS_MODE_DIS		0x80
+#define		SATA_MODE_DIS		0x40
+#define		SPINUP_HOLD_DIS		0x20
+#define		HOT_PLUG_DIS		0x10
+#define		SATA_PS_DIS		0x08
+#define		FUNCTION_MASK_DEFAULT	(SPINUP_HOLD_DIS | SATA_PS_DIS)
+
+#define OOB_MODE	0x143
+
+#define		SAS_MODE		0x80
+#define		SATA_MODE		0x40
+#define		SLOW_CLK		0x20
+#define		FORCE_XMIT_15		0x08
+#define		PHY_SPEED_60		0x04
+#define		PHY_SPEED_30		0x02
+#define		PHY_SPEED_15		0x01
+
+#define	CURRENT_STATUS	0x144
+
+#define		CURRENT_OOB_DONE	0x80
+#define		CURRENT_LOSS_OF_SIGNAL	0x40
+#define		CURRENT_SPINUP_HOLD	0x20
+#define		CURRENT_HOT_PLUG_CNCT	0x10
+#define		CURRENT_GTO_TIMEOUT	0x08
+#define		CURRENT_OOB_TIMEOUT	0x04
+#define		CURRENT_DEVICE_PRESENT	0x02
+#define		CURRENT_OOB_ERROR	0x01
+
+#define 	CURRENT_OOB1_ERROR	(CURRENT_HOT_PLUG_CNCT | \
+					 CURRENT_GTO_TIMEOUT)
+
+#define 	CURRENT_OOB2_ERROR	(CURRENT_HOT_PLUG_CNCT | \
+					 CURRENT_OOB_ERROR)
+
+#define		DEVICE_ADDED_W_CNT	(CURRENT_OOB_DONE | \
+					 CURRENT_HOT_PLUG_CNCT | \
+					 CURRENT_DEVICE_PRESENT)
+					 
+#define		DEVICE_ADDED_WO_CNT	(CURRENT_OOB_DONE | \
+					 CURRENT_DEVICE_PRESENT)
+					 
+#define 	DEVICE_REMOVED		CURRENT_LOSS_OF_SIGNAL
+
+#define		CURRENT_PHY_MASK	(CURRENT_OOB_DONE | \
+					 CURRENT_LOSS_OF_SIGNAL | \
+					 CURRENT_SPINUP_HOLD | \
+					 CURRENT_HOT_PLUG_CNCT | \
+					 CURRENT_GTO_TIMEOUT | \
+					 CURRENT_DEVICE_PRESENT | \
+					 CURRENT_OOB_ERROR )
+					
+#define		CURRENT_ERR_MASK	(CURRENT_LOSS_OF_SIGNAL | \
+					 CURRENT_GTO_TIMEOUT | \
+					 CURRENT_OOB_TIMEOUT | \
+					 CURRENT_OOB_ERROR )
+					 
+#define SPEED_MASK	0x145
+
+#define		SATA_SPEED_30_DIS	0x10   
+#define		SATA_SPEED_15_DIS	0x08 
+#define		SAS_SPEED_60_DIS	0x04
+#define		SAS_SPEED_30_DIS	0x02
+#define		SAS_SPEED_15_DIS	0x01
+#define		SAS_SPEED_MASK_DEFAULT	0x00
+
+#define OOB_TIMER_ENABLE	0x14D
+
+#define		HOT_PLUG_EN		0x80
+#define		RCD_EN			0x40  
+#define 	COMTIMER_EN		0x20  
+#define		SNTT_EN			0x10 
+#define		SNLT_EN			0x04 
+#define		SNWT_EN			0x02 
+#define		ALIGN_EN		0x01 
+
+#define OOB_STATUS		0x14E
+
+#define		OOB_DONE		0x80
+#define		LOSS_OF_SIGNAL		0x40		/* ro */		
+#define		SPINUP_HOLD		0x20
+#define		HOT_PLUG_CNCT		0x10		/* ro */
+#define		GTO_TIMEOUT		0x08		/* ro */
+#define		OOB_TIMEOUT		0x04		/* ro */		
+#define		DEVICE_PRESENT		0x02		/* ro */
+#define		OOB_ERROR		0x01		/* ro */
+
+#define		OOB_STATUS_ERROR_MASK	(LOSS_OF_SIGNAL | GTO_TIMEOUT | \
+					 OOB_TIMEOUT | OOB_ERROR)
+				
+#define OOB_STATUS_CLEAR	0x14F
+
+#define		OOB_DONE_CLR		0x80
+#define		LOSS_OF_SIGNAL_CLR 	0x40	
+#define		SPINUP_HOLD_CLR		0x20
+#define		HOT_PLUG_CNCT_CLR     	0x10
+#define		GTO_TIMEOUT_CLR		0x08
+#define		OOB_TIMEOUT_CLR		0x04		
+#define		OOB_ERROR_CLR		0x01
+
+#define HOT_PLUG_DELAY		0x150
+
+#define	HOTPLUG_DEFAULT_DELAY		20
+
+
+#define INT_ENABLE_2		0x15A
+
+#define		OOB_DONE_EN		0x80
+#define		LOSS_OF_SIGNAL_EN	0x40	
+#define		SPINUP_HOLD_EN		0x20
+#define		HOT_PLUG_CNCT_EN	0x10
+#define		GTO_TIMEOUT_EN		0x08
+#define		OOB_TIMEOUT_EN		0x04
+#define		DEVICE_PRESENT_EN	0x02
+#define		OOB_ERROR_EN		0x01
+
+#define PHY_CONTROL_0		0x160
+
+#define		PHY_LOWPWREN_TX		0x80
+#define		PHY_LOWPWREN_RX		0x40
+#define		SPARE_REG_160_B5	0x20
+#define		OFFSET_CANCEL_RX	0x10
+
+/* bits 3:2 */
+#define		PHY_RXCOMCENTER_60V	0x00
+#define		PHY_RXCOMCENTER_70V	0x04
+#define		PHY_RXCOMCENTER_80V	0x08
+#define		PHY_RXCOMCENTER_90V	0x0C
+#define 	PHY_RXCOMCENTER_MASK	0x0C
+
+#define		PHY_RESET		0x02
+#define		SAS_DEFAULT_SEL		0x01
+ 
+#define PHY_CONTROL_1		0x161
+
+/* bits 2:0 */
+#define		SATA_PHY_DETLEVEL_50mv	0x00
+#define		SATA_PHY_DETLEVEL_75mv	0x01
+#define		SATA_PHY_DETLEVEL_100mv	0x02
+#define		SATA_PHY_DETLEVEL_125mv	0x03
+#define		SATA_PHY_DETLEVEL_150mv	0x04
+#define		SATA_PHY_DETLEVEL_175mv	0x05
+#define		SATA_PHY_DETLEVEL_200mv	0x06
+#define		SATA_PHY_DETLEVEL_225mv	0x07
+#define		SATA_PHY_DETLEVEL_MASK	0x07
+
+/* bits 5:3 */
+#define		SAS_PHY_DETLEVEL_50mv	0x00
+#define		SAS_PHY_DETLEVEL_75mv	0x08
+#define		SAS_PHY_DETLEVEL_100mv	0x10
+#define		SAS_PHY_DETLEVEL_125mv	0x11
+#define		SAS_PHY_DETLEVEL_150mv	0x20
+#define		SAS_PHY_DETLEVEL_175mv	0x21
+#define		SAS_PHY_DETLEVEL_200mv	0x30
+#define		SAS_PHY_DETLEVEL_225mv	0x31
+#define		SAS_PHY_DETLEVEL_MASK	0x38
+
+#define PHY_CONTROL_2		0x162
+
+/* bits 7:5 */
+#define 	SATA_PHY_DRV_400mv	0x00
+#define 	SATA_PHY_DRV_450mv	0x20
+#define 	SATA_PHY_DRV_500mv	0x40
+#define 	SATA_PHY_DRV_550mv	0x60
+#define 	SATA_PHY_DRV_600mv	0x80
+#define 	SATA_PHY_DRV_650mv	0xA0
+#define 	SATA_PHY_DRV_725mv	0xC0
+#define 	SATA_PHY_DRV_800mv	0xE0
+#define		SATA_PHY_DRV_MASK	0xE0
+
+/* bits 4:3 */
+#define 	SATA_PREEMP_0		0x00
+#define 	SATA_PREEMP_1		0x08
+#define 	SATA_PREEMP_2		0x10
+#define 	SATA_PREEMP_3		0x18
+#define 	SATA_PREEMP_MASK	0x18
+
+#define 	SATA_CMSH1P5		0x04
+
+/* bits 1:0 */
+#define 	SATA_SLEW_0		0x00
+#define 	SATA_SLEW_1		0x01
+#define 	SATA_SLEW_2		0x02
+#define 	SATA_SLEW_3		0x03
+#define 	SATA_SLEW_MASK		0x03
+
+#define PHY_CONTROL_3		0x163
+
+/* bits 7:5 */
+#define 	SAS_PHY_DRV_400mv	0x00
+#define 	SAS_PHY_DRV_450mv	0x20
+#define 	SAS_PHY_DRV_500mv	0x40
+#define 	SAS_PHY_DRV_550mv	0x60
+#define 	SAS_PHY_DRV_600mv	0x80
+#define 	SAS_PHY_DRV_650mv	0xA0
+#define 	SAS_PHY_DRV_725mv	0xC0
+#define 	SAS_PHY_DRV_800mv	0xE0
+#define		SAS_PHY_DRV_MASK	0xE0
+
+/* bits 4:3 */
+#define 	SAS_PREEMP_0		0x00
+#define 	SAS_PREEMP_1		0x08
+#define 	SAS_PREEMP_2		0x10
+#define 	SAS_PREEMP_3		0x18
+#define 	SAS_PREEMP_MASK		0x18
+
+#define 	SAS_CMSH1P5		0x04
+
+/* bits 1:0 */
+#define 	SAS_SLEW_0		0x00
+#define 	SAS_SLEW_1		0x01
+#define 	SAS_SLEW_2		0x02
+#define 	SAS_SLEW_3		0x03
+#define 	SAS_SLEW_MASK		0x03
+
+#define PHY_CONTROL_4		0x168
+
+#define		PHY_DONE_CAL_TX		0x80
+#define		PHY_DONE_CAL_RX		0x40
+#define		RX_TERM_LOAD_DIS	0x20
+#define		TX_TERM_LOAD_DIS	0x10
+#define		AUTO_TERM_CAL_DIS	0x08
+#define		PHY_SIGDET_FLTR_EN	0x04
+#define		OSC_FREQ		0x02
+#define		PHY_START_CAL		0x01
+
+/* 
+ * HST_PCIX2 Registers, Addresss Range: (0x00-0xFC)
+ */
+#define PCIX_REG_BASE_ADR		0xB8040000
+
+#define PCIC_VENDOR_ID	0x00
+
+#define PCIC_DEVICE_ID	0x02
+
+#define PCIC_COMMAND	0x04
+
+#define		INT_DIS			0x0400
+#define		FBB_EN			0x0200		/* ro */
+#define		SERR_EN			0x0100
+#define		STEP_EN			0x0080		/* ro */
+#define		PERR_EN			0x0040
+#define		VGA_EN			0x0020		/* ro */
+#define		MWI_EN			0x0010
+#define		SPC_EN			0x0008
+#define		MST_EN			0x0004
+#define		MEM_EN			0x0002
+#define		IO_EN			0x0001
+
+#define	PCIC_STATUS	0x06
+
+#define		PERR_DET		0x8000
+#define		SERR_GEN		0x4000
+#define		MABT_DET		0x2000
+#define		TABT_DET		0x1000
+#define		TABT_GEN		0x0800
+#define		DPERR_DET		0x0100
+#define		CAP_LIST		0x0010
+#define		INT_STAT		0x0008
+
+#define	PCIC_DEVREV_ID	0x08
+
+#define	PCIC_CLASS_CODE	0x09
+
+#define	PCIC_CACHELINE_SIZE	0x0C
+				
+#define	PCIC_MBAR0	0x10
+
+#define 	PCIC_MBAR0_OFFSET	0
+
+#define	PCIC_MBAR1	0x18
+
+#define 	PCIC_MBAR1_OFFSET	2
+
+#define	PCIC_IOBAR	0x20
+
+#define 	PCIC_IOBAR_OFFSET	4
+
+#define	PCIC_SUBVENDOR_ID	0x2C
+
+#define PCIC_SUBSYTEM_ID	0x2E
+
+#define PCIC_PM_CSR		0x5C
+
+#define		PWR_STATE_D0		0			
+#define		PWR_STATE_D1		1	/* not supported */
+#define		PWR_STATE_D2		2 	/* not supported */
+#define		PWR_STATE_D3		3
+			
+#define PCIC_BASE1	0x6C	/* internal use only */
+
+#define		BASE1_RSVD		0xFFFFFFF8
+
+#define PCIC_BASEA	0x70	/* internal use only */
+
+#define		BASEA_RSVD		0xFFFFFFC0
+#define 	BASEA_START		0x0
+
+#define PCIC_BASEB	0x74	/* internal use only */
+
+#define		BASEB_RSVD		0xFFFFFF80
+#define		BASEB_IOMAP_MASK	0x7F
+#define 	BASEB_START		0x80
+
+#define PCIC_BASEC	0x78	/* internal use only */
+
+#define		BASEC_RSVD		0xFFFFFFFC
+#define 	BASEC_MASK		0x03
+#define 	BASEC_START		0x58
+
+#define PCIC_MBAR_KEY	0x7C	/* internal use only */
+
+#define 	MBAR_KEY_MASK		0xFFFFFFFF
+
+#define PCIC_HSTPCIX_CNTRL	0xA0
+
+#define 	REWIND_DIS		0x0800
+
+#define PCIC_MBAR0_MASK	0xA8
+#define		PCIC_MBAR0_SIZE_MASK 	0x1FFFE000
+#define		PCIC_MBAR0_SIZE_SHIFT 	13
+#define		PCIC_MBAR0_SIZE(val)	\
+		    (((val) & PCIC_MBAR0_SIZE_MASK) >> PCIC_MBAR0_SIZE_SHIFT)
+
+#define PCIC_FLASH_MBAR	0xB8
+
+#define PCIC_TP_CTRL	0xFC
+
+/* 
+ * EXSI Registers, Addresss Range: (0x00-0xFC)
+ */
+#define EXSI_REG_BASE_ADR		0xB8042800
+
+#define	EXSICNFGR	0x00     
+
+#define		ASIEN			0x00400000  
+#define		HCMODE			0x00200000 
+#define		PCIDEF			0x00100000    
+#define		COMSTOCK		0x00080000   
+#define		SEEPROMEND		0x00040000  
+#define		MSTTIMEN		0x00020000 
+#define		XREGEX			0x00000200
+#define		NVRAMW			0x00000100     
+#define		NVRAMEX			0x00000080    
+#define		SRAMW			0x00000040   
+#define		SRAMEX			0x00000020  
+#define		FLASHW			0x00000010 
+#define		FLASHEX			0x00000008
+#define		SEEPROMCFG		0x00000004     
+#define		SEEPROMTYP		0x00000002    
+#define		SEEPROMEX		0x00000001   
+
+
+#define EXSICNTRLR	0x04
+                                      
+#define		MODINT_EN		0x00000001     
+
+
+#define PMSTATR		0x10     
+                                       
+#define		FLASHRST		0x00000002  
+#define		FLASHRDY		0x00000001 
+
+
+#define FLCNFGR		0x14     
+                                       
+#define		FLWEH_MASK		0x30000000  
+#define		FLWESU_MASK		0x0C000000 
+#define		FLWEPW_MASK		0x03F00000
+#define		FLOEH_MASK		0x000C0000     
+#define 	FLOESU_MASK		0x00030000    
+#define 	FLOEPW_MASK		0x0000FC00   
+#define 	FLCSH_MASK		0x00000300  
+#define 	FLCSSU_MASK		0x000000C0 
+#define 	FLCSPW_MASK		0x0000003F
+
+#define SRCNFGR		0x18     
+                                       
+#define		SRWEH_MASK		0x30000000  
+#define		SRWESU_MASK		0x0C000000 
+#define		SRWEPW_MASK		0x03F00000
+
+#define		SROEH_MASK		0x000C0000     
+#define 	SROESU_MASK		0x00030000    
+#define 	SROEPW_MASK		0x0000FC00   
+#define		SRCSH_MASK		0x00000300  
+#define		SRCSSU_MASK		0x000000C0 
+#define		SRCSPW_MASK		0x0000003F
+
+#define NVCNFGR		0x1C     
+                                   
+#define 	NVWEH_MASK		0x30000000    
+#define 	NVWESU_MASK		0x0C000000   
+#define 	NVWEPW_MASK		0x03F00000  
+#define 	NVOEH_MASK		0x000C0000    
+#define 	NVOESU_MASK		0x00030000   
+#define 	NVOEPW_MASK		0x0000FC00  
+#define 	NVCSH_MASK		0x00000300   
+#define 	NVCSSU_MASK		0x000000C0  
+#define 	NVCSPW_MASK		0x0000003F 
+
+#define XRCNFGR		0x20     
+                                    
+#define 	XRWEH_MASK		0x30000000     
+#define 	XRWESU_MASK		0x0C000000    
+#define 	XRWEPW_MASK		0x03F00000   
+#define 	XROEH_MASK		0x000C0000  
+#define 	XROESU_MASK		0x00030000 
+#define 	XROEPW_MASK		0x0000FC00
+#define 	XRCSH_MASK		0x00000300    
+#define 	XRCSSU_MASK		0x000000C0   
+#define		XRCSPW_MASK		0x0000003F  
+
+#define XREGADDR	0x24     
+                                     
+#define 	XRADDRINCEN		0x80000000    
+#define 	XREGADD_MASK		0x007FFFFF   
+
+
+#define XREGDATAR	0x28     
+                                      
+#define		XREGDATA_MASK 		0x0000FFFF    
+
+#define GPIOOER		0x40     
+                                       
+#define GPIOODENR	0x44     
+                                      
+#define GPIOINVR	0x48     
+
+#define GPIODATAOR	0x4C     
+
+#define GPIODATAIR	0x50     
+
+#define GPIOCNFGR	0x54     
+
+#define		GPIO_EXTSRC		0x00000001    
+
+#define SCNTRLR		0xA0     
+    
+#define 	SXFERDONE		0x00000100 
+#define 	SXFERCNT_MASK		0x000000E0
+#define 	SCMDTYP_MASK		0x0000001C     
+#define 	SXFERSTART		0x00000002    
+#define 	SXFEREN			0x00000001
+
+#define	SRATER		0xA4
+
+#define	SADDRR		0xA8
+
+#define 	SADDR_MASK		0x0000FFFF
+
+#define SDATAOR		0xAC
+
+#define	SDATAOR0	0xAC
+#define SDATAOR1	0xAD
+#define SDATAOR2	0xAE
+#define SDATAOR3	0xAF
+
+#define SDATAIR		0xB0
+
+#define SDATAIR0	0xB0
+#define SDATAIR1	0xB1
+#define SDATAIR2	0xB2
+#define SDATAIR3	0xB3
+
+/* 
+ * NVRAM Registers, Address Range: (0x00000 - 0x3FFFF).
+ */
+#define NVRAM_REG_BASE_ADR		0xBF800000
+
+#define NVRAM_MAX_BASE_ADR		0x003FFFFF
+
+/* OCM base address */
+#define OCM_BASE_ADDR			0xA0000000
+#define OCM_MAX_SIZE			0x20000
+
+/* 
+ * Sequencers (Central and Link) Scratch RAM page definitions.
+ */ 
+
+/*
+ * Central Management Sequencer scratch RAM is 1024 bytes. 
+ * This scratch memory is divided into mode dependent and mode
+ * independent scratch with this memory further subdivided into
+ * pages of size 32 bytes. There are 5 pages (160 bytes) of
+ * mode independent scratch and 3 pages of dependent scratch 
+ * memory for modes 0-7 (768 bytes). Mode 8 pages 0-2 dependent
+ * scratch overlap with pages 0-2 of mode independent scratch memory.
+ *
+ * The host accesses this scratch in a different manner from the 
+ * central sequencer. The sequencer has to use CSEQ registers
+ * CSCRPAGE and CMnSCRPAGE to access the scratch memory. A flat
+ * mapping of the scratch memory is avaliable for software
+ * convenience and to prevent corruption while the sequencer is
+ * running. This memory is mapped onto addresses 800h - FFFh. 
+ *  
+ * These addresses are mapped as follows:
+ *
+ *        800h-83Fh   Mode Dependent Scratch Mode 0 Pages 0-1
+ *        840h-87Fh   Mode Dependent Scratch Mode 1 Pages 0-1
+ *        880h-8BFh   Mode Dependent Scratch Mode 2 Pages 0-1
+ *        8C0h-8FFh   Mode Dependent Scratch Mode 3 Pages 0-1
+ *        900h-93Fh   Mode Dependent Scratch Mode 4 Pages 0-1
+ *        940h-97Fh   Mode Dependent Scratch Mode 5 Pages 0-1
+ *        980h-9BFh   Mode Dependent Scratch Mode 6 Pages 0-1
+ *        9C0h-9FFh   Mode Dependent Scratch Mode 7 Pages 0-1
+ *        A00h-A5Fh   Mode Dependent Scratch Mode 8 Pages 0-2
+ *        A00h-A5Fh   Mode Independent Scratch Pages 0-2
+ *        A80h-AFFh   Mode Independent Scratch Pages 4-7
+ *        B00h-B1Fh   Mode Dependent Scratch Mode 0 Page 2
+ *        B20h-B3Fh   Mode Dependent Scratch Mode 1 Page 2
+ *        B40h-B5Fh   Mode Dependent Scratch Mode 2 Page 2
+ *        B60h-B7Fh   Mode Dependent Scratch Mode 3 Page 2
+ *        B80h-B9Fh   Mode Dependent Scratch Mode 4 Page 2
+ *        BA0h-BBFh   Mode Dependent Scratch Mode 5 Page 2
+ *        BC0h-BDFh   Mode Dependent Scratch Mode 6 Page 2
+ *        BE0h-BFFh   Mode Dependent Scratch Mode 7 Page 2
+ */
+
+/* General defines */
+#define CSEQ_PAGE_SIZE			32  /* Scratch page size (in bytes) */
+  
+/* All defines start with offsets from 0x800 (CMAPPEDSCR) */
+/* Mode Dependent Scratch page 0 Modes 0-7 definitions. */
+#define CSEQ_LRM_SAVE_SINDEX		(CMAPPEDSCR + 0x0000) 
+#define CSEQ_LRM_SAVE_SCBPTR		(CMAPPEDSCR + 0x0002) 
+#define CSEQ_Q_LINK_HEAD		(CMAPPEDSCR + 0x0004)
+#define CSEQ_Q_LINK_TAIL		(CMAPPEDSCR + 0x0006)
+
+/* Mode Dependent Scratch page 0 Mode 8 defines */
+#define CSEQ_RET_ADDR			(CMAPPEDSCR + 0x0200) 
+#define CSEQ_RET_SCBPTR			(CMAPPEDSCR + 0x0202)
+#define CSEQ_SAVE_SCBPTR		(CMAPPEDSCR + 0x0204)
+#define CSEQ_EMPTY_TRANS_CTX		(CMAPPEDSCR + 0x0206)
+#define CSEQ_RESP_LEN			(CMAPPEDSCR + 0x0208)
+#define CSEQ_TMF_SCBPTR			(CMAPPEDSCR + 0x020A)
+#define CSEQ_GLOBAL_PREV_SCB		(CMAPPEDSCR + 0x020C)
+#define CSEQ_GLOBAL_HEAD		(CMAPPEDSCR + 0x020E)
+#define CSEQ_TMF_OPCODE			(CMAPPEDSCR + 0x0210)
+#define CSEQ_CLEAR_LU_HEAD		(CMAPPEDSCR + 0x0212)
+#define CSEQ_FIRST_INV_SCB_SITE		(CMAPPEDSCR + 0x021C)
+#define CSEQ_FIRST_INV_DDB_SITE		(CMAPPEDSCR + 0x021E)
+ 
+/* Mode Dependent Scratch page 1 Mode 8 defines */
+#define CSEQ_LUN_TO_CLEAR		(CMAPPEDSCR + 0x0220)
+#define CSEQ_LUN_TO_CHECK		(CMAPPEDSCR + 0x0228)
+
+/* Mode Dependent Scratch page 2 Mode 8 defines */
+#define CSEQ_Q_NEW_POINTER		(CMAPPEDSCR + 0x0240)
+#define CSEQ_Q_DONE_BASE		(CMAPPEDSCR + 0x0248)
+#define CSEQ_Q_DONE_POINTER		(CMAPPEDSCR + 0x0250) 
+#define CSEQ_Q_DONE_PASS		(CMAPPEDSCR + 0x0254) 
+
+/* Mode Independent Scratch page 4 defines. */
+#define CSEQ_Q_EXE_HEAD			(CMAPPEDSCR + 0x0280)
+#define CSEQ_Q_EXE_TAIL			(CMAPPEDSCR + 0x0282)
+#define CSEQ_Q_DONE_HEAD		(CMAPPEDSCR + 0x0284)
+#define CSEQ_Q_DONE_TAIL		(CMAPPEDSCR + 0x0286)
+#define CSEQ_Q_SEND_HEAD		(CMAPPEDSCR + 0x0288)
+#define CSEQ_Q_SEND_TAIL		(CMAPPEDSCR + 0x028A)
+#define CSEQ_Q_DMA2CHIM_HEAD		(CMAPPEDSCR + 0x028C)
+#define CSEQ_Q_DMA2CHIM_TAIL		(CMAPPEDSCR + 0x028E) 
+#define CSEQ_Q_COPY_HEAD		(CMAPPEDSCR + 0x0290)
+#define CSEQ_Q_COPY_TAIL		(CMAPPEDSCR + 0x0292)
+#define CSEQ_REG0			(CMAPPEDSCR + 0x0294)
+#define CSEQ_REG1			(CMAPPEDSCR + 0x0296)
+#define CSEQ_REG2			(CMAPPEDSCR + 0x0298)
+#define CSEQ_REG3			(CMAPPEDSCR + 0x029A)
+#define CSEQ_LINK_CTL_Q_MAP		(CMAPPEDSCR + 0x029C)
+#define CSEQ_SCRATCH_FLAGS		(CMAPPEDSCR + 0x029F)
+
+/* Mode Independent Scratch page 5 defines. */
+#define CSEQ_FREE_SCB_MASK		(CMAPPEDSCR + 0x02B5) 
+#define CSEQ_BUILTIN_FREE_SCB_HEAD	(CMAPPEDSCR + 0x02B6) 
+#define CSEQ_BUILTIN_FREE_SCB_TAIL	(CMAPPEDSCR + 0x02B8) 
+#define CSEQ_EXTNDED_FREE_SCB_HEAD	(CMAPPEDSCR + 0x02BA) 
+#define CSEQ_EXTNDED_FREE_SCB_TAIL	(CMAPPEDSCR + 0x02BC) 
+
+/* Mode Independent Scratch page 6 defines. */
+#define CSEQ_INT_ROUT_RET_ADDR0		(CMAPPEDSCR + 0x02C0)
+#define CSEQ_INT_ROUT_RET_ADDR1		(CMAPPEDSCR + 0x02C2)
+#define CSEQ_INT_ROUT_SCBPTR		(CMAPPEDSCR + 0x02C4)
+#define CSEQ_INT_ROUT_MODE		(CMAPPEDSCR + 0x02C6)
+#define CSEQ_ISR_SCRATCH_FLAGS		(CMAPPEDSCR + 0x02C7)
+#define CSEQ_ISR_SAVE_SINDEX		(CMAPPEDSCR + 0x02C8)
+#define CSEQ_ISR_SAVE_DINDEX		(CMAPPEDSCR + 0x02CA)
+#define CSEQ_SLS_SAVE_ACCUM		(CMAPPEDSCR + 0x02CC)
+#define CSEQ_SLS_SAVE_SINDEX		(CMAPPEDSCR + 0x02CE)
+
+/* Mode Independent Scratch page 7 defines. */
+#define CSEQ_EMPTY_REQ_QUEUE		(CMAPPEDSCR + 0x02E0)
+#define CSEQ_EMPTY_REQ_COUNT		(CMAPPEDSCR + 0x02E8)
+#define CSEQ_Q_EMPTY_HEAD		(CMAPPEDSCR + 0x02F0)
+#define CSEQ_Q_EMPTY_TAIL		(CMAPPEDSCR + 0x02F2)
+#define CSEQ_NEED_EMPTY_SCB		(CMAPPEDSCR + 0x02F4)
+#define CSEQ_EMPTY_REQ_HEAD		(CMAPPEDSCR + 0x02F6)
+#define CSEQ_EMPTY_REQ_TAIL		(CMAPPEDSCR + 0x02F7)
+#define CSEQ_EMPTY_SCB_OFFSET		(CMAPPEDSCR + 0x02F8)
+#define CSEQ_PRIMITIVE_DATA		(CMAPPEDSCR + 0x02FA)
+#define CSEQ_TIMEOUT_CONSTANT		(CMAPPEDSCR + 0x02FC)
+
+/* Sequencer label public defines */
+#if SAS_SEQUENCER_A1
+/* 
+ * CSEQ A1 Interrupt Vector addresses based on Sequencer Alpha_7g18.
+ */
+#define CSEQ_INT_VEC0A1			0x0004
+#define CSEQ_INT_VEC1A1			0x000C
+#define CSEQ_INT_VEC2A1			0x0010
+
+#endif /* SAS_SEQUENCER_A1 */
+
+#if SAS_SEQUENCER_B0
+/* 
+ * CSEQ B0 Interrupt Vector addresses based on Sequencer Alpha_7g18.
+ */
+#define CSEQ_INT_VEC0B0			0x0004
+#define CSEQ_INT_VEC1B0			0x000C
+#define CSEQ_INT_VEC2B0			0x0010
+
+#endif /* SAS_SEQUENCER_B0 */
+
+#define CSEQ_IDLE_LOOP_ENTRY		0x0000
+#define CSEQ_SEQUENCER_PROGRAM		0x0000
+
+
+/***************************************************************************
+* Link m Sequencer scratch RAM is 512 bytes. 
+* This scratch memory is divided into mode dependent and mode
+* independent scratch with this memory further subdivided into
+* pages of size 32 bytes. There are 4 pages (128 bytes) of
+* mode independent scratch and 4 pages of dependent scratch 
+* memory for modes 0-2 (384 bytes).
+*
+* The host accesses this scratch in a different manner from the 
+* link sequencer. The sequencer has to use LSEQ registers
+* LmSCRPAGE and LmMnSCRPAGE to access the scratch memory. A flat
+* mapping of the scratch memory is avaliable for software
+* convenience and to prevent corruption while the sequencer is
+* running. This memory is mapped onto addresses 800h - 9FFh. 
+*  
+* These addresses are mapped as follows:
+*
+*        800h-85Fh   Mode Dependent Scratch Mode 0 Pages 0-2
+*        860h-87Fh   Mode Dependent Scratch Mode 0 Page 3
+*                    Mode Dependent Scratch Mode 5 Page 0 
+*        880h-8DFh   Mode Dependent Scratch Mode 1 Pages 0-2
+*        8E0h-8FFh   Mode Dependent Scratch Mode 1 Page 3
+*                    Mode Dependent Scratch Mode 5 Page 1 
+*        900h-95Fh   Mode Dependent Scratch Mode 2 Pages 0-2
+*        960h-97Fh   Mode Dependent Scratch Mode 2 Page 3
+*                    Mode Dependent Scratch Mode 5 Page 2 
+*        980h-9DFh   Mode Independent Scratch Pages 0-3
+*        9E0h-9FFh   Mode Independent Scratch Page 3
+*                    Mode Dependent Scratch Mode 5 Page 3 
+*
+****************************************************************************/
+/* General defines */
+#define LSEQ_MODE_SCRATCH_SIZE		128 /* Size of scratch RAM per mode */
+#define LSEQ_PAGE_SIZE			32  /* Scratch page size (in bytes) */  
+#define LSEQ_MODE5_PAGE0_OFFSET 	0x60
+ 
+/* Common Mode Dependent Scratch page 0 defines for modes 0,1,2, and 5 */
+/* Indexed using LSEQ_MODE_SCRATCH_SIZE * mode, for modes 0,1,2. */
+#define LmSEQ_RET_ADDR(LinkNum)		(LmSCRATCH(LinkNum) + 0x0000) 
+#define LmSEQ_REG0_MODE(LinkNum)	(LmSCRATCH(LinkNum) + 0x0002)
+#define LmSEQ_MODE_FLAGS(LinkNum)	(LmSCRATCH(LinkNum) + 0x0004)
+
+/* Mode flag defines (byte 0) */
+#define		SAS_SAVECTX_OCCURRED		0x80      
+#define		SAS_OOBSVC_OCCURRED		0x40     
+#define		SAS_OOB_DEVICE_PRESENT		0x20    
+#define		SAS_CFGHDR_OCCURRED		0x10   
+#define		SAS_RCV_INTS_ARE_DISABLED	0x08  
+#define		SAS_OOB_HOT_PLUG_CNCT		0x04 
+#define		SAS_AWAIT_OPEN_CONNECTION	0x02
+#define		SAS_CFGCMPLT_OCCURRED		0x01
+
+/* Mode flag defines (byte 1) */
+#define		SAS_RLSSCB_OCCURRED		0x80      
+#define		SAS_FORCED_HEADER_MISS		0x40      
+
+#define LmSEQ_RET_ADDR_SAVE(LinkNum)	(LmSCRATCH(LinkNum) + 0x0006)
+#define LmSEQ_RET_ADDR_SAVE2(LinkNum)	(LmSCRATCH(LinkNum) + 0x0008)
+#define LmSEQ_OPCODE_TO_CSEQ(LinkNum)	(LmSCRATCH(LinkNum) + 0x000B)
+#define LmSEQ_DATA_TO_CSEQ(LinkNum)	(LmSCRATCH(LinkNum) + 0x000C)
+
+/* Mode Dependent Scratch page 0 defines for mode 0 (non-common) */
+/* Absolute offsets */
+#define LmSEQ_FIRST_INV_DDB_SITE(LinkNum)	(LmSCRATCH(LinkNum) + 0x000E)
+#define LmSEQ_EMPTY_TRANS_CTX(LinkNum)		(LmSCRATCH(LinkNum) + 0x0010)
+#define LmSEQ_RESP_LEN(LinkNum)			(LmSCRATCH(LinkNum) + 0x0012)
+#define LmSEQ_FIRST_INV_SCB_SITE(LinkNum)	(LmSCRATCH(LinkNum) + 0x0014) 
+#define LmSEQ_INTEN_SAVE(LinkNum)		(LmSCRATCH(LinkNum) + 0x0016)
+#define LmSEQ_LNK_RST_FRM_LEN(LinkNum)		(LmSCRATCH(LinkNum) + 0x001A)
+#define LmSEQ_LNK_RST_PROTOCOL(LinkNum)		(LmSCRATCH(LinkNum) + 0x001B)
+#define LmSEQ_RESP_STATUS(LinkNum)		(LmSCRATCH(LinkNum) + 0x001C)
+#define LmSEQ_LAST_LOADED_SGE(LinkNum)		(LmSCRATCH(LinkNum) + 0x001D)
+#define LmSEQ_SAVE_SCBPTR(LinkNum)		(LmSCRATCH(LinkNum) + 0x001E)
+
+/* Mode Dependent Scratch page 0 defines for mode 1 (non-common) */
+/* Absolute offsets */
+#define LmSEQ_Q_XMIT_HEAD(LinkNum)		(LmSCRATCH(LinkNum) + 0x008E)
+#define LmSEQ_M1_EMPTY_TRANS_CTX(LinkNum)	(LmSCRATCH(LinkNum) + 0x0090)
+#define LmSEQ_XMIT_REQUEST_TYPE(LinkNum)	(LmSCRATCH(LinkNum) + 0x009B)
+#define LmSEQ_M1_RESP_STATUS(LinkNum)		(LmSCRATCH(LinkNum) + 0x009C)
+#define LmSEQ_M1_LAST_LOADED_SGE(LinkNum)	(LmSCRATCH(LinkNum) + 0x009D)
+#define LmSEQ_M1_SAVE_SCBPTR(LinkNum)		(LmSCRATCH(LinkNum) + 0x009E)
+
+/* Mode Dependent Scratch page 0 defines for mode 2 (non-common) */
+#define LmSEQ_PORT_COUNTER(LinkNum)		(LmSCRATCH(LinkNum) + 0x010E)
+#define LmSEQ_PM_TABLE_PTR(LinkNum)		(LmSCRATCH(LinkNum) + 0x0110)
+#define LmSEQ_SATA_INTERLOCK_TMR_SAVE(LinkNum)	(LmSCRATCH(LinkNum) + 0x0112)
+
+/* Mode Dependent Scratch page 0 defines for modes 4 & 5 (non-common) */
+/* Absolute offsets */
+#define LmSEQ_SAVED_OOB_STATUS(LinkNum)		(LmSCRATCH(LinkNum) + 0x006E)
+#define LmSEQ_SAVED_OOB_MODE(LinkNum)		(LmSCRATCH(LinkNum) + 0x006F)
+#define LmSEQ_Q_LINK_HEAD(LinkNum)		(LmSCRATCH(LinkNum) + 0x0070)
+#define LmSEQ_LNK_RST_ERR(LinkNum)		(LmSCRATCH(LinkNum) + 0x0072)
+#define LmSEQ_SAVED_OOB_SIGNALS(LinkNum)	(LmSCRATCH(LinkNum) + 0x0073)
+#define LmSEQ_SAS_RESET_MODE(LinkNum)		(LmSCRATCH(LinkNum) + 0x0074)
+#define LmSEQ_LINK_RESET_RETRY_CNT(LinkNum)	(LmSCRATCH(LinkNum) + 0x0075)
+#define LmSEQ_NUM_LINK_RESET_RETRIES(LinkNum)	(LmSCRATCH(LinkNum) + 0x0076)
+#define LmSEQ_OOB_INT_ENABLES(LinkNum)		(LmSCRATCH(LinkNum) + 0x007A)
+#define LmSEQ_NOTIFY_TIMER_TIMEOUT(LinkNum)	(LmSCRATCH(LinkNum) + 0x007C)
+#define LmSEQ_NOTIFY_TIMER_DOWN_CNT(LinkNum)	(LmSCRATCH(LinkNum) + 0x007E)
+
+/* Mode Dependent Scratch page 1 defines for modes 0,and 1 */
+/* Indexed using LSEQ_MODE_SCRATCH_SIZE * mode. */
+#define LmSEQ_SG0_LIST_PTR_ADDR(LinkNum)	(LmSCRATCH(LinkNum) + 0x0020)
+#define LmSEQ_SG0_LIST_DS(LinkNum)		(LmSCRATCH(LinkNum) + 0x002F)
+#define LmSEQ_SG1_LIST_PTR_ADDR(LinkNum)	(LmSCRATCH(LinkNum) + 0x0030)
+#define LmSEQ_SG1_LIST_DS(LinkNum)		(LmSCRATCH(LinkNum) + 0x003F)
+
+/* Mode Dependent Scratch page 1 defines for mode 2 */
+/* Absolute offsets */
+#define LmSEQ_INVALID_DWORD_CNT(LinkNum)	(LmSCRATCH(LinkNum) + 0x0120)
+#define LmSEQ_DISPARITY_ERROR_CNT(LinkNum) 	(LmSCRATCH(LinkNum) + 0x0124)
+#define LmSEQ_LOSS_OF_SYNC_CNT(LinkNum)		(LmSCRATCH(LinkNum) + 0x0128)
+
+/* Mode Dependent Scratch page 1 defines for mode 5 */
+/* None defined */
+
+/* Mode Dependent Scratch page 2 defines for mode 0 */
+/* Absolute offsets */
+#define LmSEQ_SMP_RCV_TIMER_TERM_TS(LinkNum)	(LmSCRATCH(LinkNum) + 0x0050)
+#define LmSEQ_M0_LAST_LOADED_SGE(LinkNum)	(LmSCRATCH(LinkNum) + 0x0054)
+#define LmSEQ_SDB_TAG(LinkNum)			(LmSCRATCH(LinkNum) + 0x005B)
+#define LmSEQ_SDB_MASK(LinkNum)			(LmSCRATCH(LinkNum) + 0x005C)
+#define LmSEQ_DEVICE_BITS(LinkNum)		(LmSCRATCH(LinkNum) + 0x005D)
+#define LmSEQ_SDB_DDB(LinkNum)			(LmSCRATCH(LinkNum) + 0x005E)
+
+/* Mode Dependent Scratch page 2 defines for mode 1 */
+/* Absolute offsets */
+/* byte 0 bits 1-0 are domain select. */
+#define LmSEQ_TX_ID_ADDR_FRAME(LinkNum)		(LmSCRATCH(LinkNum) + 0x00C0)	
+#define LmSEQ_OPEN_TIMER_TERM_TS(LinkNum)	(LmSCRATCH(LinkNum) + 0x00C8) 
+#define LmSEQ_SRST_AS_TIMER_TERM_TS(LinkNum)	(LmSCRATCH(LinkNum) + 0x00CC)  
+#define LmSEQ_M1P2_LAST_LOADED_SGE(LinkNum)	(LmSCRATCH(LinkNum) + 0x00D4)
+
+/* Mode Dependent Scratch page 2 defines for mode 2 */
+/* Absolute offsets */
+#define LmSEQ_STP_SHUTDOWN_TIMER_TERM_TS(LinkNum) (LmSCRATCH(LinkNum) + 0x0140)
+#define LmSEQ_CLOSE_TIMER_TERM_TS(LinkNum)	(LmSCRATCH(LinkNum) + 0x0144) 
+#define LmSEQ_BREAK_TIMER_TERM_TS(LinkNum)	(LmSCRATCH(LinkNum) + 0x0148) 
+#define LmSEQ_DWS_RESET_TIMER_TERM_TS(LinkNum)	(LmSCRATCH(LinkNum) + 0x014C) 
+#define LmSEQ_SATA_INTERLOCK_TIMER_TERM_TS(LinkNum) \
+						(LmSCRATCH(LinkNum) + 0x0150) 
+#define LmSEQ_DOWN_TIMER_DOWN_CNT(LinkNum)	(LmSCRATCH(LinkNum) + 0x015F) 
+
+/* Mode Dependent Scratch page 2 defines for mode 5 */
+#define LmSEQ_COMINIT_TIMER_TERM_TS(LinkNum)	(LmSCRATCH(LinkNum) + 0x0160)
+#define LmSEQ_RCV_ID_TIMER_TERM_TS(LinkNum)	(LmSCRATCH(LinkNum) + 0x0164)
+#define LmSEQ_RCV_FIS_TIMER_TERM_TS(LinkNum)	(LmSCRATCH(LinkNum) + 0x0168)
+#define LmSEQ_DEV_PRES_TIMER_TERM_TS(LinkNum)	(LmSCRATCH(LinkNum) + 0x016C)
+                                                  
+
+/* Mode Dependent Scratch page 3 defines for modes 0 and 1 */
+/* None defined */
+
+/* Mode Dependent Scratch page 3 defines for modes 2 and 5 */
+/* None defined */
+
+/* Mode Independent Scratch page 0 defines. */
+#define LmSEQ_Q_TGTXFR_HEAD(LinkNum)	(LmSCRATCH(LinkNum) + 0x0180)
+#define LmSEQ_Q_TGTXFR_TAIL(LinkNum)	(LmSCRATCH(LinkNum) + 0x0182)
+#define LmSEQ_LINK_NUMBER(LinkNum)	(LmSCRATCH(LinkNum) + 0x0186)
+#define LmSEQ_SCRATCH_FLAGS(LinkNum)	(LmSCRATCH(LinkNum) + 0x0187)
+/*
+ * Currently only bit 0, SAS_DWSAQD, is used.
+ */
+#define		SAS_DWSAQD			0x01  /*
+						       * DWSSTATUS: DWSAQD
+						       * bit las read in ISR.
+						       */		
+#define		SAS_NOTIFY_SPINUP_ENABLED	0x10     
+
+#define  LmSEQ_CONNECTION_STATE(LinkNum) (LmSCRATCH(LinkNum) + 0x0188)
+/* Connection states (byte 0) */
+#define		SAS_WE_OPENED_CS		0x01     
+#define		SAS_DEVICE_OPENED_CS		0x02
+#define		SAS_WE_SENT_DONE_CS		0x04     
+#define		SAS_DEVICE_SENT_DONE_CS		0x08
+#define		SAS_WE_SENT_CLOSE_CS		0x10     
+#define		SAS_DEVICE_SENT_CLOSE_CS	0x20     
+#define		SAS_WE_SENT_BREAK_CS		0x40    
+#define		SAS_DEVICE_SENT_BREAK_CS	0x80   
+/* Connection states (byte 1) */
+#define		SAS_OPN_TIMEOUT_OR_OPN_RJCT_CS	0x01  
+#define		SAS_AIP_RECEIVED_CS		0x02    
+#define		SAS_CREDIT_TIMEOUT_OCCURRED_CS	0x04
+#define		SAS_ACKNAK_TIMEOUT_OCCURRED_CS	0x08 
+#define		SAS_SMPRSP_TIMEOUT_OCCURRED_CS	0x10 
+#define		SAS_DONE_TIMEOUT_OCCURRED_CS	0x20 
+/* Connection states (byte 2) */
+#define		SAS_SMP_RESPONSE_RECEIVED_CS	0x01    
+#define		SAS_INTLK_TIMEOUT_OCCURRED_CS	0x02 
+#define		SAS_DEVICE_SENT_DMAT_CS		0x04     
+#define		SAS_DEVICE_SENT_SYNCSRST_CS	0x08    
+#define		SAS_CLEARING_AFFILIATION_CS	0x20   
+#define		SAS_RXTASK_ACTIVE_CS		0x40  
+#define		SAS_TXTASK_ACTIVE_CS		0x80 
+/* Connection states (byte 3) */
+#define		SAS_PHY_LOSS_OF_SIGNAL_CS	0x01     
+#define		SAS_DWS_TIMER_EXPIRED_CS	0x02     
+#define		SAS_LINK_RESET_NOT_COMPLETE_CS	0x04 
+#define		SAS_PHY_DISABLED_CS		0x08   
+#define		SAS_LINK_CTL_TASK_ACTIVE_CS	0x10  
+#define		SAS_PHY_EVENT_TASK_ACTIVE_CS	0x20
+#define		SAS_DEVICE_SENT_ID_FRAME_CS	0x40     
+#define		SAS_DEVICE_SENT_REG_FIS_CS	0x40    
+#define		SAS_DEVICE_SENT_HARD_RESET_CS	0x80 
+#define  	SAS_PHY_IS_DOWN_FLAGS		(SAS_PHY_LOSS_OF_SIGNAL_CS | \
+						 SAS_DWS_TIMER_EXPIRED_CS | \
+                                              SAS_LINK_RESET_NOT_COMPLETE_CS | \
+						 SAS_PHY_DISABLED_CS)
+
+#define		SAS_LINK_CTL_PHY_EVENT_FLAGS	(SAS_LINK_CTL_TASK_ACTIVE_CS | \
+						SAS_PHY_EVENT_TASK_ACTIVE_CS | \
+						SAS_DEVICE_SENT_ID_FRAME_CS | \
+						SAS_DEVICE_SENT_HARD_RESET_CS)
+
+#define LmSEQ_CONCTL(LinkNum)		(LmSCRATCH(LinkNum) + 0x018C)
+#define LmSEQ_CONSTAT(LinkNum)		(LmSCRATCH(LinkNum) + 0x018E) 
+#define LmSEQ_CONNECTION_MODES(LinkNum)	(LmSCRATCH(LinkNum) + 0x018F) 
+#define LmSEQ_REG1_ISR(LinkNum)		(LmSCRATCH(LinkNum) + 0x0192)
+#define LmSEQ_REG2_ISR(LinkNum)		(LmSCRATCH(LinkNum) + 0x0194)
+#define LmSEQ_REG3_ISR(LinkNum)		(LmSCRATCH(LinkNum) + 0x0196)
+#define LmSEQ_REG0_ISR(LinkNum)		(LmSCRATCH(LinkNum) + 0x0198)
+
+/* Mode Independent Scratch page 1 defines. */
+#define LmSEQ_FRAME_TYPE_MASK(LinkNum)	      (LmSCRATCH(LinkNum) + 0x01A0)
+#define LmSEQ_HASHED_DEST_ADDR_MASK(LinkNum)  (LmSCRATCH(LinkNum) + 0x01A1)
+#define LmSEQ_HASHED_SRC_ADDR_MASK(LinkNum)   (LmSCRATCH(LinkNum) + 0x01A5)
+#define LmSEQ_RETRANSMIT_MASK(LinkNum)	      (LmSCRATCH(LinkNum) + 0x01AA)
+#define LmSEQ_NUM_FILL_BYTES_MASK(LinkNum)    (LmSCRATCH(LinkNum) + 0x01AB)
+#define LmSEQ_TAG_MASK(LinkNum)		      (LmSCRATCH(LinkNum) + 0x01B0)
+#define LmSEQ_TARGET_PORT_XFER_TAG(LinkNum)   (LmSCRATCH(LinkNum) + 0x01B2)
+#define LmSEQ_DATA_OFFSET(LinkNum)	      (LmSCRATCH(LinkNum) + 0x01B4)
+#define LmSEQ_ISR_SAVE_SINDEX(LinkNum)	      (LmSCRATCH(LinkNum) + 0x01BC)
+#define LmSEQ_ISR_SAVE_DINDEX(LinkNum)	      (LmSCRATCH(LinkNum) + 0x01BE)
+
+
+/* Mode Independent Scratch page 2 defines. */
+#define LmSEQ_EMPTY_SCB_PTR0(LinkNum)	(LmSCRATCH(LinkNum) + 0x01C0)
+#define LmSEQ_EMPTY_SCB_PTR1(LinkNum)	(LmSCRATCH(LinkNum) + 0x01C2)
+#define LmSEQ_EMPTY_SCB_PTR2(LinkNum)	(LmSCRATCH(LinkNum) + 0x01C4)
+#define LmSEQ_EMPTY_SCB_PTR3(LinkNum)	(LmSCRATCH(LinkNum) + 0x01C6)
+#define LmSEQ_EMPTY_SCB_OPCD0(LinkNum)	(LmSCRATCH(LinkNum) + 0x01C8)
+#define LmSEQ_EMPTY_SCB_OPCD1(LinkNum)	(LmSCRATCH(LinkNum) + 0x01C9)
+#define LmSEQ_EMPTY_SCB_OPCD2(LinkNum)	(LmSCRATCH(LinkNum) + 0x01CA)
+#define LmSEQ_EMPTY_SCB_OPCD3(LinkNum)	(LmSCRATCH(LinkNum) + 0x01CB)
+#define LmSEQ_EMPTY_SCB_HEAD(LinkNum)	(LmSCRATCH(LinkNum) + 0x01CC)
+#define LmSEQ_EMPTY_SCB_TAIL(LinkNum)	(LmSCRATCH(LinkNum) + 0x01CD)
+#define LmSEQ_EMPTY_BUFS_AVAIL(LinkNum)	(LmSCRATCH(LinkNum) + 0x01CE)
+#define LmSEQ_ATA_SCR_REGS(LinkNum)	(LmSCRATCH(LinkNum) + 0x01D4)
+
+/* 
+ * The current sequencer implementation is to have 1ms timer to come to a 
+ * routine to check if the value inside scratch location 
+ * LSEQ_NOTIFY_TIMER_DOWN_CNT is equal to 0.  
+ * Only If the value in LSEQ_NOTIFY_TIMER_DOWN_CNT is equal to 0, sequencer 
+ * sends NOTIFY (ENABLE SPINUP) out.
+ * The initial value of LSEQ_NOTIFY_TIMER_DOWN_CNT is from CHIM's initialization
+ * value.  After the first NOTIFY (ENABLE SPINUP) sending out, the value
+ * contained in LSEQ_NOTIFY_TIMER_TIMEOUT scratch location is copied to scratch
+ * location LSEQ_NOTIFY_TIMER_DOWN_CNT and used as the constant period between 
+ * each following NOTIFY (ENABLE SPINUP) sending out.
+ * With this implementation, the actual period is the value set in 
+ * scratch ram + 1.  
+ */
+
+/* Set NOTIFY Timer Down Counter to value 0 gets 1msec for the first   */
+/* NOTIFY (ENABLE SPINUP) sending to the drives.                       */
+#define SAS_DEFAULT_NOTIFY_TIMER_DOWN_CNT      	0x0
+#define SAS_DEFAULT_STP_SHUTDOWN_TIMER_TIMEOUT	0x00000032  /* 50 usecs */
+#define SAS_DEFAULT_SRST_ASSERT_TIMEOUT		0x00000005  /* 5 usecs */
+#define SAS_DEFAULT_RCV_FIS_TIMEOUT		0x01D905C0  /* 31 secs */
+#define	SAS_DEFAULT_ONE_MILLISEC_TIMEOUT	0x000003E8  /* 1 msecs */
+
+/*
+ * We are currently seeing an erratic issue with SEAGATE FW:B83C that it takes
+ * much longer to show up during link reset sequence.
+ * Setting 1 secs for the COMMINIT TIMEOUT seems to help.
+ * This is just a temporary workaround. Default value is 10 msesc.
+ */
+//#define SAS_DEFAULT_COMINIT_TIMEOUT		0x00002710  /* 10 msecs */
+#define SAS_DEFAULT_COMINIT_TIMEOUT		0x000F4240  /* 1 secs */
+#define SAS_DEFAULT_SMP_RCV_TIMEOUT		0x000F4240  /* 1 secs */
+
+/* Mode Independent Scratch page 3 defines. */
+#define LmSEQ_DEV_PRES_TMR_TOUT_CONST(LinkNum)	(LmSCRATCH(LinkNum) + 0x01E0)
+#define LmSEQ_SATA_INTERLOCK_TIMEOUT(LinkNum)	(LmSCRATCH(LinkNum) + 0x01E4)
+#define LmSEQ_STP_SHUTDOWN_TIMEOUT(LinkNum)	(LmSCRATCH(LinkNum) + 0x01E8)
+#define LmSEQ_SRST_ASSERT_TIMEOUT(LinkNum)	(LmSCRATCH(LinkNum) + 0x01EC)
+#define LmSEQ_RCV_FIS_TIMEOUT(LinkNum)		(LmSCRATCH(LinkNum) + 0x01F0)
+#define LmSEQ_ONE_MILLISEC_TIMEOUT(LinkNum)	(LmSCRATCH(LinkNum) + 0x01F4)
+#define LmSEQ_TEN_MS_COMINIT_TIMEOUT(LinkNum)	(LmSCRATCH(LinkNum) + 0x01F8)
+#define LmSEQ_SMP_RCV_TIMEOUT(LinkNum)		(LmSCRATCH(LinkNum) + 0x01FC)
+
+/* Sequencer label public defines */
+#if SAS_SEQUENCER_A1
+/* 
+ * LSEQ A1 Interrupt Vector addresses based on Sequencer Alpha_7g18.
+ */
+#define LSEQ_INT_VEC0A1			0x001C
+#define LSEQ_INT_VEC1A1			0x0024
+#define LSEQ_INT_VEC2A1			0x002C
+#define LSEQ_INT_VEC3A1			0x0034 
+#define LSEQ_INT_VEC4A1			0x003C
+#define LSEQ_INT_VEC5A1			0x0044
+#define LSEQ_INT_VEC6A1			0x004C
+#define LSEQ_INT_VEC7A1			0x0054
+#define LSEQ_INT_VEC8A1			0x005C
+#define LSEQ_INT_VEC9A1			0x0064
+#define LSEQ_INT_VEC10A1		0x006C
+
+#endif /* SAS_SEQUENCER_A1 */
+
+#if SAS_SEQUENCER_B0
+/*
+ * LSEQ B0 Interrupt Vector addresses based on Sequencer Alpha_7g18.
+ */
+#define LSEQ_INT_VEC0B0			0x001C
+#define LSEQ_INT_VEC1B0			0x0024
+#define LSEQ_INT_VEC2B0			0x002C
+#define LSEQ_INT_VEC3B0			0x0034 
+#define LSEQ_INT_VEC4B0			0x003C
+#define LSEQ_INT_VEC5B0			0x0044
+#define LSEQ_INT_VEC6B0			0x004C
+#define LSEQ_INT_VEC7B0			0x0054
+#define LSEQ_INT_VEC8B0			0x005C
+#define LSEQ_INT_VEC9B0			0x0064
+#define LSEQ_INT_VEC10B0		0x006C
+
+#endif /* SAS_SEQUENCER_B0 */
+
+#define LSEQ_IDLE_LOOP_ENTRY		0x0000    
+#define LSEQ_SEQUENCER_PROGRAM		0x0000
+
+#define SAS_S_ACTIVE_SCB		0x00FC
+
+#define SAS_S_Q_NEW_POINTER		0x0100
+#define SAS_S_PASS_TO_DRIVER		0x0115
+#define SAS_S_Q_EXE_HEAD		0x011C
+#define SAS_S_Q_EXE_TAIL		0x011E 
+#define SAS_S_Q_EXETARG_TAIL		0x0120 
+#define SAS_S_Q_DONE_POINTER		0x0110
+
+
+#endif /* ADP94XX_REG_H */


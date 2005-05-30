From: Andrew Morton <akpm@osdl.org>
Subject: Fw: adaptec aic7xxx bug
Date: Mon, 30 May 2005 14:01:18 -0700
Message-ID: <20050530140118.6a0d4c67.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:16007 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261764AbVE3VCP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 May 2005 17:02:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Yogesh Bhanu <yogesh@gsf.de>



Begin forwarded message:

Date: Mon, 30 May 2005 13:42:59 +0200
From: Yogesh Bhanu <yogesh@gsf.de>
To: linux-kernel@vger.kernel.org
Subject: adaptec aic7xxx bug 


hi ,
      I have a nfs server running sarge (Dual Xeon 2.4GHz , 6 GB RAM) .
I am running 2.6.11.6 and 2.6.11.8 kernels. Under load the adpatec card which I 
use to connect my external RAID flakes . I have got the vendor to replace 
everything on the system from mainboard, external raid chassis to cables.


cat /proc/scsi/aic7xxx/1
Adaptec AIC7xxx driver version: 6.2.36
Adaptec 3960D Ultra160 SCSI adapter
aic7899: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
Allocated SCBs: 4, SG List Length: 128

Serial EEPROM:
0xcb3a 0xcb3a 0xc33a 0xc13a 0xc13a 0xc13a 0xc13a 0xc13a
0xc13a 0xc13a 0xc13a 0xc13a 0xc13a 0xc13a 0xc13a 0xc13a
0x08f4 0x605d 0x2807 0x0010 0x0300 0xffff 0xffff 0xffff
0xffff 0xffff 0xffff 0xffff 0xffff 0xffff 0x0250 0xc04f

Target 0 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 1 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
         Goal: 160.000MB/s transfers (80.000MHz DT, offset 62, 16bit)
         Curr: 160.000MB/s transfers (80.000MHz DT, offset 62, 16bit)
         Channel A Target 1 Lun 0 Settings
                 Commands Queued 168175
                 Commands Active 0
                 Command Openings 2
                 Max Tagged Openings 2
                 Device Queue Frozen Count 0
         Channel A Target 1 Lun 1 Settings
                 Commands Queued 1172996
                 Commands Active 0
                 Command Openings 2
                 Max Tagged Openings 2
                 Device Queue Frozen Count 0
         Channel A Target 1 Lun 2 Settings
                 Commands Queued 373111
                 Commands Active 0
                 Command Openings 2
                 Max Tagged Openings 2
                 Device Queue Frozen Count 0
Target 2 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 3 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 4 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 5 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 6 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 7 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 8 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 9 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 10 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 11 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 12 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 13 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 14 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 15 Negotiation Settings
         User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)


I get error messages like this .


  May 30 06:29:38 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) 
SCB_TAG[0xff]
May 30 06:29:38 mips-nas kernel:  13 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
May 30 06:29:38 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
May 30 06:29:38 mips-nas kernel:  14 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
May 30 06:29:38 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
May 30 06:29:38 mips-nas kernel:  15 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
May 30 06:29:38 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
May 30 06:29:38 mips-nas kernel:  16 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
May 30 06:29:38 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
May 30 06:29:38 mips-nas kernel:  17 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
May 30 06:29:38 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
May 30 06:29:38 mips-nas kernel:  18 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
May 30 06:29:38 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
May 30 06:29:38 mips-nas kernel:  19 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
May 30 06:29:38 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
May 30 06:29:38 mips-nas kernel:  20 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
May 30 06:29:38 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
May 30 06:29:38 mips-nas kernel:  21 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
May 30 06:29:38 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
May 30 06:29:38 mips-nas kernel:  22 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
May 30 06:29:38 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
May 30 06:29:38 mips-nas kernel:  23 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
May 30 06:29:38 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
May 30 06:29:38 mips-nas kernel:  24 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
May 30 06:29:38 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
May 30 06:29:38 mips-nas kernel:  25 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
May 30 06:29:38 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
May 30 06:29:38 mips-nas kernel:  26 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
May 30 06:29:38 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
May 30 06:29:38 mips-nas kernel:  27 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
May 30 06:29:38 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
May 30 06:29:38 mips-nas kernel:  28 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
May 30 06:29:38 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
May 30 06:29:38 mips-nas kernel:  29 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
May 30 06:29:38 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
May 30 06:29:38 mips-nas kernel:  30 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
May 30 06:29:38 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
May 30 06:29:38 mips-nas kernel:  31 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
May 30 06:29:38 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
May 30 06:29:38 mips-nas kernel: Pending list:
May 30 06:29:38 mips-nas kernel:   5 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) 
SCB_SCSIID[0x17] SCB_LUN[0x2]
May 30 06:29:38 mips-nas kernel: Kernel Free SCB list: 1 6 2 0 7 4
May 30 06:29:38 mips-nas kernel: DevQ(0:1:0): 0 waiting
May 30 06:29:38 mips-nas kernel: DevQ(0:1:1): 0 waiting
May 30 06:29:38 mips-nas kernel: DevQ(0:1:2): 0 waiting
May 30 06:29:38 mips-nas kernel:
May 30 06:29:38 mips-nas kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends 
 >>>>>>>>>>>>>>>>>>
May 30 06:29:38 mips-nas kernel: (scsi1:A:1:2): Device is disconnected, 
re-queuing SCB
May 30 06:29:38 mips-nas kernel: Recovery code sleeping
May 30 06:29:38 mips-nas kernel: (scsi1:A:1:2): Abort Tag Message Sent
May 30 06:29:38 mips-nas kernel: (scsi1:A:1:2): SCB 5 - Abort Tag Completed.
May 30 06:29:38 mips-nas kernel: Recovery SCB completes
May 30 06:29:38 mips-nas kernel: Recovery code awake
May 30 06:29:38 mips-nas kernel: aic7xxx_abort returns 0x2002



-- 
Yogesh Bhanu
  MIPS/IBI,
  #56, GSF- National Research Center for Environment and Health,
  Ingolstaedter Landstr. 1 ,
  D-85764, Neuherberg, Germany

  Tel:  +49 89 3187 4217
  Fax:  +49 89 3187 3585
  http://mips.gsf.de
-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

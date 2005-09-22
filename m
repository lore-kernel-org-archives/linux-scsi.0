From: Richard Bollinger <rabollinger@gmail.com>
Subject: SATA Drive Information (vs hdparm -i)?
Date: Thu, 22 Sep 2005 15:06:37 -0400
Message-ID: <7744a2840509221206254d2109@mail.gmail.com>
Reply-To: Richard Bollinger <rabollinger@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.196]:45468 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1750751AbVIVTGl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Sep 2005 15:06:41 -0400
Received: by zproxy.gmail.com with SMTP id i11so346400nzi
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2005 12:06:38 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Is there a program for SATA drives which reveals the depth of
information that "hdparm -i" does for IDE drives?  sdparm reveals
almost nothing in comparison:

# sdparm -i /dev/sda
    /dev/sda: ATA       WDC WD3200JD-00K  08.0
Device identification VPD page:
  Addressed logical unit:
    id_type: vendor specific [0x0],  code_set: ASCII
 00     4c 69 6e 75 78 20 41 54  41 2d 53 43 53 49 20 73    Linux ATA-SCSI s
 10     69 6d 75 6c 61 74 6f 72                             imulator

# hdparm -i /dev/hda

/dev/hda:

 Model=WDC WD800BB-00JHC0, FwRev=05.01C05, SerialNo=WD-MAM96054404
 Config={ HardSect NotMFM HdSw>15uSec SpinMotCtl Fixed DTR>5Mbs mtGapReq }
 RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=66
 BuffType=unknown, BuffSize=2048kB, MaxMultSect=16, MultSect=off
 CurCHS=16383/16/63, CurSects=-66060037, LBA=yes, LBAsects=156301488
 IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
 PIO modes: pio0 pio3 pio4
 DMA modes: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 *udma5
 AdvancedPM=no
 Drive Supports : Reserved : ATA-1 ATA-2 ATA-3 ATA-4 ATA-5 ATA-6

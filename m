From: margitsw@t-online.de (Margit Schubert-While)
Subject: 2.5.70 Adaptec error messages
Date: Thu, 05 Jun 2003 16:51:58 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <5.1.0.14.2.20030605162325.055137f0@pop.t-online.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout07.sul.t-online.com ([194.25.134.83]:40642 "EHLO
	mailout07.sul.t-online.com") by vger.kernel.org with ESMTP
	id S264704AbTFEOim (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jun 2003 10:38:42 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

With 2.5.70(-bk) and also Justin's 20030603, I am getting the below at boot.
After that, everything works fine.
Adapter is 39160.

Margit

----------------------------------------
kernel: (scsi0:A:0:0): CDB: 0x12 0x1 0x80 0x0 0xff 0x0
kernel: (scsi0:A:0:0): Saw underflow (752 of 768 bytes). Treated as error
         Repeats another 4 times
kernel: (scsi0:A:1:0): CDB: 0x12 0x1 0x80 0x0 0xff 0x0
kernel: (scsi0:A:1:0): Saw underflow (752 of 768 bytes). Treated as error
         Repeats another 4 times
kernel: (scsi1:A:2:0): CDB: 0x12 0x1 0x80 0x0 0xff 0x0
kernel: (scsi1:A:2:0): Saw underflow (752 of 768 bytes). Treated as error
         Repeats another 4 times
kernel: (scsi1:A:3:0): CDB: 0x12 0x1 0x80 0x0 0xff 0x0
kernel: (scsi1:A:3:0): Saw underflow (752 of 768 bytes). Treated as error
         Repeats another 4 times
----------------------------------------
         And the above block repeats once more

-- snip --
<6>scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
<4>        <Adaptec 3960D Ultra160 SCSI adapter>
<4>        aic7899: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
<4>
<4>(scsi0:A:0): 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
<4>(scsi0:A:1): 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
<5>  Vendor: FUJITSU   Model: MAN3184MP         Rev: 0108
<5>  Type:   Direct-Access                      ANSI SCSI revision: 03
<4>scsi0:A:0:0: Tagged Queuing enabled.  Depth 32
<5>  Vendor: FUJITSU   Model: MAN3184MP         Rev: 0108
<5>  Type:   Direct-Access                      ANSI SCSI revision: 03
<4>scsi0:A:1:0: Tagged Queuing enabled.  Depth 32
<6>scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
<4>        <Adaptec 3960D Ultra160 SCSI adapter>
<4>        aic7899: Ultra160 Wide Channel B, SCSI Id=7, 32/253 SCBs
<4>
<4>(scsi1:A:2): 160.000MB/s transfers (80.000MHz DT, offset 63, 16bit)
<4>(scsi1:A:3): 160.000MB/s transfers (80.000MHz DT, offset 63, 16bit)
<5>  Vendor: IBM       Model: DDYS-T18350N      Rev: S96H
<5>  Type:   Direct-Access                      ANSI SCSI revision: 03
<4>scsi1:A:2:0: Tagged Queuing enabled.  Depth 32
<5>  Vendor: IBM       Model: DDYS-T18350N      Rev: S96H
<5>  Type:   Direct-Access                      ANSI SCSI revision: 03
<4>scsi1:A:3:0: Tagged Queuing enabled.  Depth 32
<6>scsi2 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
<4>        <Adaptec 2940A Ultra SCSI adapter>
<4>        aic7860: Ultra Single Channel A, SCSI Id=7, 3/253 SCBs
<4>
-- end snip --


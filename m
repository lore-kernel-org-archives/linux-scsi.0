From: Willem Riede <wrlk@riede.org>
Subject: 2.5.74-bk2 aic7xxx still doesn't like my disk drives
Date: Sat, 5 Jul 2003 08:26:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030705122620.GH31823@linnie.riede.org>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc11.comcast.net ([204.127.198.35]:58501 "EHLO
	rwcrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S266332AbTGEMIY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 5 Jul 2003 08:08:24 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is what I see at boot time - should I worry about it?

(scsi1:A:0:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:0:0): Saw underflow (76 of 96 bytes). Treated as error
(scsi1:A:0:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:0:0): Saw underflow (76 of 96 bytes). Treated as error
(scsi1:A:0:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:0:0): Saw underflow (76 of 96 bytes). Treated as error
(scsi1:A:0:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:0:0): Saw underflow (76 of 96 bytes). Treated as error
(scsi1:A:0:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:0:0): Saw underflow (76 of 96 bytes). Treated as error
(scsi1:A:0:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:0:0): Saw underflow (76 of 96 bytes). Treated as error
(scsi1:A:0:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:0:0): Saw underflow (76 of 96 bytes). Treated as error
(scsi1:A:0:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:0:0): Saw underflow (76 of 96 bytes). Treated as error
(scsi1:A:0:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:0:0): Saw underflow (76 of 96 bytes). Treated as error
(scsi1:A:0:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:0:0): Saw underflow (76 of 96 bytes). Treated as error
(scsi1:A:1:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:1:0): Saw underflow (76 of 96 bytes). Treated as error
(scsi1:A:1:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:1:0): Saw underflow (76 of 96 bytes). Treated as error
(scsi1:A:1:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:1:0): Saw underflow (76 of 96 bytes). Treated as error
(scsi1:A:1:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:1:0): Saw underflow (76 of 96 bytes). Treated as error
(scsi1:A:1:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:1:0): Saw underflow (76 of 96 bytes). Treated as error
(scsi1:A:1:0): CDB: 0x12 0x1 0x83 0x0 0x60 0x0
(scsi1:A:1:0): Saw underflow (42 of 96 bytes). Treated as error
(scsi1:A:1:0): CDB: 0x12 0x1 0x83 0x0 0x60 0x0
(scsi1:A:1:0): Saw underflow (42 of 96 bytes). Treated as error
(scsi1:A:1:0): CDB: 0x12 0x1 0x83 0x0 0x60 0x0
(scsi1:A:1:0): Saw underflow (42 of 96 bytes). Treated as error
(scsi1:A:1:0): CDB: 0x12 0x1 0x83 0x0 0x60 0x0
(scsi1:A:1:0): Saw underflow (42 of 96 bytes). Treated as error
(scsi1:A:1:0): CDB: 0x12 0x1 0x83 0x0 0x60 0x0
(scsi1:A:1:0): Saw underflow (42 of 96 bytes). Treated as error
(scsi1:A:1:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:1:0): Saw underflow (76 of 96 bytes). Treated as error
(scsi1:A:1:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:1:0): Saw underflow (76 of 96 bytes). Treated as error
(scsi1:A:1:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:1:0): Saw underflow (76 of 96 bytes). Treated as error
(scsi1:A:1:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:1:0): Saw underflow (76 of 96 bytes). Treated as error
(scsi1:A:1:0): CDB: 0x12 0x1 0x80 0x0 0x60 0x0
(scsi1:A:1:0): Saw underflow (76 of 96 bytes). Treated as error


These are my scsi devices:

Loading aic7xxx module
scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.35
        <Adaptec aic7895 Ultra SCSI adapter>
        aic7895C: Ultra Wide Channel A, SCSI Id=7, 32/253 SCBs
                                                                                                    
(scsi0:A:3): 10.000MB/s transfers (10.000MHz, offset 7)
(scsi0:A:6): 10.000MB/s transfers (10.000MHz, offset 8)
  Vendor: OnStream  Model: SC-30             Rev: 1.09
  Type:   Sequential-Access                  ANSI SCSI revision: 02
  Vendor: MATSHITA  Model: CD-R   CW-7502    Rev: 4.17
  Type:   CD-ROM                             ANSI SCSI revision: 02
scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.35
        <Adaptec aic7895 Ultra SCSI adapter>
        aic7895C: Ultra Wide Channel B, SCSI Id=7, 32/253 SCBs
                                                                                                    
(scsi1:A:0): 40.000MB/s transfers (20.000MHz, offset 8, 16bit)
(scsi1:A:1): 40.000MB/s transfers (20.000MHz, offset 8, 16bit)
  Vendor: IBM       Model: DNES-318350W      Rev: SA30
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi1:A:0:0: Tagged Queuing enabled.  Depth 16
SCSI device sda: 35843670 512-byte hdwr sectors (18352 MB)
SCSI device sda: drive cache: write through
 sda: sda1 sda2 sda3 sda4
Attached scsi disk sda at scsi1, channel 0, id 0, lun 0
  Vendor: IBM       Model: DGHS09U           Rev: 0350
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi1:A:1:0: Tagged Queuing enabled.  Depth 16
SCSI device sdb: 17916240 512-byte hdwr sectors (9173 MB)
sdb: asking for cache data failed
sdb: assuming drive cache: write through
 sdb: sdb1 sdb2 sdb3
Attached scsi disk sdb at scsi1, channel 0, id 1, lun 0

Thanks, Willem Riede.

From: Gerhard Mack <gmack@innerfire.net>
Subject: [2.6.25.1] qla2xxx can't see more than 4 drives
Date: Sat, 3 May 2008 15:17:40 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0805031458050.2330@mtl.rackplans.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtl.rackplans.net ([69.90.0.18]:57015 "EHLO mtl.rackplans.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530AbYECTRl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 3 May 2008 15:17:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

I have an array witjh 6 drives in it and if use the card's utilities on 
boot it sees all of them but for some reason Linux only sees 4 drives.

Am I running into a limit?  I can see both drives if I remove other drives 
from the array.

[0:0:0:0]    disk    MAXTOR   ATLAS10K4_36SCA  DFM0  /dev/sda
[0:0:1:0]    disk    MAXTOR   ATLAS10K4_36SCA  DFM0  /dev/sdb
[0:0:2:0]    disk    MAXTOR   ATLAS10K4_36SCA  DFM0  /dev/sdc
[0:0:6:0]    process PE/PV    1x3 SCSI BP      0.28  -
fiber channel drives:
[2:0:0:0]    disk    SEAGATE  ST314680 CLAR146 7A0A  /dev/sdd
[2:0:1:0]    disk    SEAGATE  ST314680 CLAR146 7A04  /dev/sde
[2:0:2:0]    disk    SEAGATE  ST314680 CLAR146 7A0A  /dev/sdf
[2:0:3:0]    disk    SEAGATE  ST314680 CLAR146 7A04  /dev/sdg

QLogic Fibre Channel HBA Driver
qla2xxx 0000:02:0a.0: Found an ISP2312, irq 24, iobase 0xf88cc000
qla2xxx 0000:02:0a.0: Configuring PCI space...
qla2xxx 0000:02:0a.0: Configure NVRAM parameters...
qla2xxx 0000:02:0a.0: Verifying loaded RISC code...
qla2xxx 0000:02:0a.0: Allocated (412 KB) for firmware dump...
scsi3 : qla2xxx
qla2xxx 0000:02:0a.0: LIP reset occured (f8f7).
qla2xxx 0000:02:0a.0: LIP occured (f8f7).
qla2xxx 0000:02:0a.0: LOOP UP detected (1 Gbps).
scsi 3:0:0:0: Direct-Access     SEAGATE  ST314680 CLAR146 7A0A PQ: 0 ANSI: 3
sd 3:0:0:0: [sdd] 286749476 512-byte hardware sectors (146816 MB)
sd 3:0:0:0: [sdd] Write Protect is off
sd 3:0:0:0: [sdd] Mode Sense: a7 00 10 08
sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 3:0:0:0: [sdd] 286749476 512-byte hardware sectors (146816 MB)
sd 3:0:0:0: [sdd] Write Protect is off
sd 3:0:0:0: [sdd] Mode Sense: a7 00 10 08
sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, supports DPO and FUA
 sdd:<6>qla2xxx 0000:02:0a.0: 
 QLogic Fibre Channel HBA Driver: 8.02.00-k9
  QLogic QLA2340 - 133MHz PCI-X to 2Gb FC, Single Channel
  ISP2312: PCI (66 MHz) @ 0000:02:0a.0 hdma-, host#=3, fw=3.03.20 IPX
 unknown partition table
sd 3:0:0:0: [sdd] Attached SCSI disk
sd 3:0:0:0: Attached scsi generic sg4 type 0
sd 3:0:0:0: Embedded Enclosure Device
sd 3:0:0:0: Failed to get diagnostic page 0x6000000
sd 3:0:0:0: Failed to bind enclosure -19
scsi 3:0:1:0: Direct-Access     SEAGATE  ST314680 CLAR146 7A04 PQ: 0 ANSI: 3
sd 3:0:1:0: [sde] 286749476 512-byte hardware sectors (146816 MB)
sd 3:0:1:0: [sde] Write Protect is off
sd 3:0:1:0: [sde] Mode Sense: a7 00 10 08
sd 3:0:1:0: [sde] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 3:0:1:0: [sde] 286749476 512-byte hardware sectors (146816 MB)
sd 3:0:1:0: [sde] Write Protect is off
sd 3:0:1:0: [sde] Mode Sense: a7 00 10 08
sd 3:0:1:0: [sde] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sde: unknown partition table
sd 3:0:1:0: [sde] Attached SCSI disk
sd 3:0:1:0: Attached scsi generic sg5 type 0
sd 3:0:1:0: Embedded Enclosure Device
sd 3:0:1:0: Failed to get diagnostic page 0x6000000
sd 3:0:1:0: Failed to bind enclosure -19
scsi 3:0:2:0: Direct-Access     SEAGATE  ST314680 CLAR146 7A0A PQ: 0 ANSI: 3
sd 3:0:2:0: [sdf] 286749476 512-byte hardware sectors (146816 MB)
sd 3:0:2:0: [sdf] Write Protect is off
sd 3:0:2:0: [sdf] Mode Sense: a7 00 10 08
sd 3:0:2:0: [sdf] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 3:0:2:0: [sdf] 286749476 512-byte hardware sectors (146816 MB)
sd 3:0:2:0: [sdf] Write Protect is off
sd 3:0:2:0: [sdf] Mode Sense: a7 00 10 08
sd 3:0:2:0: [sdf] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdf: unknown partition table
sd 3:0:2:0: [sdf] Attached SCSI disk
sd 3:0:2:0: Attached scsi generic sg6 type 0
sd 3:0:2:0: Embedded Enclosure Device
qla2xxx 0000:02:0a.0: scsi(3:2:0): Abort command issued -- 1 62 2002.
qla2xxx 0000:02:0a.0: scsi(3:2:0): Abort command issued -- 1 6d 2002.



--
Gerhard Mack

gmack@innerfire.net

<>< As a computer I find your faith in technology amusing.

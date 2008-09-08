From: Mark Hounschell <dmarkh@cfl.rr.com>
Subject: Scsi Disk - Removable media problems
Date: Mon, 08 Sep 2008 18:12:20 -0400
Message-ID: <48C5A344.5000308@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.122]:60592 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbYIHWNS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Sep 2008 18:13:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>

I have 2 IOMEGA BETA90 scsi drives connected to an Adaptec pci 2930c scsi 
adapter. I use these drives in their raw form vi the SG interface. I cannot boot 
successfully with these drives connected and no media installed (2.6.24.3). 
After the machine finally boots up, "lsscsi" does not even show them. I'm 
booting off Sata drives and the scsi controller is NOT in the initrd. When the 
media is installed all is good BTW.

I tried "options scsi_mod dev_flags=IOMEGA:BETA90:0x1000" in my modprobe.conf 
file and then I get devices via lsscsi shown at the end which is pretty much 
useless though, I think.


partial dmesg output:

scsi6 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
         <Adaptec 2930CU SCSI adapter>
         aic7860: Ultra Single Channel A, SCSI Id=7, 3/253 SCBs

scsi 6:0:3:0: Direct-Access     IOMEGA   BETA90            1.5 PQ: 0 ANSI: 2
  target6:0:3: Beginning Domain Validation
  target6:0:3: Ending Domain Validation
sd 6:0:3:0: [sdb] Spinning up 
disk......................................................................................................not 
responding...
sd 6:0:3:0: [sdb] READ CAPACITY failed
sd 6:0:3:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
sd 6:0:3:0: [sdb] Sense Key : Not Ready [current]
sd 6:0:3:0: [sdb] Add. Sense: Logical unit not ready, cause not reportable
sd 6:0:3:0: [sdb] Write Protect is on
sd 6:0:3:0: [sdb] Mode Sense: 53 00 80 08
sd 6:0:3:0: [sdb] Cache data unavailable
sd 6:0:3:0: [sdb] Assuming drive cache: write through
sd 6:0:3:0: [sdb] Attached SCSI removable disk
sd 6:0:3:0: Attached scsi generic sg2 type 0
scsi 6:0:5:0: Direct-Access     IOMEGA   BETA90            1.5 PQ: 0 ANSI: 2
  target6:0:5: Beginning Domain Validation
  target6:0:5: Ending Domain Validation
sd 6:0:5:0: [sdc] Spinning up 
disk....................................................................<5>sd 
6:0:3:0: [sdb] Spinning up disk....................<6>Adding 2104504k swap on
..........not responding...
sd 6:0:5:0: [sdc] READ CAPACITY failed
sd 6:0:5:0: [sdc] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
sd 6:0:5:0: [sdc] Sense Key : Not Ready [current]
sd 6:0:5:0: [sdc] Add. Sense: Logical unit not ready, cause not reportable
sd 6:0:5:0: [sdc] Write Protect is on
sd 6:0:5:0: [sdc] Mode Sense: 53 00 80 08
sd 6:0:5:0: [sdc] Cache data unavailable
sd 6:0:5:0: [sdc] Assuming drive cache: write through
sd 6:0:5:0: [sdc] Attached SCSI removable disk
sd 6:0:5:0: Attached scsi generic sg3 type 0
sd 6:0:5:0: [sdc] Spinning up disk........<6>bootsplash: status on console 0 
changed to on
..........................................................................................................................not 
responding...
.<5>sd 6:0:3:0: [sdb] READ CAPACITY failed
sd 6:0:3:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
sd 6:0:3:0: [sdb] Sense Key : Not Ready [current]
sd 6:0:3:0: [sdb] Add. Sense: Logical unit not ready, cause not reportable
sd 6:0:3:0: [sdb] Write Protect is on
sd 6:0:3:0: [sdb] Mode Sense: 53 00 80 08
sd 6:0:3:0: [sdb] Cache data unavailable
sd 6:0:3:0: [sdb] Assuming drive cache: write through
sd 6:0:3:0: [sdb] Spinning up 
disk......................................................................not 
responding...
.<5>sd 6:0:5:0: [sdc] READ CAPACITY failed
sd 6:0:5:0: [sdc] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
sd 6:0:5:0: [sdc] Sense Key : Not Ready [current]
sd 6:0:5:0: [sdc] Add. Sense: Logical unit not ready, cause not reportable
sd 6:0:5:0: [sdc] Write Protect is on
sd 6:0:5:0: [sdc] Mode Sense: 53 00 80 08
sd 6:0:5:0: [sdc] Cache data unavailable
sd 6:0:5:0: [sdc] Assuming drive cache: write through
sd 6:0:5:0: [sdc] Spinning up 
disk..................................................................................................................................not 
responding...
.<5>sd 6:0:3:0: [sdb] READ CAPACITY failed
sd 6:0:3:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
sd 6:0:3:0: [sdb] Sense Key : Not Ready [current]
sd 6:0:3:0: [sdb] Add. Sense: Logical unit not ready, cause not reportable
sd 6:0:3:0: [sdb] Write Protect is on
sd 6:0:3:0: [sdb] Mode Sense: 53 00 80 08
sd 6:0:3:0: [sdb] Cache data unavailable
sd 6:0:3:0: [sdb] Assuming drive cache: write through
..................................not responding...
sd 6:0:5:0: [sdc] READ CAPACITY failed
sd 6:0:5:0: [sdc] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
sd 6:0:5:0: [sdc] Sense Key : Not Ready [current]
sd 6:0:5:0: [sdc] Add. Sense: Logical unit not ready, cause not reportable
sd 6:0:5:0: [sdc] Write Protect is on
sd 6:0:5:0: [sdc] Mode Sense: 53 00 80 08
sd 6:0:5:0: [sdc] Cache data unavailable
sd 6:0:5:0: [sdc] Assuming drive cache: write through


Obviously you can't do a successful Read Capacity command to a disk with no media???

Then lsscsi:

CPU1:#lsscsi
[0:0:0:0]    cd/dvd  SONY     DVD RW AW-Q170A  1.70  /dev/sr0
[2:0:0:0]    disk    ATA      ST3160811AS      3.AA  /dev/sda
[6:0:3:0]    disk    IOMEGA   BETA90            1.5  /dev/.tmp-8-16
[6:0:5:0]    disk    IOMEGA   BETA90            1.5  /dev/.tmp-8-32

What can I try??

Thanks in advance
Mark

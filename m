From: Arkadiusz Miskiewicz <arekm@maven.pl>
Subject: mptsas related problem [2.6.22], LSI SAS1064ET PCI-E
Date: Mon, 10 Sep 2007 19:55:56 +0200
Message-ID: <200709101955.57016.arekm@maven.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.carme.maven.pl ([193.239.45.138]:20542 "EHLO
	main.carme.maven.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323AbXIJR4g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Sep 2007 13:56:36 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Sathya <sathya.prakash@lsi.com>


Hello,

SR2520SAXS platform (S5000VSA mainboard in 2U SR2520 chassis) with

08:00.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1064ET=20
PCI-Express Fusion-MPT SAS (rev 02)

onboard (well afaik on backplane) and four SATA discs in various softwa=
re=20
raids level (1, 5 and 10) per partition.

Under bigger I/O load mptsas kicks out hdd disks like:
mptsas: ioc0: removing sata device, channel 0, id 24, phy 2

So far it dropped sdb twice and sdc once. Not sure if these are fauly=20
harddrives or controller problems or driver problems. Any hints?

ps. If someone knows how FwRev=3D01100000h relates to firmware version =
at
http://downloadcenter.intel.com/filter_results.aspx?strTypes=3Dall&Prod=
uctID=3D2487&OSFullName=3DOS+Independent&lang=3Deng&strOSs=3D38&submit=3D=
Go%21
then that's also interesting. Simply 01 10 ...=3D=3D 1.16.0.0 ?

mptbase: Initiating ioc0 bringup
ioc0: SAS1064E: Capabilities=3D{Initiator}
PCI: Setting latency timer of device 0000:08:00.0 to 64
scsi0 : ioc0: LSISAS1064E, FwRev=3D01100000h, Ports=3D1, MaxQ=3D511, IR=
Q=3D16
Device driver host0 lacks bus and class support for being resumed.
Device driver phy-0:0 lacks bus and class support for being resumed.
Device driver port-0:0 lacks bus and class support for being resumed.
Device driver expander-0:0 lacks bus and class support for being resume=
d.
Device driver phy-0:1 lacks bus and class support for being resumed.
Device driver phy-0:2 lacks bus and class support for being resumed.
Device driver phy-0:3 lacks bus and class support for being resumed.
Device driver phy-0:0:4 lacks bus and class support for being resumed.
Device driver phy-0:0:5 lacks bus and class support for being resumed.
Device driver port-0:0:0 lacks bus and class support for being resumed.
Device driver end_device-0:0:0 lacks bus and class support for being re=
sumed.
Device driver target0:0:0 lacks bus and class support for being resumed=
=2E
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD321KJ  0-10 PQ: 0 AN=
SI: 5
Device driver phy-0:0:6 lacks bus and class support for being resumed.
Device driver port-0:0:1 lacks bus and class support for being resumed.
Device driver end_device-0:0:1 lacks bus and class support for being re=
sumed.
Device driver target0:0:1 lacks bus and class support for being resumed=
=2E
scsi 0:0:1:0: Direct-Access     ATA      SAMSUNG HD321KJ  0-10 PQ: 0 AN=
SI: 5
Device driver phy-0:0:7 lacks bus and class support for being resumed.
Device driver phy-0:0:8 lacks bus and class support for being resumed.
Device driver port-0:0:2 lacks bus and class support for being resumed.
Device driver end_device-0:0:2 lacks bus and class support for being re=
sumed.
Device driver target0:0:2 lacks bus and class support for being resumed=
=2E
scsi 0:0:2:0: Direct-Access     ATA      SAMSUNG HD321KJ  0-10 PQ: 0 AN=
SI: 5
Device driver phy-0:0:9 lacks bus and class support for being resumed.
Device driver port-0:0:3 lacks bus and class support for being resumed.
Device driver end_device-0:0:3 lacks bus and class support for being re=
sumed.
Device driver target0:0:3 lacks bus and class support for being resumed=
=2E
scsi 0:0:3:0: Direct-Access     ATA      SAMSUNG HD321KJ  0-10 PQ: 0 AN=
SI: 5
Device driver phy-0:0:10 lacks bus and class support for being resumed.
Device driver port-0:0:4 lacks bus and class support for being resumed.
Device driver phy-0:0:11 lacks bus and class support for being resumed.
Device driver phy-0:0:12 lacks bus and class support for being resumed.
Device driver phy-0:0:13 lacks bus and class support for being resumed.
Device driver phy-0:0:14 lacks bus and class support for being resumed.
Device driver port-0:0:5 lacks bus and class support for being resumed.
Device driver port-0:0:5 lacks bus and class support for being resumed.
Device driver end_device-0:0:5 lacks bus and class support for being re=
sumed.
Device driver target0:0:4 lacks bus and class support for being resumed=
=2E
scsi 0:0:4:0: Enclosure         ESG-SHV. SCA HSBP M13.... 2.04 PQ: 0 AN=
SI: 3
sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 73 00 00 08
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't su=
pport=20
DPO or FUA
sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 73 00 00 08
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't su=
pport=20
DPO or FUA
 sda: sda1 sda2 sda3 sda4
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:1:0: [sdb] 625142448 512-byte hardware sectors (320073 MB)
sd 0:0:1:0: [sdb] Write Protect is off
sd 0:0:1:0: [sdb] Mode Sense: 73 00 00 08
sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't su=
pport=20
DPO or FUA
sd 0:0:1:0: [sdb] 625142448 512-byte hardware sectors (320073 MB)
sd 0:0:1:0: [sdb] Write Protect is off
sd 0:0:1:0: [sdb] Mode Sense: 73 00 00 08
sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't su=
pport=20
DPO or FUA
 sdb: sdb1 sdb2 sdb3 sdb4
sd 0:0:1:0: [sdb] Attached SCSI disk
sd 0:0:2:0: [sdc] 625142448 512-byte hardware sectors (320073 MB)
sd 0:0:2:0: [sdc] Write Protect is off
sd 0:0:2:0: [sdc] Mode Sense: 73 00 00 08
sd 0:0:2:0: [sdc] Write cache: enabled, read cache: enabled, doesn't su=
pport=20
DPO or FUA
sd 0:0:2:0: [sdc] 625142448 512-byte hardware sectors (320073 MB)
sd 0:0:2:0: [sdc] Write Protect is off
sd 0:0:2:0: [sdc] Mode Sense: 73 00 00 08
sd 0:0:2:0: [sdc] Write cache: enabled, read cache: enabled, doesn't su=
pport=20
DPO or FUA
 sdc: sdc1 sdc2 sdc3 sdc4
sd 0:0:2:0: [sdc] Attached SCSI disk
sd 0:0:3:0: [sdd] 625142448 512-byte hardware sectors (320073 MB)
sd 0:0:3:0: [sdd] Write Protect is off
sd 0:0:3:0: [sdd] Mode Sense: 73 00 00 08
sd 0:0:3:0: [sdd] Write cache: enabled, read cache: enabled, doesn't su=
pport=20
DPO or FUA
sd 0:0:3:0: [sdd] 625142448 512-byte hardware sectors (320073 MB)
sd 0:0:3:0: [sdd] Write Protect is off
sd 0:0:3:0: [sdd] Mode Sense: 73 00 00 08
sd 0:0:3:0: [sdd] Write cache: enabled, read cache: enabled, doesn't su=
pport=20
DPO or FUA
 sdd: sdd1 sdd2 sdd3 sdd4
sd 0:0:3:0: [sdd] Attached SCSI disk
sd 0:0:3:0: [sdd] Attached SCSI disk
SGI XFS with ACLs, security attributes, large block/inode numbers, no d=
ebug=20
enabled
SGI XFS Quota Management subsystem
md: md2 stopped.
md: bind<sdc3>
md: bind<sda3>
md: bind<sdb3>
md: bind<sdd3>
raid10: raid set md2 active with 4 out of 4 devices
Suspend2: No attempt was made to resume from any image that might exist=
=2E
=46ilesystem "md2": Disabling barriers, not supported by the underlying=
 device
XFS mounting filesystem md2
Ending clean XFS mount for filesystem: md2

[...]

md: bind<sdb4>
RAID5 conf printout:
 --- rd:4 wd:3
 disk 0, o:1, dev:sdd4
 disk 1, o:1, dev:sdc4
 disk 2, o:1, dev:sda4
 disk 3, o:1, dev:sdb4
md: recovery of RAID array md3
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000=
=20
KB/sec) for recovery.
md: using 128k window, over a total of 280069056 blocks.
mptscsih: ioc0: attempting task abort! (sc=3Dffff810158ecb540)
sd 0:0:2:0: [sdc] CDB: cdb[0]=3D0x2a: 2a 00 0a ad 28 de 00 00 10 00
mptbase: ioc0: LogInfo(0x31120403): Originator=3D{PL}, Code=3D{Abort},=20
SubCode(0x0403)
mptbase: ioc0: LogInfo(0x31140000): Originator=3D{PL}, Code=3D{IO Execu=
ted},=20
SubCode(0x0000)
mptscsih: ioc0: task abort: SUCCESS (sc=3Dffff810158ecb540)
mptbase: ioc0: LogInfo(0x31120403): Originator=3D{PL}, Code=3D{Abort},=20
SubCode(0x0403)
mptscsih: ioc0: attempting target reset! (sc=3Dffff810158ecb540)
sd 0:0:2:0: [sdc] CDB: cdb[0]=3D0x2a: 2a 00 0a ad 28 de 00 00 10 00
mptscsih: ioc0: target reset: SUCCESS (sc=3Dffff810158ecb540)
mptscsih: ioc0: attempting task abort! (sc=3Dffff81006ea80b40)
sd 0:0:1:0: [sdb] CDB: cdb[0]=3D0x2a: 2a 00 02 16 21 3c 00 00 0a 00
mptbase: ioc0: LogInfo(0x31120403): Originator=3D{PL}, Code=3D{Abort},=20
SubCode(0x0403)
mptbase: ioc0: LogInfo(0x31140000): Originator=3D{PL}, Code=3D{IO Execu=
ted},=20
SubCode(0x0000)
mptscsih: ioc0: task abort: SUCCESS (sc=3Dffff81006ea80b40)
mptbase: ioc0: LogInfo(0x31120403): Originator=3D{PL}, Code=3D{Abort},=20
SubCode(0x0403)
mptbase: ioc0: LogInfo(0x31111000): Originator=3D{PL}, Code=3D{Reset},=20
SubCode(0x1000)
mptbase: ioc0: LogInfo(0x31111000): Originator=3D{PL}, Code=3D{Reset},=20
SubCode(0x1000)
mptscsih: ioc0: attempting target reset! (sc=3Dffff81006ea80b40)
sd 0:0:1:0: [sdb] CDB: cdb[0]=3D0x2a: 2a 00 02 16 21 3c 00 00 0a 00
mptscsih: ioc0: target reset: SUCCESS (sc=3Dffff81006ea80b40)
mptscsih: ioc0: attempting task abort! (sc=3Dffff81006ea80b40)
sd 0:0:1:0: [sdb] CDB: cdb[0]=3D0x0: 00 00 00 00 00 00
mptbase: ioc0: LogInfo(0x31130000): Originator=3D{PL}, Code=3D{IO Not Y=
et=20
Executed}, SubCode(0x0000)
mptscsih: ioc0: task abort: SUCCESS (sc=3Dffff81006ea80b40)
mptscsih: ioc0: attempting bus reset! (sc=3Dffff81006ea80b40)
sd 0:0:1:0: [sdb] CDB: cdb[0]=3D0x2a: 2a 00 02 16 21 3c 00 00 0a 00
mptscsih: ioc0: bus reset: SUCCESS (sc=3Dffff81006ea80b40)
mptscsih: ioc0: attempting task abort! (sc=3Dffff81006ea80b40)
sd 0:0:1:0: [sdb] CDB: cdb[0]=3D0x0: 00 00 00 00 00 00
mptbase: ioc0: LogInfo(0x31130000): Originator=3D{PL}, Code=3D{IO Not Y=
et=20
Executed}, SubCode(0x0000)
mptscsih: ioc0: task abort: SUCCESS (sc=3Dffff81006ea80b40)
mptscsih: ioc0: attempting task abort! (sc=3Dffff81006ea806c0)
sd 0:0:1:0: [sdb] CDB: cdb[0]=3D0x0: 00 00 00 00 00 00
mptbase: ioc0: LogInfo(0x31130000): Originator=3D{PL}, Code=3D{IO Not Y=
et=20
Executed}, SubCode(0x0000)
mptscsih: ioc0: task abort: SUCCESS (sc=3Dffff81006ea806c0)
mptscsih: ioc0: Attempting host reset! (sc=3Dffff81006ea80b40)
mptbase: Initiating ioc0 recovery
sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
end_request: I/O error, dev sdb, sector 35004742
raid10: Disk failure on sdb3, disabling device.
        Operation continuing on 3 devices
sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
end_request: I/O error, dev sdb, sector 35004732
sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
end_request: I/O error, dev sdb, sector 50036487
sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
end_request: I/O error, dev sdb, sector 57635839
sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
end_request: I/O error, dev sdb, sector 75634150
raid5: Disk failure on sdb4, disabling device. Operation continuing on =
3=20
devices
sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
end_request: I/O error, dev sdb, sector 82503262
sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
end_request: I/O error, dev sdb, sector 83868190
sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
end_request: I/O error, dev sdb, sector 105214542
sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
end_request: I/O error, dev sdb, sector 131203934
sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
end_request: I/O error, dev sdb, sector 161928270
sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
end_request: I/O error, dev sdb, sector 161928398
sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
end_request: I/O error, dev sdb, sector 175936606
sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
end_request: I/O error, dev sdb, sector 187551886
sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
end_request: I/O error, dev sdb, sector 290607566
sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
end_request: I/O error, dev sdb, sector 399736142
sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
end_request: I/O error, dev sdb, sector 456110686
sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
end_request: I/O error, dev sdb, sector 524831054
sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
end_request: I/O error, dev sdb, sector 12540919
sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
end_request: I/O error, dev sdb, sector 42590839
sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
end_request: I/O error, dev sdb, sector 593333070
sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
end_request: I/O error, dev sdb, sector 27559031
sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
end_request: I/O error, dev sdb, sector 27571575
sd 0:0:1:0: [sdb] Result: hostbyte=3D0x00 driverbyte=3D0x00
end_request: I/O error, dev sdb, sector 27580407
RAID10 conf printout:
 --- wd:3 rd:4
 disk 0, wo:0, o:1, dev:sdd3
 disk 1, wo:0, o:1, dev:sdc3
 disk 2, wo:0, o:1, dev:sda3
 disk 3, wo:1, o:0, dev:sdb3
RAID10 conf printout:
 --- wd:3 rd:4
 disk 0, wo:0, o:1, dev:sdd3
 disk 1, wo:0, o:1, dev:sdc3
 disk 2, wo:0, o:1, dev:sda3
md: md3: recovery done.
RAID5 conf printout:
 --- rd:4 wd:3
 disk 0, o:1, dev:sdd4
 disk 1, o:1, dev:sdc4
 disk 2, o:1, dev:sda4
 disk 3, o:0, dev:sdb4
RAID5 conf printout:
 --- rd:4 wd:3
 disk 0, o:1, dev:sdd4
 disk 1, o:1, dev:sdc4
 disk 2, o:1, dev:sda4
mptsas: ioc0: removing sata device, channel 0, id 24, phy 2
sd 0:0:1:0: [sdb] Synchronizing SCSI cache
sd 0:0:1:0: [sdb] Result: hostbyte=3D0x01 driverbyte=3D0x00

# cat /proc/mdstat
Personalities : [raid10] [raid1] [raid6] [raid5] [raid4]
md3 : active raid5 sdb4[4](F) sdd4[0] sda4[2] sdc4[1]
      840207168 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]

md1 : active raid1 sdd2[0] sdc2[3] sda2[2] sdb2[1]
      497920 blocks [4/4] [UUUU]

md0 : active raid10 sdd1[0] sdb1[3] sda1[2] sdc1[1]
      3999872 blocks 64K chunks 2 near-copies [4/4] [UUUU]

md2 : active raid10 sdd3[0] sdb3[4](F) sda3[2] sdc3[1]
      60002560 blocks 64K chunks 2 near-copies [4/3] [UUU_]

unused devices: <none>

--=20
Arkadiusz Mi=B6kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

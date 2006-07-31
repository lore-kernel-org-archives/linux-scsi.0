From: Arkadiusz Miskiewicz <arekm@pld-linux.org>
Subject: intel srcu42e, megaraid_mbox, 2.6.16.23, x86_64 - megaraid mbox: critical hardware error!
Date: Mon, 31 Jul 2006 11:07:36 +0200
Message-ID: <200607311107.36681.arekm@pld-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outgoing3.smtp.agnat.pl ([193.239.44.85]:29881 "EHLO
	outgoing3.smtp.agnat.pl") by vger.kernel.org with ESMTP
	id S1751310AbWGaJHu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jul 2006 05:07:50 -0400
Received: from [83.18.80.218] (helo=[192.168.1.157] ident=matrix157)
	by tekla.agnat.pl with esmtpsa (TLSv1:DHE-RSA-AES256-SHA:256)
	(Exim 4.62)
	(envelope-from <arekm@pld-linux.org>)
	id 1G7TkX-0001s8-78
	for linux-scsi@vger.kernel.org; Mon, 31 Jul 2006 11:07:48 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi,

I have Tyan Thunder K8SRE S2891 mainboard, Transport GT24 B2891 1U
barebone system - 2 x dual core opteron 270, 6GB ram and Intel SRCU42E =
(PCI-E one) controller.

The system has been set up (with kernel 2.6.16.23 SMP) and while compil=
ing kernel
on it I got controller lockup. The problem is repeatable.

I'm trying to compile 2.6.18rc3 + megaraid patches from mm kernel but f=
rom
changelog it doesn't seem that there is some important fix for this cas=
e.

Any ideas?

megaraid driver, firmware and bios versions below:

megaraid cmm: 2.20.2.6 (Release Date: Mon Mar 7 00:01:03 EST 2005)
megaraid: 2.20.4.7 (Release Date: Mon Nov 14 12:27:22 EST 2005)
megaraid: probe new device 0x1000:0x0408:0x8086:0x0002: bus 3:slot 14:f=
unc 0
ACPI: PCI Interrupt Link [LNK1] enabled at IRQ 19
GSI 16 sharing vector 0xB1 and IRQ 16
ACPI: PCI Interrupt 0000:03:0e.0[A] -> Link [LNK1] -> GSI 19 (level, hi=
gh) -> IRQ 177
megaraid: fw version:[514P] bios version:[H431]
Losing some ticks... checking if CPU frequency changed.
scsi0 : LSI Logic MegaRAID driver
scsi[0]: scanning scsi channel 0 [Phy 0] for non-raid devices
scsi[0]: scanning scsi channel 1 [Phy 1] for non-raid devices
scsi[0]: scanning scsi channel 2 [virtual] for logical drives
  Vendor: MegaRAID  Model: LD 0 RAID5  280G  Rev: 514P
  Type:   Direct-Access                      ANSI SCSI revision: 02

Jul 31 10:46:13 pldmachine kernel: sd 0:2:0:0: Notifying upper driver o=
f completion (result 0)
Jul 31 10:46:13 pldmachine kernel: sd_rw_intr: sda: res=3D0x0
Jul 31 10:46:13 pldmachine kernel: 16 sectors total, 8192 bytes done.
Jul 31 10:46:13 pldmachine kernel: use_sg is 2
Jul 31 10:46:13 pldmachine kernel: sd_init_command: disk=3Dsda, block=3D=
1342159, count=3D16
Jul 31 10:46:13 pldmachine kernel: sda : block=3D1342159
Jul 31 10:46:13 pldmachine kernel: sda : writing 16/16 512 byte blocks.
Jul 31 10:46:13 pldmachine kernel: scsi_add_timer: scmd: ffff810129d141=
80, time: 7500, (ffffffff880033e0)
Jul 31 10:46:13 pldmachine kernel: sd 0:2:0:0: send 0xffff810129d14180 =
                 sd 0:2:0:0:
Jul 31 10:46:13 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 00 14 =
7a cf 00 00 10 00
Jul 31 10:46:13 pldmachine kernel: buffer =3D 0xffff81013a76a5c0, buffl=
en =3D 8192, done =3D 0xffffffff8802fb90, queuecommand 0xffffffff880250=
40
Jul 31 10:46:13 pldmachine kernel: leaving scsi_dispatch_cmnd()
Jul 31 10:46:13 pldmachine kernel: sd_init_command: disk=3Dsda, block=3D=
1346591, count=3D16
Jul 31 10:46:13 pldmachine kernel: sda : block=3D1346591
Jul 31 10:46:13 pldmachine kernel: sda : writing 16/16 512 byte blocks.
Jul 31 10:46:13 pldmachine kernel: scsi_add_timer: scmd: ffff81012eead4=
c0, time: 7500, (ffffffff880033e0)
Jul 31 10:46:13 pldmachine kernel: sd 0:2:0:0: send 0xffff81012eead4c0 =
                 sd 0:2:0:0:
Jul 31 10:46:13 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 00 14 =
8c 1f 00 00 10 00
Jul 31 10:46:13 pldmachine kernel: buffer =3D 0xffff810139b07780, buffl=
en =3D 8192, done =3D 0xffffffff8802fb90, queuecommand 0xffffffff880250=
40
Jul 31 10:46:13 pldmachine kernel: leaving scsi_dispatch_cmnd()
Jul 31 10:46:13 pldmachine kernel: sd_init_command: disk=3Dsda, block=3D=
1374735, count=3D128
Jul 31 10:46:13 pldmachine kernel: sda : block=3D1374735
Jul 31 10:46:13 pldmachine kernel: sda : writing 128/128 512 byte block=
s.
Jul 31 10:46:13 pldmachine kernel: scsi_add_timer: scmd: ffff810129d14c=
00, time: 7500, (ffffffff880033e0)
Jul 31 10:46:13 pldmachine kernel: sd 0:2:0:0: send 0xffff810129d14c00 =
                 sd 0:2:0:0:
Jul 31 10:46:13 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 00 14 =
fa 0f 00 00 80 00
Jul 31 10:46:13 pldmachine kernel: buffer =3D 0xffff81012c1ffc00, buffl=
en =3D 65536, done =3D 0xffffffff8802fb90, queuecommand 0xffffffff88025=
040
Jul 31 10:46:13 pldmachine kernel: leaving scsi_dispatch_cmnd()
Jul 31 10:46:13 pldmachine kernel: sd_init_command: disk=3Dsda, block=3D=
1374863, count=3D104
Jul 31 10:46:13 pldmachine kernel: sda : block=3D1374863
Jul 31 10:46:13 pldmachine kernel: sda : writing 104/104 512 byte block=
s.
Jul 31 10:46:13 pldmachine kernel: scsi_add_timer: scmd: ffff810138ef1d=
00, time: 7500, (ffffffff880033e0)
Jul 31 10:46:13 pldmachine kernel: sd 0:2:0:0: send 0xffff810138ef1d00 =
                 sd 0:2:0:0:
Jul 31 10:46:13 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 00 14 =
fa 8f 00 00 68 00
Jul 31 10:46:13 pldmachine kernel: buffer =3D 0xffff810134411e00, buffl=
en =3D 53248, done =3D 0xffffffff8802fb90, queuecommand 0xffffffff88025=
040
Jul 31 10:46:13 pldmachine kernel: leaving scsi_dispatch_cmnd()
Jul 31 10:46:13 pldmachine kernel: sd_init_command: disk=3Dsda, block=3D=
1374967, count=3D120
Jul 31 10:46:13 pldmachine kernel: sda : block=3D1374967
Jul 31 10:46:13 pldmachine kernel: sda : writing 120/120 512 byte block=
s.
Jul 31 10:46:13 pldmachine kernel: scsi_add_timer: scmd: ffff810129d148=
80, time: 7500, (ffffffff880033e0)
Jul 31 10:46:13 pldmachine kernel: sd 0:2:0:0: send 0xffff810129d14880 =
                 sd 0:2:0:0:
Jul 31 10:46:13 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 00 14 =
fa f7 00 00 78 00
Jul 31 10:46:13 pldmachine kernel: buffer =3D 0xffff810133918000, buffl=
en =3D 61440, done =3D 0xffffffff8802fb90, queuecommand 0xffffffff88025=
040
Jul 31 10:46:13 pldmachine kernel: leaving scsi_dispatch_cmnd()
Jul 31 10:46:13 pldmachine kernel: sd_init_command: disk=3Dsda, block=3D=
1375087, count=3D64
Jul 31 10:46:13 pldmachine kernel: sda : block=3D1375087
Jul 31 10:46:13 pldmachine kernel: sda : writing 64/64 512 byte blocks.
Jul 31 10:46:13 pldmachine kernel: scsi_add_timer: scmd: ffff810129d145=
00, time: 7500, (ffffffff880033e0)
Jul 31 10:46:13 pldmachine kernel: sd 0:2:0:0: send 0xffff810129d14500 =
                 sd 0:2:0:0:
Jul 31 10:46:13 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 00 14 =
fb 6f 00 00 40 00
Jul 31 10:46:13 pldmachine kernel: buffer =3D 0xffff8101304a0e80, buffl=
en =3D 32768, done =3D 0xffffffff8802fb90, queuecommand 0xffffffff88025=
040
Jul 31 10:46:13 pldmachine kernel: leaving scsi_dispatch_cmnd()
Jul 31 10:46:13 pldmachine kernel: sd_init_command: disk=3Dsda, block=3D=
1375151, count=3D80
Jul 31 10:46:13 pldmachine kernel: sda : block=3D1375151
Jul 31 10:46:13 pldmachine kernel: sda : writing 80/80 512 byte blocks.
Jul 31 10:46:13 pldmachine kernel: scsi_add_timer: scmd: ffff81012593c4=
40, time: 7500, (ffffffff880033e0)
Jul 31 10:46:13 pldmachine kernel: sd 0:2:0:0: send 0xffff81012593c440 =
                 sd 0:2:0:0:
Jul 31 10:46:13 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 00 14 =
fb af 00 00 50 00
Jul 31 10:46:13 pldmachine kernel: buffer =3D 0xffff810139b07480, buffl=
en =3D 40960, done =3D 0xffffffff8802fb90, queuecommand 0xffffffff88025=
040
Jul 31 10:46:13 pldmachine kernel: leaving scsi_dispatch_cmnd()
Jul 31 10:46:13 pldmachine kernel: sd_init_command: disk=3Dsda, block=3D=
2693311, count=3D112
Jul 31 10:46:13 pldmachine kernel: sda : block=3D2693311
Jul 31 10:46:13 pldmachine kernel: sda : writing 112/112 512 byte block=
s.
Jul 31 10:46:13 pldmachine kernel: scsi_add_timer: scmd: ffff810138ef12=
80, time: 7500, (ffffffff880033e0)
Jul 31 10:46:13 pldmachine kernel: sd 0:2:0:0: send 0xffff810138ef1280 =
                 sd 0:2:0:0:
Jul 31 10:46:13 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 00 29 =
18 bf 00 00 70 00
Jul 31 10:46:13 pldmachine kernel: buffer =3D 0xffff81012c5f4200, buffl=
en =3D 57344, done =3D 0xffffffff8802fb90, queuecommand 0xffffffff88025=
040
Jul 31 10:46:13 pldmachine kernel: leaving scsi_dispatch_cmnd()
Jul 31 10:46:13 pldmachine kernel: sd_init_command: disk=3Dsda, block=3D=
2693423, count=3D112
Jul 31 10:46:13 pldmachine kernel: sda : block=3D2693423
Jul 31 10:46:13 pldmachine kernel: sda : writing 112/112 512 byte block=
s.
Jul 31 10:46:13 pldmachine kernel: scsi_add_timer: scmd: ffff810129d14a=
40, time: 7500, (ffffffff880033e0)
Jul 31 10:46:13 pldmachine kernel: sd 0:2:0:0: send 0xffff810129d14a40 =
                 sd 0:2:0:0:
Jul 31 10:46:13 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 00 29 =
19 2f 00 00 70 00
Jul 31 10:46:13 pldmachine kernel: buffer =3D 0xffff81012c5f4400, buffl=
en =3D 57344, done =3D 0xffffffff8802fb90, queuecommand 0xffffffff88025=
040
Jul 31 10:46:13 pldmachine kernel: leaving scsi_dispatch_cmnd()
Jul 31 10:46:13 pldmachine kernel: sd_init_command: disk=3Dsda, block=3D=
2693535, count=3D120
Jul 31 10:46:13 pldmachine kernel: sda : block=3D2693535
Jul 31 10:46:13 pldmachine kernel: sda : writing 120/120 512 byte block=
s.
Jul 31 10:46:13 pldmachine kernel: scsi_add_timer: scmd: ffff81012fcdca=
00, time: 7500, (ffffffff880033e0)
Jul 31 10:46:13 pldmachine kernel: sd 0:2:0:0: send 0xffff81012fcdca00 =
                 sd 0:2:0:0:
Jul 31 10:46:13 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 00 29 =
19 9f 00 00 78 00
Jul 31 10:46:13 pldmachine kernel: buffer =3D 0xffff81012a8f2800, buffl=
en =3D 61440, done =3D 0xffffffff8802fb90, queuecommand 0xffffffff88025=
040
Jul 31 10:46:13 pldmachine kernel: leaving scsi_dispatch_cmnd()
Jul 31 10:46:13 pldmachine kernel: sd_init_command: disk=3Dsda, block=3D=
2693655, count=3D56
Jul 31 10:46:13 pldmachine kernel: sda : block=3D2693655
Jul 31 10:46:13 pldmachine kernel: sda : writing 56/56 512 byte blocks.
Jul 31 10:46:13 pldmachine kernel: scsi_add_timer: scmd: ffff81012fcdc3=
00, time: 7500, (ffffffff880033e0)
Jul 31 10:46:13 pldmachine kernel: sd 0:2:0:0: send 0xffff81012fcdc300 =
                 sd 0:2:0:0:
Jul 31 10:46:13 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 00 29 =
1a 17 00 00 38 00
Jul 31 10:46:13 pldmachine kernel: buffer =3D 0xffff8101304a0a80, buffl=
en =3D 28672, done =3D 0xffffffff8802fb90, queuecommand 0xffffffff88025=
040
Jul 31 10:46:13 pldmachine kernel: leaving scsi_dispatch_cmnd()
Jul 31 10:46:13 pldmachine kernel: sd_init_command: disk=3Dsda, block=3D=
3873919, count=3D32
Jul 31 10:46:13 pldmachine kernel: sda : block=3D3873919
Jul 31 10:46:13 pldmachine kernel: sda : writing 32/32 512 byte blocks.
Jul 31 10:46:13 pldmachine kernel: scsi_add_timer: scmd: ffff81012fcdc4=
c0, time: 7500, (ffffffff880033e0)
Jul 31 10:46:13 pldmachine kernel: sd 0:2:0:0: send 0xffff81012fcdc4c0 =
                 sd 0:2:0:0:
Jul 31 10:46:13 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 00 3b =
1c 7f 00 00 20 00
Jul 31 10:46:13 pldmachine kernel: buffer =3D 0xffff8101304a0180, buffl=
en =3D 16384, done =3D 0xffffffff8802fb90, queuecommand 0xffffffff88025=
040
Jul 31 10:46:13 pldmachine kernel: leaving scsi_dispatch_cmnd()
Jul 31 10:46:13 pldmachine kernel: sd_init_command: disk=3Dsda, block=3D=
5061087, count=3D16
Jul 31 10:46:13 pldmachine kernel: sda : block=3D5061087
Jul 31 10:46:13 pldmachine kernel: sda : writing 16/16 512 byte blocks.
Jul 31 10:46:13 pldmachine kernel: scsi_add_timer: scmd: ffff81012593c0=
c0, time: 7500, (ffffffff880033e0)
Jul 31 10:46:13 pldmachine kernel: sd 0:2:0:0: send 0xffff81012593c0c0 =
                 sd 0:2:0:0:
Jul 31 10:46:13 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 00 4d =
39 df 00 00 10 00
Jul 31 10:46:13 pldmachine kernel: buffer =3D 0xffff81012ed566c0, buffl=
en =3D 8192, done =3D 0xffffffff8802fb90, queuecommand 0xffffffff880250=
40
Jul 31 10:46:13 pldmachine kernel: leaving scsi_dispatch_cmnd()
Jul 31 10:46:13 pldmachine kernel: sd_init_command: disk=3Dsda, block=3D=
5275487, count=3D104
Jul 31 10:46:13 pldmachine kernel: sda : block=3D5275487
Jul 31 10:46:13 pldmachine kernel: sda : writing 104/104 512 byte block=
s.
Jul 31 10:46:13 pldmachine kernel: scsi_add_timer: scmd: ffff81012fcdcd=
80, time: 7500, (ffffffff880033e0)
Jul 31 10:46:13 pldmachine kernel: sd 0:2:0:0: send 0xffff81012fcdcd80 =
                 sd 0:2:0:0:
Jul 31 10:46:13 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 00 50 =
7f 5f 00 00 68 00
Jul 31 10:46:13 pldmachine kernel: buffer =3D 0xffff81012bd8ac00, buffl=
en =3D 53248, done =3D 0xffffffff8802fb90, queuecommand 0xffffffff88025=
040
Jul 31 10:46:13 pldmachine kernel: leaving scsi_dispatch_cmnd()
Jul 31 10:46:13 pldmachine kernel: sd_init_command: disk=3Dsda, block=3D=
5275591, count=3D128
Jul 31 10:46:13 pldmachine kernel: sda : block=3D5275591
Jul 31 10:46:13 pldmachine kernel: sda : writing 128/128 512 byte block=
s.
Jul 31 10:46:13 pldmachine kernel: scsi_add_timer: scmd: ffff8101327221=
40, time: 7500, (ffffffff880033e0)
Jul 31 10:46:13 pldmachine kernel: sd 0:2:0:0: send 0xffff810132722140 =
                 sd 0:2:0:0:
Jul 31 10:46:13 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 00 50 =
7f c7 00 00 80 00
Jul 31 10:46:13 pldmachine kernel: buffer =3D 0xffff81012bd8a000, buffl=
en =3D 65536, done =3D 0xffffffff8802fb90, queuecommand 0xffffffff88025=
040
Jul 31 10:46:13 pldmachine kernel: leaving scsi_dispatch_cmnd()
Jul 31 10:46:13 pldmachine kernel: sd_init_command: disk=3Dsda, block=3D=
5275719, count=3D104
Jul 31 10:46:13 pldmachine kernel: sda : block=3D5275719
Jul 31 10:46:13 pldmachine kernel: sda : writing 104/104 512 byte block=
s.
Jul 31 10:46:13 pldmachine kernel: scsi_add_timer: scmd: ffff81012fcdcb=
c0, time: 7500, (ffffffff880033e0)
Jul 31 10:46:13 pldmachine kernel: sd 0:2:0:0: send 0xffff81012fcdcbc0 =
                 sd 0:2:0:0:
Jul 31 10:46:13 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 00 50 =
80 47 00 00 68 00
Jul 31 10:46:13 pldmachine kernel: buffer =3D 0xffff81012bd8a600, buffl=
en =3D 53248, done =3D 0xffffffff8802fb90, queuecommand 0xffffffff88025=
040
Jul 31 10:46:13 pldmachine kernel: leaving scsi_dispatch_cmnd()
Jul 31 10:46:13 pldmachine kernel: scsi_delete_timer: scmd: ffff810129d=
14180, rtn: 1
Jul 31 10:46:13 pldmachine kernel: sd 0:2:0:0: done 0xffff810129d14180 =
SUCCESS        0 sd 0:2:0:0:
Jul 31 10:46:13 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 00 14 =
7a cf 00 00 10 00
Jul 31 10:46:13 pldmachine kernel: scsi host busy 18 failed 0
Jul 31 10:46:13 pldmachine kernel: sd 0:2:0:0: Notifying upper driver o=
f completion (result 0)
Jul 31 10:46:13 pldmachine kernel: sd_rw_intr: sda: res=3D0x0
Jul 31 10:46:13 pldmachine kernel: 16 sectors total, 8192 bytes done.
Jul 31 10:46:13 pldmachine kernel: use_sg is 1
Jul 31 10:46:13 pldmachine kernel: scsi_delete_timer: scmd: ffff81012ee=
ad4c0, rtn: 1
Jul 31 10:46:13 pldmachine kernel: sd 0:2:0:0: done 0xffff81012eead4c0 =
SUCCESS        0 sd 0:2:0:0:
Jul 31 10:46:13 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 00 14 =
8c 1f 00 00 10 00
Jul 31 10:46:13 pldmachine kernel: scsi host busy 17 failed 0
Jul 31 10:46:13 pldmachine kernel: sd 0:2:0:0: Notifying upper driver o=
f completion (result 0)
Jul 31 10:46:13 pldmachine kernel: sd_rw_intr: sda: res=3D0x0
Jul 31 10:46:13 pldmachine kernel: 16 sectors total, 8192 bytes done.
Jul 31 10:46:13 pldmachine kernel: use_sg is 2
Jul 31 10:46:13 pldmachine kernel: scsi_delete_timer: scmd: ffff810129d=
14c00, rtn: 1
Jul 31 10:46:13 pldmachine kernel: sd 0:2:0:0: done 0xffff810129d14c00 =
SUCCESS        0 sd 0:2:0:0:
Jul 31 10:46:13 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 00 14 =
fa 0f 00 00 80 00
Jul 31 10:46:13 pldmachine kernel: scsi host busy 16 failed 0
Jul 31 10:46:13 pldmachine kernel: sd 0:2:0:0: Notifying upper driver o=
f completion (result 0)
Jul 31 10:46:13 pldmachine kernel: sd_rw_intr: sda: res=3D0x0
Jul 31 10:46:13 pldmachine kernel: 128 sectors total, 65536 bytes done.
Jul 31 10:46:13 pldmachine kernel: use_sg is 16
Jul 31 10:46:13 pldmachine kernel: scsi_delete_timer: scmd: ffff810138e=
f1280, rtn: 1
Jul 31 10:46:13 pldmachine kernel: sd 0:2:0:0: done 0xffff810138ef1280 =
SUCCESS        0 sd 0:2:0:0:
Jul 31 10:46:13 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 00 29 =
18 bf 00 00 70 00
Jul 31 10:46:13 pldmachine kernel: scsi host busy 15 failed 0
Jul 31 10:46:13 pldmachine kernel: sd 0:2:0:0: Notifying upper driver o=
f completion (result 0)
Jul 31 10:46:13 pldmachine kernel: sd_rw_intr: sda: res=3D0x0
Jul 31 10:46:13 pldmachine kernel: 112 sectors total, 57344 bytes done.
Jul 31 10:46:13 pldmachine kernel: use_sg is 14
Jul 31 10:46:13 pldmachine kernel: scsi_delete_timer: scmd: ffff810138e=
f1d00, rtn: 1
Jul 31 10:46:13 pldmachine kernel: sd 0:2:0:0: done 0xffff810138ef1d00 =
SUCCESS        0 sd 0:2:0:0:
Jul 31 10:46:13 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 00 14 =
fa 8f 00 00 68 00
Jul 31 10:46:13 pldmachine kernel: scsi host busy 14 failed 0
Jul 31 10:46:13 pldmachine kernel: sd 0:2:0:0: Notifying upper driver o=
f completion (result 0)
Jul 31 10:46:13 pldmachine kernel: sd_rw_intr: sda: res=3D0x0
Jul 31 10:46:13 pldmachine kernel: 104 sectors total, 53248 bytes done.
Jul 31 10:46:13 pldmachine kernel: use_sg is 12
Jul 31 10:46:13 pldmachine kernel: scsi_delete_timer: scmd: ffff81012fc=
dc4c0, rtn: 1
Jul 31 10:46:13 pldmachine kernel: sd 0:2:0:0: done 0xffff81012fcdc4c0 =
SUCCESS        0 sd 0:2:0:0:
Jul 31 10:46:13 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 00 3b =
1c 7f 00 00 20 00
Jul 31 10:46:13 pldmachine kernel: scsi host busy 13 failed 0
Jul 31 10:46:13 pldmachine kernel: sd 0:2:0:0: Notifying upper driver o=
f completion (result 0)
Jul 31 10:46:13 pldmachine kernel: sd_rw_intr: sda: res=3D0x0
Jul 31 10:46:13 pldmachine kernel: 32 sectors total, 16384 bytes done.
Jul 31 10:46:13 pldmachine kernel: use_sg is 2
Jul 31 10:46:13 pldmachine kernel: sd_init_command: disk=3Dsda, block=3D=
7579287, count=3D16
Jul 31 10:46:13 pldmachine kernel: sda : block=3D7579287
Jul 31 10:46:13 pldmachine kernel: sda : reading 16/16 512 byte blocks.
Jul 31 10:46:13 pldmachine kernel: scsi_add_timer: scmd: ffff8101b592d5=
00, time: 7500, (ffffffff880033e0)
Jul 31 10:46:13 pldmachine kernel: sd 0:2:0:0: send 0xffff8101b592d500 =
                 sd 0:2:0:0:
Jul 31 10:46:13 pldmachine kernel: command: cdb[0]=3D0x28: 28 00 00 73 =
a6 97 00 00 10 00
Jul 31 10:46:13 pldmachine kernel: buffer =3D 0xffff8101bd1cd080, buffl=
en =3D 8192, done =3D 0xffffffff8802fb90, queuecommand 0xffffffff880250=
40
Jul 31 10:46:13 pldmachine kernel: leaving scsi_dispatch_cmnd()
Jul 31 10:46:13 pldmachine kernel: sd_init_command: disk=3Dsda, block=3D=
10005357, count=3D64
Jul 31 10:46:13 pldmachine kernel: sda : block=3D10005357
Jul 31 10:46:13 pldmachine kernel: sda : writing 64/64 512 byte blocks.
Jul 31 10:46:13 pldmachine kernel: scsi_add_timer: scmd: ffff81012eead3=
00, time: 7500, (ffffffff880033e0)
Jul 31 10:46:13 pldmachine kernel: sd 0:2:0:0: send 0xffff81012eead300 =
                 sd 0:2:0:0:
Jul 31 10:46:13 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 00 98 =
ab 6d 00 00 40 00
Jul 31 10:46:13 pldmachine kernel: buffer =3D 0xffff8101bd1cd280, buffl=
en =3D 32768, done =3D 0xffffffff8802fb90, queuecommand 0xffffffff88025=
040
Jul 31 10:46:13 pldmachine kernel: leaving scsi_dispatch_cmnd()
Jul 31 10:46:13 pldmachine kernel: sd_init_command: disk=3Dsda, block=3D=
5084807, count=3D64
Jul 31 10:46:13 pldmachine kernel: sda : block=3D5084807
Jul 31 10:46:13 pldmachine kernel: sda : reading 64/64 512 byte blocks.
Jul 31 10:46:13 pldmachine kernel: scsi_add_timer: scmd: ffff81012eead1=
40, time: 7500, (ffffffff880033e0)
Jul 31 10:46:13 pldmachine kernel: sd 0:2:0:0: send 0xffff81012eead140 =
                 sd 0:2:0:0:
Jul 31 10:46:13 pldmachine kernel: command: cdb[0]=3D0x28: 28 00 00 4d =
96 87 00 00 40 00
Jul 31 10:46:13 pldmachine kernel: buffer =3D 0xffff8101bd1cd880, buffl=
en =3D 32768, done =3D 0xffffffff8802fb90, queuecommand 0xffffffff88025=
040
Jul 31 10:46:13 pldmachine kernel: leaving scsi_dispatch_cmnd()
Jul 31 10:46:13 pldmachine kernel: sd_init_command: disk=3Dsda, block=3D=
82263, count=3D32
Jul 31 10:46:13 pldmachine kernel: sda : block=3D82263
Jul 31 10:46:13 pldmachine kernel: sda : reading 32/32 512 byte blocks.
Jul 31 10:46:13 pldmachine kernel: scsi_add_timer: scmd: ffff81012eead8=
40, time: 7500, (ffffffff880033e0)
Jul 31 10:46:13 pldmachine kernel: sd 0:2:0:0: send 0xffff81012eead840 =
                 sd 0:2:0:0:
Jul 31 10:46:13 pldmachine kernel: command: cdb[0]=3D0x28: 28 00 00 01 =
41 57 00 00 20 00
Jul 31 10:46:13 pldmachine kernel: buffer =3D 0xffff8101bd1cd680, buffl=
en =3D 16384, done =3D 0xffffffff8802fb90, queuecommand 0xffffffff88025=
040
Jul 31 10:46:13 pldmachine kernel: leaving scsi_dispatch_cmnd()
Jul 31 10:46:13 pldmachine kernel: sd_init_command: disk=3Dsda, block=3D=
6318495, count=3D64
Jul 31 10:46:13 pldmachine kernel: sda : block=3D6318495
Jul 31 10:46:13 pldmachine kernel: sda : reading 64/64 512 byte blocks.
Jul 31 10:46:13 pldmachine kernel: scsi_add_timer: scmd: ffff8101beb892=
c0, time: 7500, (ffffffff880033e0)
Jul 31 10:46:13 pldmachine kernel: sd 0:2:0:0: send 0xffff8101beb892c0 =
                 sd 0:2:0:0:
Jul 31 10:46:13 pldmachine kernel: command: cdb[0]=3D0x28: 28 00 00 60 =
69 9f 00 00 40 00
Jul 31 10:46:13 pldmachine kernel: buffer =3D 0xffff8101b9a35ac0, buffl=
en =3D 32768, done =3D 0xffffffff8802fb90, queuecommand 0xffffffff88025=
040
Jul 31 10:46:13 pldmachine kernel: leaving scsi_dispatch_cmnd()
Jul 31 10:46:13 pldmachine kernel: sd_init_command: disk=3Dsda, block=3D=
2635927, count=3D16
Jul 31 10:46:13 pldmachine kernel: sda : block=3D2635927
Jul 31 10:46:13 pldmachine kernel: sda : reading 16/16 512 byte blocks.
Jul 31 10:46:13 pldmachine kernel: scsi_add_timer: scmd: ffff810133a304=
40, time: 7500, (ffffffff880033e0)
Jul 31 10:46:13 pldmachine kernel: sd 0:2:0:0: send 0xffff810133a30440 =
                 sd 0:2:0:0:
Jul 31 10:46:13 pldmachine kernel: command: cdb[0]=3D0x28: 28 00 00 28 =
38 97 00 00 10 00
Jul 31 10:46:13 pldmachine kernel: buffer =3D 0xffff8101304a0d80, buffl=
en =3D 8192, done =3D 0xffffffff8802fb90, queuecommand 0xffffffff880250=
40
Jul 31 10:46:13 pldmachine kernel: leaving scsi_dispatch_cmnd()
Jul 31 10:46:13 pldmachine kernel: sd_init_command: disk=3Dsda, block=3D=
10005421, count=3D64
Jul 31 10:46:13 pldmachine kernel: sda : block=3D10005421
Jul 31 10:46:13 pldmachine kernel: sda : writing 64/64 512 byte blocks.
Jul 31 10:46:13 pldmachine kernel: scsi_add_timer: scmd: ffff8101b7a298=
c0, time: 7500, (ffffffff880033e0)
Jul 31 10:46:13 pldmachine kernel: sd 0:2:0:0: send 0xffff8101b7a298c0 =
                 sd 0:2:0:0:
Jul 31 10:46:13 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 00 98 =
ab ad 00 00 40 00
Jul 31 10:46:13 pldmachine kernel: buffer =3D 0xffff8101304a0880, buffl=
en =3D 32768, done =3D 0xffffffff8802fb90, queuecommand 0xffffffff88025=
040
Jul 31 10:46:13 pldmachine kernel: leaving scsi_dispatch_cmnd()
Jul 31 10:46:14 pldmachine kernel: sd_init_command: disk=3Dsda, block=3D=
2644767, count=3D48
Jul 31 10:46:14 pldmachine kernel: sda : block=3D2644767
Jul 31 10:46:14 pldmachine kernel: sda : reading 48/48 512 byte blocks.
Jul 31 10:46:14 pldmachine kernel: scsi_add_timer: scmd: ffff81012a0ac0=
c0, time: 7500, (ffffffff880033e0)
Jul 31 10:46:14 pldmachine kernel: sd 0:2:0:0: send 0xffff81012a0ac0c0 =
                 sd 0:2:0:0:
Jul 31 10:46:14 pldmachine kernel: command: cdb[0]=3D0x28: 28 00 00 28 =
5b 1f 00 00 30 00
Jul 31 10:46:14 pldmachine kernel: buffer =3D 0xffff81012ed563c0, buffl=
en =3D 24576, done =3D 0xffffffff8802fb90, queuecommand 0xffffffff88025=
040
Jul 31 10:46:14 pldmachine kernel: leaving scsi_dispatch_cmnd()
Jul 31 10:46:14 pldmachine kernel: sd_init_command: disk=3Dsda, block=3D=
10005485, count=3D64
Jul 31 10:46:14 pldmachine kernel: sda : block=3D10005485
Jul 31 10:46:14 pldmachine kernel: sda : writing 64/64 512 byte blocks.
Jul 31 10:46:14 pldmachine kernel: scsi_add_timer: scmd: ffff8101b7a293=
80, time: 7500, (ffffffff880033e0)
Jul 31 10:46:14 pldmachine kernel: sd 0:2:0:0: send 0xffff8101b7a29380 =
                 sd 0:2:0:0:
Jul 31 10:46:14 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 00 98 =
ab ed 00 00 40 00
Jul 31 10:46:14 pldmachine kernel: buffer =3D 0xffff81012aab2e80, buffl=
en =3D 32768, done =3D 0xffffffff8802fb90, queuecommand 0xffffffff88025=
040
Jul 31 10:46:14 pldmachine kernel: leaving scsi_dispatch_cmnd()
Jul 31 10:46:43 pldmachine kernel: sd 0:2:0:0: done 0xffff810129d14dc0 =
TIMEOUT        0 sd 0:2:0:0:
Jul 31 10:46:43 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 00 98 =
ab 2d 00 00 40 00
Jul 31 10:46:43 pldmachine kernel: scsi host busy 21 failed 0
Jul 31 10:46:43 pldmachine kernel: sd 0:2:0:0: done 0xffff81012fcdc840 =
TIMEOUT        0 sd 0:2:0:0:
Jul 31 10:46:43 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 01 0c =
58 f7 00 00 08 00
Jul 31 10:46:43 pldmachine kernel: scsi host busy 21 failed 1
Jul 31 10:46:43 pldmachine kernel: sd 0:2:0:0: done 0xffff810129d14880 =
TIMEOUT        0 sd 0:2:0:0:
Jul 31 10:46:43 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 00 14 =
fa f7 00 00 78 00
Jul 31 10:46:43 pldmachine kernel: scsi host busy 21 failed 2
Jul 31 10:46:43 pldmachine kernel: sd 0:2:0:0: done 0xffff810129d14500 =
TIMEOUT        0 sd 0:2:0:0:
Jul 31 10:46:43 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 00 14 =
fb 6f 00 00 40 00
Jul 31 10:46:43 pldmachine kernel: scsi host busy 21 failed 3
Jul 31 10:46:43 pldmachine kernel: sd 0:2:0:0: done 0xffff81012593c440 =
TIMEOUT        0 sd 0:2:0:0:
Jul 31 10:46:43 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 00 14 =
fb af 00 00 50 00
Jul 31 10:46:43 pldmachine kernel: scsi host busy 21 failed 4
Jul 31 10:46:43 pldmachine kernel: sd 0:2:0:0: done 0xffff810129d14a40 =
TIMEOUT        0 sd 0:2:0:0:
Jul 31 10:46:43 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 00 29 =
19 2f 00 00 70 00
Jul 31 10:46:43 pldmachine kernel: scsi host busy 21 failed 5
Jul 31 10:46:43 pldmachine kernel: sd 0:2:0:0: done 0xffff81012fcdca00 =
TIMEOUT        0 sd 0:2:0:0:
Jul 31 10:46:43 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 00 29 =
19 9f 00 00 78 00
Jul 31 10:46:43 pldmachine kernel: scsi host busy 21 failed 6
Jul 31 10:46:43 pldmachine kernel: sd 0:2:0:0: done 0xffff81012fcdc300 =
TIMEOUT        0 sd 0:2:0:0:
Jul 31 10:46:43 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 00 29 =
1a 17 00 00 38 00
Jul 31 10:46:43 pldmachine kernel: scsi host busy 21 failed 7
Jul 31 10:46:43 pldmachine kernel: sd 0:2:0:0: done 0xffff81012593c0c0 =
TIMEOUT        0 sd 0:2:0:0:
Jul 31 10:46:43 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 00 4d =
39 df 00 00 10 00
Jul 31 10:46:43 pldmachine kernel: scsi host busy 21 failed 8
Jul 31 10:46:43 pldmachine kernel: sd 0:2:0:0: done 0xffff81012fcdcd80 =
TIMEOUT        0 sd 0:2:0:0:
Jul 31 10:46:43 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 00 50 =
7f 5f 00 00 68 00
Jul 31 10:46:43 pldmachine kernel: scsi host busy 21 failed 9
Jul 31 10:46:43 pldmachine kernel: sd 0:2:0:0: done 0xffff810132722140 =
TIMEOUT        0 sd 0:2:0:0:
Jul 31 10:46:43 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 00 50 =
7f c7 00 00 80 00
Jul 31 10:46:43 pldmachine kernel: scsi host busy 21 failed 10
Jul 31 10:46:43 pldmachine kernel: sd 0:2:0:0: done 0xffff81012fcdcbc0 =
TIMEOUT        0 sd 0:2:0:0:
Jul 31 10:46:43 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 00 50 =
80 47 00 00 68 00
Jul 31 10:46:43 pldmachine kernel: scsi host busy 21 failed 11
Jul 31 10:46:43 pldmachine kernel: sd 0:2:0:0: done 0xffff8101b592d500 =
TIMEOUT        0 sd 0:2:0:0:
Jul 31 10:46:43 pldmachine kernel: command: cdb[0]=3D0x28: 28 00 00 73 =
a6 97 00 00 10 00
Jul 31 10:46:43 pldmachine kernel: scsi host busy 21 failed 12
Jul 31 10:46:43 pldmachine kernel: sd 0:2:0:0: done 0xffff81012eead300 =
TIMEOUT        0 sd 0:2:0:0:
Jul 31 10:46:43 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 00 98 =
ab 6d 00 00 40 00
Jul 31 10:46:43 pldmachine kernel: scsi host busy 21 failed 13
Jul 31 10:46:43 pldmachine kernel: sd 0:2:0:0: done 0xffff81012eead140 =
TIMEOUT        0 sd 0:2:0:0:
Jul 31 10:46:43 pldmachine kernel: command: cdb[0]=3D0x28: 28 00 00 4d =
96 87 00 00 40 00
Jul 31 10:46:43 pldmachine kernel: scsi host busy 21 failed 14
Jul 31 10:46:43 pldmachine kernel: sd 0:2:0:0: done 0xffff81012eead840 =
TIMEOUT        0 sd 0:2:0:0:
Jul 31 10:46:43 pldmachine kernel: command: cdb[0]=3D0x28: 28 00 00 01 =
41 57 00 00 20 00
Jul 31 10:46:43 pldmachine kernel: scsi host busy 21 failed 15
Jul 31 10:46:43 pldmachine kernel: sd 0:2:0:0: done 0xffff8101beb892c0 =
TIMEOUT        0 sd 0:2:0:0:
Jul 31 10:46:43 pldmachine kernel: command: cdb[0]=3D0x28: 28 00 00 60 =
69 9f 00 00 40 00
Jul 31 10:46:43 pldmachine kernel: scsi host busy 21 failed 16
Jul 31 10:46:43 pldmachine kernel: sd 0:2:0:0: done 0xffff810133a30440 =
TIMEOUT        0 sd 0:2:0:0:
Jul 31 10:46:43 pldmachine kernel: command: cdb[0]=3D0x28: 28 00 00 28 =
38 97 00 00 10 00
Jul 31 10:46:43 pldmachine kernel: scsi host busy 21 failed 17
Jul 31 10:46:43 pldmachine kernel: sd 0:2:0:0: done 0xffff8101b7a298c0 =
TIMEOUT        0 sd 0:2:0:0:
Jul 31 10:46:43 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 00 98 =
ab ad 00 00 40 00
Jul 31 10:46:43 pldmachine kernel: scsi host busy 21 failed 18
Jul 31 10:46:44 pldmachine kernel: sd 0:2:0:0: done 0xffff81012a0ac0c0 =
TIMEOUT        0 sd 0:2:0:0:
Jul 31 10:46:44 pldmachine kernel: command: cdb[0]=3D0x28: 28 00 00 28 =
5b 1f 00 00 30 00
Jul 31 10:46:44 pldmachine kernel: scsi host busy 21 failed 19
Jul 31 10:46:44 pldmachine kernel: sd 0:2:0:0: done 0xffff8101b7a29380 =
TIMEOUT        0 sd 0:2:0:0:
Jul 31 10:46:44 pldmachine kernel: command: cdb[0]=3D0x2a: 2a 00 00 98 =
ab ed 00 00 40 00
Jul 31 10:46:44 pldmachine kernel: scsi host busy 21 failed 20
Jul 31 10:46:44 pldmachine kernel: Waking error handler thread
Jul 31 10:46:44 pldmachine kernel: Error handler scsi_eh_0 waking up
Jul 31 10:46:44 pldmachine kernel: sd 0:2:0:0: scsi_eh_prt_fail_stats: =
cmds failed: 0, cancel: 21
Jul 31 10:46:44 pldmachine kernel: Total of 21 commands on 1 devices re=
quire eh work
Jul 31 10:46:44 pldmachine kernel: scsi_eh_0: aborting cmd:0xffff810129=
d14dc0
Jul 31 10:46:44 pldmachine kernel: megaraid: aborting-24395 cmd=3D2a <c=
=3D2 t=3D0 l=3D0>
Jul 31 10:46:44 pldmachine kernel: megaraid abort: 24395:29[255:0], fw =
owner
Jul 31 10:46:44 pldmachine kernel: scsi_eh_0: aborting cmd failed:0xfff=
f810129d14dc0
Jul 31 10:46:44 pldmachine kernel: scsi_eh_0: aborting cmd:0xffff81012f=
cdc840
Jul 31 10:46:44 pldmachine kernel: megaraid: aborting-24399 cmd=3D2a <c=
=3D2 t=3D0 l=3D0>
Jul 31 10:46:44 pldmachine kernel: megaraid abort: 24399:50[255:0], fw =
owner
Jul 31 10:46:44 pldmachine kernel: scsi_eh_0: aborting cmd failed:0xfff=
f81012fcdc840
Jul 31 10:46:44 pldmachine kernel: scsi_eh_0: aborting cmd:0xffff810129=
d14880
Jul 31 10:46:44 pldmachine kernel: megaraid: aborting-24404 cmd=3D2a <c=
=3D2 t=3D0 l=3D0>
Jul 31 10:46:44 pldmachine kernel: megaraid abort: 24404:55[255:0], fw =
owner
Jul 31 10:46:44 pldmachine kernel: scsi_eh_0: aborting cmd failed:0xfff=
f810129d14880
Jul 31 10:46:44 pldmachine kernel: scsi_eh_0: aborting cmd:0xffff810129=
d14500
Jul 31 10:46:44 pldmachine kernel: megaraid: aborting-24405 cmd=3D2a <c=
=3D2 t=3D0 l=3D0>
Jul 31 10:46:44 pldmachine kernel: megaraid abort: 24405:25[255:0], fw =
owner
Jul 31 10:46:44 pldmachine kernel: scsi_eh_0: aborting cmd failed:0xfff=
f810129d14500
Jul 31 10:46:44 pldmachine kernel: scsi_eh_0: aborting cmd:0xffff810125=
93c440
Jul 31 10:46:44 pldmachine kernel: megaraid: aborting-24406 cmd=3D2a <c=
=3D2 t=3D0 l=3D0>
Jul 31 10:46:44 pldmachine kernel: megaraid abort: 24406:30[255:0], fw =
owner
Jul 31 10:46:44 pldmachine kernel: scsi_eh_0: aborting cmd failed:0xfff=
f81012593c440
Jul 31 10:46:44 pldmachine kernel: scsi_eh_0: aborting cmd:0xffff810129=
d14a40
Jul 31 10:46:44 pldmachine kernel: megaraid: aborting-24408 cmd=3D2a <c=
=3D2 t=3D0 l=3D0>
Jul 31 10:46:44 pldmachine kernel: megaraid abort: 24408:26[255:0], fw =
owner
Jul 31 10:46:44 pldmachine kernel: scsi_eh_0: aborting cmd failed:0xfff=
f810129d14a40
Jul 31 10:46:44 pldmachine kernel: scsi_eh_0: aborting cmd:0xffff81012f=
cdca00
Jul 31 10:46:44 pldmachine kernel: megaraid: aborting-24409 cmd=3D2a <c=
=3D2 t=3D0 l=3D0>
Jul 31 10:46:44 pldmachine kernel: megaraid abort: 24409:48[255:0], fw =
owner
Jul 31 10:46:44 pldmachine kernel: scsi_eh_0: aborting cmd failed:0xfff=
f81012fcdca00
Jul 31 10:46:44 pldmachine kernel: scsi_eh_0: aborting cmd:0xffff81012f=
cdc300
Jul 31 10:46:44 pldmachine kernel: megaraid: aborting-24410 cmd=3D2a <c=
=3D2 t=3D0 l=3D0>
Jul 31 10:46:44 pldmachine kernel: megaraid abort: 24410:37[255:0], fw =
owner
Jul 31 10:46:44 pldmachine kernel: scsi_eh_0: aborting cmd failed:0xfff=
f81012fcdc300
Jul 31 10:46:44 pldmachine kernel: scsi_eh_0: aborting cmd:0xffff810125=
93c0c0
Jul 31 10:46:44 pldmachine kernel: megaraid: aborting-24412 cmd=3D2a <c=
=3D2 t=3D0 l=3D0>
Jul 31 10:46:44 pldmachine kernel: megaraid abort: 24412:7[255:0], fw o=
wner
Jul 31 10:46:44 pldmachine kernel: scsi_eh_0: aborting cmd failed:0xfff=
f81012593c0c0
Jul 31 10:46:44 pldmachine kernel: scsi_eh_0: aborting cmd:0xffff81012f=
cdcd80
Jul 31 10:46:44 pldmachine kernel: megaraid: aborting-24413 cmd=3D2a <c=
=3D2 t=3D0 l=3D0>
Jul 31 10:46:44 pldmachine kernel: megaraid abort: 24413:31[255:0], fw =
owner
Jul 31 10:46:44 pldmachine kernel: scsi_eh_0: aborting cmd failed:0xfff=
f81012fcdcd80
Jul 31 10:46:44 pldmachine kernel: scsi_eh_0: aborting cmd:0xffff810132=
722140
Jul 31 10:46:44 pldmachine kernel: megaraid: aborting-24414 cmd=3D2a <c=
=3D2 t=3D0 l=3D0>
Jul 31 10:46:44 pldmachine kernel: megaraid abort: 24414:4[255:0], fw o=
wner
Jul 31 10:46:44 pldmachine kernel: scsi_eh_0: aborting cmd failed:0xfff=
f810132722140
Jul 31 10:46:44 pldmachine kernel: scsi_eh_0: aborting cmd:0xffff81012f=
cdcbc0
Jul 31 10:46:44 pldmachine kernel: megaraid: aborting-24415 cmd=3D2a <c=
=3D2 t=3D0 l=3D0>
Jul 31 10:46:44 pldmachine kernel: megaraid abort: 24415:52[255:0], fw =
owner
Jul 31 10:46:44 pldmachine kernel: scsi_eh_0: aborting cmd failed:0xfff=
f81012fcdcbc0
Jul 31 10:46:44 pldmachine kernel: scsi_eh_0: aborting cmd:0xffff8101b5=
92d500
Jul 31 10:46:44 pldmachine kernel: megaraid: aborting-24416 cmd=3D28 <c=
=3D2 t=3D0 l=3D0>
Jul 31 10:46:44 pldmachine kernel: megaraid abort: 24416:24[255:0], fw =
owner
Jul 31 10:46:44 pldmachine kernel: scsi_eh_0: aborting cmd failed:0xfff=
f8101b592d500
Jul 31 10:46:44 pldmachine kernel: scsi_eh_0: aborting cmd:0xffff81012e=
ead300
Jul 31 10:46:44 pldmachine kernel: megaraid: aborting-24417 cmd=3D2a <c=
=3D2 t=3D0 l=3D0>
Jul 31 10:46:44 pldmachine kernel: megaraid abort: 24417[255:0], driver=
 owner
Jul 31 10:46:44 pldmachine kernel: scsi_delete_timer: scmd: ffff81012ee=
ad300, rtn: 0
Jul 31 10:46:44 pldmachine kernel: sd 0:2:0:0: send 0xffff81012eead300 =
                 sd 0:2:0:0:
Jul 31 10:46:44 pldmachine kernel: command: cdb[0]=3D0x0: 00 00 00 00 0=
0 00
Jul 31 10:46:44 pldmachine kernel: buffer =3D 0xffff8101bd1cd280, buffl=
en =3D 32768, done =3D 0xffffffff8802fb90, queuecommand 0xffffffff88025=
040
Jul 31 10:46:44 pldmachine kernel: scsi_eh_done scmd: ffff81012eead300 =
result: 0
Jul 31 10:46:44 pldmachine kernel: sd 0:2:0:0: done 0xffff81012eead300 =
SUCCESS        0 sd 0:2:0:0:
Jul 31 10:46:44 pldmachine kernel: command: cdb[0]=3D0x0: 00 00 00 00 0=
0 00
Jul 31 10:46:44 pldmachine kernel: scsi host busy 21 failed 21
Jul 31 10:46:44 pldmachine kernel: scsi_send_eh_cmnd: scmd: ffff81012ee=
ad300, timeleft: 2500
Jul 31 10:46:44 pldmachine kernel: scsi_send_eh_cmnd: scsi_eh_completed=
_normally 2002
Jul 31 10:46:44 pldmachine kernel: scsi_eh_tur: scmd ffff81012eead300 r=
tn 2002
Jul 31 10:46:44 pldmachine kernel: scsi_eh_0: aborting cmd:0xffff81012e=
ead140
Jul 31 10:46:44 pldmachine kernel: megaraid: aborting-24418 cmd=3D28 <c=
=3D2 t=3D0 l=3D0>
Jul 31 10:46:44 pldmachine kernel: megaraid abort: 24418[255:0], driver=
 owner
Jul 31 10:46:44 pldmachine kernel: scsi_delete_timer: scmd: ffff81012ee=
ad140, rtn: 0
Jul 31 10:46:44 pldmachine kernel: sd 0:2:0:0: send 0xffff81012eead140 =
                 sd 0:2:0:0:
Jul 31 10:46:44 pldmachine kernel: command: cdb[0]=3D0x0: 00 00 00 00 0=
0 00
Jul 31 10:46:44 pldmachine kernel: buffer =3D 0xffff8101bd1cd880, buffl=
en =3D 32768, done =3D 0xffffffff8802fb90, queuecommand 0xffffffff88025=
040
Jul 31 10:46:44 pldmachine kernel: scsi_eh_done scmd: ffff81012eead140 =
result: 0
Jul 31 10:46:44 pldmachine kernel: sd 0:2:0:0: done 0xffff81012eead140 =
SUCCESS        0 sd 0:2:0:0:
Jul 31 10:46:44 pldmachine kernel: command: cdb[0]=3D0x0: 00 00 00 00 0=
0 00
Jul 31 10:46:44 pldmachine kernel: scsi host busy 21 failed 20
Jul 31 10:46:44 pldmachine kernel: scsi_send_eh_cmnd: scmd: ffff81012ee=
ad140, timeleft: 2500
Jul 31 10:46:44 pldmachine kernel: scsi_send_eh_cmnd: scsi_eh_completed=
_normally 2002
Jul 31 10:46:44 pldmachine kernel: scsi_eh_tur: scmd ffff81012eead140 r=
tn 2002
Jul 31 10:46:44 pldmachine kernel: scsi_eh_0: aborting cmd:0xffff81012e=
ead840
Jul 31 10:46:44 pldmachine kernel: megaraid: aborting-24419 cmd=3D28 <c=
=3D2 t=3D0 l=3D0>
Jul 31 10:46:44 pldmachine kernel: megaraid abort: 24419[255:0], driver=
 owner
Jul 31 10:46:44 pldmachine kernel: scsi_delete_timer: scmd: ffff81012ee=
ad840, rtn: 0
Jul 31 10:46:44 pldmachine kernel: sd 0:2:0:0: send 0xffff81012eead840 =
                 sd 0:2:0:0:
Jul 31 10:46:44 pldmachine kernel: command: cdb[0]=3D0x0: 00 00 00 00 0=
0 00
Jul 31 10:46:44 pldmachine kernel: buffer =3D 0xffff8101bd1cd680, buffl=
en =3D 16384, done =3D 0xffffffff8802fb90, queuecommand 0xffffffff88025=
040
Jul 31 10:46:44 pldmachine kernel: scsi_eh_done scmd: ffff81012eead840 =
result: 0
Jul 31 10:46:44 pldmachine kernel: sd 0:2:0:0: done 0xffff81012eead840 =
SUCCESS        0 sd 0:2:0:0:
Jul 31 10:46:44 pldmachine kernel: command: cdb[0]=3D0x0: 00 00 00 00 0=
0 00
Jul 31 10:46:44 pldmachine kernel: scsi host busy 21 failed 19
Jul 31 10:46:44 pldmachine kernel: scsi_send_eh_cmnd: scmd: ffff81012ee=
ad840, timeleft: 2500
Jul 31 10:46:44 pldmachine kernel: scsi_send_eh_cmnd: scsi_eh_completed=
_normally 2002
Jul 31 10:46:44 pldmachine kernel: scsi_eh_tur: scmd ffff81012eead840 r=
tn 2002
Jul 31 10:46:44 pldmachine kernel: scsi_eh_0: aborting cmd:0xffff8101be=
b892c0
Jul 31 10:46:44 pldmachine kernel: megaraid: aborting-24420 cmd=3D28 <c=
=3D2 t=3D0 l=3D0>
Jul 31 10:46:44 pldmachine kernel: megaraid abort: 24420[255:0], driver=
 owner
Jul 31 10:46:44 pldmachine kernel: scsi_delete_timer: scmd: ffff8101beb=
892c0, rtn: 0
Jul 31 10:46:44 pldmachine kernel: sd 0:2:0:0: send 0xffff8101beb892c0 =
                 sd 0:2:0:0:
Jul 31 10:46:44 pldmachine kernel: command: cdb[0]=3D0x0: 00 00 00 00 0=
0 00
Jul 31 10:46:44 pldmachine kernel: buffer =3D 0xffff8101b9a35ac0, buffl=
en =3D 32768, done =3D 0xffffffff8802fb90, queuecommand 0xffffffff88025=
040
Jul 31 10:46:44 pldmachine kernel: scsi_eh_done scmd: ffff8101beb892c0 =
result: 0
Jul 31 10:46:44 pldmachine kernel: sd 0:2:0:0: done 0xffff8101beb892c0 =
SUCCESS        0 sd 0:2:0:0:
Jul 31 10:46:44 pldmachine kernel: command: cdb[0]=3D0x0: 00 00 00 00 0=
0 00
Jul 31 10:46:44 pldmachine kernel: scsi host busy 21 failed 18
Jul 31 10:46:44 pldmachine kernel: scsi_send_eh_cmnd: scmd: ffff8101beb=
892c0, timeleft: 2500
Jul 31 10:46:44 pldmachine kernel: scsi_send_eh_cmnd: scsi_eh_completed=
_normally 2002
Jul 31 10:46:44 pldmachine kernel: scsi_eh_tur: scmd ffff8101beb892c0 r=
tn 2002
Jul 31 10:46:44 pldmachine kernel: scsi_eh_0: aborting cmd:0xffff810133=
a30440
Jul 31 10:46:44 pldmachine kernel: megaraid: aborting-24421 cmd=3D28 <c=
=3D2 t=3D0 l=3D0>
Jul 31 10:46:44 pldmachine kernel: megaraid abort: 24421[255:0], driver=
 owner
Jul 31 10:46:44 pldmachine kernel: scsi_delete_timer: scmd: ffff810133a=
30440, rtn: 0
Jul 31 10:46:44 pldmachine kernel: sd 0:2:0:0: send 0xffff810133a30440 =
                 sd 0:2:0:0:
Jul 31 10:46:44 pldmachine kernel: command: cdb[0]=3D0x0: 00 00 00 00 0=
0 00
Jul 31 10:46:44 pldmachine kernel: buffer =3D 0xffff8101304a0d80, buffl=
en =3D 8192, done =3D 0xffffffff8802fb90, queuecommand 0xffffffff880250=
40
Jul 31 10:46:44 pldmachine kernel: scsi_eh_done scmd: ffff810133a30440 =
result: 0
Jul 31 10:46:44 pldmachine kernel: sd 0:2:0:0: done 0xffff810133a30440 =
SUCCESS        0 sd 0:2:0:0:
Jul 31 10:46:44 pldmachine kernel: command: cdb[0]=3D0x0: 00 00 00 00 0=
0 00
Jul 31 10:46:44 pldmachine kernel: scsi host busy 21 failed 17
Jul 31 10:46:44 pldmachine kernel: scsi_send_eh_cmnd: scmd: ffff810133a=
30440, timeleft: 2500
Jul 31 10:46:44 pldmachine kernel: scsi_send_eh_cmnd: scsi_eh_completed=
_normally 2002
Jul 31 10:46:44 pldmachine kernel: scsi_eh_tur: scmd ffff810133a30440 r=
tn 2002
Jul 31 10:46:44 pldmachine kernel: scsi_eh_0: aborting cmd:0xffff8101b7=
a298c0
Jul 31 10:46:44 pldmachine kernel: megaraid: aborting-24422 cmd=3D2a <c=
=3D2 t=3D0 l=3D0>
Jul 31 10:46:44 pldmachine kernel: megaraid abort: 24422[255:0], driver=
 owner
Jul 31 10:46:44 pldmachine kernel: scsi_delete_timer: scmd: ffff8101b7a=
298c0, rtn: 0
Jul 31 10:46:44 pldmachine kernel: sd 0:2:0:0: send 0xffff8101b7a298c0 =
                 sd 0:2:0:0:
Jul 31 10:46:44 pldmachine kernel: command: cdb[0]=3D0x0: 00 00 00 00 0=
0 00
Jul 31 10:46:44 pldmachine kernel: buffer =3D 0xffff8101304a0880, buffl=
en =3D 32768, done =3D 0xffffffff8802fb90, queuecommand 0xffffffff88025=
040
Jul 31 10:46:44 pldmachine kernel: scsi_eh_done scmd: ffff8101b7a298c0 =
result: 0
Jul 31 10:46:44 pldmachine kernel: sd 0:2:0:0: done 0xffff8101b7a298c0 =
SUCCESS        0 sd 0:2:0:0:
Jul 31 10:46:44 pldmachine kernel: command: cdb[0]=3D0x0: 00 00 00 00 0=
0 00
Jul 31 10:46:44 pldmachine kernel: scsi host busy 21 failed 16
Jul 31 10:46:44 pldmachine kernel: scsi_send_eh_cmnd: scmd: ffff8101b7a=
298c0, timeleft: 2500
Jul 31 10:46:44 pldmachine kernel: scsi_send_eh_cmnd: scsi_eh_completed=
_normally 2002
Jul 31 10:46:44 pldmachine kernel: scsi_eh_tur: scmd ffff8101b7a298c0 r=
tn 2002
Jul 31 10:46:44 pldmachine kernel: scsi_eh_0: aborting cmd:0xffff81012a=
0ac0c0
Jul 31 10:46:44 pldmachine kernel: megaraid: aborting-24423 cmd=3D28 <c=
=3D2 t=3D0 l=3D0>
Jul 31 10:46:44 pldmachine kernel: megaraid abort: 24423[255:0], driver=
 owner
Jul 31 10:46:44 pldmachine kernel: scsi_delete_timer: scmd: ffff81012a0=
ac0c0, rtn: 0
Jul 31 10:46:44 pldmachine kernel: sd 0:2:0:0: send 0xffff81012a0ac0c0 =
                 sd 0:2:0:0:
Jul 31 10:46:44 pldmachine kernel: command: cdb[0]=3D0x0: 00 00 00 00 0=
0 00
Jul 31 10:46:44 pldmachine kernel: buffer =3D 0xffff81012ed563c0, buffl=
en =3D 24576, done =3D 0xffffffff8802fb90, queuecommand 0xffffffff88025=
040
Jul 31 10:46:44 pldmachine kernel: scsi_eh_done scmd: ffff81012a0ac0c0 =
result: 0
Jul 31 10:46:44 pldmachine kernel: sd 0:2:0:0: done 0xffff81012a0ac0c0 =
SUCCESS        0 sd 0:2:0:0:
Jul 31 10:46:44 pldmachine kernel: command: cdb[0]=3D0x0: 00 00 00 00 0=
0 00
Jul 31 10:46:44 pldmachine kernel: scsi host busy 21 failed 15
Jul 31 10:46:44 pldmachine kernel: scsi_send_eh_cmnd: scmd: ffff81012a0=
ac0c0, timeleft: 2500
Jul 31 10:46:44 pldmachine kernel: scsi_send_eh_cmnd: scsi_eh_completed=
_normally 2002
Jul 31 10:46:44 pldmachine kernel: scsi_eh_tur: scmd ffff81012a0ac0c0 r=
tn 2002
Jul 31 10:46:44 pldmachine kernel: scsi_eh_0: aborting cmd:0xffff8101b7=
a29380
Jul 31 10:46:44 pldmachine kernel: megaraid: aborting-24424 cmd=3D2a <c=
=3D2 t=3D0 l=3D0>
Jul 31 10:46:44 pldmachine kernel: megaraid abort: 24424[255:0], driver=
 owner
Jul 31 10:46:44 pldmachine kernel: scsi_delete_timer: scmd: ffff8101b7a=
29380, rtn: 0
Jul 31 10:46:44 pldmachine kernel: sd 0:2:0:0: send 0xffff8101b7a29380 =
                 sd 0:2:0:0:
Jul 31 10:46:44 pldmachine kernel: command: cdb[0]=3D0x0: 00 00 00 00 0=
0 00
Jul 31 10:46:44 pldmachine kernel: buffer =3D 0xffff81012aab2e80, buffl=
en =3D 32768, done =3D 0xffffffff8802fb90, queuecommand 0xffffffff88025=
040
Jul 31 10:46:44 pldmachine kernel: scsi_eh_done scmd: ffff8101b7a29380 =
result: 0
Jul 31 10:46:44 pldmachine kernel: sd 0:2:0:0: done 0xffff8101b7a29380 =
SUCCESS        0 sd 0:2:0:0:
Jul 31 10:46:44 pldmachine kernel: command: cdb[0]=3D0x0: 00 00 00 00 0=
0 00
Jul 31 10:46:44 pldmachine kernel: scsi host busy 21 failed 14
Jul 31 10:46:44 pldmachine kernel: scsi_send_eh_cmnd: scmd: ffff8101b7a=
29380, timeleft: 2500
Jul 31 10:46:44 pldmachine kernel: scsi_send_eh_cmnd: scsi_eh_completed=
_normally 2002
Jul 31 10:46:44 pldmachine kernel: scsi_eh_tur: scmd ffff8101b7a29380 r=
tn 2002
Jul 31 10:46:44 pldmachine kernel: scsi_eh_0: Sending BDR sdev: 0xffff8=
1013fb27800
Jul 31 10:46:44 pldmachine kernel: megaraid: 13 outstanding commands. M=
ax wait 180 sec
Jul 31 10:46:44 pldmachine kernel: megaraid mbox: Wait for 13 commands =
to complete:180
Jul 31 10:46:49 pldmachine kernel: megaraid mbox: Wait for 13 commands =
to complete:175
Jul 31 10:46:54 pldmachine kernel: megaraid mbox: Wait for 13 commands =
to complete:170
Jul 31 10:46:59 pldmachine kernel: megaraid mbox: Wait for 13 commands =
to complete:165
Jul 31 10:47:04 pldmachine kernel: megaraid mbox: Wait for 13 commands =
to complete:160
Jul 31 10:47:09 pldmachine kernel: megaraid mbox: Wait for 13 commands =
to complete:155
Jul 31 10:47:14 pldmachine kernel: megaraid mbox: Wait for 13 commands =
to complete:150
Jul 31 10:47:19 pldmachine kernel: megaraid mbox: Wait for 13 commands =
to complete:145
Jul 31 10:47:24 pldmachine kernel: megaraid mbox: Wait for 13 commands =
to complete:140
Jul 31 10:47:29 pldmachine kernel: megaraid mbox: Wait for 13 commands =
to complete:135
Jul 31 10:47:34 pldmachine kernel: megaraid mbox: Wait for 13 commands =
to complete:130
Jul 31 10:47:39 pldmachine kernel: megaraid mbox: Wait for 13 commands =
to complete:125
Jul 31 10:47:44 pldmachine kernel: megaraid mbox: Wait for 13 commands =
to complete:120
Jul 31 10:47:49 pldmachine kernel: megaraid mbox: Wait for 13 commands =
to complete:115
Jul 31 10:47:54 pldmachine kernel: megaraid mbox: Wait for 13 commands =
to complete:110
Jul 31 10:47:59 pldmachine kernel: megaraid mbox: Wait for 13 commands =
to complete:105
Jul 31 10:48:04 pldmachine kernel: megaraid mbox: Wait for 13 commands =
to complete:100
Jul 31 10:48:08 pldmachine syslog-ng[2032]: STATS: dropped 0
Jul 31 10:48:09 pldmachine kernel: megaraid mbox: Wait for 13 commands =
to complete:95
Jul 31 10:48:14 pldmachine kernel: megaraid mbox: Wait for 13 commands =
to complete:90
Jul 31 10:48:19 pldmachine kernel: megaraid mbox: Wait for 13 commands =
to complete:85
Jul 31 10:48:24 pldmachine kernel: megaraid mbox: Wait for 13 commands =
to complete:80
Jul 31 10:48:29 pldmachine kernel: megaraid mbox: Wait for 13 commands =
to complete:75
Jul 31 10:48:34 pldmachine kernel: megaraid mbox: Wait for 13 commands =
to complete:70
Jul 31 10:48:39 pldmachine kernel: megaraid mbox: Wait for 13 commands =
to complete:65
Jul 31 10:48:44 pldmachine kernel: megaraid mbox: Wait for 13 commands =
to complete:60
Jul 31 10:48:49 pldmachine kernel: megaraid mbox: Wait for 13 commands =
to complete:55
Jul 31 10:48:54 pldmachine kernel: megaraid mbox: Wait for 13 commands =
to complete:50
Jul 31 10:48:59 pldmachine kernel: megaraid mbox: Wait for 13 commands =
to complete:45
Jul 31 10:49:04 pldmachine kernel: megaraid mbox: Wait for 13 commands =
to complete:40
Jul 31 10:49:09 pldmachine kernel: megaraid mbox: Wait for 13 commands =
to complete:35
Jul 31 10:49:14 pldmachine kernel: megaraid mbox: Wait for 13 commands =
to complete:30
Jul 31 10:49:19 pldmachine kernel: megaraid mbox: Wait for 13 commands =
to complete:25
Jul 31 10:49:24 pldmachine kernel: megaraid mbox: Wait for 13 commands =
to complete:20
Jul 31 10:49:29 pldmachine kernel: megaraid mbox: Wait for 13 commands =
to complete:15
Jul 31 10:49:34 pldmachine kernel: megaraid mbox: Wait for 13 commands =
to complete:10
Jul 31 10:49:39 pldmachine kernel: megaraid mbox: Wait for 13 commands =
to complete:5
tail: error reading `/var/log/syslog': Input/output error

=2E... catched from other session:

megaraid mbox: Wait for 11 commands to complete:5
megaraid mbox: Wait for 11 commands to complete:0
megaraid mbox: critical hardware error!
megaraid: hw error, cannot reset
megaraid: hw error, cannot reset
sd 0:2:0:0: scsi: Device offlined - not ready after error recovery
sd 0:2:0:0: scsi: Device offlined - not ready after error recovery
sd 0:2:0:0: scsi: Device offlined - not ready after error recovery
sd 0:2:0:0: scsi: Device offlined - not ready after error recovery
sd 0:2:0:0: scsi: Device offlined - not ready after error recovery
sd 0:2:0:0: scsi: Device offlined - not ready after error recovery
sd 0:2:0:0: scsi: Device offlined - not ready after error recovery
sd 0:2:0:0: scsi: Device offlined - not ready after error recovery
sd 0:2:0:0: scsi: Device offlined - not ready after error recovery
sd 0:2:0:0: scsi: Device offlined - not ready after error recovery
sd 0:2:0:0: scsi: Device offlined - not ready after error recovery
sd 0:2:0:0: SCSI error: return code =3D 0x6000000
end_request: I/O error, dev sda, sector 2593455
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: SCSI error: return code =3D 0x6000000
end_request: I/O error, dev sda, sector 6264671
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: SCSI error: return code =3D 0x6000000
end_request: I/O error, dev sda, sector 2593479
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: SCSI error: return code =3D 0x6000000
end_request: I/O error, dev sda, sector 3792559
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: SCSI error: return code =3D 0x6000000
end_request: I/O error, dev sda, sector 1262895
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: SCSI error: return code =3D 0x6000000
end_request: I/O error, dev sda, sector 2517199
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: SCSI error: return code =3D 0x6000000
end_request: I/O error, dev sda, sector 1263455
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: SCSI error: return code =3D 0x6000000
end_request: I/O error, dev sda, sector 1290103
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: SCSI error: return code =3D 0x6000000
end_request: I/O error, dev sda, sector 3827951
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: SCSI error: return code =3D 0x6000000
end_request: I/O error, dev sda, sector 6290399
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: SCSI error: return code =3D 0x6000000
end_request: I/O error, dev sda, sector 6290511
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: rejecting I/O to offline device
sd 0:2:0:0: rejecting I/O to offline device
Buffer I/O error on device sda1, logical block 324174
lost page write due to I/O error on sda1
Buffer I/O error on device sda1, logical block 324175
lost page write due to I/O error on sda1
Buffer I/O error on device sda1, logical block 324176
lost page write due to I/O error on sda1
Buffer I/O error on device sda1, logical block 324177
lost page write due to I/O error on sda1
Buffer I/O error on device sda1, logical block 324178
lost page write due to I/O error on sda1
Buffer I/O error on device sda1, logical block 324179
lost page write due to I/O error on sda1
Buffer I/O error on device sda1, logical block 161255
lost page write due to I/O error on sda1
Buffer I/O error on device sda1, logical block 161256
lost page write due to I/O error on sda1
Buffer I/O error on device sda1, logical block 161257
lost page write due to I/O error on sda1
Buffer I/O error on device sda1, logical block 161258
lost page write due to I/O error on sda1
Device sda1 - XFS write error in file system meta-data block 0x278af0 i=
n sda1
I/O error in filesystem ("sda1") meta-data dev sda1 block 0x98b33d     =
  ("xlog_iodone") error 5 buf count 32768
xfs_force_shutdown(sda1,0x2) called from line 959 of file fs/xfs/xfs_lo=
g.c.  Return address =3D 0xffffffff881b13d6
=46ilesystem "sda1": Log I/O Error Detected.  Shutting down filesystem:=
 sda1
Please umount the filesystem, and rectify the problem(s)
I/O error in filesystem ("sda1") meta-data dev sda1 block 0x98b37d     =
  ("xlog_iodone") error 5 buf count 32768
xfs_force_shutdown(sda1,0x2) called from line 959 of file fs/xfs/xfs_lo=
g.c.  Return address =3D 0xffffffff881b13d6
I/O error in filesystem ("sda1") meta-data dev sda1 block 0x98b3bd     =
  ("xlog_iodone") error 5 buf count 32768
xfs_force_shutdown(sda1,0x2) called from line 959 of file fs/xfs/xfs_lo=
g.c.  Return address =3D 0xffffffff881b13d6
I/O error in filesystem ("sda1") meta-data dev sda1 block 0x98b3fd     =
  ("xlog_iodone") error 5 buf count 32768
xfs_force_shutdown(sda1,0x2) called from line 959 of file fs/xfs/xfs_lo=
g.c.  Return address =3D 0xffffffff881b13d6
I/O error in filesystem ("sda1") meta-data dev sda1 block 0x98b43d     =
  ("xlog_iodone") error 5 buf count 18432
xfs_force_shutdown(sda1,0x2) called from line 959 of file fs/xfs/xfs_lo=
g.c.  Return address =3D 0xffffffff881b13d6
I/O error in filesystem ("sda1") meta-data dev sda1 block 0x98b461     =
  ("xlog_iodone") error 5 buf count 1536
xfs_force_shutdown(sda1,0x2) called from line 959 of file fs/xfs/xfs_lo=
g.c.  Return address =3D 0xffffffff881b13d6
sd 0:2:0:0: rejecting I/O to offline device


dmesg:

Bootdata ok (command line is BOOT_IMAGE=3Dpld-2.6.16.23 ro root=3D801 c=
onsole=3Dtty0 console=3DttyS0,115200n81 panic=3D60 nmi_watchdog=3D1 sel=
inux=3D0 elevator=3Dcfq)
Linux version 2.6.16.23-1smp (builder@serwus) (gcc version 3.3.6 (PLD L=
inux)) #1 SMP Sun Jul 2 13:21:11 UTC 2006
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009c800 (usable)
 BIOS-e820: 000000000009c800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000cc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007ff90000 (usable)
 BIOS-e820: 000000007ff90000 - 000000007ff99000 (ACPI data)
 BIOS-e820: 000000007ff99000 - 0000000080000000 (ACPI NVS)
 BIOS-e820: 0000000080000000 - 00000000bff80000 (usable)
 BIOS-e820: 00000000bff80000 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000e8000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec00400 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 00000001c0000000 (usable)
ACPI: RSDP (v000 PTLTD                                 ) @ 0x0000000000=
0f7040
ACPI: RSDT (v001 PTLTD    RSDT   0x06040000  LTP 0x00000000) @ 0x000000=
007ff953c7
ACPI: FADT (v001 NVIDIA CK8S     0x06040000 PTL_ 0x000f4240) @ 0x000000=
007ff98d36
ACPI: SRAT (v001 AMD    HAMMER   0x06040000 AMD  0x00000001) @ 0x000000=
007ff98daa
ACPI: SPCR (v001 PTLTD  $UCRTBL$ 0x06040000 PTL  0x00000001) @ 0x000000=
007ff98eba
ACPI: MCFG (v001 PTLTD    MCFG   0x06040000  LTP 0x00000000) @ 0x000000=
007ff98f0a
ACPI: MADT (v001 PTLTD  	 APIC   0x06040000  LTP 0x00000000) @ 0x000000=
007ff98f46
ACPI: BOOT (v001 PTLTD  $SBFTBL$ 0x06040000  LTP 0x00000001) @ 0x000000=
007ff98fd8
ACPI: DSDT (v001 NVIDIA      CK8 0x06040000 MSFT 0x0100000e) @ 0x000000=
0000000000
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: PXM 1 -> APIC 2 -> Node 1
SRAT: PXM 1 -> APIC 3 -> Node 1
SRAT: Node 0 PXM 0 0-a0000
SRAT: Node 0 PXM 0 0-c0000000
SRAT: Node 0 PXM 0 0-140000000
SRAT: Node 1 PXM 1 140000000-1c0000000
NUMA: Using 30 for the hash shift.
Bootmem setup node 0 0000000000000000-0000000140000000
Bootmem setup node 1 0000000140000000-00000001c0000000
On node 0 totalpages: 1029089
  DMA zone: 2713 pages, LIFO batch:0
  DMA32 zone: 767816 pages, LIFO batch:31
  Normal zone: 258560 pages, LIFO batch:31
  HighMem zone: 0 pages, LIFO batch:0
On node 1 totalpages: 517120
  DMA zone: 0 pages, LIFO batch:0
  DMA32 zone: 0 pages, LIFO batch:0
  Normal zone: 517120 pages, LIFO batch:31
  HighMem zone: 0 pages, LIFO batch:0
Nvidia board detected. Ignoring ACPI timer override.
ACPI: PM-Timer IO Port: 0x8008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 15:1 APIC version 16
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1 15:1 APIC version 16
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
Processor #2 15:1 APIC version 16
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
Processor #3 15:1 APIC version 16
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, version 17, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x05] address[0xdf400000] gsi_base[24])
IOAPIC[1]: apic_id 5, version 17, address 0xdf400000, GSI 24-27
ACPI: IOAPIC (id[0x06] address[0xdf401000] gsi_base[28])
IOAPIC[2]: apic_id 6, version 17, address 0xdf401000, GSI 28-31
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ9 used by override.
Setting APIC routing to physical flat
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at c2000000 (gap: c0000000:20000000)
Checking aperture...
CPU 0: aperture @ d8000000 size 64 MB
CPU 1: aperture @ d8000000 size 64 MB
SMP: Allowing 4 CPUs, 0 hotplug CPUs
Built 2 zonelists
Kernel command line: BOOT_IMAGE=3Dpld-2.6.16.23 ro root=3D801 console=3D=
tty0 console=3DttyS0,115200n81 panic=3D60 nmi_watchdog=3D1 selinux=3D0 =
elevator=3Dcfq
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 131072 bytes)
Disabling vsyscall due to use of PM timer
time.c: Using 3.579545 MHz WALL PM GTOD PM timer.
time.c: Detected 2009.271 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Memory: 6171940k/7340032k available (2162k kernel code, 118156k reserve=
d, 1146k data, 196k init)
Calibrating delay using timer specific routine.. 4026.62 BogoMIPS (lpj=3D=
8053251)
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0(2) -> Node 0 -> Core 0
activating NMI Watchdog ... done.
Using local APIC timer interrupts.
result 12557961
Detected 12.557 MHz APIC timer.
Booting processor 1/4 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4018.81 BogoMIPS (lpj=3D=
8037630)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1(2) -> Node 0 -> Core 1
Dual Core AMD Opteron(tm) Processor 270 stepping 02
CPU 1: Syncing TSC to CPU 0.
CPU 1: synchronized TSC with CPU 0 (last diff 0 cycles, maxerr 593 cycl=
es)
Booting processor 2/4 APIC 0x2
Initializing CPU#2
Calibrating delay using timer specific routine.. 4018.73 BogoMIPS (lpj=3D=
8037468)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 2(2) -> Node 1 -> Core 0
Dual Core AMD Opteron(tm) Processor 270 stepping 02
CPU 2: Syncing TSC to CPU 0.
CPU 2: synchronized TSC with CPU 0 (last diff -14 cycles, maxerr 1115 c=
ycles)
Booting processor 3/4 APIC 0x3
Initializing CPU#3
Calibrating delay using timer specific routine.. 4019.00 BogoMIPS (lpj=3D=
8038008)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 3(2) -> Node 1 -> Core 1
Dual Core AMD Opteron(tm) Processor 270 stepping 02
CPU 3: Syncing TSC to CPU 0.
CPU 3: synchronized TSC with CPU 0 (last diff -14 cycles, maxerr 1115 c=
ycles)
Brought up 4 CPUs
testing NMI watchdog ... CPU#0: NMI appears to be stuck (0->0)!
migration_cost=3D80,796
checking if image is initramfs...it isn't (no cpio magic); looks like a=
n initrd
=46reeing initrd memory: 866k freed
DMI present.
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
PCI: Using MMCONFIG at e0000000
ACPI: Subsystem revision 20060127
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
ACPI: Assume root bridge [\_SB_.PCI0] bus is 0
Boot video device is 0000:01:07.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.XVR0._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 16 17 18 19) *0
ACPI: PCI Interrupt Link [LNK2] (IRQs 16 17 18 19) *0
ACPI: PCI Interrupt Link [LNK3] (IRQs 16 17 18 19) *0
ACPI: PCI Interrupt Link [LNK4] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNK5] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LUS0] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LUS2] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LACI] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LMCI] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LPID] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LTID] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [LSI1] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Root Bridge [PCI2] (0000:08)
PCI: Probing PCI hardware (bus 08)
ACPI: Assume root bridge [\_SB_.PCI0] bus is 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI2.G0PA._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI2.G0PB._PRT]
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 15 devices
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=3Drouteirq".  If it helps, post=
 a report
TC classifier action (bugs to netdev@vger.kernel.org cc hadi@cyberus.ca=
)
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ d8000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
pnp: 00:08: ioport range 0x8000-0x807f could not be reserved
pnp: 00:08: ioport range 0x8080-0x80ff has been reserved
pnp: 00:08: ioport range 0x8400-0x847f has been reserved
pnp: 00:08: ioport range 0x8480-0x84ff has been reserved
pnp: 00:08: ioport range 0x8800-0x887f has been reserved
pnp: 00:08: ioport range 0x8880-0x88ff has been reserved
pnp: 00:08: ioport range 0x5000-0x503f has been reserved
pnp: 00:08: ioport range 0x5040-0x507f has been reserved
PCI: Bridge: 0000:00:09.0
  IO window: 2000-2fff
  MEM window: dd100000-deffffff
  PREFETCH window: c2000000-c20fffff
PCI: Bridge: 0000:02:00.0
  IO window: disabled.
  MEM window: df000000-df0fffff
  PREFETCH window: df300000-df3fffff
PCI: Bridge: 0000:02:00.2
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0e.0
  IO window: disabled.
  MEM window: df000000-df0fffff
  PREFETCH window: df300000-df3fffff
PCI: Setting latency timer of device 0000:00:09.0 to 64
PCI: Setting latency timer of device 0000:00:0e.0 to 64
PCI: Setting latency timer of device 0000:02:00.0 to 64
PCI: Setting latency timer of device 0000:02:00.2 to 64
PCI: Bridge: 0000:08:0a.0
  IO window: 3000-3fff
  MEM window: df500000-df5fffff
  PREFETCH window: c2100000-c21fffff
PCI: Bridge: 0000:08:0b.0
  IO window: disabled.
  MEM window: df600000-df6fffff
  PREFETCH window: disabled.
Simple Boot Flag at 0x36 set to 0x1
IA32 emulation $Id: sys_ia32.c,v 1.32 2002/03/24 13:02:28 ak Exp $
audit: initializing netlink socket (disabled)
audit(1154343188.852:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Initializing Cryptographic API
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: MSI quirk detected. pci_msi_quirk set.
PCI: MSI quirk detected. pci_msi_quirk set.
PCI: Setting latency timer of device 0000:00:0e.0 to 64
pcie_portdrv_probe->Dev[005d:10de] has invalid IRQ. Check vendor BIOS
assign_interrupt_mode Found MSI capability
PCI: MSI quirk detected. MSI disabled.
Allocate Port Service[0000:00:0e.0:pcie00]
Allocate Port Service[0000:00:0e.0:pcie03]
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.101 (c) Dave Jones
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enable=
d
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
00:02: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
00:03: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
mice: PS/2 mouse device common for all mice
NET: Registered protocol family 2
input: AT Translated Set 2 keyboard as /class/input/input0
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
ACPI wakeup devices:=20
PCI0 PS2M PS2K USB0 USB2 MAC0 P2P0 G0PA G0PB=20
ACPI: (supports S0 S1 S4 S5)
RAMDISK: Compressed image found at block 0
VFS: Mounted root (romfs filesystem) readonly.
SCSI subsystem initialized
megaraid cmm: 2.20.2.6 (Release Date: Mon Mar 7 00:01:03 EST 2005)
megaraid: 2.20.4.7 (Release Date: Mon Nov 14 12:27:22 EST 2005)
megaraid: probe new device 0x1000:0x0408:0x8086:0x0002: bus 3:slot 14:f=
unc 0
ACPI: PCI Interrupt Link [LNK1] enabled at IRQ 19
GSI 16 sharing vector 0xB1 and IRQ 16
ACPI: PCI Interrupt 0000:03:0e.0[A] -> Link [LNK1] -> GSI 19 (level, hi=
gh) -> IRQ 177
megaraid: fw version:[514P] bios version:[H431]
Losing some ticks... checking if CPU frequency changed.
scsi0 : LSI Logic MegaRAID driver
scsi[0]: scanning scsi channel 0 [Phy 0] for non-raid devices
scsi[0]: scanning scsi channel 1 [Phy 1] for non-raid devices
scsi[0]: scanning scsi channel 2 [virtual] for logical drives
  Vendor: MegaRAID  Model: LD 0 RAID5  280G  Rev: 514P
  Type:   Direct-Access                      ANSI SCSI revision: 02
SCSI device sda: 574218240 512-byte hdwr sectors (294000 MB)
sda: Write Protect is off
sda: Mode Sense: 00 00 00 00
sda: asking for cache data failed
sda: assuming drive cache: write through
SCSI device sda: 574218240 512-byte hdwr sectors (294000 MB)
sda: Write Protect is off
sda: Mode Sense: 00 00 00 00
sda: asking for cache data failed
sda: assuming drive cache: write through
 sda: sda1 sda2 sda3
sd 0:2:0:0: Attached scsi disk sda
SGI XFS with ACLs, security attributes, large block/inode numbers, no d=
ebug enabled
SGI XFS Quota Management subsystem
XFS mounting filesystem sda1
Starting XFS recovery on filesystem: sda1 (logdev: internal)
Ending XFS recovery on filesystem: sda1 (logdev: internal)
VFS: Mounted root (xfs filesystem) readonly.
Trying to move old root to /initrd ... okay
=46reeing unused kernel memory: 196k freed
Adding 6000268k swap on /dev/sda2.  Priority:-1 extents:1 across:600026=
8k
tg3.c:v3.49 (Feb 2, 2006)
GSI 17 sharing vector 0xB9 and IRQ 17
ACPI: PCI Interrupt 0000:0a:09.0[A] -> GSI 28 (level, low) -> IRQ 185
eth0: Tigon3 [partno(BCM95704) rev 2003 PHY(5704)] (PCIX:133MHz:64-bit)=
 10/100/1000BaseT Ethernet 00:e0:81:33:5e:74
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] Split[0] WireSpeed[1] TS=
Ocap[0]=20
eth0: dma_rwctrl[769f4000] dma_mask[64-bit]
GSI 18 sharing vector 0xC1 and IRQ 18
ACPI: PCI Interrupt 0000:0a:09.1[B] -> GSI 29 (level, low) -> IRQ 193
eth1: Tigon3 [partno(BCM95704) rev 2003 PHY(5704)] (PCIX:133MHz:64-bit)=
 10/100/1000BaseT Ethernet 00:e0:81:33:5e:75
eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] Split[0] WireSpeed[1] TS=
Ocap[1]=20
eth1: dma_rwctrl[769f4000] dma_mask[64-bit]
tg3: eth0: Link is up at 100 Mbps, full duplex.
tg3: eth0: Flow control is on for TX and on for RX.
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
IPv6 over IPv4 tunneling driver
eth0: no IPv6 routers present

[root@pldmachine ~]# zgrep SCSI /proc/config.gz
CONFIG_CISS_SCSI_TAPE=3Dy
CONFIG_BLK_DEV_IDESCSI=3Dm
# SCSI device support
CONFIG_SCSI=3Dm
CONFIG_SCSI_PROC_FS=3Dy
# SCSI support type (disk, tape, CD-ROM)
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
CONFIG_SCSI_MULTI_LUN=3Dy
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=3Dy
# SCSI Transport Attributes
CONFIG_SCSI_SPI_ATTRS=3Dm
CONFIG_SCSI_FC_ATTRS=3Dm
CONFIG_SCSI_ISCSI_ATTRS=3Dm
CONFIG_SCSI_SAS_ATTRS=3Dm
# SCSI low-level drivers
CONFIG_ISCSI_TCP=3Dm
CONFIG_SCSI_3W_9XXX=3Dm
CONFIG_SCSI_ACARD=3Dm
CONFIG_SCSI_AACRAID=3Dm
CONFIG_SCSI_AIC7XXX=3Dm
CONFIG_SCSI_AIC7XXX_OLD=3Dm
CONFIG_SCSI_AIC79XX=3Dm
CONFIG_SCSI_SATA=3Dm
CONFIG_SCSI_SATA_AHCI=3Dm
CONFIG_SCSI_SATA_SVW=3Dm
CONFIG_SCSI_ATA_PIIX=3Dm
CONFIG_SCSI_SATA_MV=3Dm
CONFIG_SCSI_SATA_NV=3Dm
CONFIG_SCSI_PDC_ADMA=3Dm
CONFIG_SCSI_SATA_QSTOR=3Dm
CONFIG_SCSI_SATA_PROMISE=3Dm
CONFIG_SCSI_SATA_SX4=3Dm
CONFIG_SCSI_SATA_SIL=3Dm
CONFIG_SCSI_SATA_SIL24=3Dm
CONFIG_SCSI_SATA_SIS=3Dm
CONFIG_SCSI_SATA_ULI=3Dm
CONFIG_SCSI_SATA_VIA=3Dm
CONFIG_SCSI_SATA_VITESSE=3Dm
CONFIG_SCSI_BUSLOGIC=3Dm
# CONFIG_SCSI_OMIT_FLASHPOINT is not set
CONFIG_SCSI_DMX3191D=3Dm
CONFIG_SCSI_EATA=3Dm
CONFIG_SCSI_EATA_TAGGED_QUEUE=3Dy
CONFIG_SCSI_EATA_LINKED_COMMANDS=3Dy
CONFIG_SCSI_EATA_MAX_TAGS=3D62
CONFIG_SCSI_FUTURE_DOMAIN=3Dm
CONFIG_SCSI_GDTH=3Dm
CONFIG_SCSI_IPS=3Dm
CONFIG_SCSI_INITIO=3Dm
CONFIG_SCSI_INIA100=3Dm
CONFIG_SCSI_PPA=3Dm
CONFIG_SCSI_IMM=3Dm
# CONFIG_SCSI_IZIP_EPP16 is not set
# CONFIG_SCSI_IZIP_SLOW_CTR is not set
CONFIG_SCSI_SYM53C8XX_2=3Dm
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=3D1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=3D16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=3D256
# CONFIG_SCSI_SYM53C8XX_IOMAPPED is not set
CONFIG_SCSI_IPR=3Dm
# CONFIG_SCSI_IPR_TRACE is not set
# CONFIG_SCSI_IPR_DUMP is not set
CONFIG_SCSI_QLOGIC_FC=3Dm
CONFIG_SCSI_QLOGIC_FC_FIRMWARE=3Dy
CONFIG_SCSI_QLOGIC_1280=3Dm
CONFIG_SCSI_QLA_FC=3Dm
CONFIG_SCSI_QLA2XXX_EMBEDDED_FIRMWARE=3Dy
CONFIG_SCSI_QLA21XX=3Dm
CONFIG_SCSI_QLA22XX=3Dm
CONFIG_SCSI_QLA2300=3Dm
CONFIG_SCSI_QLA2322=3Dm
CONFIG_SCSI_QLA6312=3Dm
CONFIG_SCSI_QLA24XX=3Dm
CONFIG_SCSI_LPFC=3Dm
CONFIG_SCSI_DC395x=3Dm
CONFIG_SCSI_DC390T=3Dm
CONFIG_SCSI_DEBUG=3Dm
# PCMCIA SCSI adapter support
CONFIG_I2O_SCSI=3Dm
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'

--=20
Arkadiusz Mi=B6kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

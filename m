From: Eddie Williams <eddie.williams@steeleye.com>
Subject: Re: qla2xxx - blocked FC remote port time out: removing target and
	saving binding
Date: Tue, 18 May 2010 16:31:14 -0400
Message-ID: <AANLkTiktBZGtpvlXn_3fwwABn5HOJqw36rTHJdUUvBvD@mail.gmail.com>
References: <AANLkTinG6IYyKvYtNMBUpJcYslBmm2_h8iEwp-JYwIdR@mail.gmail.com>
	 <alpine.OSX.2.00.1005180950070.38012@gmmac.local>
	 <AANLkTil7VuIJcINJEQp-RRP8TLxb4-u0rF9uUOJNuczP@mail.gmail.com>
	 <alpine.OSX.2.00.1005181158350.38012@gmmac.local>
	 <AANLkTiluJI-xFC_Z1c7Y3f_ansJEkU_lfO4d8A_2mRLq@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f193.google.com ([209.85.221.193]:56098 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756773Ab0ERUiv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2010 16:38:51 -0400
Received: by qyk31 with SMTP id 31so10190596qyk.25
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2010 13:38:50 -0700 (PDT)
In-Reply-To: <AANLkTiluJI-xFC_Z1c7Y3f_ansJEkU_lfO4d8A_2mRLq@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Giridhar Malavali <giridhar.malavali@qlogic.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

No help, if anything I now get the much slower recovery seen with the
SLES 11 kernel.  With the latest stable at least the recovery was
quick though not what I expected.  Would you expect a different result
with the latest?

QLogic Fibre Channel HBA Driver: 8.03.01-E10-debug
qla2xxx 0000:06:01.0: PCI INT A -> GSI 74 (level, low) -> IRQ 74
qla2xxx 0000:06:01.0: Found an ISP2312, irq 74, iobase 0xffffc90003712000
qla2xxx 0000:06:01.0: Configuring PCI space...
qla2xxx 0000:06:01.0: Configure NVRAM parameters...
qla2xxx 0000:06:01.0: Verifying loaded RISC code...
scsi(8): **** Load RISC code ****
qla2xxx 0000:06:01.0: firmware: requesting ql2300_fw.bin
scsi(8): Verifying Checksum of loaded RISC code.
scsi(8): Checksum OK, start firmware.
qla2xxx 0000:06:01.0: Allocated (412 KB) for firmware dump...
scsi(8): Issue init firmware.
DEBUG: detect hba 8 at address = ffff88002eb1f800
scsi8 : qla2xxx
scsi(8): qla2x00_loop_resync()
scsi(8): Asynchronous P2P MODE received.
scsi(8): Asynchronous LOOP UP (2 Gbps).
qla2xxx 0000:06:01.0: LOOP UP detected (2 Gbps).
scsi(8): Asynchronous PORT UPDATE.
scsi(8): Port database changed ffff 0006 0000.
scsi(8): F/W Ready - OK
scsi(8): fw_state=3 (3be6, 8800, ffff, 680) curr time=100500754.
scsi(8): Configure loop -- dpc flags =0x112e1
scsi(8): RSCN queue entry[0] = [00/000000].
scsi(8): device_resync: rscn overflow.
  ISP2312: PCI-X (100 MHz) @ 0000:06:01.0 hdma-, host#=8, fw=3.03.27 IPX
qla2xxx 0000:06:02.0: PCI INT A -> GSI 78 (level, low) -> IRQ 78
qla2xxx 0000:06:02.0: Found an ISP2312, irq 78, iobase 0xffffc900037a0000
qla2xxx 0000:06:02.0: Configuring PCI space...
qla2xxx 0000:06:02.0: Configure NVRAM parameters...
qla2xxx 0000:06:02.0: Verifying loaded RISC code...
scsi(9): **** Load RISC code ****
scsi(9): Verifying Checksum of loaded RISC code.
scsi(9): Checksum OK, start firmware.
qla2xxx 0000:06:02.0: Allocated (412 KB) for firmware dump...
scsi(9): Issue init firmware.
DEBUG: detect hba 9 at address = ffff88003cb4a800
scsi9 : qla2xxx
scsi(9): qla2x00_loop_resync()
qla2xxx 0000:06:02.0:
 QLogic Fibre Channel HBA Driver: 8.03.01-E10-debug
  QLogic QLA2340 -
  ISP2312: PCI-X (100 MHz) @ 0000:06:02.0 hdma-, host#=9, fw=3.03.27 IPX
scsi(8): RHBA failed, completion status (6).
scsi(8): RFT_ID exiting normally.
scsi(8): RFF_ID failed, rejected request:
 0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
--------------------------------------------------------------
01  00  00  00  fc  02  00  00  80  01  00  00  00  0b  00  00
scsi(8): Register FC-4 Features failed.
scsi(8): RNN_ID exiting normally.
scsi(8): RSNN_NN exiting normally.
scsi(8): GID_PT entry - nn 200000e08b07ae8f pn 210000e08b07ae8f portid=610913.
scsi(8): GID_PT entry - nn 200000e08b17a9df pn 210000e08b17a9df portid=610813.
scsi(8): GID_PT entry - nn 20000000c9294b5b pn 10000000c9294b5b portid=610413.
scsi(8): GID_PT entry - nn 50001fe150004d10 pn 50001fe150004d19 portid=610613.
scsi(8): GID_PT entry - nn 50001fe150004d10 pn 50001fe150004d1d portid=610513.
scsi(8): GID_PT entry - nn 500508b300902930 pn 500508b300902939 portid=610713.
scsi(8): device wrap (610713)
scsi(8): Trying Fabric Login w/loop id 0x0081 for port 610813.
qla2x00_mailbox_command(8): **** FAILED. mbx0=4007, mbx1=0, mbx2=813,
cmd=6f ****
qla2x00_login_fabric(8): failed=102 mb[0]=4007 mb[1]=0 mb[2]=813.
Fabric Login: port in use - next loop id=0x0000, port Id=610813.
scsi(8): Trying Fabric Login w/loop id 0x0000 for port 610813.
scsi(8): Trying Fabric Login w/loop id 0x0081 for port 610413.
qla2x00_mailbox_command(8): **** FAILED. mbx0=4007, mbx1=1, mbx2=413,
cmd=6f ****
qla2x00_login_fabric(8): failed=102 mb[0]=4007 mb[1]=1 mb[2]=413.
Fabric Login: port in use - next loop id=0x0001, port Id=610413.
scsi(8): Trying Fabric Login w/loop id 0x0001 for port 610413.
scsi(8): Trying Fabric Login w/loop id 0x0081 for port 610613.
scsi(8): Trying Fabric Login w/loop id 0x0082 for port 610513.
scsi 8:0:0:0: RAID              COMPAQ   HSV111 (C)COMPAQ 4004 PQ: 0 ANSI: 5



qla2xxx 0000:06:01.0: scsi(8:2:16): BUS RESET ISSUED.
scsi(8): Asynchronous P2P MODE received.
scsi(8): fcport-0 - port retry count: 15 remaining
scsi(8): fcport-1 - port retry count: 15 remaining
scsi(8): fcport-2 - port retry count: 15 remaining
scsi(8): qla2x00_reset_marker()
scsi(8): Asynchronous PORT UPDATE.
scsi(8): Port database changed ffff 0006 0000.
scsi(8): Asynchronous PORT UPDATE ignored 0001/0006/0000.
scsi(8): Asynchronous PORT UPDATE ignored 0001/0007/0000.
scsi(8): fcport-0 - port retry count: 14 remaining
scsi(8): fcport-1 - port retry count: 14 remaining
scsi(8): fcport-2 - port retry count: 14 remaining
scsi(8): qla2x00_loop_resync()
scsi(8): F/W Ready - OK
scsi(8): fw_state=3 (3be6, 8800, ffff, 680) curr time=1005045c7.
scsi(8): Configure loop -- dpc flags =0x1260
scsi(8): RSCN queue entry[0] = [00/000000].
scsi(8): device_resync: rscn overflow.
scsi(8): fcport-0 - port retry count: 13 remaining
scsi(8): fcport-1 - port retry count: 13 remaining
scsi(8): fcport-2 - port retry count: 13 remaining
scsi(8): fcport-0 - port retry count: 12 remaining
scsi(8): fcport-1 - port retry count: 12 remaining
scsi(8): fcport-2 - port retry count: 12 remaining
scsi(8): fcport-0 - port retry count: 11 remaining
scsi(8): fcport-1 - port retry count: 11 remaining
scsi(8): fcport-2 - port retry count: 11 remaining
scsi(8): fcport-0 - port retry count: 10 remaining
scsi(8): fcport-1 - port retry count: 10 remaining
scsi(8): fcport-2 - port retry count: 10 remaining
scsi(8): fcport-0 - port retry count: 9 remaining
scsi(8): fcport-1 - port retry count: 9 remaining
scsi(8): fcport-2 - port retry count: 9 remaining
scsi(8): fcport-2 - port retry count: 9 remaining
scsi(8): fcport-0 - port retry count: 8 remaining
scsi(8): fcport-1 - port retry count: 8 remaining
scsi(8): fcport-2 - port retry count: 8 remaining
scsi(8): fcport-0 - port retry count: 7 remaining
scsi(8): fcport-1 - port retry count: 7 remaining
scsi(8): fcport-2 - port retry count: 7 remaining
scsi(8): fcport-0 - port retry count: 6 remaining
scsi(8): fcport-1 - port retry count: 6 remaining
scsi(8): fcport-2 - port retry count: 6 remaining
scsi(8): fcport-0 - port retry count: 5 remaining
scsi(8): fcport-1 - port retry count: 5 remaining
scsi(8): fcport-2 - port retry count: 5 remaining
scsi(8): fcport-0 - port retry count: 4 remaining
scsi(8): fcport-1 - port retry count: 4 remaining
scsi(8): fcport-2 - port retry count: 4 remaining
scsi(8): fcport-0 - port retry count: 3 remaining
scsi(8): fcport-1 - port retry count: 3 remaining
scsi(8): fcport-2 - port retry count: 3 remaining
scsi(8): fcport-0 - port retry count: 2 remaining
scsi(8): fcport-1 - port retry count: 2 remaining
scsi(8): fcport-2 - port retry count: 2 remaining
scsi(8): fcport-0 - port retry count: 1 remaining
scsi(8): fcport-1 - port retry count: 1 remaining
scsi(8): fcport-2 - port retry count: 1 remaining
scsi(8): fcport-0 - port retry count: 0 remaining
scsi(8): fcport-1 - port retry count: 0 remaining
scsi(8): fcport-2 - port retry count: 0 remaining
scsi(8): RHBA failed, completion status (6).
qla2x00_mailbox_command(8): **** FAILED. mbx0=4005, mbx1=81, mbx2=0, cmd=71 ****
qla2x00_fabric_logout(8): failed=102 mbx1=81.
scsi(8): RFT_ID exiting normally.
qla2x00_mailbox_command(8): **** FAILED. mbx0=4005, mbx1=82,
mbx2=ffff, cmd=71 ****
qla2x00_fabric_logout(8): failed=102 mbx1=82.
 rport-8:0-4: blocked FC remote port time out: removing target and
saving binding
scsi(8): RFF_ID failed, rejected request:
 0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
--------------------------------------------------------------
01  00  00  00  fc  02  00  00  80  01  00  00  00  0b  00  00
scsi(8): Register FC-4 Features failed.
qla2x00_mailbox_command(8): **** FAILED. mbx0=4005, mbx1=83, mbx2=0, cmd=71 ****
qla2x00_fabric_logout(8): failed=102 mbx1=83.
scsi(8): RNN_ID exiting normally.
scsi(8): RSNN_NN exiting normally.
sd 8:0:2:1: [sdk] Synchronizing SCSI cache
scsi(8): GID_PT entry - nn 200000e08b07ae8f pn 210000e08b07ae8f portid=610913.
scsi(8): GID_PT entry - nn 200000e08b17a9df pn 210000e08b17a9df portid=610813.
scsi(8): GID_PT entry - nn 20000000c9294b5b pn 10000000c9294b5b portid=610413.
scsi(8): GID_PT entry - nn 50001fe150004d10 pn 50001fe150004d19 portid=610613.
scsi(8): GID_PT entry - nn 50001fe150004d10 pn 50001fe150004d1d portid=610513.
scsi(8): GID_PT entry - nn 500508b300902930 pn 500508b300902939 portid=610713.
qla2x00_mailbox_command(8): **** FAILED. mbx0=4005, mbx1=81,
mbx2=8800, cmd=71 ****
qla2x00_fabric_logout(8): failed=102 mbx1=81.
qla2x00_mailbox_command(8): **** FAILED. mbx0=4005, mbx1=82,
mbx2=8800, cmd=71 ****
qla2x00_fabric_logout(8): failed=102 mbx1=82.
qla2x00_mailbox_command(8): **** FAILED. mbx0=4005, mbx1=83,
mbx2=8800, cmd=71 ****
qla2x00_fabric_logout(8): failed=102 mbx1=83.
scsi(8): device wrap (610713)
scsi(8): Trying Fabric Login w/loop id 0x0000 for port 610813.
 rport-8:0-2: blocked FC remote port time out: removing target and
saving binding
 rport-8:0-3: blocked FC remote port time out: removing target and
saving binding
 rport-8:0-0: blocked FC remote port time out: removing rport
 rport-8:0-1: blocked FC remote port time out: removing rport

4 minute delay

qla2x00_mailbox_command(8): **** FAILED. mbx0=4006, mbx1=1000, mbx2=5,
cmd=17 ****
qla2x00_abort_target(8): failed=102.
qla2x00_loop_reset(8): bus_reset failed: target_reset=258 d_id=610613.
qla2x00_mailbox_command(8): **** FAILED. mbx0=4006, mbx1=1000, mbx2=5,
cmd=17 ****
qla2x00_abort_target(8): failed=102.
qla2x00_loop_reset(8): bus_reset failed: target_reset=258 d_id=610513.
qla2x00_mailbox_command(8): **** FAILED. mbx0=4006, mbx1=1000, mbx2=5,
cmd=17 ****
qla2x00_abort_target(8): failed=102.
qla2x00_loop_reset(8): bus_reset failed: target_reset=258 d_id=610713.
qla2xxx 0000:06:01.0: qla2xxx_eh_bus_reset: reset succeded

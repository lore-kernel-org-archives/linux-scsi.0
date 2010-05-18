From: Eddie Williams <eddie.williams@steeleye.com>
Subject: Re: qla2xxx - blocked FC remote port time out: removing target and
	saving binding
Date: Tue, 18 May 2010 14:09:05 -0400
Message-ID: <AANLkTil7VuIJcINJEQp-RRP8TLxb4-u0rF9uUOJNuczP@mail.gmail.com>
References: <AANLkTinG6IYyKvYtNMBUpJcYslBmm2_h8iEwp-JYwIdR@mail.gmail.com>
	 <alpine.OSX.2.00.1005180950070.38012@gmmac.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f171.google.com ([209.85.221.171]:40780 "EHLO
	mail-qy0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756642Ab0ERSJH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2010 14:09:07 -0400
Received: by qyk1 with SMTP id 1so9012504qyk.5
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2010 11:09:06 -0700 (PDT)
In-Reply-To: <alpine.OSX.2.00.1005180950070.38012@gmmac.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Giridhar Malavali <giridhar.malavali@qlogic.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Here is a snipit of the log with the timestamp cut off to avoid making
the mail so large.=A0 I can send you the full log directly if you like.

driver load:
QLogic Fibre Channel HBA Driver: 8.03.01-k10-debug
qla2xxx 0000:06:01.0: PCI INT A -> GSI 74 (level, low) -> IRQ 74
qla2xxx 0000:06:01.0: Found an ISP2312, irq 74, iobase 0xffffc90000dba0=
00
qla2xxx 0000:06:01.0: Configuring PCI space...
qla2xxx 0000:06:01.0: Configure NVRAM parameters...
qla2xxx 0000:06:01.0: Verifying loaded RISC code...
scsi(4): **** Load RISC code ****
qla2xxx 0000:06:01.0: firmware: requesting ql2300_fw.bin
scsi(4): Verifying Checksum of loaded RISC code.
scsi(4): Checksum OK, start firmware.
qla2xxx 0000:06:01.0: Allocated (412 KB) for firmware dump...
scsi(4): Issue init firmware.
DEBUG: detect hba 4 at address =3D ffff88003bf90000
scsi4 : qla2xxx
scsi(4): qla2x00_loop_resync()
scsi(4): Asynchronous P2P MODE received.
scsi(4): Asynchronous LOOP UP (2 Gbps).
qla2xxx 0000:06:01.0: LOOP UP detected (2 Gbps).
scsi(4): Asynchronous PORT UPDATE.
scsi(4): Port database changed ffff 0006 0000.
scsi(4): F/W Ready - OK
scsi(4): fw_state=3D3 (3bb1, 8800, ffff, e540) curr time=3D10031b431.
scsi(4): Configure loop -- dpc flags =3D0x112e1
scsi(4): RSCN queue entry[0] =3D [00/000000].
scsi(4): device_resync: rscn overflow.
qla2xxx 0000:06:01.0:
 QLogic Fibre Channel HBA Driver: 8.03.01-k10-debug
  QLogic QLA2340 -
  ISP2312: PCI-X (100 MHz) @ 0000:06:01.0 hdma-, host#=3D4, fw=3D3.03.2=
7 IPX
qla2xxx 0000:06:02.0: PCI INT A -> GSI 78 (level, low) -> IRQ 78
qla2xxx 0000:06:02.0: Found an ISP2312, irq 78, iobase 0xffffc900010e40=
00
qla2xxx 0000:06:02.0: Configuring PCI space...
qla2xxx 0000:06:02.0: Configure NVRAM parameters...
qla2xxx 0000:06:02.0: Verifying loaded RISC code...
scsi(5): **** Load RISC code ****
scsi(5): Verifying Checksum of loaded RISC code.
scsi(5): Checksum OK, start firmware.
qla2xxx 0000:06:02.0: Allocated (412 KB) for firmware dump...
scsi(5): Issue init firmware.
DEBUG: detect hba 5 at address =3D ffff88003b000000
scsi5 : qla2xxx
scsi(5): qla2x00_loop_resync()
qla2xxx 0000:06:02.0:
 QLogic Fibre Channel HBA Driver: 8.03.01-k10-debug
  QLogic QLA2340 -
  ISP2312: PCI-X (100 MHz) @ 0000:06:02.0 hdma-, host#=3D5, fw=3D3.03.2=
7 IPX
scsi(4): RHBA failed, completion status (6).
scsi(4): RFT_ID exiting normally.
scsi(4): RFF_ID failed, rejected request:
 0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
--------------------------------------------------------------
01  00  00  00  fc  02  00  00  80  01  00  00  00  0b  00  00
scsi(4): Register FC-4 Features failed.
scsi(4): RNN_ID exiting normally.
scsi(4): RSNN_NN exiting normally.
scsi(4): GID_PT entry - nn 200000e08b07ae8f pn 210000e08b07ae8f portid=3D=
610913.
scsi(4): GID_PT entry - nn 200000e08b17a9df pn 210000e08b17a9df portid=3D=
610813.
scsi(4): GID_PT entry - nn 20000000c9294b5b pn 10000000c9294b5b portid=3D=
610413.
scsi(4): GID_PT entry - nn 50001fe150004d10 pn 50001fe150004d19 portid=3D=
610613.
scsi(4): GID_PT entry - nn 50001fe150004d10 pn 50001fe150004d1d portid=3D=
610513.
scsi(4): GID_PT entry - nn 500508b300902930 pn 500508b300902939 portid=3D=
610713.
scsi(4): device wrap (610713)
scsi(4): LOOP READY
scsi(4): qla2x00_loop_resync - end
scsi(4:2): Async-login - loop-id=3D81 portid=3D610813 retries=3D0.
scsi(4:3): Async-login - loop-id=3D82 portid=3D610413 retries=3D0.
scsi(4:2): Async-login failed - status=3D30 mb0=3D4007 mb1=3D0 mb2=3D0 =
mb6=3D0 mb7=3D0.
scsi(4:3): Async-login failed - status=3D30 mb0=3D4007 mb1=3D1 mb2=3D0 =
mb6=3D0 mb7=3D0.
scsi(4:4): Async-login - loop-id=3D83 portid=3D610613 retries=3D0.
scsi(4:5): Async-login - loop-id=3D84 portid=3D610513 retries=3D0.
scsi(4:6): Async-login - loop-id=3D85 portid=3D610713 retries=3D0.
scsi(4): qla2x00_reset_marker()
scsi(4:4): Async-login complete - mbx1=3D4.
scsi(4:5): Async-login complete - mbx1=3D4.
scsi(4:6): Async-login complete - mbx1=3D4.
scsi(4:8): Async-login - loop-id=3D0 portid=3D610813 retries=3D0.
scsi(4:9): Async-login - loop-id=3D1 portid=3D610413 retries=3D0.
scsi(4:8): Async-login failed - status=3D30 mb0=3D4000 mb1=3D3 mb2=3D0 =
mb6=3D0 mb7=3D0.
scsi 4:0:0:0: RAID              COMPAQ   HSV111 (C)COMPAQ 4004 PQ: 0 AN=
SI: 5



reset:


qla2xxx 0000:06:01.0: scsi(4:2:13): BUS RESET ISSUED.
scsi(4): Asynchronous P2P MODE received.
scsi(4): Asynchronous PORT UPDATE.
scsi(4): Port database changed ffff 0006 0000.
scsi(4): Asynchronous PORT UPDATE ignored 0001/0006/0000.
scsi(4): Asynchronous PORT UPDATE ignored 0001/0007/0000.
scsi(4): fcport-0 - port retry count: 15 remaining
scsi(4): fcport-1 - port retry count: 15 remaining
scsi(4): fcport-2 - port retry count: 15 remaining
scsi(4): qla2x00_reset_marker()
scsi(4): qla2x00_loop_resync()
scsi(4): F/W Ready - OK
scsi(4): fw_state=3D3 (3bb1, 8800, ffff, e540) curr time=3D10032f088.
scsi(4): Configure loop -- dpc flags =3D0x1260
scsi(4): RSCN queue entry[0] =3D [00/000000].
scsi(4): device_resync: rscn overflow.
scsi(4): fcport-0 - port retry count: 14 remaining
scsi(4): fcport-1 - port retry count: 14 remaining
scsi(4): fcport-2 - port retry count: 14 remaining
scsi(4): fcport-0 - port retry count: 13 remaining
scsi(4): fcport-1 - port retry count: 13 remaining
scsi(4): fcport-2 - port retry count: 13 remaining
scsi(4): fcport-0 - port retry count: 12 remaining
scsi(4): fcport-1 - port retry count: 12 remaining
scsi(4): fcport-2 - port retry count: 12 remaining
scsi(4): fcport-0 - port retry count: 11 remaining
scsi(4): fcport-1 - port retry count: 11 remaining
scsi(4): fcport-2 - port retry count: 11 remaining
scsi(4): fcport-0 - port retry count: 10 remaining
scsi(4): fcport-1 - port retry count: 10 remaining
scsi(4): fcport-2 - port retry count: 10 remaining
scsi(4): fcport-0 - port retry count: 9 remaining
scsi(4): fcport-1 - port retry count: 9 remaining
scsi(4): fcport-2 - port retry count: 9 remaining
scsi(4): fcport-0 - port retry count: 8 remaining
scsi(4): fcport-1 - port retry count: 8 remaining
scsi(4): fcport-2 - port retry count: 8 remaining
scsi(4): fcport-0 - port retry count: 7 remaining
scsi(4): fcport-1 - port retry count: 7 remaining
scsi(4): fcport-2 - port retry count: 7 remaining
scsi(4): fcport-0 - port retry count: 6 remaining
scsi(4): fcport-1 - port retry count: 6 remaining
scsi(4): fcport-2 - port retry count: 6 remaining
scsi(4): fcport-0 - port retry count: 5 remaining
scsi(4): fcport-1 - port retry count: 5 remaining
scsi(4): fcport-2 - port retry count: 5 remaining
scsi(4): fcport-0 - port retry count: 4 remaining
scsi(4): fcport-1 - port retry count: 4 remaining
scsi(4): fcport-2 - port retry count: 4 remaining
scsi(4): fcport-0 - port retry count: 3 remaining
scsi(4): fcport-1 - port retry count: 3 remaining
scsi(4): fcport-2 - port retry count: 3 remaining
scsi(4): fcport-0 - port retry count: 2 remaining
scsi(4): fcport-1 - port retry count: 2 remaining
scsi(4): fcport-2 - port retry count: 2 remaining
scsi(4): fcport-0 - port retry count: 1 remaining
scsi(4): fcport-1 - port retry count: 1 remaining
scsi(4): fcport-2 - port retry count: 1 remaining
scsi(4): fcport-0 - port retry count: 0 remaining
scsi(4): fcport-1 - port retry count: 0 remaining
scsi(4): fcport-2 - port retry count: 0 remaining
scsi(4): RHBA failed, completion status (6).
qla2x00_mailbox_command(4): **** FAILED. mbx0=3D4005, mbx1=3D82, mbx2=3D=
0, cmd=3D71 ****
qla2x00_fabric_logout(4): failed=3D102 mbx1=3D82.
scsi(4): RFT_ID exiting normally.
qla2x00_mailbox_command(4): **** FAILED. mbx0=3D4005, mbx1=3D83,
mbx2=3Dffff, cmd=3D71 ****
qla2x00_fabric_logout(4): failed=3D102 mbx1=3D83.
 rport-4:0-2: blocked FC remote port time out: removing target and
saving binding
scsi(4): RFF_ID failed, rejected request:
 0   1   2   3   4   5   6   7   8   9  Ah  Bh  Ch  Dh  Eh  Fh
--------------------------------------------------------------
01  00  00  00  fc  02  00  00  80  01  00  00  00  0b  00  00
scsi(4): Register FC-4 Features failed.
qla2x00_mailbox_command(4): **** FAILED. mbx0=3D4005, mbx1=3D84, mbx2=3D=
0, cmd=3D71 ****
qla2x00_fabric_logout(4): failed=3D102 mbx1=3D84.
scsi(4): RNN_ID exiting normally.
scsi(4): RSNN_NN exiting normally.
sd 4:0:2:1: [sdk] Synchronizing SCSI cache
hd: sdk: remove path (uevent)
scsi(4): GID_PT entry - nn 200000e08b07ae8f pn 210000e08b07ae8f portid=3D=
610913.
scsi(4): GID_PT entry - nn 200000e08b17a9df pn 210000e08b17a9df portid=3D=
610813.
scsi(4): GID_PT entry - nn 20000000c9294b5b pn 10000000c9294b5b portid=3D=
610413.
scsi(4): GID_PT entry - nn 50001fe150004d10 pn 50001fe150004d19 portid=3D=
610613.
scsi(4): GID_PT entry - nn 50001fe150004d10 pn 50001fe150004d1d portid=3D=
610513.
scsi(4): GID_PT entry - nn 500508b300902930 pn 500508b300902939 portid=3D=
610713.
qla2x00_mailbox_command(4): **** FAILED. mbx0=3D4005, mbx1=3D82,
mbx2=3D8800, cmd=3D71 ****
qla2x00_fabric_logout(4): failed=3D102 mbx1=3D82.
qla2x00_mailbox_command(4): **** FAILED. mbx0=3D4005, mbx1=3D83,
mbx2=3D8800, cmd=3D71 ****
qla2x00_fabric_logout(4): failed=3D102 mbx1=3D83.
qla2x00_mailbox_command(4): **** FAILED. mbx0=3D4005, mbx1=3D84,
mbx2=3D8800, cmd=3D71 ****
qla2x00_fabric_logout(4): failed=3D102 mbx1=3D84.
scsi(4): device wrap (610713)
scsi(4): LOOP READY
scsi(4): qla2x00_loop_resync - end
qla2x00_mailbox_command(4): **** FAILED. mbx0=3D4006, mbx1=3D82, mbx2=3D=
5, cmd=3D17 ****
qla2x00_abort_target(4): failed=3D102.
qla2x00_loop_reset(4): bus_reset failed: target_reset=3D258 d_id=3D6106=
13.
qla2x00_mailbox_command(4): **** FAILED. mbx0=3D4006, mbx1=3D83, mbx2=3D=
5, cmd=3D17 ****
qla2x00_abort_target(4): failed=3D102.
qla2x00_loop_reset(4): bus_reset failed: target_reset=3D258 d_id=3D6105=
13.
qla2x00_mailbox_command(4): **** FAILED. mbx0=3D4006, mbx1=3D84, mbx2=3D=
5, cmd=3D17 ****
qla2x00_abort_target(4): failed=3D102.
qla2x00_loop_reset(4): bus_reset failed: target_reset=3D258 d_id=3D6107=
13.
qla2xxx 0000:06:01.0: qla2xxx_eh_bus_reset: reset succeded
scsi(4:2a9): Async-login - loop-id=3D81 portid=3D610813 retries=3D0.
scsi(4:2aa): Async-login - loop-id=3D1 portid=3D610413 retries=3D0.
scsi(4:2ab): Async-login - loop-id=3D82 portid=3D610613 retries=3D0.
scsi(4:2ac): Async-login - loop-id=3D83 portid=3D610513 retries=3D0.
scsi(4:2ad): Async-login - loop-id=3D84 portid=3D610713 retries=3D0.
scsi(4:2a9): Async-login failed - status=3D30 mb0=3D4000 mb1=3D3 mb2=3D=
0 mb6=3D0 mb7=3D0.
scsi(4:2aa): Async-login complete - mbx1=3D3.
scsi(4): Port login retry: 210000e08b17a9df, id =3D 0x0081 retry cnt=3D=
16
scsi(4:2ab): Async-login complete - mbx1=3D4.
scsi(4:2ac): Async-login complete - mbx1=3D4.
scsi(4:2ad): Async-login complete - mbx1=3D4.
sd 4:0:2:1: [sdk] Result: hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER=
_OK
sd 4:0:2:7: [sdq] Synchronizing SCSI cache

On Tue, May 18, 2010 at 12:56 PM, Giridhar Malavali
<giridhar.malavali@qlogic.com> wrote:
>
>
> On Tue, 18 May 2010, Eddie Williams wrote:
>
>> I upgraded an older EM64T server with 2 Qlogic controllers (QLA2340
>> FW:v3.03.27 DVR:v8.03.01-k10) to SLES 11 and when a SCSI Bus Reset
>> (Loop Reset) is issued I get this time out where the driver ends up
>> removing all devices (causing IO failures for mounted file systems a=
nd
>> the like) and then rescaning to add the devices back.=A0 I verified =
that
>> with the latest stable kernel (2.6.33.4) I see similar behavior
>> (though the new kernel recovery much quicker).=A0 If I go back to an
>> older boot disk with Red Hat EL 4 that kernel/driver will issue a
>> reset without any issues, aka no port time out or loss of connection
>> to the storage.
>>
>> I have tried similar tests on different servers connected to the sam=
e
>> FC switch/storage as well as servers connected to different storage
>> without seeing this behavior.
>>
>
> Thanks for bringing this to attention. Is it possible to re-run the t=
est
> with extended logging (ql2xextended_error_logging=3D1). This will hel=
p to
> debug further.
>
> -- Giri
>
>
>> output to /var/log/messages:
>>
>> May 14 11:18:14 goofy kernel: qla2xxx 0000:06:01.0: scsi(2:2:15): LO=
OP
>> RESET ISSUED.
>> May 14 11:18:34 goofy kernel:=A0 rport-2:0-4: blocked FC remote port
>> time out: removing target and saving binding
>> May 14 11:18:34 goofy kernel: sd 2:0:2:1: [sdv] Synchronizing SCSI c=
ache
>> May 14 11:18:34 goofy multipathd: sdv: remove path (uevent)
>> May 14 11:19:04 goofy kernel:=A0 rport-2:0-2: blocked FC remote port
>> time out: removing target and saving binding
>> May 14 11:19:04 goofy kernel:=A0 rport-2:0-3: blocked FC remote port
>> time out: removing target and saving binding
>> May 14 11:19:14 goofy kernel:=A0 rport-2:0-6: blocked FC remote port
>> time out: removing rport
>> May 14 11:20:22 goofy LifeKeeper[8115]: RECOVERY class=3Ddisk
>> event=3Dinqfail name=3D3600508b300902930a83a23d1a2850036 STARTING AT=
: Fri
>> May 14 11:20:22 EDT 2010
>> May 14 11:20:23 goofy LifeKeeper[8115]: RECOVERY class=3Ddisk
>> event=3Dinqfail name=3D3600508b300902930a83a23d1a2850036 ENDING AT: =
=46ri
>> May 14 11:20:23 EDT 2010
>> May 14 11:23:14 goofy kernel: qla2xxx 0000:06:01.0:
>> qla2xxx_eh_bus_reset: reset succeded
>>
>>
>> What is causing this time out and how can I avoid it?
>>
>> Eddie Williams
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

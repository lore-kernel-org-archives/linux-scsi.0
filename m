From: Eddie Williams <eddie.williams@steeleye.com>
Subject: Re: qla2xxx - blocked FC remote port time out: removing target and
	saving binding
Date: Tue, 18 May 2010 15:48:04 -0400
Message-ID: <AANLkTiluJI-xFC_Z1c7Y3f_ansJEkU_lfO4d8A_2mRLq@mail.gmail.com>
References: <AANLkTinG6IYyKvYtNMBUpJcYslBmm2_h8iEwp-JYwIdR@mail.gmail.com>
	 <alpine.OSX.2.00.1005180950070.38012@gmmac.local>
	 <AANLkTil7VuIJcINJEQp-RRP8TLxb4-u0rF9uUOJNuczP@mail.gmail.com>
	 <alpine.OSX.2.00.1005181158350.38012@gmmac.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f183.google.com ([209.85.221.183]:52986 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757053Ab0ERTsJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2010 15:48:09 -0400
Received: by qyk13 with SMTP id 13so9809517qyk.1
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2010 12:48:07 -0700 (PDT)
In-Reply-To: <alpine.OSX.2.00.1005181158350.38012@gmmac.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Giridhar Malavali <giridhar.malavali@qlogic.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

I will give it a go.  I am use the latest stable so the patch was not
clean.  I will pull down the latest if need be...

Eddie

On Tue, May 18, 2010 at 3:05 PM, Giridhar Malavali
<giridhar.malavali@qlogic.com> wrote:
>
>
> On Tue, 18 May 2010, Eddie Williams wrote:
>
>> Here is a snipit of the log with the timestamp cut off to avoid maki=
ng
>> the mail so large. =A0I can send you the full log directly if you li=
ke.
>>
>> driver load:
>> QLogic Fibre Channel HBA Driver: 8.03.01-k10-debug
>> qla2xxx 0000:06:01.0: PCI INT A -> GSI 74 (level, low) -> IRQ 74
>> qla2xxx 0000:06:01.0: Found an ISP2312, irq 74, iobase 0xffffc90000d=
ba000
>> qla2xxx 0000:06:01.0: Configuring PCI space...
>> qla2xxx 0000:06:01.0: Configure NVRAM parameters...
>> qla2xxx 0000:06:01.0: Verifying loaded RISC code...
>> scsi(4): **** Load RISC code ****
>> qla2xxx 0000:06:01.0: firmware: requesting ql2300_fw.bin
>> scsi(4): Verifying Checksum of loaded RISC code.
>> scsi(4): Checksum OK, start firmware.
>> qla2xxx 0000:06:01.0: Allocated (412 KB) for firmware dump...
>> scsi(4): Issue init firmware.
>> DEBUG: detect hba 4 at address =3D ffff88003bf90000
>> scsi4 : qla2xxx
>> scsi(4): qla2x00_loop_resync()
>> scsi(4): Asynchronous P2P MODE received.
>> scsi(4): Asynchronous LOOP UP (2 Gbps).
>> qla2xxx 0000:06:01.0: LOOP UP detected (2 Gbps).
>> scsi(4): Asynchronous PORT UPDATE.
>> scsi(4): Port database changed ffff 0006 0000.
>> scsi(4): F/W Ready - OK
>> scsi(4): fw_state=3D3 (3bb1, 8800, ffff, e540) curr time=3D10031b431=
=2E
>> scsi(4): Configure loop -- dpc flags =3D0x112e1
>> scsi(4): RSCN queue entry[0] =3D [00/000000].
>> scsi(4): device_resync: rscn overflow.
>> qla2xxx 0000:06:01.0:
>> QLogic Fibre Channel HBA Driver: 8.03.01-k10-debug
>> =A0QLogic QLA2340 -
>> =A0ISP2312: PCI-X (100 MHz) @ 0000:06:01.0 hdma-, host#=3D4, fw=3D3.=
03.27 IPX
>> qla2xxx 0000:06:02.0: PCI INT A -> GSI 78 (level, low) -> IRQ 78
>> qla2xxx 0000:06:02.0: Found an ISP2312, irq 78, iobase 0xffffc900010=
e4000
>> qla2xxx 0000:06:02.0: Configuring PCI space...
>> qla2xxx 0000:06:02.0: Configure NVRAM parameters...
>> qla2xxx 0000:06:02.0: Verifying loaded RISC code...
>> scsi(5): **** Load RISC code ****
>> scsi(5): Verifying Checksum of loaded RISC code.
>> scsi(5): Checksum OK, start firmware.
>> qla2xxx 0000:06:02.0: Allocated (412 KB) for firmware dump...
>> scsi(5): Issue init firmware.
>> DEBUG: detect hba 5 at address =3D ffff88003b000000
>> scsi5 : qla2xxx
>> scsi(5): qla2x00_loop_resync()
>> qla2xxx 0000:06:02.0:
>> QLogic Fibre Channel HBA Driver: 8.03.01-k10-debug
>> =A0QLogic QLA2340 -
>> =A0ISP2312: PCI-X (100 MHz) @ 0000:06:02.0 hdma-, host#=3D5, fw=3D3.=
03.27 IPX
>> scsi(4): RHBA failed, completion status (6).
>> scsi(4): RFT_ID exiting normally.
>> scsi(4): RFF_ID failed, rejected request:
>> 0 =A0 1 =A0 2 =A0 3 =A0 4 =A0 5 =A0 6 =A0 7 =A0 8 =A0 9 =A0Ah =A0Bh =
=A0Ch =A0Dh =A0Eh =A0Fh
>> --------------------------------------------------------------
>> 01 =A000 =A000 =A000 =A0fc =A002 =A000 =A000 =A080 =A001 =A000 =A000=
 =A000 =A00b =A000 =A000
>> scsi(4): Register FC-4 Features failed.
>> scsi(4): RNN_ID exiting normally.
>> scsi(4): RSNN_NN exiting normally.
>> scsi(4): GID_PT entry - nn 200000e08b07ae8f pn 210000e08b07ae8f
>> portid=3D610913.
>> scsi(4): GID_PT entry - nn 200000e08b17a9df pn 210000e08b17a9df
>> portid=3D610813.
>> scsi(4): GID_PT entry - nn 20000000c9294b5b pn 10000000c9294b5b
>> portid=3D610413.
>> scsi(4): GID_PT entry - nn 50001fe150004d10 pn 50001fe150004d19
>> portid=3D610613.
>> scsi(4): GID_PT entry - nn 50001fe150004d10 pn 50001fe150004d1d
>> portid=3D610513.
>> scsi(4): GID_PT entry - nn 500508b300902930 pn 500508b300902939
>> portid=3D610713.
>> scsi(4): device wrap (610713)
>> scsi(4): LOOP READY
>> scsi(4): qla2x00_loop_resync - end
>> scsi(4:2): Async-login - loop-id=3D81 portid=3D610813 retries=3D0.
>> scsi(4:3): Async-login - loop-id=3D82 portid=3D610413 retries=3D0.
>> scsi(4:2): Async-login failed - status=3D30 mb0=3D4007 mb1=3D0 mb2=3D=
0 mb6=3D0
>> mb7=3D0.
>> scsi(4:3): Async-login failed - status=3D30 mb0=3D4007 mb1=3D1 mb2=3D=
0 mb6=3D0
>> mb7=3D0.
>> scsi(4:4): Async-login - loop-id=3D83 portid=3D610613 retries=3D0.
>> scsi(4:5): Async-login - loop-id=3D84 portid=3D610513 retries=3D0.
>> scsi(4:6): Async-login - loop-id=3D85 portid=3D610713 retries=3D0.
>> scsi(4): qla2x00_reset_marker()
>> scsi(4:4): Async-login complete - mbx1=3D4.
>> scsi(4:5): Async-login complete - mbx1=3D4.
>> scsi(4:6): Async-login complete - mbx1=3D4.
>> scsi(4:8): Async-login - loop-id=3D0 portid=3D610813 retries=3D0.
>> scsi(4:9): Async-login - loop-id=3D1 portid=3D610413 retries=3D0.
>> scsi(4:8): Async-login failed - status=3D30 mb0=3D4000 mb1=3D3 mb2=3D=
0 mb6=3D0
>> mb7=3D0.
>> scsi 4:0:0:0: RAID =A0 =A0 =A0 =A0 =A0 =A0 =A0COMPAQ =A0 HSV111 (C)C=
OMPAQ 4004 PQ: 0 ANSI:
>> 5
>>
>>
>>
>> reset:
>>
>>
>> qla2xxx 0000:06:01.0: scsi(4:2:13): BUS RESET ISSUED.
>> scsi(4): Asynchronous P2P MODE received.
>> scsi(4): Asynchronous PORT UPDATE.
>> scsi(4): Port database changed ffff 0006 0000.
>> scsi(4): Asynchronous PORT UPDATE ignored 0001/0006/0000.
>> scsi(4): Asynchronous PORT UPDATE ignored 0001/0007/0000.
>> scsi(4): fcport-0 - port retry count: 15 remaining
>> scsi(4): fcport-1 - port retry count: 15 remaining
>> scsi(4): fcport-2 - port retry count: 15 remaining
>> scsi(4): qla2x00_reset_marker()
>> scsi(4): qla2x00_loop_resync()
>> scsi(4): F/W Ready - OK
>> scsi(4): fw_state=3D3 (3bb1, 8800, ffff, e540) curr time=3D10032f088=
=2E
>> scsi(4): Configure loop -- dpc flags =3D0x1260
>> scsi(4): RSCN queue entry[0] =3D [00/000000].
>> scsi(4): device_resync: rscn overflow.
>> scsi(4): fcport-0 - port retry count: 14 remaining
>> scsi(4): fcport-1 - port retry count: 14 remaining
>> scsi(4): fcport-2 - port retry count: 14 remaining
>> scsi(4): fcport-0 - port retry count: 13 remaining
>> scsi(4): fcport-1 - port retry count: 13 remaining
>> scsi(4): fcport-2 - port retry count: 13 remaining
>> scsi(4): fcport-0 - port retry count: 12 remaining
>> scsi(4): fcport-1 - port retry count: 12 remaining
>> scsi(4): fcport-2 - port retry count: 12 remaining
>> scsi(4): fcport-0 - port retry count: 11 remaining
>> scsi(4): fcport-1 - port retry count: 11 remaining
>> scsi(4): fcport-2 - port retry count: 11 remaining
>> scsi(4): fcport-0 - port retry count: 10 remaining
>> scsi(4): fcport-1 - port retry count: 10 remaining
>> scsi(4): fcport-2 - port retry count: 10 remaining
>> scsi(4): fcport-0 - port retry count: 9 remaining
>> scsi(4): fcport-1 - port retry count: 9 remaining
>> scsi(4): fcport-2 - port retry count: 9 remaining
>> scsi(4): fcport-0 - port retry count: 8 remaining
>> scsi(4): fcport-1 - port retry count: 8 remaining
>> scsi(4): fcport-2 - port retry count: 8 remaining
>> scsi(4): fcport-0 - port retry count: 7 remaining
>> scsi(4): fcport-1 - port retry count: 7 remaining
>> scsi(4): fcport-2 - port retry count: 7 remaining
>> scsi(4): fcport-0 - port retry count: 6 remaining
>> scsi(4): fcport-1 - port retry count: 6 remaining
>> scsi(4): fcport-2 - port retry count: 6 remaining
>> scsi(4): fcport-0 - port retry count: 5 remaining
>> scsi(4): fcport-1 - port retry count: 5 remaining
>> scsi(4): fcport-2 - port retry count: 5 remaining
>> scsi(4): fcport-0 - port retry count: 4 remaining
>> scsi(4): fcport-1 - port retry count: 4 remaining
>> scsi(4): fcport-2 - port retry count: 4 remaining
>> scsi(4): fcport-0 - port retry count: 3 remaining
>> scsi(4): fcport-1 - port retry count: 3 remaining
>> scsi(4): fcport-2 - port retry count: 3 remaining
>> scsi(4): fcport-0 - port retry count: 2 remaining
>> scsi(4): fcport-1 - port retry count: 2 remaining
>> scsi(4): fcport-2 - port retry count: 2 remaining
>> scsi(4): fcport-0 - port retry count: 1 remaining
>> scsi(4): fcport-1 - port retry count: 1 remaining
>> scsi(4): fcport-2 - port retry count: 1 remaining
>> scsi(4): fcport-0 - port retry count: 0 remaining
>> scsi(4): fcport-1 - port retry count: 0 remaining
>> scsi(4): fcport-2 - port retry count: 0 remaining
>> scsi(4): RHBA failed, completion status (6).
>> qla2x00_mailbox_command(4): **** FAILED. mbx0=3D4005, mbx1=3D82, mbx=
2=3D0,
>> cmd=3D71 ****
>> qla2x00_fabric_logout(4): failed=3D102 mbx1=3D82.
>> scsi(4): RFT_ID exiting normally.
>> qla2x00_mailbox_command(4): **** FAILED. mbx0=3D4005, mbx1=3D83,
>> mbx2=3Dffff, cmd=3D71 ****
>> qla2x00_fabric_logout(4): failed=3D102 mbx1=3D83.
>> rport-4:0-2: blocked FC remote port time out: removing target and
>> saving binding
>> scsi(4): RFF_ID failed, rejected request:
>> 0 =A0 1 =A0 2 =A0 3 =A0 4 =A0 5 =A0 6 =A0 7 =A0 8 =A0 9 =A0Ah =A0Bh =
=A0Ch =A0Dh =A0Eh =A0Fh
>> --------------------------------------------------------------
>> 01 =A000 =A000 =A000 =A0fc =A002 =A000 =A000 =A080 =A001 =A000 =A000=
 =A000 =A00b =A000 =A000
>> scsi(4): Register FC-4 Features failed.
>> qla2x00_mailbox_command(4): **** FAILED. mbx0=3D4005, mbx1=3D84, mbx=
2=3D0,
>> cmd=3D71 ****
>> qla2x00_fabric_logout(4): failed=3D102 mbx1=3D84.
>> scsi(4): RNN_ID exiting normally.
>> scsi(4): RSNN_NN exiting normally.
>> sd 4:0:2:1: [sdk] Synchronizing SCSI cache
>> hd: sdk: remove path (uevent)
>> scsi(4): GID_PT entry - nn 200000e08b07ae8f pn 210000e08b07ae8f
>> portid=3D610913.
>> scsi(4): GID_PT entry - nn 200000e08b17a9df pn 210000e08b17a9df
>> portid=3D610813.
>> scsi(4): GID_PT entry - nn 20000000c9294b5b pn 10000000c9294b5b
>> portid=3D610413.
>> scsi(4): GID_PT entry - nn 50001fe150004d10 pn 50001fe150004d19
>> portid=3D610613.
>> scsi(4): GID_PT entry - nn 50001fe150004d10 pn 50001fe150004d1d
>> portid=3D610513.
>> scsi(4): GID_PT entry - nn 500508b300902930 pn 500508b300902939
>> portid=3D610713.
>> qla2x00_mailbox_command(4): **** FAILED. mbx0=3D4005, mbx1=3D82,
>> mbx2=3D8800, cmd=3D71 ****
>> qla2x00_fabric_logout(4): failed=3D102 mbx1=3D82.
>> qla2x00_mailbox_command(4): **** FAILED. mbx0=3D4005, mbx1=3D83,
>> mbx2=3D8800, cmd=3D71 ****
>> qla2x00_fabric_logout(4): failed=3D102 mbx1=3D83.
>> qla2x00_mailbox_command(4): **** FAILED. mbx0=3D4005, mbx1=3D84,
>> mbx2=3D8800, cmd=3D71 ****
>> qla2x00_fabric_logout(4): failed=3D102 mbx1=3D84.
>> scsi(4): device wrap (610713)
>> scsi(4): LOOP READY
>> scsi(4): qla2x00_loop_resync - end
>> qla2x00_mailbox_command(4): **** FAILED. mbx0=3D4006, mbx1=3D82, mbx=
2=3D5,
>> cmd=3D17 ****
>> qla2x00_abort_target(4): failed=3D102.
>> qla2x00_loop_reset(4): bus_reset failed: target_reset=3D258 d_id=3D6=
10613.
>> qla2x00_mailbox_command(4): **** FAILED. mbx0=3D4006, mbx1=3D83, mbx=
2=3D5,
>> cmd=3D17 ****
>> qla2x00_abort_target(4): failed=3D102.
>> qla2x00_loop_reset(4): bus_reset failed: target_reset=3D258 d_id=3D6=
10513.
>> qla2x00_mailbox_command(4): **** FAILED. mbx0=3D4006, mbx1=3D84, mbx=
2=3D5,
>> cmd=3D17 ****
>> qla2x00_abort_target(4): failed=3D102.
>> qla2x00_loop_reset(4): bus_reset failed: target_reset=3D258 d_id=3D6=
10713.
>> qla2xxx 0000:06:01.0: qla2xxx_eh_bus_reset: reset succeded
>> scsi(4:2a9): Async-login - loop-id=3D81 portid=3D610813 retries=3D0.
>> scsi(4:2aa): Async-login - loop-id=3D1 portid=3D610413 retries=3D0.
>> scsi(4:2ab): Async-login - loop-id=3D82 portid=3D610613 retries=3D0.
>> scsi(4:2ac): Async-login - loop-id=3D83 portid=3D610513 retries=3D0.
>> scsi(4:2ad): Async-login - loop-id=3D84 portid=3D610713 retries=3D0.
>> scsi(4:2a9): Async-login failed - status=3D30 mb0=3D4000 mb1=3D3 mb2=
=3D0 mb6=3D0
>> mb7=3D0.
>> scsi(4:2aa): Async-login complete - mbx1=3D3.
>> scsi(4): Port login retry: 210000e08b17a9df, id =3D 0x0081 retry cnt=
=3D16
>> scsi(4:2ab): Async-login complete - mbx1=3D4.
>> scsi(4:2ac): Async-login complete - mbx1=3D4.
>> scsi(4:2ad): Async-login complete - mbx1=3D4.
>> sd 4:0:2:1: [sdk] Result: hostbyte=3DDID_NO_CONNECT driverbyte=3DDRI=
VER_OK
>> sd 4:0:2:7: [sdq] Synchronizing SCSI cache
>
> Recently, we found an issue with async login stuff with 23xx adapters=
 and
> decided to disbale this feature for timebeing on 23xx to debug furthe=
r. Can
> u please try following patches and let me know whether this fix the p=
roblem.
> I am in process of queuing these patches to linux-scsi shortly.
>
> -- Giri
>
>
> From c40c40cab7ffa8c0710a7fba9fba572df9f38e83 Mon Sep 17 00:00:00 200=
1
> From: Giridhar Malavali <giridhar.malavali@qlogic.com>
> Date: Sun, 9 May 2010 19:55:41 -0700
> Subject: [PATCH 7/9] qla2xxx: Limit rport-flaps during link-disruptio=
ns.
>
> Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
> ---
> =A0drivers/scsi/qla2xxx/qla_init.c | =A0 =A08 +++++---
> =A01 files changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_init.c
> b/drivers/scsi/qla2xxx/qla_init.c
> index f546839..b33e6c0 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -2651,7 +2651,8 @@ qla2x00_configure_loop(scsi_qla_host_t *vha)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0set_bit(LOCAL_LOOP_UPD=
ATE, &vha->dpc_flags);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (test_bit(RSCN_UPDATE, &save_flags)=
) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0set_bit(RSCN_UPDATE, &=
vha->dpc_flags);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vha->flags.rscn_queue_o=
verflow =3D 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!IS_ALOGIO_CAPABLE(=
ha))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vha->fl=
ags.rscn_queue_overflow =3D 1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
>
> @@ -3209,8 +3210,9 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *v=
ha,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (qla2x00_is_reserved_id(vha, loop_i=
d))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (atomic_read(&vha->loop_down_timer) =
||
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 LOOP_TRANSITION(vha)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ha->current_topology =3D=3D ISP_CFG=
_FL &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (atomic_read(&vha->loop_down_ti=
mer) ||
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0LOOP_TRANSITION(vha))) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0atomic_set(&vha->loop_=
down_timer, 0);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0set_bit(LOOP_RESYNC_NE=
EDED, &vha->dpc_flags);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0set_bit(LOCAL_LOOP_UPD=
ATE, &vha->dpc_flags);
> --
> 1.6.0.2
>
>
> From 4e449325ee1268c1e62e10287e810111f0edb57d Mon Sep 17 00:00:00 200=
1
> From: Andrew Vasquez <andrew.vasquez@qlogic.com>
> Date: Fri, 14 May 2010 18:14:12 -0700
> Subject: [PATCH 8/9] qla2xxx: Disable async-logins on ISP23xx.
>
> Temporary workaround while additional investigation done by
> the firmware group.
>
> Can be re-enabled with the ql2xasyncenable module parameter set
> to 1.
> ---
> =A0drivers/scsi/qla2xxx/qla_def.h | =A0 =A03 ++-
> =A0drivers/scsi/qla2xxx/qla_gbl.h | =A0 =A01 +
> =A0drivers/scsi/qla2xxx/qla_os.c =A0| =A0 =A06 ++++++
> =A03 files changed, 9 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/ql=
a_def.h
> index f8239bf..3ff3f5f 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -2542,7 +2542,8 @@ struct qla_hw_data {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(ha)->=
flags.msix_enabled)
> =A0#define IS_FAC_REQUIRED(ha) =A0 =A0(IS_QLA81XX(ha))
> =A0#define IS_NOCACHE_VPD_TYPE(ha) =A0 =A0 =A0 =A0(IS_QLA81XX(ha))
> -#define IS_ALOGIO_CAPABLE(ha) =A0(IS_QLA23XX(ha) || IS_FWI2_CAPABLE(=
ha))
> +#define IS_ALOGIO_CAPABLE(ha) =A0((IS_QLA23XX(ha) && ql2xasyncenable=
) || \
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 IS_FWI2=
_CAPABLE(ha))
>
> =A0#define IS_IIDMA_CAPABLE(ha) =A0 =A0((ha)->device_type & DT_IIDMA)
> =A0#define IS_FWI2_CAPABLE(ha) =A0 =A0 ((ha)->device_type & DT_FWI2)
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/ql=
a_gbl.h
> index 2d3c540..2161e09 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -98,6 +98,7 @@ extern int ql2xenabledif;
> =A0extern int ql2xenablehba_err_chk;
> =A0extern int ql2xtargetreset;
> =A0extern int ql2xfwloadalways;
> +extern int ql2xasyncenable;
>
> =A0extern int qla2x00_loop_reset(scsi_qla_host_t *);
> =A0extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla=
_os.c
> index 7400456..cb76059 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -31,6 +31,12 @@ static int apidev_major;
> =A0*/
> =A0static struct kmem_cache *srb_cachep;
>
> +int ql2xasyncenable;
> +module_param(ql2xasyncenable, int, S_IRUGO|S_IRUSR);
> +MODULE_PARM_DESC(ql2xasyncenable,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Enables usage of Async-login/adisc on =
ISP23xx."
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Default is 0 - use serialized mailbox =
commands.");
> +
> =A0/*
> =A0* CT6 CTX allocation cache
> =A0*/
> --
> 1.6.0.2
>
>
>
>
>>
>> On Tue, May 18, 2010 at 12:56 PM, Giridhar Malavali
>> <giridhar.malavali@qlogic.com> wrote:
>>>
>>>
>>> On Tue, 18 May 2010, Eddie Williams wrote:
>>>
>>>> I upgraded an older EM64T server with 2 Qlogic controllers (QLA234=
0
>>>> FW:v3.03.27 DVR:v8.03.01-k10) to SLES 11 and when a SCSI Bus Reset
>>>> (Loop Reset) is issued I get this time out where the driver ends u=
p
>>>> removing all devices (causing IO failures for mounted file systems=
 and
>>>> the like) and then rescaning to add the devices back. =A0I verifie=
d that
>>>> with the latest stable kernel (2.6.33.4) I see similar behavior
>>>> (though the new kernel recovery much quicker). =A0If I go back to =
an
>>>> older boot disk with Red Hat EL 4 that kernel/driver will issue a
>>>> reset without any issues, aka no port time out or loss of connecti=
on
>>>> to the storage.
>>>>
>>>> I have tried similar tests on different servers connected to the s=
ame
>>>> FC switch/storage as well as servers connected to different storag=
e
>>>> without seeing this behavior.
>>>>
>>>
>>> Thanks for bringing this to attention. Is it possible to re-run the=
 test
>>> with extended logging (ql2xextended_error_logging=3D1). This will h=
elp to
>>> debug further.
>>>
>>> -- Giri
>>>
>>>
>>>> output to /var/log/messages:
>>>>
>>>> May 14 11:18:14 goofy kernel: qla2xxx 0000:06:01.0: scsi(2:2:15): =
LOOP
>>>> RESET ISSUED.
>>>> May 14 11:18:34 goofy kernel: =A0rport-2:0-4: blocked FC remote po=
rt
>>>> time out: removing target and saving binding
>>>> May 14 11:18:34 goofy kernel: sd 2:0:2:1: [sdv] Synchronizing SCSI=
 cache
>>>> May 14 11:18:34 goofy multipathd: sdv: remove path (uevent)
>>>> May 14 11:19:04 goofy kernel: =A0rport-2:0-2: blocked FC remote po=
rt
>>>> time out: removing target and saving binding
>>>> May 14 11:19:04 goofy kernel: =A0rport-2:0-3: blocked FC remote po=
rt
>>>> time out: removing target and saving binding
>>>> May 14 11:19:14 goofy kernel: =A0rport-2:0-6: blocked FC remote po=
rt
>>>> time out: removing rport
>>>> May 14 11:20:22 goofy LifeKeeper[8115]: RECOVERY class=3Ddisk
>>>> event=3Dinqfail name=3D3600508b300902930a83a23d1a2850036 STARTING =
AT: Fri
>>>> May 14 11:20:22 EDT 2010
>>>> May 14 11:20:23 goofy LifeKeeper[8115]: RECOVERY class=3Ddisk
>>>> event=3Dinqfail name=3D3600508b300902930a83a23d1a2850036 ENDING AT=
: Fri
>>>> May 14 11:20:23 EDT 2010
>>>> May 14 11:23:14 goofy kernel: qla2xxx 0000:06:01.0:
>>>> qla2xxx_eh_bus_reset: reset succeded
>>>>
>>>>
>>>> What is causing this time out and how can I avoid it?
>>>>
>>>> Eddie Williams
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-sc=
si" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

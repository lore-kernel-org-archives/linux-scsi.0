From: Govindarajan <govind.rajan@gmail.com>
Subject: Re: iSCSI bug
Date: Tue, 17 Mar 2015 21:57:38 -0700
Message-ID: <meb0k4$l30$1@ger.gmane.org>
References: <D5289E78-CABB-4E26-A28B-7F0F04EFFEAD@gmail.com> <1425583361.5860.12.camel@haakon3.risingtidesystems.com>
Reply-To: govind.rajan@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52269 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbbCRFkK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Mar 2015 01:40:10 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1YY6i4-0000fk-F8
	for linux-scsi@vger.kernel.org; Wed, 18 Mar 2015 06:40:04 +0100
Received: from c-98-210-161-193.hsd1.ca.comcast.net ([98.210.161.193])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2015 06:40:04 +0100
Received: from govind.rajan by c-98-210-161-193.hsd1.ca.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2015 06:40:04 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: target-devel@vger.kernel.org

I see the same problem. Would this help?

Mar 17 21:13:00 storage1 kernel: [119260.960821] TARGET_CORE[iSCSI]:=20
Detected NON_EXISTENT_LUN Access for 0x00000090
Mar 17 21:13:00 storage1 kernel: [119260.963752] ABORT_TASK: Sending=20
TMR_TASK_DOES_NOT_EXIST for ref_tag: 18170949
Mar 17 21:13:00 storage1 kernel: [119260.963759] ABORT_TASK: Sending=20
TMR_TASK_DOES_NOT_EXIST for ref_tag: 18170948
Mar 17 21:13:00 storage1 kernel: [119260.963761] ABORT_TASK: Sending=20
TMR_TASK_DOES_NOT_EXIST for ref_tag: 18170950
Mar 17 21:13:04 storage1 kernel: [119265.171082] Unexpected ret: -32 se=
nd=20
data 48
Mar 17 21:13:06 storage1 kernel: [119267.172218] TARGET_CORE[iSCSI]:=20
Detected NON_EXISTENT_LUN Access for 0x0000000a
Mar 17 21:13:06 storage1 kernel: [119267.175296] ABORT_TASK: Sending=20
TMR_TASK_DOES_NOT_EXIST for ref_tag: 182076996
Mar 17 21:13:06 storage1 kernel: [119267.175303] ABORT_TASK: Sending=20
TMR_TASK_DOES_NOT_EXIST for ref_tag: 182076994
Mar 17 21:13:06 storage1 kernel: [119267.175306] ABORT_TASK: Sending=20
TMR_TASK_DOES_NOT_EXIST for ref_tag: 182076997
Mar 17 21:13:07 storage1 kernel: [119267.796469] iSCSI Login timeout on=
=20
Network Portal 10.12.9.249:3260
Mar 17 21:13:17 storage1 kernel: [119278.498259] NMI watchdog: BUG: sof=
t=20
lockup - CPU#1 stuck for 22s! [iscsi_trx:5637]
Mar 17 21:13:17 storage1 kernel: [119278.501397] Modules linked in:=20
ib_srpt(E) tcm_qla2xxx(E) tcm_loop(E) tcm_fc(E) iscsi_target_mod(E)=20
target_core_user(E) uio(E) target_core_pscsi(E) target_core_file(E)=20
target_core_iblock(E) target_core_mod(E) ib_cm(E) ib_sa(E) ib_mad(E)=20
ib_core(E) ib_addr(E) qla2xxx(E) libfc(E) scsi_transport_fc(E) configfs=
(E)=20
nfsd(E) auth_rpcgss(E) nfs_acl(E) nfs(E) lockd(E) grace(E) sunrpc(E)=20
fscache(E) gpio_ich(E) amdkfd(E) amd_iommu_v2(E) coretemp(E) kvm_intel(=
E)=20
kvm(E) radeon(E) serio_raw(E) 8021q(E) joydev(E) garp(E) ttm(E) mrp(E)=20
stp(E) llc(E) drm_kms_helper(E) drm(E) lpc_ich(E) i7core_edac(E)=20
edac_core(E) i5500_temp(E) ioatdma(E) 8250_fintek(E) mac_hid(E) shpchp(=
E)=20
bonding(E) btrfs(E) raid456(E) async_raid6_recov(E) async_memcpy(E)=20
bcache(E) async_pq(E) async_xor(E) raid10(E) async_tx(E) xor(E) raid6_p=
q(E)=20
raid1(E) hid_generic(E) raid0(E) multipath(E) igb(E) mpt2sas(E) ixgbe(E=
)=20
linear(E) raid_class(E) pata_acpi(E) i2c_algo_bit(E) dca(E) usbhid(E)=20
scsi_transport_sas(E) hid(E) ahci(E) pata_jmicron(E) psmouse(E) mdio(E)=
=20
ptp(E) libahci(E) pps_core(E) [last unloaded: target_core_mod]
Mar 17 21:13:17 storage1 kernel: [119278.501476] CPU: 1 PID: 5637 Comm:=
=20
iscsi_trx Tainted: G            E  3.19.0-031900-generic #201502091451
Mar 17 21:13:17 storage1 kernel: [119278.501479] Hardware name: Supermi=
cro=20
X8DTN/X8DTN, BIOS 2.1c       10/28/2011
Mar 17 21:13:17 storage1 kernel: [119278.501481] task: ffff8808f86c2740=
 ti:=20
ffff8808e7234000 task.ti: ffff8808e7234000
Mar 17 21:13:17 storage1 kernel: [119278.501484] RIP: 0010:
[<ffffffffc0982e35>]  [<ffffffffc0982e35>]=20
iscsit_remove_cmd_from_immediate_queue+0x25/0x120 [iscsi_target_mod]
Mar 17 21:13:17 storage1 kernel: [119278.501501] RSP: 0018:ffff8808e723=
7ce8 =20
EFLAGS: 00000246
Mar 17 21:13:17 storage1 kernel: [119278.501503] RAX: 0000000096da96da =
RBX:=20
0000000000000001 RCX: 00000000f9a9b4a6
Mar 17 21:13:17 storage1 kernel: [119278.501505] RDX: 00000000000096da =
RSI:=20
ffff881081bbc800 RDI: ffff881081bbcbe8
Mar 17 21:13:17 storage1 kernel: [119278.501507] RBP: ffff8808e7237d08 =
R08:=20
ffff880f45d68410 R09: 0000000000000101
Mar 17 21:13:17 storage1 kernel: [119278.501509] R10: 0000000000000001 =
R11:=20
000000000000001d R12: ffffffffffffff10
Mar 17 21:13:17 storage1 kernel: [119278.501511] R13: ffff8808e7237cd8 =
R14:=20
ffff880f45d68350 R15: 00000000f9ac4872
Mar 17 21:13:17 storage1 kernel: [119278.501513] FS:  0000000000000000(=
0000)=20
GS:ffff88091bc20000(0000) knlGS:0000000000000000
Mar 17 21:13:17 storage1 kernel: [119278.501516] CS:  0010 DS: 0000 ES:=
 0000=20
CR0: 000000008005003b
Mar 17 21:13:17 storage1 kernel: [119278.501518] CR2: 00000000012bb100 =
CR3:=20
0000000001c15000 CR4: 00000000000007e0
Mar 17 21:13:17 storage1 kernel: [119278.501520] Stack:
Mar 17 21:13:17 storage1 kernel: [119278.501521]  ffff880f45d68140=20
ffff881081bbc800 0000000000000001 ffff880f45d68350
Mar 17 21:13:17 storage1 kernel: [119278.501525]  ffff8808e7237d38=20
ffffffffc0984230 ffffffffc098d30b ffff880f45d68140
Mar 17 21:13:17 storage1 kernel: [119278.501528]  0000000000000001=20
0000000000000001 ffff8808e7237d78 ffffffffc098433e
Mar 17 21:13:17 storage1 kernel: [119278.501531] Call Trace:
Mar 17 21:13:17 storage1 kernel: [119278.501545]  [<ffffffffc0984230>]=20
__iscsit_free_cmd+0x50/0xa0 [iscsi_target_mod]
Mar 17 21:13:17 storage1 kernel: [119278.501557]  [<ffffffffc098d30b>] =
?=20
iscsit_close_connection+0x3ab/0x640 [iscsi_target_mod]
Mar 17 21:13:17 storage1 kernel: [119278.501568]  [<ffffffffc098433e>]=20
iscsit_free_cmd+0xbe/0x160 [iscsi_target_mod]
Mar 17 21:13:17 storage1 kernel: [119278.501580]  [<ffffffffc098d324>]=20
iscsit_close_connection+0x3c4/0x640 [iscsi_target_mod]
Mar 17 21:13:17 storage1 kernel: [119278.501590]  [<ffffffffc0978a63>]=20
iscsit_take_action_for_connection_exit+0x83/0x110 [iscsi_target_mod]
Mar 17 21:13:17 storage1 kernel: [119278.501601]  [<ffffffffc098c3ee>]=20
iscsi_target_rx_thread+0x22e/0x320 [iscsi_target_mod]
Mar 17 21:13:17 storage1 kernel: [119278.501613]  [<ffffffffc098c1c0>] =
?=20
iscsi_target_tx_thread+0x220/0x220 [iscsi_target_mod]
Mar 17 21:13:17 storage1 kernel: [119278.501619]  [<ffffffff81095d59>]=20
kthread+0xc9/0xe0
Mar 17 21:13:17 storage1 kernel: [119278.501624]  [<ffffffff81095c90>] =
?=20
flush_kthread_worker+0x90/0x90
Mar 17 21:13:17 storage1 kernel: [119278.501629]  [<ffffffff817d1e7c>]=20
ret_from_fork+0x7c/0xb0
Mar 17 21:13:17 storage1 kernel: [119278.501632]  [<ffffffff81095c90>] =
?=20
flush_kthread_worker+0x90/0x90
Mar 17 21:13:17 storage1 kernel: [119278.501634] Code: 84 00 00 00 00 0=
0 66=20
66 66 66 90 55 48 89 e5 41 56 4c 8d b6 e8 03 00 00 41 55 49 89 f5 41 54=
 49=20
89 fc 4c 89 f7 53 e8 6b e7 e4 c0 <41> 8b 84 24 d8 00 00 00 85 c0 0f 84 =
ab 00=20
00 00 49 8b 85 50 04=20
Mar 17 21:13:45 storage1 kernel: [119306.513810] NMI watchdog: BUG: sof=
t=20
lockup - CPU#1 stuck for 22s! [iscsi_trx:5637]
Mar 17 21:13:45 storage1 kernel: [119306.516944] Modules linked in:=20
ib_srpt(E) tcm_qla2xxx(E) tcm_loop(E) tcm_fc(E) iscsi_target_mod(E)=20
target_core_user(E) uio(E) target_core_pscsi(E) target_core_file(E)=20
target_core_iblock(E) target_core_mod(E) ib_cm(E) ib_sa(E) ib_mad(E)=20
ib_core(E) ib_addr(E) qla2xxx(E) libfc(E) scsi_transport_fc(E) configfs=
(E)=20
nfsd(E) auth_rpcgss(E) nfs_acl(E) nfs(E) lockd(E) grace(E) sunrpc(E)=20
fscache(E) gpio_ich(E) amdkfd(E) amd_iommu_v2(E) coretemp(E) kvm_intel(=
E)=20
kvm(E) radeon(E) serio_raw(E) 8021q(E) joydev(E) garp(E) ttm(E) mrp(E)=20
stp(E) llc(E) drm_kms_helper(E) drm(E) lpc_ich(E) i7core_edac(E)=20
edac_core(E) i5500_temp(E) ioatdma(E) 8250_fintek(E) mac_hid(E) shpchp(=
E)=20
bonding(E) btrfs(E) raid456(E) async_raid6_recov(E) async_memcpy(E)=20
bcache(E) async_pq(E) async_xor(E) raid10(E) async_tx(E) xor(E) raid6_p=
q(E)=20
raid1(E) hid_generic(E) raid0(E) multipath(E) igb(E) mpt2sas(E) ixgbe(E=
)=20
linear(E) raid_class(E) pata_acpi(E) i2c_algo_bit(E) dca(E) usbhid(E)=20
scsi_transport_sas(E) hid(E) ahci(E) pata_jmicron(E) psmouse(E) mdio(E)=
=20
ptp(E) libahci(E) pps_core(E) [last unloaded: target_core_mod]
Mar 17 21:13:45 storage1 kernel: [119306.517024] CPU: 1 PID: 5637 Comm:=
=20
iscsi_trx Tainted: G            EL 3.19.0-031900-generic #201502091451
Mar 17 21:13:45 storage1 kernel: [119306.517026] Hardware name: Supermi=
cro=20
X8DTN/X8DTN, BIOS 2.1c       10/28/2011
Mar 17 21:13:45 storage1 kernel: [119306.517029] task: ffff8808f86c2740=
 ti:=20
ffff8808e7234000 task.ti: ffff8808e7234000
Mar 17 21:13:45 storage1 kernel: [119306.517031] RIP: 0010:
[<ffffffff817d1612>]  [<ffffffff817d1612>] _raw_spin_unlock_bh+0x12/0x4=
0
Mar 17 21:13:45 storage1 kernel: [119306.517040] RSP: 0018:ffff8808e723=
7cd8 =20
EFLAGS: 00000282
Mar 17 21:13:45 storage1 kernel: [119306.517042] RAX: 0000000000000000 =
RBX:=20
0000000000000042 RCX: ffff880f45d68340
Mar 17 21:13:45 storage1 kernel: [119306.517044] RDX: 0000000000009a48 =
RSI:=20
ffff881081bbc800 RDI: ffff881081bbcbf0
Mar 17 21:13:45 storage1 kernel: [119306.517046] RBP: ffff8808e7237cd8 =
R08:=20
ffff880f45d68410 R09: 0000000000000101
Mar 17 21:13:45 storage1 kernel: [119306.517048] R10: 0000000000000042 =
R11:=20
0000000000000000 R12: 000000000000f8ec
Mar 17 21:13:45 storage1 kernel: [119306.517050] R13: ffff8808e7237cc8 =
R14:=20
ffff880f45d68410 R15: 0000000000000101
Mar 17 21:13:45 storage1 kernel: [119306.517053] FS:  0000000000000000(=
0000)=20
GS:ffff88091bc20000(0000) knlGS:0000000000000000
Mar 17 21:13:45 storage1 kernel: [119306.517055] CS:  0010 DS: 0000 ES:=
 0000=20
CR0: 000000008005003b
Mar 17 21:13:45 storage1 kernel: [119306.517057] CR2: 00000000012bb100 =
CR3:=20
0000000001c15000 CR4: 00000000000007e0
Mar 17 21:13:45 storage1 kernel: [119306.517059] Stack:
Mar 17 21:13:45 storage1 kernel: [119306.517060]  ffff8808e7237d08=20
ffffffffc0983018 ffff880f45d68140 ffff881081bbc800
Mar 17 21:13:45 storage1 kernel: [119306.517064]  0000000000000001=20
ffff880f45d68350 ffff8808e7237d38 ffffffffc098423b
Mar 17 21:13:45 storage1 kernel: [119306.517067]  ffffffffc09841e0=20
ffff880f45d68140 0000000000000001 0000000000000001
Mar 17 21:13:45 storage1 kernel: [119306.517070] Call Trace:
Mar 17 21:13:45 storage1 kernel: [119306.517086]  [<ffffffffc0983018>]=20
iscsit_remove_cmd_from_response_queue+0xe8/0x120 [iscsi_target_mod]
Mar 17 21:13:45 storage1 kernel: [119306.517098]  [<ffffffffc098423b>]=20
__iscsit_free_cmd+0x5b/0xa0 [iscsi_target_mod]
Mar 17 21:13:45 storage1 kernel: [119306.517110]  [<ffffffffc09841e0>] =
?=20
iscsit_free_queue_reqs_for_conn+0x150/0x150 [iscsi_target_mod]
Mar 17 21:13:45 storage1 kernel: [119306.517121]  [<ffffffffc098430b>]=20
iscsit_free_cmd+0x8b/0x160 [iscsi_target_mod]
Mar 17 21:13:45 storage1 kernel: [119306.517133]  [<ffffffffc098d324>]=20
iscsit_close_connection+0x3c4/0x640 [iscsi_target_mod]
Mar 17 21:13:45 storage1 kernel: [119306.517142]  [<ffffffffc0978a63>]=20
iscsit_take_action_for_connection_exit+0x83/0x110 [iscsi_target_mod]
Mar 17 21:13:45 storage1 kernel: [119306.517154]  [<ffffffffc098c3ee>]=20
iscsi_target_rx_thread+0x22e/0x320 [iscsi_target_mod]
Mar 17 21:13:45 storage1 kernel: [119306.517166]  [<ffffffffc098c1c0>] =
?=20
iscsi_target_tx_thread+0x220/0x220 [iscsi_target_mod]
Mar 17 21:13:45 storage1 kernel: [119306.517170]  [<ffffffff81095d59>]=20
kthread+0xc9/0xe0
Mar 17 21:13:45 storage1 kernel: [119306.517174]  [<ffffffff81095c90>] =
?=20
flush_kthread_worker+0x90/0x90
Mar 17 21:13:45 storage1 kernel: [119306.517178]  [<ffffffff817d1e7c>]=20
ret_from_fork+0x7c/0xb0
Mar 17 21:13:45 storage1 kernel: [119306.517182]  [<ffffffff81095c90>] =
?=20
flush_kthread_worker+0x90/0x90
Mar 17 21:13:45 storage1 kernel: [119306.517184] Code: 0f b7 0f 66 39 c=
a 75=20
f1 5d c3 66 66 66 90 66 66 90 eb d5 66 0f 1f 44 00 00 66 66 66 66 90 55=
 48=20
89 e5 66 66 66 66 90 66 83 07 02 <48> 8b 7d 08 be 00 02 00 00 e8 20 99 =
8a ff=20
5d c3 66 0f 1f 44 00=20
Mar 17 21:13:52 storage1 kernel: [119313.337597] INFO: rcu_sched self-
detected stall on CPU { 1}  (t=3D15000 jiffies g=3D3864139 c=3D3864138 =
q=3D0)
Mar 17 21:13:52 storage1 kernel: [119313.340805] Task dump for CPU 1:
Mar 17 21:13:52 storage1 kernel: [119313.340808] iscsi_trx       R  run=
ning=20
task        0  5637      2 0x0000000c
Mar 17 21:13:52 storage1 kernel: [119313.340812]  ffffffff81c54d00=20
ffff88091bc23d18 ffffffff810a3364 0000000000000001
Mar 17 21:13:52 storage1 kernel: [119313.340815]  ffffffff81c54d00=20
ffff88091bc23d38 ffffffff810a5fdf ffff88091bc23d78
Mar 17 21:13:52 storage1 kernel: [119313.340818]  ffffffff81c54e00=20
ffff88091bc23d68 ffffffff810d686b ffffffff81c54d00
Mar 17 21:13:52 storage1 kernel: [119313.340821] Call Trace:
Mar 17 21:13:52 storage1 kernel: [119313.340824]  <IRQ> =20
[<ffffffff810a3364>] sched_show_task+0xb4/0x120
Mar 17 21:13:52 storage1 kernel: [119313.340834]  [<ffffffff810a5fdf>]=20
dump_cpu_task+0x3f/0x50
Mar 17 21:13:52 storage1 kernel: [119313.340839]  [<ffffffff810d686b>]=20
rcu_dump_cpu_stacks+0x8b/0xc0
Mar 17 21:13:52 storage1 kernel: [119313.340843]  [<ffffffff810d8447>]=20
print_cpu_stall+0xd7/0x140
Mar 17 21:13:52 storage1 kernel: [119313.340848]  [<ffffffff810d8e65>]=20
check_cpu_stall.isra.55+0xa5/0xb0
Mar 17 21:13:52 storage1 kernel: [119313.340852]  [<ffffffff810d8ea8>]=20
__rcu_pending+0x38/0x170
Mar 17 21:13:52 storage1 kernel: [119313.340856]  [<ffffffff810da9dd>]=20
rcu_check_callbacks+0x9d/0x190
Mar 17 21:13:52 storage1 kernel: [119313.340860]  [<ffffffff810dfd08>]=20
update_process_times+0x38/0x70
Mar 17 21:13:52 storage1 kernel: [119313.340866]  [<ffffffff810ef9f3>]=20
tick_sched_handle.isra.12+0x33/0x70
Mar 17 21:13:52 storage1 kernel: [119313.340869]  [<ffffffff810efb2b>]=20
tick_sched_timer+0x4b/0x80
Mar 17 21:13:52 storage1 kernel: [119313.340873]  [<ffffffff810e07c6>]=20
__run_hrtimer+0x76/0x230
Mar 17 21:13:52 storage1 kernel: [119313.340877]  [<ffffffff810efae0>] =
?=20
tick_nohz_handler+0xb0/0xb0
Mar 17 21:13:52 storage1 kernel: [119313.340881]  [<ffffffff810e0fcf>]=20
hrtimer_interrupt+0xff/0x260
Mar 17 21:13:52 storage1 kernel: [119313.340887]  [<ffffffff8104c339>]=20
local_apic_timer_interrupt+0x39/0x60
Mar 17 21:13:52 storage1 kernel: [119313.340892]  [<ffffffff817d4f45>]=20
smp_apic_timer_interrupt+0x45/0x60
Mar 17 21:13:52 storage1 kernel: [119313.340895]  [<ffffffff817d2fbd>]=20
apic_timer_interrupt+0x6d/0x80
Mar 17 21:13:52 storage1 kernel: [119313.340897]  <EOI> =20
[<ffffffffc09833a6>] ? iscsit_free_r2ts_from_list+0x16/0x80=20
[iscsi_target_mod]
Mar 17 21:13:52 storage1 kernel: [119313.340921]  [<ffffffffc098426d>]=20
__iscsit_free_cmd+0x8d/0xa0 [iscsi_target_mod]
Mar 17 21:13:52 storage1 kernel: [119313.340939]  [<ffffffffc0b9323a>] =
?=20
target_put_sess_cmd+0x4a/0xd0 [target_core_mod]
Mar 17 21:13:52 storage1 kernel: [119313.340950]  [<ffffffffc098430b>]=20
iscsit_free_cmd+0x8b/0x160 [iscsi_target_mod]
Mar 17 21:13:52 storage1 kernel: [119313.340962]  [<ffffffffc098d324>]=20
iscsit_close_connection+0x3c4/0x640 [iscsi_target_mod]
Mar 17 21:13:52 storage1 kernel: [119313.340972]  [<ffffffffc0978a63>]=20
iscsit_take_action_for_connection_exit+0x83/0x110 [iscsi_target_mod]
Mar 17 21:13:52 storage1 kernel: [119313.340983]  [<ffffffffc098c3ee>]=20
iscsi_target_rx_thread+0x22e/0x320 [iscsi_target_mod]
Mar 17 21:13:52 storage1 kernel: [119313.340995]  [<ffffffffc098c1c0>] =
?=20
iscsi_target_tx_thread+0x220/0x220 [iscsi_target_mod]
Mar 17 21:13:52 storage1 kernel: [119313.340999]  [<ffffffff81095d59>]=20
kthread+0xc9/0xe0
Mar 17 21:13:52 storage1 kernel: [119313.341002]  [<ffffffff81095c90>] =
?=20
flush_kthread_worker+0x90/0x90
Mar 17 21:13:52 storage1 kernel: [119313.341006]  [<ffffffff817d1e7c>]=20
ret_from_fork+0x7c/0xb0
Mar 17 21:13:52 storage1 kernel: [119313.341010]  [<ffffffff81095c90>] =
?=20
flush_kthread_worker+0x90/0x90
Mar 17 21:14:17 storage1 kernel: [119338.531583] NMI watchdog: BUG: sof=
t=20
lockup - CPU#1 stuck for 22s! [iscsi_trx:5637]
Mar 17 21:14:17 storage1 kernel: [119338.534777] Modules linked in:=20
ib_srpt(E) tcm_qla2xxx(E) tcm_loop(E) tcm_fc(E) iscsi_target_mod(E)=20
target_core_user(E) uio(E) target_core_pscsi(E) target_core_file(E)=20
target_core_iblock(E) target_core_mod(E) ib_cm(E) ib_sa(E) ib_mad(E)=20
ib_core(E) ib_addr(E) qla2xxx(E) libfc(E) scsi_transport_fc(E) configfs=
(E)=20
nfsd(E) auth_rpcgss(E) nfs_acl(E) nfs(E) lockd(E) grace(E) sunrpc(E)=20
fscache(E) gpio_ich(E) amdkfd(E) amd_iommu_v2(E) coretemp(E) kvm_intel(=
E)=20
kvm(E) radeon(E) serio_raw(E) 8021q(E) joydev(E) garp(E) ttm(E) mrp(E)=20
stp(E) llc(E) drm_kms_helper(E) drm(E) lpc_ich(E) i7core_edac(E)=20
edac_core(E) i5500_temp(E) ioatdma(E) 8250_fintek(E) mac_hid(E) shpchp(=
E)=20
bonding(E) btrfs(E) raid456(E) async_raid6_recov(E) async_memcpy(E)=20
bcache(E) async_pq(E) async_xor(E) raid10(E) async_tx(E) xor(E) raid6_p=
q(E)=20
raid1(E) hid_generic(E) raid0(E) multipath(E) igb(E) mpt2sas(E) ixgbe(E=
)=20
linear(E) raid_class(E) pata_acpi(E) i2c_algo_bit(E) dca(E) usbhid(E)=20
scsi_transport_sas(E) hid(E) ahci(E) pata_jmicron(E) psmouse(E) mdio(E)=
=20
ptp(E) libahci(E) pps_core(E) [last unloaded: target_core_mod]
Mar 17 21:14:17 storage1 kernel: [119338.534843] CPU: 1 PID: 5637 Comm:=
=20
iscsi_trx Tainted: G            EL 3.19.0-031900-generic #201502091451
Mar 17 21:14:17 storage1 kernel: [119338.534845] Hardware name: Supermi=
cro=20
X8DTN/X8DTN, BIOS 2.1c       10/28/2011
Mar 17 21:14:17 storage1 kernel: [119338.534848] task: ffff8808f86c2740=
 ti:=20
ffff8808e7234000 task.ti: ffff8808e7234000
Mar 17 21:14:17 storage1 kernel: [119338.534850] RIP: 0010:
[<ffffffff817d15c7>]  [<ffffffff817d15c7>] _raw_spin_lock_bh+0x27/0x60
Mar 17 21:14:17 storage1 kernel: [119338.534856] RSP: 0018:ffff8808e723=
7ce8 =20
EFLAGS: 00000246
Mar 17 21:14:17 storage1 kernel: [119338.534858] RAX: 000000008f2e8f2e =
RBX:=20
ffff880f45d68410 RCX: 00000000eab4386c
Mar 17 21:14:17 storage1 kernel: [119338.534860] RDX: 0000000000008f2e =
RSI:=20
0000000000000001 RDI: ffff880f45d68224
Mar 17 21:14:17 storage1 kernel: [119338.534862] RBP: ffff8808e7237ce8 =
R08:=20
ffff880f45d68410 R09: 0000000000000101
Mar 17 21:14:17 storage1 kernel: [119338.534864] R10: 0000000000000001 =
R11:=20
000000000000001d R12: 0000000000000001
Mar 17 21:14:17 storage1 kernel: [119338.534866] R13: 000000000000001d =
R14:=20
0000000000000001 R15: ffff8808e7237cc8
Mar 17 21:14:17 storage1 kernel: [119338.534868] FS:  0000000000000000(=
0000)=20
GS:ffff88091bc20000(0000) knlGS:0000000000000000
Mar 17 21:14:17 storage1 kernel: [119338.534871] CS:  0010 DS: 0000 ES:=
 0000=20
CR0: 000000008005003b
Mar 17 21:14:17 storage1 kernel: [119338.534873] CR2: 00000000012bb100 =
CR3:=20
0000000001c15000 CR4: 00000000000007e0
Mar 17 21:14:17 storage1 kernel: [119338.534874] Stack:
Mar 17 21:14:17 storage1 kernel: [119338.534876]  ffff8808e7237d08=20
ffffffffc09792a7 ffff880f45d68140 ffff881081bbc800
Mar 17 21:14:17 storage1 kernel: [119338.534879]  ffff8808e7237d38=20
ffffffffc0984265 00ff0000000000ff ffff880f45d68140
Mar 17 21:14:17 storage1 kernel: [119338.534882]  0000000000000001=20
0000000000000001 ffff8808e7237d78 ffffffffc098433e
Mar 17 21:14:17 storage1 kernel: [119338.534886] Call Trace:
Mar 17 21:14:17 storage1 kernel: [119338.534898]  [<ffffffffc09792a7>]=20
iscsit_stop_dataout_timer+0x27/0x90 [iscsi_target_mod]
Mar 17 21:14:17 storage1 kernel: [119338.534910]  [<ffffffffc0984265>]=20
__iscsit_free_cmd+0x85/0xa0 [iscsi_target_mod]
Mar 17 21:14:17 storage1 kernel: [119338.534921]  [<ffffffffc098433e>]=20
iscsit_free_cmd+0xbe/0x160 [iscsi_target_mod]
Mar 17 21:14:17 storage1 kernel: [119338.534931]  [<ffffffffc0977643>] =
?=20
iscsit_increment_maxcmdsn+0x13/0x90 [iscsi_target_mod]
Mar 17 21:14:17 storage1 kernel: [119338.534942]  [<ffffffffc098d324>]=20
iscsit_close_connection+0x3c4/0x640 [iscsi_target_mod]
Mar 17 21:14:17 storage1 kernel: [119338.534952]  [<ffffffffc0978a63>]=20
iscsit_take_action_for_connection_exit+0x83/0x110 [iscsi_target_mod]
Mar 17 21:14:17 storage1 kernel: [119338.534963]  [<ffffffffc098c3ee>]=20
iscsi_target_rx_thread+0x22e/0x320 [iscsi_target_mod]
Mar 17 21:14:17 storage1 kernel: [119338.534975]  [<ffffffffc098c1c0>] =
?=20
iscsi_target_tx_thread+0x220/0x220 [iscsi_target_mod]
Mar 17 21:14:17 storage1 kernel: [119338.534979]  [<ffffffff81095d59>]=20
kthread+0xc9/0xe0
Mar 17 21:14:17 storage1 kernel: [119338.534983]  [<ffffffff81095c90>] =
?=20
flush_kthread_worker+0x90/0x90
Mar 17 21:14:17 storage1 kernel: [119338.534987]  [<ffffffff817d1e7c>]=20
ret_from_fork+0x7c/0xb0
Mar 17 21:14:17 storage1 kernel: [119338.534990]  [<ffffffff81095c90>] =
?=20
flush_kthread_worker+0x90/0x90
Mar 17 21:14:17 storage1 kernel: [119338.534992] Code: 00 00 00 00 66 6=
6 66=20
66 90 55 65 81 05 ef a2 83 7e 00 02 00 00 48 89 e5 b8 00 00 02 00 f0 0f=
 c1=20
07 89 c2 c1 ea 10 66 39 c2 75 02 <5d> c3 83 e2 fe 0f b7 f2 b8 00 80 00 =
00 eb=20
11 66 2e 0f 1f 84 00=20
Mar 17 21:14:45 storage1 kernel: [119366.547135] NMI watchdog: BUG: sof=
t=20
lockup - CPU#1 stuck for 22s! [iscsi_trx:5637]
Mar 17 21:14:45 storage1 kernel: [119366.550324] Modules linked in:=20
ib_srpt(E) tcm_qla2xxx(E) tcm_loop(E) tcm_fc(E) iscsi_target_mod(E)=20
target_core_user(E) uio(E) target_core_pscsi(E) target_core_file(E)=20
target_core_iblock(E) target_core_mod(E) ib_cm(E) ib_sa(E) ib_mad(E)=20
ib_core(E) ib_addr(E) qla2xxx(E) libfc(E) scsi_transport_fc(E) configfs=
(E)=20
nfsd(E) auth_rpcgss(E) nfs_acl(E) nfs(E) lockd(E) grace(E) sunrpc(E)=20
fscache(E) gpio_ich(E) amdkfd(E) amd_iommu_v2(E) coretemp(E) kvm_intel(=
E)=20
kvm(E) radeon(E) serio_raw(E) 8021q(E) joydev(E) garp(E) ttm(E) mrp(E)=20
stp(E) llc(E) drm_kms_helper(E) drm(E) lpc_ich(E) i7core_edac(E)=20
edac_core(E) i5500_temp(E) ioatdma(E) 8250_fintek(E) mac_hid(E) shpchp(=
E)=20
bonding(E) btrfs(E) raid456(E) async_raid6_recov(E) async_memcpy(E)=20
bcache(E) async_pq(E) async_xor(E) raid10(E) async_tx(E) xor(E) raid6_p=
q(E)=20
raid1(E) hid_generic(E) raid0(E) multipath(E) igb(E) mpt2sas(E) ixgbe(E=
)=20
linear(E) raid_class(E) pata_acpi(E) i2c_algo_bit(E) dca(E) usbhid(E)=20
scsi_transport_sas(E) hid(E) ahci(E) pata_jmicron(E) psmouse(E) mdio(E)=
=20
ptp(E) libahci(E) pps_core(E) [last unloaded: target_core_mod]
Mar 17 21:14:45 storage1 kernel: [119366.550388] CPU: 1 PID: 5637 Comm:=
=20
iscsi_trx Tainted: G            EL 3.19.0-031900-generic #201502091451
Mar 17 21:14:45 storage1 kernel: [119366.550390] Hardware name: Supermi=
cro=20
X8DTN/X8DTN, BIOS 2.1c       10/28/2011
Mar 17 21:14:45 storage1 kernel: [119366.550393] task: ffff8808f86c2740=
 ti:=20
ffff8808e7234000 task.ti: ffff8808e7234000
Mar 17 21:14:45 storage1 kernel: [119366.550395] RIP: 0010:
[<ffffffff8107af81>]  [<ffffffff8107af81>] __local_bh_enable_ip+0x41/0x=
90
Mar 17 21:14:45 storage1 kernel: [119366.550401] RSP: 0018:ffff8808e723=
7cb8 =20
EFLAGS: 00000246
Mar 17 21:14:45 storage1 kernel: [119366.550403] RAX: 0000000000000000 =
RBX:=20
00000000e3bd91ab RCX: 00000000e3b8754e
Mar 17 21:14:45 storage1 kernel: [119366.550405] RDX: 000000000000158a =
RSI:=20
0000000000000200 RDI: ffffffffc0982ef8
Mar 17 21:14:45 storage1 kernel: [119366.550407] RBP: ffff8808e7237cc8 =
R08:=20
ffff880f45d68410 R09: 0000000000000101
Mar 17 21:14:45 storage1 kernel: [119366.550409] R10: 0000000000000042 =
R11:=20
0000000000000000 R12: ffff880f45d68410
Mar 17 21:14:45 storage1 kernel: [119366.550411] R13: 0000000000000101 =
R14:=20
0000000000000001 R15: dead000000200200
Mar 17 21:14:45 storage1 kernel: [119366.550414] FS:  0000000000000000(=
0000)=20
GS:ffff88091bc20000(0000) knlGS:0000000000000000
Mar 17 21:14:45 storage1 kernel: [119366.550416] CS:  0010 DS: 0000 ES:=
 0000=20
CR0: 000000008005003b
Mar 17 21:14:45 storage1 kernel: [119366.550418] CR2: 00000000012bb100 =
CR3:=20
0000000001c15000 CR4: 00000000000007e0
Mar 17 21:14:45 storage1 kernel: [119366.550420] Stack:
Mar 17 21:14:45 storage1 kernel: [119366.550421]  0000000000000000=20
ffff880f45d68140 ffff8808e7237cd8 ffffffff817d1620
Mar 17 21:14:45 storage1 kernel: [119366.550424]  ffff8808e7237d08=20
ffffffffc0982ef8 ffff880f45d68140 ffff881081bbc800
Mar 17 21:14:45 storage1 kernel: [119366.550427]  0000000000000001=20
ffff880f45d68350 ffff8808e7237d38 ffffffffc0984230
Mar 17 21:14:45 storage1 kernel: [119366.550431] Call Trace:
Mar 17 21:14:45 storage1 kernel: [119366.550436]  [<ffffffff817d1620>]=20
_raw_spin_unlock_bh+0x20/0x40
Mar 17 21:14:45 storage1 kernel: [119366.550449]  [<ffffffffc0982ef8>]=20
iscsit_remove_cmd_from_immediate_queue+0xe8/0x120 [iscsi_target_mod]
Mar 17 21:14:45 storage1 kernel: [119366.550460]  [<ffffffffc0984230>]=20
__iscsit_free_cmd+0x50/0xa0 [iscsi_target_mod]
Mar 17 21:14:45 storage1 kernel: [119366.550471]  [<ffffffffc098433e>]=20
iscsit_free_cmd+0xbe/0x160 [iscsi_target_mod]
Mar 17 21:14:45 storage1 kernel: [119366.550483]  [<ffffffffc098d324>]=20
iscsit_close_connection+0x3c4/0x640 [iscsi_target_mod]
Mar 17 21:14:45 storage1 kernel: [119366.550493]  [<ffffffffc0978a63>]=20
iscsit_take_action_for_connection_exit+0x83/0x110 [iscsi_target_mod]
Mar 17 21:14:45 storage1 kernel: [119366.550504]  [<ffffffffc098c3ee>]=20
iscsi_target_rx_thread+0x22e/0x320 [iscsi_target_mod]
Mar 17 21:14:45 storage1 kernel: [119366.550516]  [<ffffffffc098c1c0>] =
?=20
iscsi_target_tx_thread+0x220/0x220 [iscsi_target_mod]
Mar 17 21:14:45 storage1 kernel: [119366.550520]  [<ffffffff81095d59>]=20
kthread+0xc9/0xe0
Mar 17 21:14:45 storage1 kernel: [119366.550524]  [<ffffffff81095c90>] =
?=20
flush_kthread_worker+0x90/0x90
Mar 17 21:14:45 storage1 kernel: [119366.550528]  [<ffffffff817d1e7c>]=20
ret_from_fork+0x7c/0xb0
Mar 17 21:14:45 storage1 kernel: [119366.550531]  [<ffffffff81095c90>] =
?=20
flush_kthread_worker+0x90/0x90
Mar 17 21:14:45 storage1 kernel: [119366.550533] Code: 7e a9 00 00 0f 0=
0 74=20
32 80 3d 25 48 c7 00 01 75 37 83 eb 01 f7 db 65 01 1d 2d 09 f9 7e 65 8b=
 05=20
26 09 f9 7e a9 00 ff 1f 00 74 37 <65> ff 0d 18 09 f9 7e 48 83 c4 08 5b =
5d c3=20
90 9c 58 66 66 90 66=20
Mar 17 21:15:13 storage1 kernel: [119394.562687] NMI watchdog: BUG: sof=
t=20
lockup - CPU#1 stuck for 22s! [iscsi_trx:5637]
Mar 17 21:15:13 storage1 kernel: [119394.565872] Modules linked in:=20
ib_srpt(E) tcm_qla2xxx(E) tcm_loop(E) tcm_fc(E) iscsi_target_mod(E)=20
target_core_user(E) uio(E) target_core_pscsi(E) target_core_file(E)=20
target_core_iblock(E) target_core_mod(E) ib_cm(E) ib_sa(E) ib_mad(E)=20
ib_core(E) ib_addr(E) qla2xxx(E) libfc(E) scsi_transport_fc(E) configfs=
(E)=20
nfsd(E) auth_rpcgss(E) nfs_acl(E) nfs(E) lockd(E) grace(E) sunrpc(E)=20
fscache(E) gpio_ich(E) amdkfd(E) amd_iommu_v2(E) coretemp(E) kvm_intel(=
E)=20
kvm(E) radeon(E) serio_raw(E) 8021q(E) joydev(E) garp(E) ttm(E) mrp(E)=20
stp(E) llc(E) drm_kms_helper(E) drm(E) lpc_ich(E) i7core_edac(E)=20
edac_core(E) i5500_temp(E) ioatdma(E) 8250_fintek(E) mac_hid(E) shpchp(=
E)=20
bonding(E) btrfs(E) raid456(E) async_raid6_recov(E) async_memcpy(E)=20
bcache(E) async_pq(E) async_xor(E) raid10(E) async_tx(E) xor(E) raid6_p=
q(E)=20
raid1(E) hid_generic(E) raid0(E) multipath(E) igb(E) mpt2sas(E) ixgbe(E=
)=20
linear(E) raid_class(E) pata_acpi(E) i2c_algo_bit(E) dca(E) usbhid(E)=20
scsi_transport_sas(E) hid(E) ahci(E) pata_jmicron(E) psmouse(E) mdio(E)=
=20
ptp(E) libahci(E) pps_core(E) [last unloaded: target_core_mod]
Mar 17 21:15:13 storage1 kernel: [119394.565937] CPU: 1 PID: 5637 Comm:=
=20
iscsi_trx Tainted: G            EL 3.19.0-031900-generic #201502091451
Mar 17 21:15:13 storage1 kernel: [119394.565939] Hardware name: Supermi=
cro=20
X8DTN/X8DTN, BIOS 2.1c       10/28/2011
Mar 17 21:15:13 storage1 kernel: [119394.565941] task: ffff8808f86c2740=
 ti:=20
ffff8808e7234000 task.ti: ffff8808e7234000
Mar 17 21:15:13 storage1 kernel: [119394.565943] RIP: 0010:
[<ffffffff8107af50>]  [<ffffffff8107af50>] __local_bh_enable_ip+0x10/0x=
90
Mar 17 21:15:13 storage1 kernel: [119394.565949] RSP: 0018:ffff8808e723=
7cc8 =20
EFLAGS: 00000292
Mar 17 21:15:13 storage1 kernel: [119394.565951] RAX: 0000000000000000 =
RBX:=20
00000000000091b8 RCX: ffff880f45d68340
Mar 17 21:15:13 storage1 kernel: [119394.565953] RDX: 0000000000002dcc =
RSI:=20
0000000000000200 RDI: ffffffffc09792e9
Mar 17 21:15:13 storage1 kernel: [119394.565955] RBP: ffff8808e7237cd8 =
R08:=20
ffff880f45d68410 R09: 0000000000000101
Mar 17 21:15:13 storage1 kernel: [119394.565957] R10: 0000000000000000 =
R11:=20
000000000000001d R12: ffff880f45d68410
Mar 17 21:15:13 storage1 kernel: [119394.565959] R13: 0000000000000101 =
R14:=20
0000000000000000 R15: 000000000000001d
Mar 17 21:15:13 storage1 kernel: [119394.565962] FS:  0000000000000000(=
0000)=20
GS:ffff88091bc20000(0000) knlGS:0000000000000000
Mar 17 21:15:13 storage1 kernel: [119394.565964] CS:  0010 DS: 0000 ES:=
 0000=20
CR0: 000000008005003b
Mar 17 21:15:13 storage1 kernel: [119394.565966] CR2: 00000000012bb100 =
CR3:=20
0000000001c15000 CR4: 00000000000007e0
Mar 17 21:15:13 storage1 kernel: [119394.565967] Stack:
Mar 17 21:15:13 storage1 kernel: [119394.565969]  ffff8808e7237cd8=20
ffff880f45d68224 ffff8808e7237ce8 ffffffff817d1620
Mar 17 21:15:13 storage1 kernel: [119394.565972]  ffff8808e7237d08=20
ffffffffc09792e9 ffff880f45d68140 ffff881081bbc800
Mar 17 21:15:13 storage1 kernel: [119394.565975]  ffff8808e7237d38=20
ffffffffc0984265 00000000c7d0c7d0 ffff880f45d68140
Mar 17 21:15:13 storage1 kernel: [119394.565979] Call Trace:
Mar 17 21:15:13 storage1 kernel: [119394.565984]  [<ffffffff817d1620>]=20
_raw_spin_unlock_bh+0x20/0x40
Mar 17 21:15:13 storage1 kernel: [119394.565995]  [<ffffffffc09792e9>]=20
iscsit_stop_dataout_timer+0x69/0x90 [iscsi_target_mod]
Mar 17 21:15:13 storage1 kernel: [119394.566007]  [<ffffffffc0984265>]=20
__iscsit_free_cmd+0x85/0xa0 [iscsi_target_mod]
Mar 17 21:15:13 storage1 kernel: [119394.566018]  [<ffffffffc098430b>]=20
iscsit_free_cmd+0x8b/0x160 [iscsi_target_mod]
Mar 17 21:15:13 storage1 kernel: [119394.566030]  [<ffffffffc098d324>]=20
iscsit_close_connection+0x3c4/0x640 [iscsi_target_mod]
Mar 17 21:15:13 storage1 kernel: [119394.566040]  [<ffffffffc0978a63>]=20
iscsit_take_action_for_connection_exit+0x83/0x110 [iscsi_target_mod]
Mar 17 21:15:13 storage1 kernel: [119394.566051]  [<ffffffffc098c3ee>]=20
iscsi_target_rx_thread+0x22e/0x320 [iscsi_target_mod]
Mar 17 21:15:13 storage1 kernel: [119394.566063]  [<ffffffffc098c1c0>] =
?=20
iscsi_target_tx_thread+0x220/0x220 [iscsi_target_mod]
Mar 17 21:15:13 storage1 kernel: [119394.566067]  [<ffffffff81095d59>]=20
kthread+0xc9/0xe0
Mar 17 21:15:13 storage1 kernel: [119394.566071]  [<ffffffff81095c90>] =
?=20
flush_kthread_worker+0x90/0x90
Mar 17 21:15:13 storage1 kernel: [119394.566075]  [<ffffffff817d1e7c>]=20
ret_from_fork+0x7c/0xb0
Mar 17 21:15:13 storage1 kernel: [119394.566078]  [<ffffffff81095c90>] =
?=20
flush_kthread_worker+0x90/0x90
Mar 17 21:15:13 storage1 kernel: [119394.566080] Code: 89 df 57 9d 66 6=
6 90=20
66 90 48 83 c4 08 5b 5d c3 0f 1f 00 e8 23 8d 75 00 eb e5 90 66 66 66 66=
 90=20
55 48 89 e5 53 89 f3 48 83 ec 08 <65> 8b 05 49 09 f9 7e a9 00 00 0f 00 =
74 32=20
80 3d 25 48 c7 00 01=20
Mar 17 21:15:41 storage1 kernel: [119422.578240] NMI watchdog: BUG: sof=
t=20
lockup - CPU#1 stuck for 22s! [iscsi_trx:5637]
Mar 17 21:15:41 storage1 kernel: [119422.581431] Modules linked in:=20
ib_srpt(E) tcm_qla2xxx(E) tcm_loop(E) tcm_fc(E) iscsi_target_mod(E)=20
target_core_user(E) uio(E) target_core_pscsi(E) target_core_file(E)=20
target_core_iblock(E) target_core_mod(E) ib_cm(E) ib_sa(E) ib_mad(E)=20
ib_core(E) ib_addr(E) qla2xxx(E) libfc(E) scsi_transport_fc(E) configfs=
(E)=20
nfsd(E) auth_rpcgss(E) nfs_acl(E) nfs(E) lockd(E) grace(E) sunrpc(E)=20
fscache(E) gpio_ich(E) amdkfd(E) amd_iommu_v2(E) coretemp(E) kvm_intel(=
E)=20
kvm(E) radeon(E) serio_raw(E) 8021q(E) joydev(E) garp(E) ttm(E) mrp(E)=20
stp(E) llc(E) drm_kms_helper(E) drm(E) lpc_ich(E) i7core_edac(E)=20
edac_core(E) i5500_temp(E) ioatdma(E) 8250_fintek(E) mac_hid(E) shpchp(=
E)=20
bonding(E) btrfs(E) raid456(E) async_raid6_recov(E) async_memcpy(E)=20
bcache(E) async_pq(E) async_xor(E) raid10(E) async_tx(E) xor(E) raid6_p=
q(E)=20
raid1(E) hid_generic(E) raid0(E) multipath(E) igb(E) mpt2sas(E) ixgbe(E=
)=20
linear(E) raid_class(E) pata_acpi(E) i2c_algo_bit(E) dca(E) usbhid(E)=20
scsi_transport_sas(E) hid(E) ahci(E) pata_jmicron(E) psmouse(E) mdio(E)=
=20
ptp(E) libahci(E) pps_core(E) [last unloaded: target_core_mod]
Mar 17 21:15:41 storage1 kernel: [119422.581495] CPU: 1 PID: 5637 Comm:=
=20
iscsi_trx Tainted: G            EL 3.19.0-031900-generic #201502091451
Mar 17 21:15:41 storage1 kernel: [119422.581497] Hardware name: Supermi=
cro=20
X8DTN/X8DTN, BIOS 2.1c       10/28/2011
Mar 17 21:15:41 storage1 kernel: [119422.581499] task: ffff8808f86c2740=
 ti:=20
ffff8808e7234000 task.ti: ffff8808e7234000
Mar 17 21:15:41 storage1 kernel: [119422.581501] RIP: 0010:
[<ffffffff817d15bd>]  [<ffffffff817d15bd>] _raw_spin_lock_bh+0x1d/0x60
Mar 17 21:15:41 storage1 kernel: [119422.581507] RSP: 0018:ffff8808e723=
7ce8 =20
EFLAGS: 00000286
Mar 17 21:15:41 storage1 kernel: [119422.581509] RAX: 00000000c828c828 =
RBX:=20
0000000070000000 RCX: ffff880f45d68340
Mar 17 21:15:41 storage1 kernel: [119422.581511] RDX: 0000000000000001 =
RSI:=20
0000000000000001 RDI: ffff880f45d68224
Mar 17 21:15:41 storage1 kernel: [119422.581513] RBP: ffff8808e7237ce8 =
R08:=20
ffff880f45d68410 R09: 0000000000000101
Mar 17 21:15:41 storage1 kernel: [119422.581515] R10: 0000000000000000 =
R11:=20
0000000000000001 R12: 0000000000000286
Mar 17 21:15:41 storage1 kernel: [119422.581517] R13: ffff8808e7237cd8 =
R14:=20
0000000000003b1e R15: 0000000000000000
Mar 17 21:15:41 storage1 kernel: [119422.581519] FS:  0000000000000000(=
0000)=20
GS:ffff88091bc20000(0000) knlGS:0000000000000000
Mar 17 21:15:41 storage1 kernel: [119422.581521] CS:  0010 DS: 0000 ES:=
 0000=20
CR0: 000000008005003b
Mar 17 21:15:41 storage1 kernel: [119422.581523] CR2: 00000000012bb100 =
CR3:=20
0000000001c15000 CR4: 00000000000007e0
Mar 17 21:15:41 storage1 kernel: [119422.581525] Stack:
Mar 17 21:15:41 storage1 kernel: [119422.581527]  ffff8808e7237d08=20
ffffffffc09792a7 ffff880f45d68140 ffff881081bbc800
Mar 17 21:15:41 storage1 kernel: [119422.581530]  ffff8808e7237d38=20
ffffffffc0984265 000000003cae3cae ffff880f45d68140
Mar 17 21:15:41 storage1 kernel: [119422.581533]  0000000000000001=20
0000000000000001 ffff8808e7237d78 ffffffffc098430b
Mar 17 21:15:41 storage1 kernel: [119422.581536] Call Trace:
Mar 17 21:15:41 storage1 kernel: [119422.581548]  [<ffffffffc09792a7>]=20
iscsit_stop_dataout_timer+0x27/0x90 [iscsi_target_mod]
Mar 17 21:15:41 storage1 kernel: [119422.581560]  [<ffffffffc0984265>]=20
__iscsit_free_cmd+0x85/0xa0 [iscsi_target_mod]
Mar 17 21:15:41 storage1 kernel: [119422.581571]  [<ffffffffc098430b>]=20
iscsit_free_cmd+0x8b/0x160 [iscsi_target_mod]
Mar 17 21:15:41 storage1 kernel: [119422.581583]  [<ffffffffc098d324>]=20
iscsit_close_connection+0x3c4/0x640 [iscsi_target_mod]
Mar 17 21:15:41 storage1 kernel: [119422.581593]  [<ffffffffc0978a63>]=20
iscsit_take_action_for_connection_exit+0x83/0x110 [iscsi_target_mod]
Mar 17 21:15:41 storage1 kernel: [119422.581604]  [<ffffffffc098c3ee>]=20
iscsi_target_rx_thread+0x22e/0x320 [iscsi_target_mod]
Mar 17 21:15:41 storage1 kernel: [119422.581616]  [<ffffffffc098c1c0>] =
?=20
iscsi_target_tx_thread+0x220/0x220 [iscsi_target_mod]
Mar 17 21:15:41 storage1 kernel: [119422.581620]  [<ffffffff81095d59>]=20
kthread+0xc9/0xe0
Mar 17 21:15:41 storage1 kernel: [119422.581624]  [<ffffffff81095c90>] =
?=20
flush_kthread_worker+0x90/0x90
Mar 17 21:15:41 storage1 kernel: [119422.581628]  [<ffffffff817d1e7c>]=20
ret_from_fork+0x7c/0xb0
Mar 17 21:15:41 storage1 kernel: [119422.581631]  [<ffffffff81095c90>] =
?=20
flush_kthread_worker+0x90/0x90
Mar 17 21:15:41 storage1 kernel: [119422.581633] Code: e0 8e ff 5d c3 6=
6 0f=20
1f 84 00 00 00 00 00 66 66 66 66 90 55 65 81 05 ef a2 83 7e 00 02 00 00=
 48=20
89 e5 b8 00 00 02 00 f0 0f c1 07 <89> c2 c1 ea 10 66 39 c2 75 02 5d c3 =
83 e2=20
fe 0f b7 f2 b8 00 80=20
Mar 17 21:16:09 storage1 kernel: [119450.593796] NMI watchdog: BUG: sof=
t=20
lockup - CPU#1 stuck for 23s! [iscsi_trx:5637]
Mar 17 21:16:09 storage1 kernel: [119450.596986] Modules linked in:=20
ib_srpt(E) tcm_qla2xxx(E) tcm_loop(E) tcm_fc(E) iscsi_target_mod(E)=20
target_core_user(E) uio(E) target_core_pscsi(E) target_core_file(E)=20
target_core_iblock(E) target_core_mod(E) ib_cm(E) ib_sa(E) ib_mad(E)=20
ib_core(E) ib_addr(E) qla2xxx(E) libfc(E) scsi_transport_fc(E) configfs=
(E)=20
nfsd(E) auth_rpcgss(E) nfs_acl(E) nfs(E) lockd(E) grace(E) sunrpc(E)=20
fscache(E) gpio_ich(E) amdkfd(E) amd_iommu_v2(E) coretemp(E) kvm_intel(=
E)=20
kvm(E) radeon(E) serio_raw(E) 8021q(E) joydev(E) garp(E) ttm(E) mrp(E)=20
stp(E) llc(E) drm_kms_helper(E) drm(E) lpc_ich(E) i7core_edac(E)=20
edac_core(E) i5500_temp(E) ioatdma(E) 8250_fintek(E) mac_hid(E) shpchp(=
E)=20
bonding(E) btrfs(E) raid456(E) async_raid6_recov(E) async_memcpy(E)=20
bcache(E) async_pq(E) async_xor(E) raid10(E) async_tx(E) xor(E) raid6_p=
q(E)=20
raid1(E) hid_generic(E) raid0(E) multipath(E) igb(E) mpt2sas(E) ixgbe(E=
)=20
linear(E) raid_class(E) pata_acpi(E) i2c_algo_bit(E) dca(E) usbhid(E)=20
scsi_transport_sas(E) hid(E) ahci(E) pata_jmicron(E) psmouse(E) mdio(E)=
=20
ptp(E) libahci(E) pps_core(E) [last unloaded: target_core_mod]
Mar 17 21:16:09 storage1 kernel: [119450.597050] CPU: 1 PID: 5637 Comm:=
=20
iscsi_trx Tainted: G            EL 3.19.0-031900-generic #201502091451
Mar 17 21:16:09 storage1 kernel: [119450.597052] Hardware name: Supermi=
cro=20
X8DTN/X8DTN, BIOS 2.1c       10/28/2011
Mar 17 21:16:09 storage1 kernel: [119450.597054] task: ffff8808f86c2740=
 ti:=20
ffff8808e7234000 task.ti: ffff8808e7234000
Mar 17 21:16:09 storage1 kernel: [119450.597056] RIP: 0010:
[<ffffffff8107af67>]  [<ffffffff8107af67>] __local_bh_enable_ip+0x27/0x=
90
Mar 17 21:16:09 storage1 kernel: [119450.597061] RSP: 0018:ffff8808e723=
7d58 =20
EFLAGS: 00000202
Mar 17 21:16:09 storage1 kernel: [119450.597063] RAX: 0000000000000246 =
RBX:=20
ffffffff817d1620 RCX: ffff880f45d68340
Mar 17 21:16:09 storage1 kernel: [119450.597065] RDX: ffff880f45d68340 =
RSI:=20
0000000000000200 RDI: ffffffffc098d30b
Mar 17 21:16:09 storage1 kernel: [119450.597067] RBP: ffff8808e7237d68 =
R08:=20
ffff880f45d68410 R09: 0000000000000101
Mar 17 21:16:09 storage1 kernel: [119450.597069] R10: 0000000000000001 =
R11:=20
dead000000200200 R12: ffff880f45d68140
Mar 17 21:16:09 storage1 kernel: [119450.597071] R13: 0000000000000000 =
R14:=20
0000000000000246 R15: ffff8808e7237cc8
Mar 17 21:16:09 storage1 kernel: [119450.597074] FS:  0000000000000000(=
0000)=20
GS:ffff88091bc20000(0000) knlGS:0000000000000000
Mar 17 21:16:09 storage1 kernel: [119450.597076] CS:  0010 DS: 0000 ES:=
 0000=20
CR0: 000000008005003b
Mar 17 21:16:09 storage1 kernel: [119450.597078] CR2: 00000000012bb100 =
CR3:=20
0000000001c15000 CR4: 00000000000007e0
Mar 17 21:16:09 storage1 kernel: [119450.597080] Stack:
Mar 17 21:16:09 storage1 kernel: [119450.597081]  ffff8808e66b8800=20
ffff881081bbc800 ffff8808e7237d78 ffffffff817d1620
Mar 17 21:16:09 storage1 kernel: [119450.597085]  ffff8808e7237dd8=20
ffffffffc098d30b ffff8808e7237de8 ffff8808e66b8800
Mar 17 21:16:09 storage1 kernel: [119450.597088]  ffff881081bbcbe0=20
ffff881081bbcc40 ffff8808f86c2740 ffff881081bbc800
Mar 17 21:16:09 storage1 kernel: [119450.597091] Call Trace:
Mar 17 21:16:09 storage1 kernel: [119450.597096]  [<ffffffff817d1620>]=20
_raw_spin_unlock_bh+0x20/0x40
Mar 17 21:16:09 storage1 kernel: [119450.597108]  [<ffffffffc098d30b>]=20
iscsit_close_connection+0x3ab/0x640 [iscsi_target_mod]
Mar 17 21:16:09 storage1 kernel: [119450.597118]  [<ffffffffc0978a63>]=20
iscsit_take_action_for_connection_exit+0x83/0x110 [iscsi_target_mod]
Mar 17 21:16:09 storage1 kernel: [119450.597130]  [<ffffffffc098c3ee>]=20
iscsi_target_rx_thread+0x22e/0x320 [iscsi_target_mod]
Mar 17 21:16:09 storage1 kernel: [119450.597142]  [<ffffffffc098c1c0>] =
?=20
iscsi_target_tx_thread+0x220/0x220 [iscsi_target_mod]
Mar 17 21:16:09 storage1 kernel: [119450.597146]  [<ffffffff81095d59>]=20
kthread+0xc9/0xe0
Mar 17 21:16:09 storage1 kernel: [119450.597149]  [<ffffffff81095c90>] =
?=20
flush_kthread_worker+0x90/0x90
Mar 17 21:16:09 storage1 kernel: [119450.597153]  [<ffffffff817d1e7c>]=20
ret_from_fork+0x7c/0xb0
Mar 17 21:16:09 storage1 kernel: [119450.597157]  [<ffffffff81095c90>] =
?=20
flush_kthread_worker+0x90/0x90
Mar 17 21:16:09 storage1 kernel: [119450.597159] Code: 00 eb e5 90 66 6=
6 66=20
66 90 55 48 89 e5 53 89 f3 48 83 ec 08 65 8b 05 49 09 f9 7e a9 00 00 0f=
 00=20
74 32 80 3d 25 48 c7 00 01 75 37 <83> eb 01 f7 db 65 01 1d 2d 09 f9 7e =
65 8b=20
05 26 09 f9 7e a9 00=20
Mar 17 21:16:26 storage1 kernel: [119466.911040] INFO: task=20
bcache_writebac:425 blocked for more than 120 seconds.
Mar 17 21:16:26 storage1 kernel: [119466.914309]       Tainted: G      =
     =20
EL 3.19.0-031900-generic #201502091451
Mar 17 21:16:26 storage1 kernel: [119466.917723] "echo 0 >=20
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar 17 21:16:26 storage1 kernel: [119466.921191] bcache_writebac D=20
ffff8800ba5dfc38     0   425      2 0x00000000
Mar 17 21:16:26 storage1 kernel: [119466.921194]  ffff8800ba5dfc38=20
ffff88093fffbf00 ffff8800ba5dffd8 0000000000013e40
Mar 17 21:16:26 storage1 kernel: [119466.921197]  ffff88121147db00=20
ffffffff81c1c500 ffff880914cff5c0 ffffffff8101358e
Mar 17 21:16:26 storage1 kernel: [119466.921199]  ffff88090d830bb0=20
7fffffffffffffff ffff880914cff5c0 0000000000000002
Mar 17 21:16:26 storage1 kernel: [119466.921202] Call Trace:
Mar 17 21:16:26 storage1 kernel: [119466.921209]  [<ffffffff8101358e>] =
?=20
__switch_to+0xbe/0x5b0
Mar 17 21:16:26 storage1 kernel: [119466.921212]  [<ffffffff817cdd29>]=20
schedule+0x29/0x70
Mar 17 21:16:26 storage1 kernel: [119466.921215]  [<ffffffff817d0ab5>]=20
schedule_timeout+0x1b5/0x210
Mar 17 21:16:26 storage1 kernel: [119466.921218]  [<ffffffff817cfea7>]=20
__down_common+0xe0/0x134
Mar 17 21:16:26 storage1 kernel: [119466.921221]  [<ffffffff811ccd00>] =
?=20
get_task_policy+0x20/0x60
Mar 17 21:16:26 storage1 kernel: [119466.921224]  [<ffffffff817cff6e>]=20
__down+0x1d/0x1f
Mar 17 21:16:26 storage1 kernel: [119466.921227]  [<ffffffff810bdba1>]=20
down+0x41/0x50
Mar 17 21:16:26 storage1 kernel: [119466.921243]  [<ffffffffc0332744>]=20
read_dirty+0x1f4/0x440 [bcache]
Mar 17 21:16:26 storage1 kernel: [119466.921253]  [<ffffffffc0331cc0>] =
?=20
bch_crc64+0x50/0x50 [bcache]
Mar 17 21:16:26 storage1 kernel: [119466.921262]  [<ffffffffc0332c2c>]=20
bch_writeback_thread+0x15c/0x200 [bcache]
Mar 17 21:16:26 storage1 kernel: [119466.921272]  [<ffffffffc0332ad0>] =
?=20
write_dirty+0xc0/0xc0 [bcache]
Mar 17 21:16:26 storage1 kernel: [119466.921274]  [<ffffffff81095d59>]=20
kthread+0xc9/0xe0
Mar 17 21:16:26 storage1 kernel: [119466.921277]  [<ffffffff81095c90>] =
?=20
flush_kthread_worker+0x90/0x90
Mar 17 21:16:26 storage1 kernel: [119466.921280]  [<ffffffff817d1e7c>]=20
ret_from_fork+0x7c/0xb0
Mar 17 21:16:26 storage1 kernel: [119466.921282]  [<ffffffff81095c90>] =
?=20
flush_kthread_worker+0x90/0x90
Mar 17 21:16:26 storage1 kernel: [119466.921288] INFO: task jbd2/dm-1-8=
:856=20
blocked for more than 120 seconds.
Mar 17 21:16:26 storage1 kernel: [119466.924848]       Tainted: G      =
     =20
EL 3.19.0-031900-generic #201502091451
Mar 17 21:16:26 storage1 kernel: [119466.928460] "echo 0 >=20
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar 17 21:16:26 storage1 kernel: [119466.932112] jbd2/dm-1-8     D=20
ffff88120f917b58     0   856      2 0x00000000
Mar 17 21:16:26 storage1 kernel: [119466.932114]  ffff88120f917b58=20
ffff88120f917b28 ffff88120f917fd8 0000000000013e40
Mar 17 21:16:26 storage1 kernel: [119466.932123]  ffff88121147db00=20
ffff8809157c3ae0 ffff88121171e220 ffff88120f917b58
Mar 17 21:16:26 storage1 kernel: [119466.932125]  ffff88123fc74738=20
ffff88121171e220 ffffffff817ce750 ffff88120f917c10
Mar 17 21:16:26 storage1 kernel: [119466.932127] Call Trace:
Mar 17 21:16:26 storage1 kernel: [119466.932131]  [<ffffffff817ce750>] =
?=20
bit_wait_timeout+0x80/0x80
Mar 17 21:16:26 storage1 kernel: [119466.932133]  [<ffffffff817cdd29>]=20
schedule+0x29/0x70
Mar 17 21:16:26 storage1 kernel: [119466.932135]  [<ffffffff817cddfe>]=20
io_schedule+0x8e/0xd0
Mar 17 21:16:26 storage1 kernel: [119466.932138]  [<ffffffff817ce77c>]=20
bit_wait_io+0x2c/0x50
Mar 17 21:16:26 storage1 kernel: [119466.932146]  [<ffffffff817ce4e5>]=20
__wait_on_bit+0x65/0x90
Mar 17 21:16:26 storage1 kernel: [119466.932150]  [<ffffffff817ce750>] =
?=20
bit_wait_timeout+0x80/0x80
Mar 17 21:16:26 storage1 kernel: [119466.932152]  [<ffffffff817ce63c>]=20
out_of_line_wait_on_bit+0x7c/0x90
Mar 17 21:16:26 storage1 kernel: [119466.932155]  [<ffffffff810b75b0>] =
?=20
wake_atomic_t_function+0x40/0x40
Mar 17 21:16:26 storage1 kernel: [119466.932163]  [<ffffffff81227686>]=20
__wait_on_buffer+0x36/0x40
Mar 17 21:16:26 storage1 kernel: [119466.932167]  [<ffffffff812c3e05>]=20
jbd2_journal_commit_transaction+0x1285/0x1440
Mar 17 21:16:26 storage1 kernel: [119466.932171]  [<ffffffff812c7923>]=20
kjournald2+0xb3/0x230
Mar 17 21:16:26 storage1 kernel: [119466.932174]  [<ffffffff810b7530>] =
?=20
prepare_to_wait_event+0x100/0x100
Mar 17 21:16:26 storage1 kernel: [119466.932176]  [<ffffffff812c7870>] =
?=20
commit_timeout+0x10/0x10
Mar 17 21:16:26 storage1 kernel: [119466.932179]  [<ffffffff81095d59>]=20
kthread+0xc9/0xe0
Mar 17 21:16:26 storage1 kernel: [119466.932181]  [<ffffffff81095c90>] =
?=20
flush_kthread_worker+0x90/0x90
Mar 17 21:16:26 storage1 kernel: [119466.932184]  [<ffffffff817d1e7c>]=20
ret_from_fork+0x7c/0xb0
Mar 17 21:16:26 storage1 kernel: [119466.932186]  [<ffffffff81095c90>] =
?=20
flush_kthread_worker+0x90/0x90
Mar 17 21:16:26 storage1 kernel: [119466.932189] INFO: task jbd2/dm-2-8=
:1322=20
blocked for more than 120 seconds.
Mar 17 21:16:26 storage1 kernel: [119466.935823]       Tainted: G      =
     =20
EL 3.19.0-031900-generic #201502091451
Mar 17 21:16:26 storage1 kernel: [119466.939532] "echo 0 >=20
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar 17 21:16:26 storage1 kernel: [119466.943336] jbd2/dm-2-8     D=20
ffff88120f8efb58     0  1322      2 0x00000000
Mar 17 21:16:26 storage1 kernel: [119466.943339]  ffff88120f8efb58=20
ffff88120f8efb28 ffff88120f8effd8 0000000000013e40
Mar 17 21:16:26 storage1 kernel: [119466.943341]  ffff88121147db00=20
ffff8809157c2740 ffff88120f235850 ffff88120f8efb58
Mar 17 21:16:26 storage1 kernel: [119466.943344]  ffff88123fc34738=20
ffff88120f235850 ffffffff817ce750 ffff88120f8efc10
Mar 17 21:16:26 storage1 kernel: [119466.943351] Call Trace:
Mar 17 21:16:26 storage1 kernel: [119466.943354]  [<ffffffff817ce750>] =
?=20
bit_wait_timeout+0x80/0x80
Mar 17 21:16:26 storage1 kernel: [119466.943357]  [<ffffffff817cdd29>]=20
schedule+0x29/0x70
Mar 17 21:16:26 storage1 kernel: [119466.943359]  [<ffffffff817cddfe>]=20
io_schedule+0x8e/0xd0
Mar 17 21:16:26 storage1 kernel: [119466.943361]  [<ffffffff817ce77c>]=20
bit_wait_io+0x2c/0x50
Mar 17 21:16:26 storage1 kernel: [119466.943363]  [<ffffffff817ce4e5>]=20
__wait_on_bit+0x65/0x90
Mar 17 21:16:26 storage1 kernel: [119466.943366]  [<ffffffff817ce750>] =
?=20
bit_wait_timeout+0x80/0x80
Mar 17 21:16:26 storage1 kernel: [119466.943375]  [<ffffffff817ce63c>]=20
out_of_line_wait_on_bit+0x7c/0x90
Mar 17 21:16:26 storage1 kernel: [119466.943379]  [<ffffffff810b75b0>] =
?=20
wake_atomic_t_function+0x40/0x40
Mar 17 21:16:26 storage1 kernel: [119466.943382]  [<ffffffff81227686>]=20
__wait_on_buffer+0x36/0x40
Mar 17 21:16:26 storage1 kernel: [119466.943384]  [<ffffffff812c3e05>]=20
jbd2_journal_commit_transaction+0x1285/0x1440
Mar 17 21:16:26 storage1 kernel: [119466.943390]  [<ffffffff812c7923>]=20
kjournald2+0xb3/0x230
Mar 17 21:16:26 storage1 kernel: [119466.943394]  [<ffffffff810b7530>] =
?=20
prepare_to_wait_event+0x100/0x100
Mar 17 21:16:26 storage1 kernel: [119466.943397]  [<ffffffff812c7870>] =
?=20
commit_timeout+0x10/0x10
Mar 17 21:16:26 storage1 kernel: [119466.943399]  [<ffffffff81095d59>]=20
kthread+0xc9/0xe0
Mar 17 21:16:26 storage1 kernel: [119466.943402]  [<ffffffff81095c90>] =
?=20
flush_kthread_worker+0x90/0x90
Mar 17 21:16:26 storage1 kernel: [119466.943404]  [<ffffffff817d1e7c>]=20
ret_from_fork+0x7c/0xb0
Mar 17 21:16:26 storage1 kernel: [119466.943407]  [<ffffffff81095c90>] =
?=20
flush_kthread_worker+0x90/0x90

Nicholas A. Bellinger wrote:

> Hi Edgaras,
>=20
> Adding target-devel CC.
>=20
> On Thu, 2015-03-05 at 17:56 +0200, Edgaras Luko=C5=A1evi=C4=8Dius wro=
te:
>> Hello,
>>=20
>> we have a problem. iscsi connection is dropping constantly. After
>> enabling iscsi debug following message popped up after iscsi connect=
ion
>> got lost:
>>=20
>> # Kernel
>> 3.18.6-1.el7.elrepo.x86_64
>>=20
>> Message from syslogd@storage-1 at Mar  5 15:55:12 ...
>>  kernel:NMI watchdog: BUG: soft lockup - CPU#0 stuck for 23s!
>>  [iscsi_trx:11958]
>>=20
>> Message from syslogd@storage-1 at Mar  5 15:55:40 ...
>>  kernel:NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s!
>>  [iscsi_trx:11958]
>>=20
>> Message from syslogd@storage-1 at Mar  5 15:56:08 ...
>>  kernel:NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s!
>>  [iscsi_trx:11958]
>>=20
>> Message from syslogd@storage-1 at Mar  5 15:56:48 ...
>>  kernel:NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s!
>>  [iscsi_trx:11958]
>>=20
>>=20
>> P.S.
>>=20
>> Kernel 3.19 acts same I just don=E2=80=99t have debug messages for i=
t. --
>=20
> Please send along the dmesg output of your system so we can have a lo=
ok
> at the specific soft lockup stack back-traces.
>=20
> Thanks,
>=20
> --nab
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

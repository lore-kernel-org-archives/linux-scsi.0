From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 81861] Oops by mvsas v0.8.16: sas: ataX: end_device-Y:0:Z: dev
 error handler -> general protection fault, RIP: mvs_task_prep_ata+0x80/0x3a0
Date: Tue, 12 Aug 2014 20:09:15 +0000
Message-ID: <bug-81861-11613-eIYP0QR2t3@https.bugzilla.kernel.org/>
References: <bug-81861-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:58571 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606AbaHLUJU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Aug 2014 16:09:20 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C2F9920160
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2014 20:09:18 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 104CF20172
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2014 20:09:16 +0000 (UTC)
In-Reply-To: <bug-81861-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=81861

--- Comment #3 from linux-ide@crashplan.pro ---
Because Ubuntu doesn't provide debug symbols for their mainline kernel builds
<http://comments.gmane.org/gmane.linux.ubuntu.devel.kernel.general/40661> I am
reverting back to their kernel version 3.13.0-24.46

That results in a kernel crash on port 8C: 
BUG: unable to handle kernel NULL pointer dereference at 0000000000000255

Full output:
[   25.212661] mvsas 0000:01:00.0: mvsas: driver version 0.8.16
[   25.212703] mvsas 0000:01:00.0: enabling device (0000 -> 0002)
[   25.213249] mvsas 0000:01:00.0: mvsas: PCI-E x8, Bandwidth Usage: 5.0 Gbps
[   31.994771] scsi5 : mvsas
[   31.995530] sas: phy-5:0 added to port-5:0, phy_mask:0x1 (50014380182cf0e6)
[   31.995564] /build/buildd/linux-3.13.0/drivers/scsi/mvsas/mv_sas.c 1218:set
wide port phy map 1
[   32.005672] sas: phy1 matched wide port0
[   32.005695] sas: phy-5:1 added to port-5:0, phy_mask:0x3 (50014380182cf0e6)
[   32.005720] /build/buildd/linux-3.13.0/drivers/scsi/mvsas/mv_sas.c 1218:set
wide port phy map 3
[   32.025591] sas: phy2 matched wide port0
[   32.025611] sas: phy-5:2 added to port-5:0, phy_mask:0x7 (50014380182cf0e6)
[   32.025635] /build/buildd/linux-3.13.0/drivers/scsi/mvsas/mv_sas.c 1218:set
wide port phy map 7
[   32.055410] sas: phy3 matched wide port0
[   32.055427] sas: phy-5:3 added to port-5:0, phy_mask:0xf (50014380182cf0e6)
[   32.055452] /build/buildd/linux-3.13.0/drivers/scsi/mvsas/mv_sas.c 1218:set
wide port phy map f
[   32.095144] sas: DOING DISCOVERY on port 0, pid:127
[   32.096843] sas: ex 50014380182cf0e6 phy00:D:0 attached: 0000000000000000
(no device)
[   32.097408] sas: ex 50014380182cf0e6 phy01:D:0 attached: 0000000000000000
(no device)
[   32.097917] sas: ex 50014380182cf0e6 phy02:D:0 attached: 0000000000000000
(no device)
[   32.098503] sas: ex 50014380182cf0e6 phy03:D:0 attached: 0000000000000000
(no device)
[   32.099044] sas: ex 50014380182cf0e6 phy04:D:0 attached: 0000000000000000
(no device)
[   32.099628] sas: ex 50014380182cf0e6 phy05:D:0 attached: 0000000000000000
(no device)
[   32.100205] sas: ex 50014380182cf0e6 phy06:D:0 attached: 0000000000000000
(no device)
[   32.100739] sas: ex 50014380182cf0e6 phy07:D:0 attached: 0000000000000000
(no device)
[   32.101310] sas: ex 50014380182cf0e6 phy08:D:0 attached: 0000000000000000
(no device)
[   32.101840] sas: ex 50014380182cf0e6 phy09:D:0 attached: 0000000000000000
(no device)
[   32.102412] sas: ex 50014380182cf0e6 phy10:D:0 attached: 0000000000000000
(no device)
[   32.102959] sas: ex 50014380182cf0e6 phy11:D:0 attached: 0000000000000000
(no device)
[   32.103545] sas: ex 50014380182cf0e6 phy12:D:0 attached: 0000000000000000
(no device)
[   32.104128] sas: ex 50014380182cf0e6 phy13:D:0 attached: 0000000000000000
(no device)
[   32.104661] sas: ex 50014380182cf0e6 phy14:D:0 attached: 0000000000000000
(no device)
[   32.105273] sas: ex 50014380182cf0e6 phy15:D:0 attached: 0000000000000000
(no device)
[   32.105781] sas: ex 50014380182cf0e6 phy16:D:0 attached: 0000000000000000
(no device)
[   32.106385] sas: ex 50014380182cf0e6 phy17:D:0 attached: 0000000000000000
(no device)
[   32.106904] sas: ex 50014380182cf0e6 phy18:D:0 attached: 0000000000000000
(no device)
[   32.107486] sas: ex 50014380182cf0e6 phy19:D:0 attached: 0000000000000000
(no device)
[   32.108020] sas: ex 50014380182cf0e6 phy20:D:0 attached: 0000000000000000
(no device)
[   32.108605] sas: ex 50014380182cf0e6 phy21:D:0 attached: 0000000000000000
(no device)
[   32.109183] sas: ex 50014380182cf0e6 phy22:D:0 attached: 0000000000000000
(no device)
[   32.109714] sas: ex 50014380182cf0e6 phy23:D:0 attached: 0000000000000000
(no device)
[   32.110357] sas: ex 50014380182cf0e6 phy24:U:A attached: 5005043011ab0000
(host)
[   32.110929] sas: ex 50014380182cf0e6 phy25:U:A attached: 5005043011ab0000
(host)
[   32.111558] sas: ex 50014380182cf0e6 phy26:U:A attached: 5005043011ab0000
(host)
[   32.112181] sas: ex 50014380182cf0e6 phy27:U:A attached: 5005043011ab0000
(host)
[   32.112774] sas: ex 50014380182cf0e6 phy28:S:9 attached: 50014380182cf0dc
(stp)
[   32.113366] sas: ex 50014380182cf0e6 phy29:S:9 attached: 50014380182cf0dd
(stp)
[   32.113934] sas: ex 50014380182cf0e6 phy30:S:9 attached: 50014380182cf0de
(stp)
[   32.114557] sas: ex 50014380182cf0e6 phy31:S:9 attached: 50014380182cf0df
(stp)
[   32.115138] sas: ex 50014380182cf0e6 phy32:S:0 attached: 0000000000000000
(no device)
[   32.115654] sas: ex 50014380182cf0e6 phy33:S:0 attached: 0000000000000000
(no device)
[   32.116198] sas: ex 50014380182cf0e6 phy34:S:0 attached: 0000000000000000
(no device)
[   32.116711] sas: ex 50014380182cf0e6 phy35:S:0 attached: 0000000000000000
(no device)
[   32.117003] sas: ex 50014380182cf0e6 phy36:D:A attached: 50014380182cf0e5
(host+target)
[   32.118398] sas: DONE DISCOVERY on port 0, pid:127, result:0
[   32.118435] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[   32.118465] sas: ata6: end_device-5:0:28: dev error handler
[   32.119140] sas: ata7: end_device-5:0:29: dev error handler
[   32.119333] sas: ata8: end_device-5:0:30: dev error handler
[   32.119368] sas: ata9: end_device-5:0:31: dev error handler
[   32.271218] BUG: unable to handle kernel NULL pointer dereference at
0000000000000255
[   32.271791] IP: [<ffffffffa02d381e>] mvs_task_prep+0x72e/0xd50 [mvsas]
[   32.272365] PGD 0
[   32.272928] Oops: 0000 [#1] SMP
[   32.273480] Modules linked in: mvsas libsas scsi_transport_sas hid_generic
usbhid hid x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel cryptd i915 drm_kms_helper
serio_raw lpc_ich mei_me mei drm i2c_algo_bit netconsole configfs lp parport
video mac_hid psmouse ahci libahci r8169 mii
[   32.275388] CPU: 0 PID: 54 Comm: kworker/u4:1 Not tainted 3.13.0-24-generic
#47-Ubuntu
[   32.276028] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./H81
Pro BTC, BIOS P1.80 07/21/2014
[   32.276745] Workqueue: events_unbound async_run_entry_fn
[   32.277389] task: ffff88020fe6afe0 ti: ffff8802136aa000 task.ti:
ffff8802136aa000
[   32.278032] RIP: 0010:[<ffffffffa02d381e>]  [<ffffffffa02d381e>]
mvs_task_prep+0x72e/0xd50 [mvsas]
[   32.278691] RSP: 0018:ffff8802136ab8c0  EFLAGS: 00010097
[   32.279337] RAX: 000000000000002c RBX: 0000000000000001 RCX:
0000000000000000
[   32.279980] RDX: 0000000000000000 RSI: ffff8800d8c255b8 RDI:
ffff8800d8c00000
[   32.280619] RBP: ffff8802136ab958 R08: ffff8800d8c03618 R09:
ffff8800363a0000
[   32.281246] R10: ffff880212977600 R11: 0000000000000000 R12:
ffff8800d8c00000
[   32.281861] R13: 0000000000000000 R14: ffff8800d8c03618 R15:
ffff88020f8dedc0
[   32.282474] FS:  0000000000000000(0000) GS:ffff88021f200000(0000)
knlGS:0000000000000000
[   32.283082] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   32.283679] CR2: 0000000000000255 CR3: 0000000002c0e000 CR4:
00000000000407f0
[   32.284278] Stack:
[   32.284880]  ffff88020fe6afe0 ffff880212977200 ffff8802136ab8e0
ffffffff81719ee9
[   32.285520]  ffff880212977600 ffff8800363a0000 ffff8800d8c03618
ffff8800d8c255b0
[   32.286167]  ffff8800d8c02678 0000000000000000 00000001d8c00008
ffff8800d8c255b8
[   32.286821] Call Trace:
[   32.287473]  [<ffffffff81719ee9>] ? schedule+0x29/0x70
[   32.288144]  [<ffffffffa02d3e9d>] mvs_task_exec.isra.13+0x5d/0xe0 [mvsas]
[   32.288832]  [<ffffffffa02d49dc>] mvs_queue_command+0x30c/0x320 [mvsas]
[   32.289530]  [<ffffffff811a013f>] ? kmem_cache_free+0xef/0x120
[   32.290232]  [<ffffffff8119f692>] ? kmem_cache_alloc+0x132/0x140
[   32.290942]  [<ffffffffa028601d>] ? sas_alloc_task+0x1d/0x40 [libsas]
[   32.291662]  [<ffffffffa028fcab>] sas_ata_qc_issue+0x24b/0x290 [libsas]
[   32.292392]  [<ffffffff814f7762>] ata_qc_issue+0x172/0x380
[   32.293128]  [<ffffffff814f7c23>] ata_exec_internal_sg+0x2b3/0x570
[   32.293875]  [<ffffffff814f7f3a>] ata_exec_internal+0x5a/0xa0
[   32.294624]  [<ffffffff814f8334>] ata_dev_read_id+0x274/0x550
[   32.295380]  [<ffffffffa028f8f0>] ? sas_ata_printk+0x80/0x80 [libsas]
[   32.296148]  [<ffffffff81505bab>] ata_eh_recover+0x74b/0x1310
[   32.296923]  [<ffffffff810bcfe8>] ? console_unlock+0x208/0x400
[   32.297707]  [<ffffffff814facd0>] ? ata_phys_link_online+0x30/0x30
[   32.298503]  [<ffffffffa028f8f0>] ? sas_ata_printk+0x80/0x80 [libsas]
[   32.299367]  [<ffffffff814fae50>] ? ata_phys_link_offline+0x30/0x30
[   32.300179]  [<ffffffffa028f8f0>] ? sas_ata_printk+0x80/0x80 [libsas]
[   32.301001]  [<ffffffff814fae50>] ? ata_phys_link_offline+0x30/0x30
[   32.301826]  [<ffffffffa028f8f0>] ? sas_ata_printk+0x80/0x80 [libsas]
[   32.302661]  [<ffffffff81507299>] ata_do_eh+0x49/0xc0
[   32.303503]  [<ffffffff814facd0>] ? ata_phys_link_online+0x30/0x30
[   32.304357]  [<ffffffff8150734e>] ata_std_error_handler+0x3e/0x80
[   32.305215]  [<ffffffff81506dba>] ata_scsi_port_error_handler+0x56a/0x940
[   32.306086]  [<ffffffffa02900aa>] async_sas_ata_eh+0x4a/0x80 [libsas]
[   32.306963]  [<ffffffff81091517>] async_run_entry_fn+0x37/0x130
[   32.307849]  [<ffffffff810838a2>] process_one_work+0x182/0x450
[   32.308735]  [<ffffffff81084641>] worker_thread+0x121/0x410
[   32.309629]  [<ffffffff81084520>] ? rescuer_thread+0x3e0/0x3e0
[   32.310530]  [<ffffffff8108b312>] kthread+0xd2/0xf0
[   32.311437]  [<ffffffff8108b240>] ? kthread_create_on_node+0x1d0/0x1d0
[   32.312351]  [<ffffffff817263fc>] ret_from_fork+0x7c/0xb0
[   32.313255]  [<ffffffff8108b240>] ? kthread_create_on_node+0x1d0/0x1d0
[   32.314160] Code: 63 92 a0 02 00 00 41 80 b8 84 00 00 00 7f 48 8b 80 58 01
00 00 48 8b 1c d0 0f 84 a0 05 00 00 41 8b 44 24 58 48 8b 75 c0 89 46 1c <8b> 8b
54 02 00 00 be 00 10 00 00 41 8b 54 24 58 49 8b 44 24 48
[   32.316308] RIP  [<ffffffffa02d381e>] mvs_task_prep+0x72e/0xd50 [mvsas]
[   32.317292]  RSP <ffff8802136ab8c0>
[   32.318278] CR2: 0000000000000255

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 81861] mvsas.ko v0.8.16 error messages and kernel crashes
 attaching 4 SATA drives to specific HP SAS expander ports
Date: Fri, 08 Aug 2014 08:19:37 +0000
Message-ID: <bug-81861-11613-alCPun9JMp@https.bugzilla.kernel.org/>
References: <bug-81861-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:36057 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258AbaHHITl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Aug 2014 04:19:41 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 20CE92018E
	for <linux-scsi@vger.kernel.org>; Fri,  8 Aug 2014 08:19:40 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id B2A89201BA
	for <linux-scsi@vger.kernel.org>; Fri,  8 Aug 2014 08:19:37 +0000 (UTC)
In-Reply-To: <bug-81861-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=81861

--- Comment #1 from linux-ide@crashplan.pro ---
After setting up netconsole using <https://wiki.ubuntu.com/Kernel/Netconsole>,
and enabling kernel boot parameters debug and ignore_loglevel there is are more
kernel crash log lines available:
============
[   77.094783] mvsas 0000:01:00.0: mvsas: driver version 0.8.16
[   77.095405] mvsas 0000:01:00.0: mvsas: PCI-E x8, Bandwidth Usage: 5.0 Gbps
[   83.881049] scsi5 : mvsas
[   83.883157] sas: phy-5:4 added to port-5:0, phy_mask:0x1 (50014380182cf0e6)
[   83.883190] /home/apw/COD/linux/drivers/scsi/mvsas/mv_sas.c 1218:set wide
port phy map 1
[   83.893532] sas: phy1 matched wide port0
[   83.893558] sas: phy-5:5 added to port-5:0, phy_mask:0x3 (50014380182cf0e6)
[   83.893580] /home/apw/COD/linux/drivers/scsi/mvsas/mv_sas.c 1218:set wide
port phy map 3
[   83.913447] sas: phy2 matched wide port0
[   83.913468] sas: phy-5:6 added to port-5:0, phy_mask:0x7 (50014380182cf0e6)
[   83.913491] /home/apw/COD/linux/drivers/scsi/mvsas/mv_sas.c 1218:set wide
port phy map 7
[   83.943257] sas: phy3 matched wide port0
[   83.943274] sas: phy-5:7 added to port-5:0, phy_mask:0xf (50014380182cf0e6)
[   83.943294] /home/apw/COD/linux/drivers/scsi/mvsas/mv_sas.c 1218:set wide
port phy map f
[   83.982994] sas: DOING DISCOVERY on port 0, pid:6
[   83.984660] sas: ex 50014380182cf0e6 phy00:D:0 attached: 0000000000000000
(no device)
[   83.985256] sas: ex 50014380182cf0e6 phy01:D:0 attached: 0000000000000000
(no device)
[   83.985851] sas: ex 50014380182cf0e6 phy02:D:0 attached: 0000000000000000
(no device)
[   83.986372] sas: ex 50014380182cf0e6 phy03:D:0 attached: 0000000000000000
(no device)
[   83.986933] sas: ex 50014380182cf0e6 phy04:D:0 attached: 0000000000000000
(no device)
[   83.987488] sas: ex 50014380182cf0e6 phy05:D:0 attached: 0000000000000000
(no device)
[   83.988086] sas: ex 50014380182cf0e6 phy06:D:0 attached: 0000000000000000
(no device)
[   83.988603] sas: ex 50014380182cf0e6 phy07:D:0 attached: 0000000000000000
(no device)
[   83.989197] sas: ex 50014380182cf0e6 phy08:D:0 attached: 0000000000000000
(no device)
[   83.989766] sas: ex 50014380182cf0e6 phy09:D:0 attached: 0000000000000000
(no device)
[   83.990300] sas: ex 50014380182cf0e6 phy10:D:0 attached: 0000000000000000
(no device)
[   83.990872] sas: ex 50014380182cf0e6 phy11:D:0 attached: 0000000000000000
(no device)
[   83.991401] sas: ex 50014380182cf0e6 phy12:D:0 attached: 0000000000000000
(no device)
[   83.991978] sas: ex 50014380182cf0e6 phy13:D:0 attached: 0000000000000000
(no device)
[   83.992515] sas: ex 50014380182cf0e6 phy14:D:0 attached: 0000000000000000
(no device)
[   83.993098] sas: ex 50014380182cf0e6 phy15:D:0 attached: 0000000000000000
(no device)
[   83.993625] sas: ex 50014380182cf0e6 phy16:D:0 attached: 0000000000000000
(no device)
[   83.994213] sas: ex 50014380182cf0e6 phy17:D:0 attached: 0000000000000000
(no device)
[   83.994785] sas: ex 50014380182cf0e6 phy18:D:0 attached: 0000000000000000
(no device)
[   83.995316] sas: ex 50014380182cf0e6 phy19:D:0 attached: 0000000000000000
(no device)
[   83.995890] sas: ex 50014380182cf0e6 phy20:D:0 attached: 0000000000000000
(no device)
[   83.996432] sas: ex 50014380182cf0e6 phy21:D:0 attached: 0000000000000000
(no device)
[   83.996998] sas: ex 50014380182cf0e6 phy22:D:0 attached: 0000000000000000
(no device)
[   83.997540] sas: ex 50014380182cf0e6 phy23:D:0 attached: 0000000000000000
(no device)
[   83.998189] sas: ex 50014380182cf0e6 phy24:U:A attached: 5005043011ab0000
(host)
[   83.998812] sas: ex 50014380182cf0e6 phy25:U:A attached: 5005043011ab0000
(host)
[   83.999386] sas: ex 50014380182cf0e6 phy26:U:A attached: 5005043011ab0000
(host)
[   84.000012] sas: ex 50014380182cf0e6 phy27:U:A attached: 5005043011ab0000
(host)
[   84.000575] sas: ex 50014380182cf0e6 phy28:S:0 attached: 0000000000000000
(no device)
[   84.001581] sas: ex 50014380182cf0e6 phy29:S:0 attached: 0000000000000000
(no device)
[   84.002561] sas: ex 50014380182cf0e6 phy30:S:0 attached: 0000000000000000
(no device)
[   84.003550] sas: ex 50014380182cf0e6 phy31:S:0 attached: 0000000000000000
(no device)
[   84.004573] sas: ex 50014380182cf0e6 phy32:S:9 attached: 50014380182cf0e0
(stp)
[   84.005580] sas: ex 50014380182cf0e6 phy33:S:9 attached: 50014380182cf0e1
(stp)
[   84.006543] sas: ex 50014380182cf0e6 phy34:S:9 attached: 50014380182cf0e2
(stp)
[   84.007442] sas: ex 50014380182cf0e6 phy35:S:9 attached: 50014380182cf0e3
(stp)
[   84.008136] sas: ex 50014380182cf0e6 phy36:D:A attached: 50014380182cf0e5
(host+target)
[   84.009969] sas: DONE DISCOVERY on port 0, pid:6, result:0
[   84.010274] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[   84.010569] sas: ata6: end_device-5:0:32: dev error handler
[   84.010873] sas: ata7: end_device-5:0:33: dev error handler
[   84.011160] sas: ata8: end_device-5:0:34: dev error handler
[   84.011424] sas: ata9: end_device-5:0:35: dev error handler
[   84.164663] general protection fault: 0000 [#1] SMP
[   84.164897] Modules linked in: mvsas libsas scsi_transport_sas ppdev
intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel i915 kvm
crct10dif_pclmul drm_kms_helper crc32_pclmul drm ghash_clmulni_intel cryptd
i2c_algo_bit lpc_ich mei_me microcode mei serio_raw soc_button_array video
parport_pc mac_hid netconsole configfs lp parport psmouse ahci libahci r8169
mii
[   84.165752] CPU: 0 PID: 1008 Comm: kworker/u4:5 Not tainted
3.16.0-031600rc6-generic #201407210035
[   84.166027] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./H81
Pro BTC, BIOS P1.50 02/14/2014
[   84.166325] Workqueue: events_unbound async_run_entry_fn
[   84.166630] task: ffff880036d5ef60 ti: ffff8800d4b34000 task.ti:
ffff8800d4b34000
[   84.166953] RIP: 0010:[<ffffffffc028e5a0>]  [<ffffffffc028e5a0>]
mvs_task_prep_ata+0x80/0x3a0 [mvsas]
[   84.167364] RSP: 0018:ffff8800d4b377c8  EFLAGS: 00010097
[   84.167714] RAX: 000000000000002c RBX: ffff88020f200000 RCX:
dead000000200200
[   84.168078] RDX: ffff88020f2037b0 RSI: ffff88020f2255b8 RDI:
ffff88020f200000
[   84.168451] RBP: ffff8800d4b37838 R08: 0000000000000000 R09:
0000000000001000
[   84.168834] R10: 0000000000000000 R11: ffff88020f2255b0 R12:
ffff88020fbab640
[   84.169228] R13: ffff8800d4b37898 R14: ffff88021b4a0000 R15:
ffff880036f19a00
[   84.169628] FS:  0000000000000000(0000) GS:ffff88021b200000(0000)
knlGS:0000000000000000
[   84.170044] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   84.170467] CR2: 00007f0031fbf000 CR3: 0000000001c12000 CR4:
00000000000407f0
[   84.170907] Stack:
[   84.171345]  ffff88021b314400 ffff880200000000 0000000000000282
dead000000200200
[   84.171818]  ffff88020f2037b0 0000000000000046 ffff88020cd81e38
ffffffff811b06ae
[   84.172300]  ffff88021b314400 ffff88020fbab640 ffff88020f2037b0
ffff88020f200000
[   84.172791] Call Trace:
[   84.173280]  [<ffffffff811b06ae>] ? dma_pool_alloc+0xce/0x100
[   84.173785]  [<ffffffffc028f4ab>] mvs_task_prep+0x58b/0x620 [mvsas]
[   84.174298]  [<ffffffff810a29e6>] ? ttwu_do_activate.constprop.111+0x66/0x70
[   84.174823]  [<ffffffffc028f5a8>] mvs_task_exec.isra.14+0x68/0xf0 [mvsas]
[   84.175358]  [<ffffffffc0290149>] mvs_queue_command+0x39/0x40 [mvsas]
[   84.175901]  [<ffffffffc02778ab>] sas_ata_qc_issue+0x28b/0x2d0 [libsas]
[   84.176446]  [<ffffffff8153102f>] ata_qc_issue+0x18f/0x2d0
[   84.176997]  [<ffffffff81531468>] ata_exec_internal_sg+0x2f8/0x5d0
[   84.177554]  [<ffffffff815317b2>] ata_exec_internal+0x72/0xb0
[   84.178113]  [<ffffffff81531faa>] ata_do_dev_read_id+0x2a/0x30
[   84.178673]  [<ffffffffc02774b0>] ? sas_ata_internal_abort+0x120/0x120
[libsas]
[   84.179245]  [<ffffffff815321f5>] ata_dev_read_id+0x245/0x460
[   84.179825]  [<ffffffff8153e99c>] ? ata_eh_reset+0x24c/0xe20
[   84.180409]  [<ffffffff8153d8f8>] ata_eh_revalidate_and_attach+0x198/0x3a0
[   84.181002]  [<ffffffff810cd4d1>] ? vprintk_emit+0x1b1/0x560
[   84.181598]  [<ffffffff8153fd69>] ata_eh_recover+0x599/0x7e0
[   84.182200]  [<ffffffff81534200>] ? sata_print_link_status+0xc0/0xc0
[   84.182809]  [<ffffffffc02774b0>] ? sas_ata_internal_abort+0x120/0x120
[libsas]
[   84.183427]  [<ffffffff81534750>] ? sata_std_hardreset+0x50/0x50
[   84.184037]  [<ffffffffc02774b0>] ? sas_ata_internal_abort+0x120/0x120
[libsas]
[   84.184710]  [<ffffffff81534750>] ? sata_std_hardreset+0x50/0x50
[   84.185323]  [<ffffffffc02774b0>] ? sas_ata_internal_abort+0x120/0x120
[libsas]
[   84.185945]  [<ffffffff81540742>] ata_do_eh+0x52/0xc0
[   84.186574]  [<ffffffff81534200>] ? sata_print_link_status+0xc0/0xc0
[   84.187213]  [<ffffffff815407f7>] ata_std_error_handler+0x47/0x80
[   84.187850]  [<ffffffff8153b8f8>] ? ata_eh_handle_port_resume+0x38/0x160
[   84.188473]  [<ffffffff8154041b>] ata_scsi_port_error_handler+0x39b/0x5a0
[   84.189081]  [<ffffffffc02772c5>] async_sas_ata_eh+0x55/0x90 [libsas]
[   84.189673]  [<ffffffff8109a89b>] async_run_entry_fn+0x3b/0x140
[   84.190248]  [<ffffffff8108c6ff>] process_one_work+0x17f/0x4c0
[   84.190812]  [<ffffffff81776ba8>] ? maybe_create_worker+0xbb/0x1c5
[   84.191364]  [<ffffffff8108d46b>] worker_thread+0x11b/0x3f0
[   84.191910]  [<ffffffff8108d350>] ? create_and_start_worker+0x80/0x80
[   84.192446]  [<ffffffff81094479>] kthread+0xc9/0xe0
[   84.192971]  [<ffffffff810943b0>] ? flush_kthread_worker+0xb0/0xb0
[   84.193495]  [<ffffffff817910fc>] ret_from_fork+0x7c/0xb0
[   84.194015]  [<ffffffff810943b0>] ? flush_kthread_worker+0xb0/0xb0
[   84.194534] Code: 00 00 48 8b 0c c8 0f 84 a7 02 00 00 44 89 c0 41 b9 00 10
00 00 48 8d 34 80 48 8d 04 70 48 8d b4 c3 b8 55 02 00 8b 43 58 89 46 1c <8b> 89
54 02 00 00 44 89 c0 8b 7b 58 0d 00 00 00 70 4c 8b 53 48
[   84.195858] RIP  [<ffffffffc028e5a0>] mvs_task_prep_ata+0x80/0x3a0 [mvsas]
[   84.196412]  RSP <ffff8800d4b377c8>

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

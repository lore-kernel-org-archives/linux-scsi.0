Return-Path: <SRS0=9nM7=7R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E17E0C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Jun 2020 06:17:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B45092072E
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Jun 2020 06:17:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgFDGR3 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Jun 2020 02:17:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:58150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725959AbgFDGR3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 4 Jun 2020 02:17:29 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 208045] New: ARM ubuntu 18.04 as the iscsi server, using
 initiator login, the kernel crashes
Date:   Thu, 04 Jun 2020 06:17:27 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: lnsyyj@hotmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-208045-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=208045

            Bug ID: 208045
           Summary: ARM ubuntu 18.04 as the iscsi server, using initiator
                    login, the kernel crashes
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 4.19.118
          Hardware: ARM
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: lnsyyj@hotmail.com
        Regression: No

[Mon Jun  1 09:16:22 2020] scsi host5: iSCSI Initiator over TCP/IP
[Mon Jun  1 09:16:22 2020] scsi host6: iSCSI Initiator over TCP/IP
[Mon Jun  1 09:16:22 2020] scsi host7: iSCSI Initiator over TCP/IP
[Mon Jun  1 09:16:22 2020] Unable to handle kernel paging request at virtual
address ffff7e00008fa940
[Mon Jun  1 09:16:22 2020] Mem abort info:
[Mon Jun  1 09:16:22 2020]   ESR = 0x96000004
[Mon Jun  1 09:16:22 2020]   Exception class = DABT (current EL), IL = 32 bits
[Mon Jun  1 09:16:22 2020]   SET = 0, FnV = 0
[Mon Jun  1 09:16:22 2020]   EA = 0, S1PTW = 0
[Mon Jun  1 09:16:22 2020] Data abort info:
[Mon Jun  1 09:16:22 2020]   ISV = 0, ISS = 0x00000004
[Mon Jun  1 09:16:22 2020]   CM = 0, WnR = 0
[Mon Jun  1 09:16:22 2020] swapper pgtable: 4k pages, 48-bit VAs, pgdp =
0000000082681c2b
[Mon Jun  1 09:16:22 2020] [ffff7e00008fa940] pgd=0000000000000000
[Mon Jun  1 09:16:22 2020] Internal error: Oops: 96000004 [#1] SMP
[Mon Jun  1 09:16:22 2020] Modules linked in: target_core_pscsi
target_core_file target_core_iblock iscsi_target_mod cfg80211 target_core_user
uio target_core_mod openvswitch nsh nf_nat_ipv6 nf_nat_ipv4 nf_conncount nf_nat
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nls_iso8859_1 dm_multipath
scsi_dh_rdac scsi_dh_emc scsi_dh_alua ipmi_ssif joydev input_leds ipmi_si
ipmi_devintf ipmi_msghandler sch_fq_codel ib_iser rdma_cm iw_cm ib_cm ib_core
iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi sunrpc ip_tables x_tables
autofs4 btrfs zstd_compress raid10 raid456 async_raid6_recov async_memcpy
async_pq async_xor async_tx xor raid6_pq libcrc32c raid1 raid0 multipath linear
ses enclosure scsi_transport_sas hid_generic usbhid hid ast ttm drm_kms_helper
cfbfillrect syscopyarea cfbimgblt sysfillrect sysimgblt fb_sys_fops
[Mon Jun  1 09:16:22 2020]  cfbcopyarea fb bcache font crc32_ce crc64 drm
megaraid_sas igb ixgbe ahci drm_panel_orientation_quirks libahci
i2c_designware_platform i2c_designware_core i2c_algo_bit mdio i2c_core
aes_neon_bs aes_neon_blk crypto_simd cryptd aes_arm64
[Mon Jun  1 09:16:22 2020] Process iscsi_trx (pid: 7496, stack limit =
0x0000000010dd111a)
[Mon Jun  1 09:16:22 2020] CPU: 0 PID: 7496 Comm: iscsi_trx Not tainted
4.19.118-0419118-generic #202004230533
[Mon Jun  1 09:16:22 2020] Hardware name: Greatwall QingTian DF720/F601, BIOS
601FBE20 Sep 26 2019
[Mon Jun  1 09:16:22 2020] pstate: 80400005 (Nzcv daif +PAN -UAO)
[Mon Jun  1 09:16:22 2020] pc : flush_dcache_page+0x18/0x40
[Mon Jun  1 09:16:22 2020] lr : is_ring_space_avail+0x68/0x2f8
[target_core_user]
[Mon Jun  1 09:16:22 2020] sp : ffff000015123a80
[Mon Jun  1 09:16:22 2020] x29: ffff000015123a80 x28: 0000000000000000 
[Mon Jun  1 09:16:22 2020] x27: 0000000000001000 x26: ffff000023ea5000 
[Mon Jun  1 09:16:22 2020] x25: ffffcfa25bbe08b8 x24: 0000000000000078 
[Mon Jun  1 09:16:22 2020] x23: ffff7e0000000000 x22: ffff000023ea5001 
[Mon Jun  1 09:16:22 2020] x21: ffffcfa24b79c000 x20: 0000000000000fff 
[Mon Jun  1 09:16:22 2020] x19: ffff7e00008fa940 x18: 0000000000000000 
[Mon Jun  1 09:16:22 2020] x17: 0000000000000000 x16: ffff2d047e709138 
[Mon Jun  1 09:16:22 2020] x15: 0000000000000000 x14: 0000000000000000 
[Mon Jun  1 09:16:22 2020] x13: 0000000000000000 x12: ffff2d047fbd0a40 
[Mon Jun  1 09:16:22 2020] x11: 0000000000000000 x10: 0000000000000030 
[Mon Jun  1 09:16:22 2020] x9 : 0000000000000000 x8 : ffffc9a254820a00 
[Mon Jun  1 09:16:22 2020] x7 : 00000000000013b0 x6 : 000000000000003f 
[Mon Jun  1 09:16:22 2020] x5 : 0000000000000040 x4 : ffffcfa25bbe08e8 
[Mon Jun  1 09:16:22 2020] x3 : 0000000000001000 x2 : 0000000000000078 
[Mon Jun  1 09:16:22 2020] x1 : ffffcfa25bbe08b8 x0 : ffff2d040bc88a18 
[Mon Jun  1 09:16:22 2020] Call trace:
[Mon Jun  1 09:16:22 2020]  flush_dcache_page+0x18/0x40
[Mon Jun  1 09:16:22 2020]  is_ring_space_avail+0x68/0x2f8 [target_core_user]
[Mon Jun  1 09:16:22 2020]  queue_cmd_ring+0x1f8/0x680 [target_core_user]
[Mon Jun  1 09:16:22 2020]  tcmu_queue_cmd+0xe4/0x158 [target_core_user]
[Mon Jun  1 09:16:22 2020]  __target_execute_cmd+0x30/0xf0 [target_core_mod]
[Mon Jun  1 09:16:22 2020]  target_execute_cmd+0x294/0x390 [target_core_mod]
[Mon Jun  1 09:16:22 2020]  transport_generic_new_cmd+0x1e8/0x358
[target_core_mod]
[Mon Jun  1 09:16:22 2020]  transport_handle_cdb_direct+0x50/0xb0
[target_core_mod]
[Mon Jun  1 09:16:22 2020]  iscsit_execute_cmd+0x2b4/0x350 [iscsi_target_mod]
[Mon Jun  1 09:16:22 2020]  iscsit_sequence_cmd+0xd8/0x1d8 [iscsi_target_mod]
[Mon Jun  1 09:16:22 2020]  iscsit_process_scsi_cmd+0xac/0xf8
[iscsi_target_mod]
[Mon Jun  1 09:16:22 2020]  iscsit_get_rx_pdu+0x404/0xd00 [iscsi_target_mod]
[Mon Jun  1 09:16:22 2020]  iscsi_target_rx_thread+0xb8/0x130
[iscsi_target_mod]
[Mon Jun  1 09:16:22 2020]  kthread+0x130/0x138
[Mon Jun  1 09:16:22 2020]  ret_from_fork+0x10/0x18
[Mon Jun  1 09:16:22 2020] Code: f9000bf3 aa0003f3 aa1e03e0 d503201f (f9400260) 
[Mon Jun  1 09:16:22 2020] ---[ end trace 1e451c73f4266776 ]---
[Mon Jun  1 09:16:32 2020] ------------[ cut here ]------------
[Mon Jun  1 09:16:32 2020] WARNING: CPU: 0 PID: 7495 at kernel/kthread.c:391
__kthread_bind_mask+0xb0/0xb8
[Mon Jun  1 09:16:32 2020] Modules linked in: target_core_pscsi
target_core_file target_core_iblock iscsi_target_mod cfg80211 target_core_user
uio target_core_mod openvswitch nsh nf_nat_ipv6 nf_nat_ipv4 nf_conncount nf_nat
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nls_iso8859_1 dm_multipath
scsi_dh_rdac scsi_dh_emc scsi_dh_alua ipmi_ssif joydev input_leds ipmi_si
ipmi_devintf ipmi_msghandler sch_fq_codel ib_iser rdma_cm iw_cm ib_cm ib_core
iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi sunrpc ip_tables x_tables
autofs4 btrfs zstd_compress raid10 raid456 async_raid6_recov async_memcpy
async_pq async_xor async_tx xor raid6_pq libcrc32c raid1 raid0 multipath linear
ses enclosure scsi_transport_sas hid_generic usbhid hid ast ttm drm_kms_helper
cfbfillrect syscopyarea cfbimgblt sysfillrect sysimgblt fb_sys_fops
[Mon Jun  1 09:16:32 2020]  cfbcopyarea fb bcache font crc32_ce crc64 drm
megaraid_sas igb ixgbe ahci drm_panel_orientation_quirks libahci
i2c_designware_platform i2c_designware_core i2c_algo_bit mdio i2c_core
aes_neon_bs aes_neon_blk crypto_simd cryptd aes_arm64
[Mon Jun  1 09:16:32 2020] CPU: 0 PID: 7495 Comm: iscsi_ttx Tainted: G      D  
        4.19.118-0419118-generic #202004230533
[Mon Jun  1 09:16:32 2020] Hardware name: Greatwall QingTian DF720/F601, BIOS
601FBE20 Sep 26 2019
[Mon Jun  1 09:16:32 2020] pstate: 40400005 (nZcv daif +PAN -UAO)
[Mon Jun  1 09:16:33 2020] pc : __kthread_bind_mask+0xb0/0xb8
[Mon Jun  1 09:16:33 2020] lr : __kthread_bind_mask+0xb0/0xb8
[Mon Jun  1 09:16:33 2020] sp : ffff00001511bca0
[Mon Jun  1 09:16:33 2020] x29: ffff00001511bca0 x28: 0000000000000000 
[Mon Jun  1 09:16:33 2020] x27: ffffcfa05e811838 x26: ffff2d047f4e0a18 
[Mon Jun  1 09:16:33 2020] x25: ffff2d040bf06750 x24: 0000000000000008 
[Mon Jun  1 09:16:33 2020] x23: ffff2d047fbc8708 x22: ffff2d040bef25d8 
[Mon Jun  1 09:16:33 2020] x21: ffff2d047f202368 x20: 0000000000000040 
[Mon Jun  1 09:16:33 2020] x19: ffffcfa2080ee3c0 x18: 0000000000000010 
[Mon Jun  1 09:16:33 2020] x17: 0000000000000000 x16: 0000000000000000 
[Mon Jun  1 09:16:33 2020] x15: ffffffffffffffff x14: ffff2d047fbc8708 
[Mon Jun  1 09:16:33 2020] x13: ffff2d04ffd878b7 x12: ffff2d047fd878bf 
[Mon Jun  1 09:16:33 2020] x11: ffff2d047fbed000 x10: ffff00001511b980 
[Mon Jun  1 09:16:33 2020] x9 : 00000000ffffffd0 x8 : ffff2d047ed8e3f8 
[Mon Jun  1 09:16:33 2020] x7 : 5d20657265682074 x6 : ffffc9a27ff33158 
[Mon Jun  1 09:16:33 2020] x5 : ffffc9a27ff33158 x4 : 0000000000000000 
[Mon Jun  1 09:16:33 2020] x3 : ffffc9a27ff3bf88 x2 : 5879f7f686901900 
[Mon Jun  1 09:16:33 2020] x1 : 0000000000000000 x0 : 0000000000000024 
[Mon Jun  1 09:16:33 2020] Call trace:
[Mon Jun  1 09:16:33 2020]  __kthread_bind_mask+0xb0/0xb8
[Mon Jun  1 09:16:33 2020]  kthread_unpark+0x8c/0x90
[Mon Jun  1 09:16:33 2020]  kthread_stop+0x60/0x198
[Mon Jun  1 09:16:33 2020]  iscsit_close_connection+0x428/0x998
[iscsi_target_mod]
[Mon Jun  1 09:16:33 2020]  iscsit_take_action_for_connection_exit+0xc0/0x190
[iscsi_target_mod]
[Mon Jun  1 09:16:33 2020]  iscsi_target_tx_thread+0x180/0x200
[iscsi_target_mod]
[Mon Jun  1 09:16:33 2020]  kthread+0x130/0x138
[Mon Jun  1 09:16:33 2020]  ret_from_fork+0x10/0x18
[Mon Jun  1 09:16:33 2020] ---[ end trace 1e451c73f4266777 ]---
[Mon Jun  1 09:16:37 2020]  connection2:0: ping timeout of 5 secs expired, recv
timeout 5, last rx 4295230129, last ping 4295231424, now 4295232704
[Mon Jun  1 09:16:38 2020]  connection2:0: detected conn error (1022)
[Mon Jun  1 09:16:38 2020]  connection1:0: ping timeout of 5 secs expired, recv
timeout 5, last rx 4295230126, last ping 4295231424, now 4295232708
[Mon Jun  1 09:16:38 2020]  connection1:0: detected conn error (1022)
[Mon Jun  1 09:16:38 2020]  connection3:0: ping timeout of 5 secs expired, recv
timeout 5, last rx 4295230144, last ping 4295230144, now 4295232712
[Mon Jun  1 09:16:38 2020]  connection3:0: detected conn error (1022)
[Mon Jun  1 09:16:55 2020] iSCSI Login timeout on Network Portal
192.168.1.10:3260
[Mon Jun  1 09:17:44 2020] scsi 6:0:0:0: timing out command, waited 82s
[Mon Jun  1 09:17:44 2020] scsi 7:0:0:0: timing out command, waited 82s
[Mon Jun  1 09:17:44 2020] scsi 5:0:0:0: timing out command, waited 82s
[Mon Jun  1 09:18:38 2020]  session3: session recovery timed out after 120 secs
[Mon Jun  1 09:18:38 2020]  session1: session recovery timed out after 120 secs
[Mon Jun  1 09:18:38 2020]  session2: session recovery timed out after 120 secs

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

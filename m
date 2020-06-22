Return-Path: <SRS0=lGnU=AD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDE24C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Jun 2020 02:33:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B965025371
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Jun 2020 02:33:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731000AbgFVCdD convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 Jun 2020 22:33:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726983AbgFVCdD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 21 Jun 2020 22:33:03 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 208045] ARM ubuntu 18.04 as the iscsi server, using initiator
 login, the kernel crashes
Date:   Mon, 22 Jun 2020 02:33:01 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: IO/Storage
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
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-208045-11613-8rZiak88UB@https.bugzilla.kernel.org/>
In-Reply-To: <bug-208045-11613@https.bugzilla.kernel.org/>
References: <bug-208045-11613@https.bugzilla.kernel.org/>
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

--- Comment #10 from JiangYu (lnsyyj@hotmail.com) ---
[Fri Jun 19 11:19:46 2020] scsi host5: iSCSI Initiator over TCP/IP
[Fri Jun 19 11:19:46 2020] iSCSI Initiator Node:
iqn.1993-08.org.debian:01:b27579df472 is not authorized to access iSCSI target
portal group: 1.
[Fri Jun 19 11:19:47 2020] iSCSI Login negotiation failed.
[Fri Jun 19 11:21:33 2020] scsi host5: iSCSI Initiator over TCP/IP
[Fri Jun 19 11:23:32 2020] scsi host5: iSCSI Initiator over TCP/IP
[Fri Jun 19 11:23:32 2020] scsi 5:0:0:0: Direct-Access     LIO-ORG  TCMU device
     0002 PQ: 0 ANSI: 5
[Fri Jun 19 11:23:32 2020] sd 5:0:0:0: Attached scsi generic sg11 type 0
[Fri Jun 19 11:23:32 2020] sd 5:0:0:0: [sdk] 2147483648 512-byte logical
blocks: (1.10 TB/1.00 TiB)
[Fri Jun 19 11:23:32 2020] sd 5:0:0:0: [sdk] Write Protect is off
[Fri Jun 19 11:23:32 2020] sd 5:0:0:0: [sdk] Mode Sense: 2f 00 00 00
[Fri Jun 19 11:23:32 2020] sd 5:0:0:0: [sdk] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[Fri Jun 19 11:23:32 2020] sd 5:0:0:0: [sdk] Optimal transfer size 524288 bytes
[Fri Jun 19 11:23:32 2020] sd 5:0:0:0: [sdk] Attached SCSI disk
[Fri Jun 19 18:17:11 2020] EXT4-fs (sdk): mounted filesystem with ordered data
mode. Opts: (null)
[Mon Jun 22 00:00:14 2020] Unable to handle kernel access to user memory
outside uaccess routines at virtual address 0000000000000000
[Mon Jun 22 00:00:14 2020] Mem abort info:
[Mon Jun 22 00:00:14 2020]   ESR = 0x96000004
[Mon Jun 22 00:00:14 2020]   Exception class = DABT (current EL), IL = 32 bits
[Mon Jun 22 00:00:14 2020]   SET = 0, FnV = 0
[Mon Jun 22 00:00:14 2020]   EA = 0, S1PTW = 0
[Mon Jun 22 00:00:14 2020] Data abort info:
[Mon Jun 22 00:00:14 2020]   ISV = 0, ISS = 0x00000004
[Mon Jun 22 00:00:14 2020]   CM = 0, WnR = 0
[Mon Jun 22 00:00:14 2020] user pgtable: 4k pages, 48-bit VAs, pgdp =
000000002c314fa8
[Mon Jun 22 00:00:14 2020] [0000000000000000] pgd=0000000000000000
[Mon Jun 22 00:00:14 2020] Internal error: Oops: 96000004 [#1] SMP
[Mon Jun 22 00:00:14 2020] Modules linked in: rpcsec_gss_krb5 auth_rpcgss nfsv4
nfs lockd grace fscache target_core_pscsi target_core_file target_core_iblock
iscsi_target_mod cfg80211 target_core_user uio target_core_mod openvswitch nsh
nf_nat_ipv6 nf_nat_ipv4 nf_conncount nf_nat nf_conntrack nf_defrag_ipv6
nf_defrag_ipv4 nls_iso8859_1 ipmi_ssif joydev input_leds ipmi_si ipmi_devintf
ipmi_msghandler sch_fq_codel sunrpc ib_iser rdma_cm iw_cm ib_cm ib_core
iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ip_tables x_tables autofs4
btrfs zstd_compress raid10 raid456 async_raid6_recov async_memcpy async_pq
async_xor async_tx xor raid6_pq libcrc32c raid1 raid0 multipath linear ses
enclosure scsi_transport_sas ast ttm drm_kms_helper cfbfillrect syscopyarea
cfbimgblt sysfillrect sysimgblt fb_sys_fops cfbcopyarea fb
[Mon Jun 22 00:00:15 2020]  font drm ixgbe igb drm_panel_orientation_quirks
i2c_algo_bit mdio bcache crc32_ce crc64 hid_generic i2c_designware_platform
ahci i2c_designware_core megaraid_sas libahci i2c_core usbhid hid aes_neon_bs
aes_neon_blk crypto_simd cryptd aes_arm64
[Mon Jun 22 00:00:15 2020] Process tp_librbd (pid: 5707, stack limit =
0x00000000d11d520b)
[Mon Jun 22 00:00:15 2020] CPU: 52 PID: 5707 Comm: tp_librbd Not tainted
4.19.118-maxcn #1
[Mon Jun 22 00:00:15 2020] Hardware name: Greatwall QingTian DF720/F601, BIOS
601FBE20 Sep 26 2019
[Mon Jun 22 00:00:15 2020] pstate: 20400005 (nzCv daif +PAN -UAO)
[Mon Jun 22 00:00:15 2020] pc : flush_dcache_page+0x18/0x40
[Mon Jun 22 00:00:15 2020] lr : tcmu_handle_completions+0xc4/0x4a0
[target_core_user]
[Mon Jun 22 00:00:15 2020] sp : ffff00002245bc10
[Mon Jun 22 00:00:15 2020] x29: ffff00002245bc10 x28: ffffcd70fb93d580 
[Mon Jun 22 00:00:15 2020] x27: ffff0000223c5000 x26: ffff363403dcf680 
[Mon Jun 22 00:00:15 2020] x25: ffffc771da0393e0 x24: 0000000000000000 
[Mon Jun 22 00:00:15 2020] x23: ffff000021bc5000 x22: ffffc771da038000 
[Mon Jun 22 00:00:15 2020] x21: ffff0000223c4fd0 x20: 00000000007fffd0 
[Mon Jun 22 00:00:15 2020] x19: 0000000000000000 x18: 0000000000000000 
[Mon Jun 22 00:00:15 2020] x17: 0000000000000000 x16: ffff36340eba9e00 
[Mon Jun 22 00:00:15 2020] x15: 0000000000000000 x14: 0000000000000000 
[Mon Jun 22 00:00:15 2020] x13: 0000000000000000 x12: 0000000000000000 
[Mon Jun 22 00:00:15 2020] x11: 0000000000000000 x10: 0000000000000000 
[Mon Jun 22 00:00:15 2020] x9 : 0000000000000000 x8 : 00000000000013e0 
[Mon Jun 22 00:00:15 2020] x7 : 0000000000000000 x6 : ffff00002245bcf8 
[Mon Jun 22 00:00:15 2020] x5 : ffff00002245bcf8 x4 : 0000000000000000 
[Mon Jun 22 00:00:15 2020] x3 : ffff36340fab0000 x2 : ffffb91200000000 
[Mon Jun 22 00:00:15 2020] x1 : 0000000000000000 x0 : ffff363403dc8f6c 
[Mon Jun 22 00:00:15 2020] Call trace:
[Mon Jun 22 00:00:15 2020]  flush_dcache_page+0x18/0x40
[Mon Jun 22 00:00:15 2020]  tcmu_handle_completions+0xc4/0x4a0
[target_core_user]
[Mon Jun 22 00:00:15 2020]  tcmu_irqcontrol+0x34/0x58 [target_core_user]
[Mon Jun 22 00:00:15 2020]  uio_write+0xb8/0x138 [uio]
[Mon Jun 22 00:00:15 2020]  __vfs_write+0x60/0x190
[Mon Jun 22 00:00:15 2020]  vfs_write+0xac/0x1b0
[Mon Jun 22 00:00:15 2020]  ksys_write+0x74/0xf0
[Mon Jun 22 00:00:15 2020]  __arm64_sys_write+0x24/0x30
[Mon Jun 22 00:00:15 2020]  el0_svc_common+0x88/0x180
[Mon Jun 22 00:00:15 2020]  el0_svc_handler+0x38/0x78
[Mon Jun 22 00:00:15 2020]  el0_svc+0x8/0xc
[Mon Jun 22 00:00:15 2020] Code: f9000bf3 aa0003f3 aa1e03e0 d503201f (f9400260) 
[Mon Jun 22 00:00:15 2020] ---[ end trace cdb72dbc3b2a8038 ]---
[Mon Jun 22 00:01:16 2020] ABORT_TASK: Found referenced iSCSI task_tag: 42
[Mon Jun 22 00:01:16 2020] ------------[ cut here ]------------
[Mon Jun 22 00:01:16 2020] WARNING: CPU: 7 PID: 746959 at
kernel/workqueue.c:2919 __flush_work+0x260/0x290
[Mon Jun 22 00:01:16 2020] Modules linked in: rpcsec_gss_krb5 auth_rpcgss nfsv4
nfs lockd grace fscache target_core_pscsi target_core_file target_core_iblock
iscsi_target_mod cfg80211 target_core_user uio target_core_mod openvswitch nsh
nf_nat_ipv6 nf_nat_ipv4 nf_conncount nf_nat nf_conntrack nf_defrag_ipv6
nf_defrag_ipv4 nls_iso8859_1 ipmi_ssif joydev input_leds ipmi_si ipmi_devintf
ipmi_msghandler sch_fq_codel sunrpc ib_iser rdma_cm iw_cm ib_cm ib_core
iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ip_tables x_tables autofs4
btrfs zstd_compress raid10 raid456 async_raid6_recov async_memcpy async_pq
async_xor async_tx xor raid6_pq libcrc32c raid1 raid0 multipath linear ses
enclosure scsi_transport_sas ast ttm drm_kms_helper cfbfillrect syscopyarea
cfbimgblt sysfillrect sysimgblt fb_sys_fops cfbcopyarea fb
[Mon Jun 22 00:01:16 2020]  font drm ixgbe igb drm_panel_orientation_quirks
i2c_algo_bit mdio bcache crc32_ce crc64 hid_generic i2c_designware_platform
ahci i2c_designware_core megaraid_sas libahci i2c_core usbhid hid aes_neon_bs
aes_neon_blk crypto_simd cryptd aes_arm64
[Mon Jun 22 00:01:16 2020] CPU: 7 PID: 746959 Comm: kworker/u128:0 Tainted: G  
   D           4.19.118-maxcn #1
[Mon Jun 22 00:01:16 2020] Hardware name: Greatwall QingTian DF720/F601, BIOS
601FBE20 Sep 26 2019
[Mon Jun 22 00:01:16 2020] Workqueue: tmr-user target_tmr_work
[target_core_mod]
[Mon Jun 22 00:01:16 2020] pstate: 40400005 (nZcv daif +PAN -UAO)
[Mon Jun 22 00:01:16 2020] pc : __flush_work+0x260/0x290
[Mon Jun 22 00:01:16 2020] lr : __flush_work+0x260/0x290
[Mon Jun 22 00:01:16 2020] sp : ffff0000167cbbd0
[Mon Jun 22 00:01:16 2020] x29: ffff0000167cbbd0 x28: 0000000000000000 
[Mon Jun 22 00:01:16 2020] x27: ffffccef4ebc68b8 x26: ffff0000167cbce0 
[Mon Jun 22 00:01:16 2020] x25: ffff3634100b6a40 x24: 0000000000000000 
[Mon Jun 22 00:01:16 2020] x23: ffff363410252000 x22: 0000000000000000 
[Mon Jun 22 00:01:16 2020] x21: ffff363410098000 x20: ffffcd6fad1b1550 
[Mon Jun 22 00:01:16 2020] x19: ffffcd6fad1b1550 x18: ffffffffffffffff 
[Mon Jun 22 00:01:16 2020] x17: 0000000000000000 x16: 0000000000000000 
[Mon Jun 22 00:01:16 2020] x15: ffff363410098708 x14: ffff3634902578af 
[Mon Jun 22 00:01:16 2020] x13: ffff3634102578be x12: ffff3634100bd000 
[Mon Jun 22 00:01:16 2020] x11: 0000000005f5e0ff x10: ffff363410099168 
[Mon Jun 22 00:01:16 2020] x9 : ffff36340fc7d018 x8 : ffff36340f24d010 
[Mon Jun 22 00:01:16 2020] x7 : 5d20657265682074 x6 : ffffc771fffe2158 
[Mon Jun 22 00:01:16 2020] x5 : ffffc771fffe2158 x4 : 0000000000000000 
[Mon Jun 22 00:01:16 2020] x3 : ffffc771fffeaf88 x2 : 203f2659feac9b00 
[Mon Jun 22 00:01:16 2020] x1 : 0000000000000000 x0 : 0000000000000024 
[Mon Jun 22 00:01:16 2020] Call trace:
[Mon Jun 22 00:01:16 2020]  __flush_work+0x260/0x290
[Mon Jun 22 00:01:16 2020]  __cancel_work_timer+0x134/0x1a8
[Mon Jun 22 00:01:16 2020]  cancel_work_sync+0x24/0x30
[Mon Jun 22 00:01:16 2020]  core_tmr_abort_task+0xfc/0x1b0 [target_core_mod]
[Mon Jun 22 00:01:16 2020]  target_tmr_work+0x108/0x1d8 [target_core_mod]
[Mon Jun 22 00:01:16 2020]  process_one_work+0x1f0/0x428
[Mon Jun 22 00:01:16 2020]  worker_thread+0x44/0x488
[Mon Jun 22 00:01:16 2020]  kthread+0x134/0x138
[Mon Jun 22 00:01:16 2020]  ret_from_fork+0x10/0x18
[Mon Jun 22 00:01:16 2020] ---[ end trace cdb72dbc3b2a8039 ]---
[Mon Jun 22 00:01:31 2020]  connection3:0: detected conn error (1021)
[Mon Jun 22 00:01:31 2020]  connection3:0: detected conn error (1021)
[Mon Jun 22 00:01:48 2020] iSCSI Login timeout on Network Portal
192.168.1.201:3260
[Mon Jun 22 00:03:31 2020]  session3: session recovery timed out after 120 secs
[Mon Jun 22 00:03:31 2020] sd 5:0:0:0: Device offlined - not ready after error
recovery
[Mon Jun 22 00:03:31 2020] sd 5:0:0:0: [sdk] tag#57 FAILED Result:
hostbyte=DID_TRANSPORT_DISRUPTED driverbyte=DRIVER_OK
[Mon Jun 22 00:03:31 2020] sd 5:0:0:0: [sdk] tag#57 CDB: Unmap/Read sub-channel
42 00 00 00 00 00 00 00 18 00
[Mon Jun 22 00:03:31 2020] print_req_error: I/O error, dev sdk, sector
1727496192
[Mon Jun 22 00:03:31 2020] sd 5:0:0:0: rejecting I/O to offline device
[Mon Jun 22 00:03:31 2020] print_req_error: I/O error, dev sdk, sector
1727430656
[Mon Jun 22 00:03:31 2020] sd 5:0:0:0: rejecting I/O to offline device
[Mon Jun 22 00:03:31 2020] print_req_error: I/O error, dev sdk, sector
1727463424
[Mon Jun 22 10:07:20 2020] sd 5:0:0:0: rejecting I/O to offline device
[Mon Jun 22 10:07:20 2020] print_req_error: I/O error, dev sdk, sector
1074326448
[Mon Jun 22 10:07:20 2020] Aborting journal on device sdk-8.
[Mon Jun 22 10:07:20 2020] sd 5:0:0:0: rejecting I/O to offline device
[Mon Jun 22 10:07:20 2020] print_req_error: I/O error, dev sdk, sector
1074003968
[Mon Jun 22 10:07:21 2020] Buffer I/O error on dev sdk, logical block
134250496, lost sync page write
[Mon Jun 22 10:07:21 2020] JBD2: Error -5 detected when updating journal
superblock for sdk-8.
[Mon Jun 22 10:25:43 2020] sd 5:0:0:0: rejecting I/O to offline device
[Mon Jun 22 10:25:43 2020] print_req_error: I/O error, dev sdk, sector 0
[Mon Jun 22 10:25:43 2020] Buffer I/O error on dev sdk, logical block 0, lost
sync page write
[Mon Jun 22 10:25:43 2020] EXT4-fs (sdk): I/O error while writing superblock
[Mon Jun 22 10:25:43 2020] EXT4-fs error (device sdk):
ext4_journal_check_start:61: Detected aborted journal
[Mon Jun 22 10:25:43 2020] EXT4-fs (sdk): Remounting filesystem read-only
[Mon Jun 22 10:25:43 2020] sd 5:0:0:0: rejecting I/O to offline device
[Mon Jun 22 10:25:43 2020] print_req_error: I/O error, dev sdk, sector 0
[Mon Jun 22 10:25:43 2020] Buffer I/O error on dev sdk, logical block 0, lost
sync page write
[Mon Jun 22 10:25:43 2020] EXT4-fs (sdk): I/O error while writing superblock


Hello, after a few days of testing, I found another problem. When I use the
initiator login target, and format the ext4 file system, and write some data,
there will be an error as reported above.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

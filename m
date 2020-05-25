Return-Path: <SRS0=b1yV=7H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23354C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 25 May 2020 21:34:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E01E52075F
	for <linux-scsi@archiver.kernel.org>; Mon, 25 May 2020 21:34:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730210AbgEYVeG convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 May 2020 17:34:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:45960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726393AbgEYVeG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 May 2020 17:34:06 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 207891] New: Kernel log keeps growing
Date:   Mon, 25 May 2020 21:34:05 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: g-dalbudak@hotmail.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-207891-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=207891

            Bug ID: 207891
           Summary: Kernel log keeps growing
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 5.4.0-1011-raspi
          Hardware: ARM
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: g-dalbudak@hotmail.de
        Regression: No

Created attachment 289279
  --> https://bugzilla.kernel.org/attachment.cgi?id=289279&action=edit
zipped log files

I noticed that my raspberry pi 4's boot drive is full and found out that the
kernel.log and syslog is very big. Both always append this over and over again
in the log files multiple times a second. I always truncate the content but
this is a problem which come with the latest update.
Didn't had the problems when I had 5.4.0-1008-raspi installed.


May 25 20:50:48 merts-pi kernel: [79846.673137] ------------[ cut here
]------------
May 25 20:50:48 merts-pi kernel: [79846.673159] WARNING: CPU: 2 PID: 281 at
drivers/mmc/host/sdhci.c:1101 sdhci_prepare_data+0x3dc/0x7b0
May 25 20:50:48 merts-pi kernel: [79846.673161] Modules linked in: binfmt_misc
dm_multipath scsi_dh_rdac scsi_dh_emc scsi_dh_alua btsdio bluetooth
ecdh_generic ecc brcmfmac bcm2835_v4l2(CE) bcm2835_mmal_vchiq(CE) brcmutil
videobuf2_vmalloc cfg80211 videobuf2_memops videobuf2_v4l2 videobuf2_common
videodev snd_bcm2835(CE) mc snd_pcm snd_timer vc_sm_cma(CE) snd
raspberrypi_hwmon rpivid_mem uio_pdrv_genirq uio sch_fq_codel sunrpc drm
ip_tables x_tables autofs4 btrfs zstd_compress raid10 raid456 async_raid6_recov
async_memcpy async_pq async_xor async_tx xor xor_neon raid6_pq libcrc32c raid1
raid0 multipath linear crct10dif_ce spidev phy_generic uas usb_storage
aes_neon_bs aes_neon_blk crypto_simd cryptd
May 25 20:50:48 merts-pi kernel: [79846.673212] CPU: 2 PID: 281 Comm:
kworker/2:1H Tainted: G        WC  E     5.4.0-1011-raspi #11-Ubuntu
May 25 20:50:48 merts-pi kernel: [79846.673214] Hardware name: Raspberry Pi 4
Model B Rev 1.1 (DT)
May 25 20:50:48 merts-pi kernel: [79846.673223] Workqueue: kblockd
blk_mq_run_work_fn
May 25 20:50:48 merts-pi kernel: [79846.673228] pstate: a0400085 (NzCv daIf
+PAN -UAO)
May 25 20:50:48 merts-pi kernel: [79846.673231] pc :
sdhci_prepare_data+0x3dc/0x7b0
May 25 20:50:48 merts-pi kernel: [79846.673234] lr :
sdhci_prepare_data+0x2cc/0x7b0
May 25 20:50:48 merts-pi kernel: [79846.673235] sp : ffff800010eb39b0
May 25 20:50:48 merts-pi kernel: [79846.673237] x29: ffff800010eb39b0 x28:
ffff0000eb734000 
May 25 20:50:48 merts-pi kernel: [79846.673240] x27: 0000000000000001 x26:
0000000000000000 
May 25 20:50:48 merts-pi kernel: [79846.673243] x25: ffff0000f63d1000 x24:
ffff0000f63d1580 
May 25 20:50:48 merts-pi kernel: [79846.673245] x23: 0000000000418958 x22:
ffff0000eb03b498 
May 25 20:50:48 merts-pi kernel: [79846.673247] x21: ffff0000f6193b80 x20:
ffff0000eb03b518 
May 25 20:50:48 merts-pi kernel: [79846.673250] x19: ffff0000f63d1580 x18:
0000000000000000 
May 25 20:50:48 merts-pi kernel: [79846.673252] x17: 0000000000000000 x16:
0000000000000000 
May 25 20:50:48 merts-pi kernel: [79846.673254] x15: 0000000000000000 x14:
0000000000000000 
May 25 20:50:48 merts-pi kernel: [79846.673256] x13: ffff0000fb74d000 x12:
00000000001fffff 
May 25 20:50:48 merts-pi kernel: [79846.673259] x11: 0000000000000003 x10:
0000000000008000 
May 25 20:50:48 merts-pi kernel: [79846.673261] x9 : 0000000000000080 x8 :
0000000000000002 
May 25 20:50:48 merts-pi kernel: [79846.673263] x7 : 000000003a600000 x6 :
ffffd33c9ee09a44 
May 25 20:50:48 merts-pi kernel: [79846.673266] x5 : ffffffffffffffff x4 :
0000000000000020 
May 25 20:50:48 merts-pi kernel: [79846.673268] x3 : 0000000000000002 x2 :
0000000000000000 
May 25 20:50:48 merts-pi kernel: [79846.673270] x1 : ffff0000eb07f000 x0 :
00000000ffffffe4 
May 25 20:50:48 merts-pi kernel: [79846.673273] Call trace:
May 25 20:50:48 merts-pi kernel: [79846.673277]  sdhci_prepare_data+0x3dc/0x7b0
May 25 20:50:48 merts-pi kernel: [79846.673280]  sdhci_send_command+0xe0/0x5f0
May 25 20:50:48 merts-pi kernel: [79846.673282]  sdhci_request+0x110/0x150
May 25 20:50:48 merts-pi kernel: [79846.673286]  __mmc_start_request+0x88/0x1a8
May 25 20:50:48 merts-pi kernel: [79846.673289]  mmc_start_request+0x98/0xc0
May 25 20:50:48 merts-pi kernel: [79846.673292] 
mmc_blk_mq_issue_rq+0x30c/0x778
May 25 20:50:48 merts-pi kernel: [79846.673294]  mmc_mq_queue_rq+0x14c/0x320
May 25 20:50:48 merts-pi kernel: [79846.673297] 
blk_mq_dispatch_rq_list+0xa4/0x5f8
May 25 20:50:48 merts-pi kernel: [79846.673301] 
blk_mq_do_dispatch_sched+0x68/0x108
May 25 20:50:48 merts-pi kernel: [79846.673303] 
blk_mq_sched_dispatch_requests+0x164/0x1c0
May 25 20:50:48 merts-pi kernel: [79846.673306] 
__blk_mq_run_hw_queue+0xfc/0x158
May 25 20:50:48 merts-pi kernel: [79846.673308]  blk_mq_run_work_fn+0x28/0x38
May 25 20:50:48 merts-pi kernel: [79846.673312]  process_one_work+0x1d0/0x430
May 25 20:50:48 merts-pi kernel: [79846.673314]  worker_thread+0x54/0x4a0
May 25 20:50:48 merts-pi kernel: [79846.673318]  kthread+0xfc/0x128
May 25 20:50:48 merts-pi kernel: [79846.673322]  ret_from_fork+0x10/0x1c
May 25 20:50:48 merts-pi kernel: [79846.673324] ---[ end trace 3f9a941cee68d128
]---

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14644] PROBLEM: system locking when burning dvd with an
 externel usb dvd writer
Date: Fri, 20 Nov 2009 11:38:56 GMT
Message-ID: <200911201138.nAKBcuUs017049@demeter.kernel.org>
References: <bug-14644-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:51708 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbZKTLiu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Nov 2009 06:38:50 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAKBcu56017050
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2009 11:38:56 GMT
In-Reply-To: <bug-14644-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14644





--- Comment #3 from Laurent Carlier <lordheavym@gmail.com>  2009-11-20 11:38:55 ---
Here is the revelant part of the log:

INFO: task wodim:2562 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
wodim         D ffff88011eef5da0     0  2562   2420 0x00000000
 ffff88011eef5da0 0000000000000082 0000000000000000 ffff88011e41b580
 ffff8800282d3b00 ffff8800282d3b00 ffff88011e85a820 ffff880091b18000
 ffff88011eef6040 000000000000e1c8 ffff88011eef6040 ffff880091b18000
Call Trace:
 [<ffffffff8131839d>] ? schedule_timeout+0x23d/0x380
 [<ffffffff81199d1e>] ? blk_peek_request+0x13e/0x220
 [<ffffffff81317235>] ? wait_for_common+0xd5/0x190
 [<ffffffff81045200>] ? default_wake_function+0x0/0x20
 [<ffffffff8119eb79>] ? blk_execute_rq+0x79/0xe0
 [<ffffffff8119e933>] ? blk_rq_map_user+0x1b3/0x2a0
 [<ffffffff811a2a05>] ? sg_io+0x2b5/0x3f0
 [<ffffffff811a33b0>] ? scsi_cmd_ioctl+0x4e0/0x540
 [<ffffffff81053cae>] ? current_fs_time+0x1e/0x30
 [<ffffffff81318c7d>] ? __mutex_lock_slowpath+0x23d/0x330
 [<ffffffff81039880>] ? __wake_up_common+0x50/0x80
 [<ffffffff811180b1>] ? file_update_time+0x111/0x1b0
 [<ffffffffa039dcc1>] ? cdrom_ioctl+0x51/0xff0 [cdrom]
 [<ffffffff8110ae5e>] ? pipe_write+0x41e/0x570
 [<ffffffffa0164408>] ? sr_block_ioctl+0x58/0xd0 [sr_mod]
 [<ffffffff811a0145>] ? __blkdev_driver_ioctl+0x75/0x90
 [<ffffffff811a05eb>] ? blkdev_ioctl+0x1fb/0x700
 [<ffffffff81130267>] ? block_ioctl+0x37/0x40
 [<ffffffff81111ecd>] ? vfs_ioctl+0x1d/0xb0
 [<ffffffff81112004>] ? do_vfs_ioctl+0x4/0x570
 [<ffffffff81112088>] ? do_vfs_ioctl+0x88/0x570
 [<ffffffff811125f0>] ? sys_ioctl+0x80/0xa0
 [<ffffffff81102a9e>] ? sys_write+0x4e/0x90
 [<ffffffff8100c042>] ? system_call_fastpath+0x16/0x1b
usb 3-6: reset high speed USB device using ehci_hcd and address 2

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

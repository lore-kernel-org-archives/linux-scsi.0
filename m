From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 114401] New: crash dump aic94xx
Date: Fri, 11 Mar 2016 13:47:03 +0000
Message-ID: <bug-114401-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35398 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878AbcCKNrS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Mar 2016 08:47:18 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 68C702035E
	for <linux-scsi@vger.kernel.org>; Fri, 11 Mar 2016 13:47:11 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 4A30320361
	for <linux-scsi@vger.kernel.org>; Fri, 11 Mar 2016 13:47:04 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=114401

            Bug ID: 114401
           Summary: crash dump aic94xx
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 4.4.3-gentoo #1 SMP Mon Feb 29 16:03:39 MSK 2016
                    x86_64
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: AIC94XX
          Assignee: scsi_drivers-aic94xx@kernel-bugs.osdl.org
          Reporter: bulanovmg@yandex.ru
        Regression: No

[350548.713114] ------------[ cut here ]------------
[350548.713130] kernel BUG at drivers/scsi/aic94xx/aic94xx_hwi.h:344!
[350548.713144] invalid opcode: 0000 [#1] SMP
[350548.713159] Modules linked in: w83793 w83627hf hwmon_vid aic94xx
[350548.713184] CPU: 1 PID: 1372 Comm: scsi_eh_6 Tainted: G        W      
4.4.3-gentoo #1
[350548.713200] Hardware name: Supermicro X7DB8/X7DB8, BIOS 2.1c 07/04/2011
[350548.713215] task: ffff8800bb992340 ti: ffff8800bb168000 task.ti:
ffff8800bb168000
[350548.713231] RIP: 0010:[<ffffffffa000b9e4>]  [<ffffffffa000b9e4>]
asd_abort_task+0x444/0x450 [aic94xx]
[350548.713257] RSP: 0018:ffff8800bb16bd18  EFLAGS: 00010283
[350548.713269] RAX: 0000000000000246 RBX: ffff88007b0d7840 RCX:
0000000000000000
[350548.713284] RDX: 0000000000000001 RSI: 0000000000000246 RDI:
ffff8800bbbc6808
[350548.713299] RBP: ffff8800bb16bd90 R08: ffff8800bb168000 R09:
0000000000000000
[350548.713314] R10: 0000000000000000 R11: 0000000000000004 R12:
ffff8800b9d18000
[350548.713329] R13: ffff880034e0bcc0 R14: ffff8800bbbc6808 R15:
ffff8800bb16bd48
[350548.713590] FS:  0000000000000000(0000) GS:ffff88013fc80000(0000)
knlGS:0000000000000000
[350548.713853] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[350548.713989] CR2: 00007fa7f9e49000 CR3: 0000000001e09000 CR4:
00000000000406e0
[350548.714086] Stack:
[350548.714391]  0000000000000000 0000880000000000 ffffffff00000000
ffff880000000000
[350548.714391]  ffff8800bb16bd38 ffff8800bb16bd38 ffff880000000000
ffff880000000000
[350548.714391]  ffff8800bb16bd58 ffff8800bb16bd58 0000000000000005
ffff8800bb16bde8
[350548.714391] Call Trace:
[350548.714391]  [<ffffffff8159dd6e>] sas_scsi_recover_host+0x42e/0xb60
[350548.714391]  [<ffffffff81584eb2>] scsi_error_handler+0xa2/0x520
[350548.714391]  [<ffffffff81806968>] ? __schedule+0x348/0x8b0
[350548.714391]  [<ffffffff81584e10>] ? scsi_eh_get_sense+0x170/0x170
[350548.714391]  [<ffffffff81584e10>] ? scsi_eh_get_sense+0x170/0x170
[350548.714391]  [<ffffffff81095154>] kthread+0xc4/0xe0
[350548.714391]  [<ffffffff81095090>] ? kthread_worker_fn+0x140/0x140
[350548.714391]  [<ffffffff8180a91f>] ret_from_fork+0x3f/0x70
[350548.714391]  [<ffffffff81095090>] ? kthread_worker_fn+0x140/0x140
[350548.714391] Code: fe ff ff b8 02 00 00 00 eb e9 8b 45 90 85 c0 75 e2 4c 89
e7 e8 de f4 ff ff 89 45 88 e9 cf fe ff ff b8 f4 ff ff ff e9 06 fe ff ff <0f> 0b
c7 45 88 05 00 00 00 eb 99 90 55 31 c9 ba 02 00 00 00 48
[350548.714391] RIP  [<ffffffffa000b9e4>] asd_abort_task+0x444/0x450 [aic94xx]
[350548.714391]  RSP <ffff8800bb16bd18>
[350548.714978] ---[ end trace ce789fd9c515a590 ]---

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

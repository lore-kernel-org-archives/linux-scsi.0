Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07280C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 02:18:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C310D61582
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 02:18:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhC2CSU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Mar 2021 22:18:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:42810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229822AbhC2CSQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 28 Mar 2021 22:18:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6358960C41
        for <linux-scsi@vger.kernel.org>; Mon, 29 Mar 2021 02:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616984296;
        bh=Yv/YJixy62fzT7ZHPvXBkrB1IzghGcwqOo15aghnjek=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=RGUXu7brYuLfh97gdR2W282Rg1uv8tSueUMK6jU99kIALVXb1ujitI8DodGxVf7jq
         2aV2M5rv1DQfsYxQTq49idxkElA8fF+0FKNJnyr1oOYhZVfqxPGjyGJJQ9n4l0i9c3
         7EVx1uIgCD2Oi0ccWVsZez4QIMJ3B1vG5I/OS2UBdVxGqcengouP72U7lfF0w7yybx
         JcXijPoUiS2ExvWZo30qOizK1TGJ0TGPz0auC7fYs5vyNSGHOcc5B8wjzlK8I8EMdr
         DlMd14i/ddxu57SuDPRYQ7fNIcz2o5/REhl89dSHgYUfapZqnuBkY18Yfyewy9Cksp
         kFvD0OuDw/QLw==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 187221] HPSA resetting logical / reset logical
Date:   Mon, 29 Mar 2021 02:18:16 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: vsudoblog@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: cc
Message-ID: <bug-187221-11613-UFf6CTHzl2@https.bugzilla.kernel.org/>
In-Reply-To: <bug-187221-11613@https.bugzilla.kernel.org/>
References: <bug-187221-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D187221

vsudo (vsudoblog@gmail.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |vsudoblog@gmail.com

--- Comment #2 from vsudo (vsudoblog@gmail.com) ---
I have a HPE Gen9 using RAI5, I get this error and distributed on this serv=
er
is resynced and I don't understand the reason why OS doesn't accept and fai=
lure
disk in RAID5 is normal.

[Sun Mar 28 09:47:04 2021] hpsa 0000:03:00.0: device is ready.
[Sun Mar 28 09:47:04 2021] hpsa 0000:03:00.0: scsi 0:1:0:4: reset logical=20
completed successfully Direct-Access     HP       LOGICAL VO
LUME   RAID-5 SSDSmartPathCap- En- Exp=3D1
[Sun Mar 28 09:54:54 2021] hpsa 0000:03:00.0: scsi 0:1:0:4: resetting logic=
al=20
Direct-Access     HP       LOGICAL VOLUME   RAID-5 SSDSm
artPathCap- En- Exp=3D1
[Sun Mar 28 09:55:50 2021] hpsa 0000:03:00.0: device is ready.
[Sun Mar 28 09:55:50 2021] hpsa 0000:03:00.0: scsi 0:1:0:4: reset logical=20
completed successfully Direct-Access     HP       LOGICAL VO
LUME   RAID-5 SSDSmartPathCap- En- Exp=3D1
[Sun Mar 28 09:56:35 2021] hpsa 0000:03:00.0: scsi 0:1:0:4: resetting logic=
al=20
Direct-Access     HP       LOGICAL VOLUME   RAID-5 SSDSm
artPathCap- En- Exp=3D1
[Sun Mar 28 09:57:01 2021] hpsa 0000:03:00.0: device is ready.
[Sun Mar 28 09:57:01 2021] hpsa 0000:03:00.0: scsi 0:1:0:4: reset logical=20
completed successfully Direct-Access     HP       LOGICAL VO
LUME   RAID-5 SSDSmartPathCap- En- Exp=3D1
[Sun Mar 28 10:00:56 2021] hpsa 0000:03:00.0: scsi 0:1:0:4: resetting logic=
al=20
Direct-Access     HP       LOGICAL VOLUME   RAID-5 SSDSm
artPathCap- En- Exp=3D1
[Sun Mar 28 10:00:57 2021] hpsa 0000:03:00.0: device is ready.
[Sun Mar 28 10:00:57 2021] hpsa 0000:03:00.0: scsi 0:1:0:4: reset logical=20
completed successfully Direct-Access     HP       LOGICAL VO
LUME   RAID-5 SSDSmartPathCap- En- Exp=3D1
[Sun Mar 28 10:05:13 2021] hpsa 0000:03:00.0: scsi 0:1:0:4: resetting logic=
al=20
Direct-Access     HP       LOGICAL VOLUME   RAID-5 SSDSm
artPathCap- En- Exp=3D1
[Sun Mar 28 10:07:16 2021] INFO: task scsi_eh_0:473 blocked for more than 1=
20
seconds.
[Sun Mar 28 10:07:16 2021]       Not tainted 4.15.0-55-generic #60-Ubuntu
[Sun Mar 28 10:07:16 2021] "echo 0 > /proc/sys/kernel/hung_task_timeout_sec=
s"
disables this message.
[Sun Mar 28 10:07:16 2021] scsi_eh_0       D    0   473      2 0x80000000
[Sun Mar 28 10:07:16 2021] Call Trace:
[Sun Mar 28 10:07:16 2021]  __schedule+0x291/0x8a0
[Sun Mar 28 10:07:16 2021]  ? dev_printk_emit+0x4a/0x70
[Sun Mar 28 10:07:16 2021]  schedule+0x2c/0x80
[Sun Mar 28 10:07:16 2021]  schedule_timeout+0x1cf/0x350
[Sun Mar 28 10:07:16 2021]  ? __dev_printk+0x3c/0x80
[Sun Mar 28 10:07:16 2021]  ? dev_printk+0x56/0x80
[Sun Mar 28 10:07:16 2021]  io_schedule_timeout+0x1e/0x50
[Sun Mar 28 10:07:16 2021]  wait_for_completion_io+0xba/0x140
[Sun Mar 28 10:07:16 2021]  ? wake_up_q+0x80/0x80
[Sun Mar 28 10:07:16 2021]  hpsa_scsi_do_simple_cmd.isra.60+0xb3/0xf0 [hpsa]
[Sun Mar 28 10:07:16 2021]  hpsa_eh_device_reset_handler+0x3e4/0x7b0 [hpsa]
[Sun Mar 28 10:07:16 2021]  ? __switch_to_asm+0x40/0x70
[Sun Mar 28 10:07:16 2021]  ? __switch_to_asm+0x34/0x70
[Sun Mar 28 10:07:16 2021]  ? scsi_device_put+0x2b/0x30
[Sun Mar 28 10:07:16 2021]  scsi_eh_ready_devs+0x333/0xbf0
[Sun Mar 28 10:07:16 2021]  ? __pm_runtime_resume+0x5b/0x80
[Sun Mar 28 10:07:16 2021]  ? scsi_try_target_reset+0x90/0x90
[Sun Mar 28 10:07:16 2021]  scsi_error_handler+0x4c3/0x5b0
[Sun Mar 28 10:07:16 2021]  kthread+0x121/0x140
[Sun Mar 28 10:07:16 2021]  ? scsi_eh_get_sense+0x200/0x200
[Sun Mar 28 10:07:16 2021]  ? kthread_create_worker_on_cpu+0x70/0x70
[Sun Mar 28 10:07:16 2021]  ret_from_fork+0x35/0x40
[Sun Mar 28 10:07:16 2021] INFO: task systemd-journal:109135 blocked for mo=
re
than 120 seconds.
[Sun Mar 28 10:07:16 2021]       Not tainted 4.15.0-55-generic #60-Ubuntu
[Sun Mar 28 10:07:16 2021] "echo 0 > /proc/sys/kernel/hung_task_timeout_sec=
s"
disables this message.
[Sun Mar 28 10:07:16 2021] systemd-journal D    0 109135      1 0x00000320
[Sun Mar 28 10:07:16 2021] Call Trace:
[Sun Mar 28 10:07:16 2021]  __schedule+0x291/0x8a0
[Sun Mar 28 10:07:16 2021]  ? intel_pstate_update_pstate+0x40/0x40

My website: https://vsudo.blog

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.=

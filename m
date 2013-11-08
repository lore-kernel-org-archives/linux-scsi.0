From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60758] module scsi_wait_scan not found kernel panic on boot
Date: Fri, 08 Nov 2013 15:34:29 +0000
Message-ID: <bug-60758-11613-q7TAJdyYe2@https.bugzilla.kernel.org/>
References: <bug-60758-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:39425 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516Ab3KHPei (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Nov 2013 10:34:38 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 349AB20453
	for <linux-scsi@vger.kernel.org>; Fri,  8 Nov 2013 15:34:36 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 634E82020A
	for <linux-scsi@vger.kernel.org>; Fri,  8 Nov 2013 15:34:29 +0000 (UTC)
In-Reply-To: <bug-60758-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60758

--- Comment #45 from newbie <kernel.tw@gmail.com> ---
> If you do not like seeing the message,
> just "comment out" line number 165 in your /etc/rc.d/rc.sysinit file.

seems no help, that message still exist, I don't know why.
but really problem is:

I use two SATA 200G(sda/sdb) build a soft RAID1 (md)
three days ago, one disk error and off,
but I just discovered today,
after I mdadm add fix it then reboot,
the bad disk show read error constantly,
I can't use normally,so I use the other good one boot, then...

 FATAL: Module scsi_wait_scan not found

then...

message loop~

I use 3.10.17, 3.10.18, the same situation,I can't boot into system,
so finally,I boot with CentOS 2.6 kernel into the system save data,
then shutdown now... ><

-- 
You are receiving this mail because:
You are the assignee for the bug.

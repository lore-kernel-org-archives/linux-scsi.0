From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 48241] oops when setting up LVM
Date: Wed,  3 Oct 2012 15:36:53 +0000 (UTC)
Message-ID: <20121003153653.CFA6311FC3E@bugzilla.kernel.org>
References: <bug-48241-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:44663 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932574Ab2JCPhB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Oct 2012 11:37:01 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 31544204E8
	for <linux-scsi@vger.kernel.org>; Wed,  3 Oct 2012 15:37:00 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 8A772204E3
	for <linux-scsi@vger.kernel.org>; Wed,  3 Oct 2012 15:36:55 +0000 (UTC)
In-Reply-To: <bug-48241-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=48241





--- Comment #5 from Daniel Santos <daniel.santos@pobox.com>  2012-10-03 15:36:53 ---
> The image says the RIP is at kthread_data + 0xb
> 
> That implies something went wrong within the workqueue or kthread
> systems, I've cc'd linux-kernel, but it's a bit of a vague thing to go
> on and could conceivably be a hardware issue (or some weird thread
> interaction in linux-next).

OK, thanks. I was kinda guessing it was from scsi_setup_fs_cmnd when I choose a
component, I don't really know that part of the kernel.

> The first question would be "does it happen in vanilla 3.6"?

I haven't tried 3.6 yet, but I did just rebuild using gcc 4.6.3 to make sure it
wasn't compiler related.  After that, I will try 3.6 built with gcc 4.7.1. 
Also, I got this in -mmotm prior to trying linux-next.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

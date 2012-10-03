From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 48241] oops when setting up LVM
Date: Wed,  3 Oct 2012 15:23:11 +0000 (UTC)
Message-ID: <20121003152311.2582511FC43@bugzilla.kernel.org>
References: <bug-48241-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:44076 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933157Ab2JCPXY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Oct 2012 11:23:24 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9AEE3204CC
	for <linux-scsi@vger.kernel.org>; Wed,  3 Oct 2012 15:23:19 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 2E530204C6
	for <linux-scsi@vger.kernel.org>; Wed,  3 Oct 2012 15:23:11 +0000 (UTC)
In-Reply-To: <bug-48241-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=48241





--- Comment #4 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2012-10-03 15:23:10 ---
Reply-To: James.Bottomley@HansenPartnership.com

On Wed, 2012-10-03 at 15:04 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=48241
> 
>            Summary: oops when setting up LVM
>            Product: IO/Storage
>            Version: 2.5
>     Kernel Version: 3.6.0-next-20121003
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: SCSI
>         AssignedTo: linux-scsi@vger.kernel.org
>         ReportedBy: daniel.santos@pobox.com
>         Regression: No
> 
> 
> Created an attachment (id=81921)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=81921)
>  --> (https://bugzilla.kernel.org/attachment.cgi?id=81921)
> image of oops

The image says the RIP is at kthread_data + 0xb

That implies something went wrong within the workqueue or kthread
systems, I've cc'd linux-kernel, but it's a bit of a vague thing to go
on and could conceivably be a hardware issue (or some weird thread
interaction in linux-next).

The first question would be "does it happen in vanilla 3.6"?

James

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

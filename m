From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 47781] ata2: exception Emask 0x10 SAct 0x0 SErr 0x4050002
 action 0xe frozen
Date: Mon, 24 Sep 2012 05:38:59 +0000 (UTC)
Message-ID: <20120924053859.9B36911FBF3@bugzilla.kernel.org>
References: <bug-47781-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:43897 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792Ab2IXFjN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Sep 2012 01:39:13 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9A487202EB
	for <linux-scsi@vger.kernel.org>; Mon, 24 Sep 2012 05:39:09 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id A15AC202E2
	for <linux-scsi@vger.kernel.org>; Mon, 24 Sep 2012 05:39:00 +0000 (UTC)
In-Reply-To: <bug-47781-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=47781





--- Comment #6 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2012-09-24 05:38:59 ---
Reply-To: James.Bottomley@HansenPartnership.com

On Sun, 2012-09-23 at 21:07 +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=47781
> 
> 
> Alan <alan@lxorguk.ukuu.org.uk> changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>           Component|IDE                         |SCSI
>          AssignedTo|io_ide@kernel-bugs.osdl.org |linux-scsi@vger.kernel.org

I'm a bit mystified by this reassignment.  This looks like a pure ata
problem to me; what makes you think it's SCSI?

James

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 101011] Kernel Oops when disconnecting a mounted ext4 usb stick
Date: Mon, 28 Sep 2015 18:49:28 +0000
Message-ID: <bug-101011-11613-X9wWaEcn7M@https.bugzilla.kernel.org/>
References: <bug-101011-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48368 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbbI1Stc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Sep 2015 14:49:32 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7D48C20764
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2015 18:49:31 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id ACFF820718
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2015 18:49:28 +0000 (UTC)
In-Reply-To: <bug-101011-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=101011

Ronny Standtke <ronny.standtke@gmx.net> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |ronny.standtke@gmx.net

--- Comment #11 from Ronny Standtke <ronny.standtke@gmx.net> ---
This bug is already hitting distributions, e.g. here:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1478623

I hope this helps to get the right people into contact and sorry if I just
added to the noise...

-- 
You are receiving this mail because:
You are the assignee for the bug.

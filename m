From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 101011] Kernel Oops when disconnecting a mounted ext4 usb stick
Date: Sat, 15 Aug 2015 08:19:05 +0000
Message-ID: <bug-101011-11613-fwpVG3Kvou@https.bugzilla.kernel.org/>
References: <bug-101011-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35822 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbbHOITJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Aug 2015 04:19:09 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CFB3C2069A
	for <linux-scsi@vger.kernel.org>; Sat, 15 Aug 2015 08:19:07 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 392032063A
	for <linux-scsi@vger.kernel.org>; Sat, 15 Aug 2015 08:19:06 +0000 (UTC)
In-Reply-To: <bug-101011-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=101011

--- Comment #9 from Christoph Hellwig <hch@lst.de> ---
Hi Ted,


sorry for the delay - I saw the mail Jan Cc'ed me on yesterday.  After
my changes it should not go away and I had tested the original eject
test that it indeed didn't.  Either I forgot a case, or the major
writeback Tejun did a little later regressed it.

As I won't have time to look into it ASAP I'd suggest to revert my
patch for now.  In the long run I really don't want to have these
checks spread over file system so I plan to look into it once I
get a few spare hours.

-- 
You are receiving this mail because:
You are the assignee for the bug.

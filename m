From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60644] MPT2SAS drops all HDDs when under high I/O
Date: Tue, 21 Jan 2014 02:54:42 +0000
Message-ID: <bug-60644-11613-8lp2KZteuw@https.bugzilla.kernel.org/>
References: <bug-60644-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:45307 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917AbaAUCyp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jan 2014 21:54:45 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 282472017E
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jan 2014 02:54:44 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 4548720161
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jan 2014 02:54:43 +0000 (UTC)
In-Reply-To: <bug-60644-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60644

--- Comment #47 from Konstantin <ktrackfd@gmail.com> ---
Thanks for the hint at ASPM ! After disabling it in the BIOS I was able to
scrub my zpool without a single issue.

# zpool status

....
scan: scrub repaired 0 in 6h32m with 0 errors on Tue Jan 21 03:15:12 2014
....

Problem solved. Proper support for PCIe ASPM would be great though !

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

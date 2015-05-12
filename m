From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16058] [BUG] Cannot boot any kernel from 2.6.27 on if a 256
 byte sector SCSI disk is attached
Date: Tue, 12 May 2015 13:29:20 +0000
Message-ID: <bug-16058-11613-THrRW5avgR@https.bugzilla.kernel.org/>
References: <bug-16058-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34181 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932574AbbELN3X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 May 2015 09:29:23 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6680E20421
	for <linux-scsi@vger.kernel.org>; Tue, 12 May 2015 13:29:22 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 77EED2041C
	for <linux-scsi@vger.kernel.org>; Tue, 12 May 2015 13:29:21 +0000 (UTC)
In-Reply-To: <bug-16058-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16058

Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |REOPENED
     Kernel Version|2.6.27                      |4.0.2
         Resolution|OBSOLETE                    |---

--- Comment #17 from Alan <alan@lxorguk.ukuu.org.uk> ---
It would be good to get this fixed so if you have a patch it would be good to
get it upstream. The only users I know of 256 byte/sector are a few ancient USB
devices and also retro-computing folk . For the retro stuff the file systems
are not native Linux anyway so requiring sg wouldn't be a problem.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

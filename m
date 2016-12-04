From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151631] "Synchronizing SCSI cache" fails during(and delays)
 reboot/shutdown
Date: Sun, 04 Dec 2016 20:22:03 +0000
Message-ID: <bug-151631-11613-Stf3R8ZvJH@https.bugzilla.kernel.org/>
References: <bug-151631-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:59072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750979AbcLDUWH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 4 Dec 2016 15:22:07 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 87D20202BE
        for <linux-scsi@vger.kernel.org>; Sun,  4 Dec 2016 20:22:05 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 7888020272
        for <linux-scsi@vger.kernel.org>; Sun,  4 Dec 2016 20:22:03 +0000 (UTC)
In-Reply-To: <bug-151631-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=151631

Rich <fr0@bitservices.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |fr0@bitservices.org.uk

--- Comment #7 from Rich <fr0@bitservices.org.uk> ---
Very similar (if not same) problem happening on my works PC - a Dell Precision
T1700. I will try and get a screenshot and add it to this thread.

The problem began with Kernel 4.8.6 and is still present (currently running
Kernel 4.8.11).

Very annoying on shutdown. I have absolutely no idea if the disks' cache is
actually flushing or not - so data integrity is a concern. Its a magnetic disk
and I have been running fsck on it regularly (no issues found as of yet) and
been avoiding shutting the PC down.

Point of this comment: Its still an issue on some PCs. Anyone else finding the
same?

-- 
You are receiving this mail because:
You are the assignee for the bug.

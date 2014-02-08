From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 70271] rmmod st causes general protection fault
Date: Sat, 08 Feb 2014 17:55:02 +0000
Message-ID: <bug-70271-11613-VjO5WFGtyf@https.bugzilla.kernel.org/>
References: <bug-70271-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:53042 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949AbaBHRzH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Feb 2014 12:55:07 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2C0922016C
	for <linux-scsi@vger.kernel.org>; Sat,  8 Feb 2014 17:55:06 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id F1D4D20181
	for <linux-scsi@vger.kernel.org>; Sat,  8 Feb 2014 17:55:02 +0000 (UTC)
In-Reply-To: <bug-70271-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=70271

Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alan@lxorguk.ukuu.org.uk
          Component|Other                       |SCSI
           Assignee|drivers_other@kernel-bugs.o |linux-scsi@vger.kernel.org
                   |sdl.org                     |
            Product|Drivers                     |IO/Storage

-- 
You are receiving this mail because:
You are the assignee for the bug.

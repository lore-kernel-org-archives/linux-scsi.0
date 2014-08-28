From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 83391] Oops  on sd_mod
Date: Thu, 28 Aug 2014 13:52:29 +0000
Message-ID: <bug-83391-11613-mc3BqdTTr9@https.bugzilla.kernel.org/>
References: <bug-83391-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:43688 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731AbaH1Nwc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2014 09:52:32 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 62DFE20179
	for <linux-scsi@vger.kernel.org>; Thu, 28 Aug 2014 13:52:31 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 90B802015A
	for <linux-scsi@vger.kernel.org>; Thu, 28 Aug 2014 13:52:29 +0000 (UTC)
In-Reply-To: <bug-83391-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=83391

Jeff Moyer <jmoyer@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jmoyer@redhat.com

--- Comment #3 from Jeff Moyer <jmoyer@redhat.com> ---
This is a vendor kernel.  You should file a bug report with Red Hat here:
 
https://bugzilla.redhat.com/enter_bug.cgi?product=Red%20Hat%20Enterprise%20Linux%206

First, though, you should update to a newer kernel... that one is several years
old.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

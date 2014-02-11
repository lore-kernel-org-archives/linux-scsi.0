From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 70271] rmmod st causes general protection fault
Date: Tue, 11 Feb 2014 21:28:39 +0000
Message-ID: <bug-70271-11613-3mBuqcZwWp@https.bugzilla.kernel.org/>
References: <bug-70271-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:44377 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbaBKV2m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Feb 2014 16:28:42 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id ADB1220212
	for <linux-scsi@vger.kernel.org>; Tue, 11 Feb 2014 21:28:41 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id E4BA32020E
	for <linux-scsi@vger.kernel.org>; Tue, 11 Feb 2014 21:28:40 +0000 (UTC)
In-Reply-To: <bug-70271-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=70271

Maurizio Lombardi <mlombard@redhat.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mlombard@redhat.com

--- Comment #1 from Maurizio Lombardi <mlombard@redhat.com> ---
I sent a patch to the linux-scsi mailing list that fixes the problem for me.
Can someone test and review it?

http://marc.info/?l=linux-scsi&m=139215379402532&w=2

-- 
You are receiving this mail because:
You are the assignee for the bug.

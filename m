From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 98171] [Regression] Marvell SE91xx SATA 3 controllers not
 recognized correctly
Date: Tue, 30 Jun 2015 10:48:08 +0000
Message-ID: <bug-98171-11613-0stfN0e4pX@https.bugzilla.kernel.org/>
References: <bug-98171-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:49041 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119AbbF3KsL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Jun 2015 06:48:11 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 055C1204A0
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2015 10:48:10 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 284FE20459
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2015 10:48:09 +0000 (UTC)
In-Reply-To: <bug-98171-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=98171

Tom Yan <tom.ty89@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tom.ty89@gmail.com

--- Comment #2 from Tom Yan <tom.ty89@gmail.com> ---
Why don't you get linux 3.14 (linux-lts in the current Arch) and patch it with
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/patch/?id=bc6e7c4b0d1a1f742d96556f63d68f17f4e232c3
and see if it reproduce the issue?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

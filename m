From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 101371] OOPS: unplugging western digital passport drive
Date: Sun, 19 Jul 2015 02:37:48 +0000
Message-ID: <bug-101371-11613-kZVexilxaI@https.bugzilla.kernel.org/>
References: <bug-101371-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60781 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbbGSChv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Jul 2015 22:37:51 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 99F0920567
	for <linux-scsi@vger.kernel.org>; Sun, 19 Jul 2015 02:37:50 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id AEDDE205B5
	for <linux-scsi@vger.kernel.org>; Sun, 19 Jul 2015 02:37:48 +0000 (UTC)
In-Reply-To: <bug-101371-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=101371

Joe Lawrence <joe.lawrence@stratus.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |joe.lawrence@stratus.com

--- Comment #1 from Joe Lawrence <joe.lawrence@stratus.com> ---
Hi Ilan,

Have you tried the patch to drivers/scsi/scsi_pm.c that Alan posted in the
thread you mentioned:

https://www.mail-archive.com/linux-scsi@vger.kernel.org/msg37852.html

Thanks,

-- Joe

-- 
You are receiving this mail because:
You are the assignee for the bug.

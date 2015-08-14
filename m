From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 101011] Kernel Oops when disconnecting a mounted ext4 usb stick
Date: Fri, 14 Aug 2015 11:02:14 +0000
Message-ID: <bug-101011-11613-PGvplgVz20@https.bugzilla.kernel.org/>
References: <bug-101011-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40048 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754268AbbHNLCT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Aug 2015 07:02:19 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 43177207CA
	for <linux-scsi@vger.kernel.org>; Fri, 14 Aug 2015 11:02:18 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 5635C207CD
	for <linux-scsi@vger.kernel.org>; Fri, 14 Aug 2015 11:02:14 +0000 (UTC)
In-Reply-To: <bug-101011-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=101011

Maciej Szmigiero <mail@maciej.szmigiero.name> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mail@maciej.szmigiero.name

--- Comment #7 from Maciej Szmigiero <mail@maciej.szmigiero.name> ---
I can also confirm that this bug is present in latest stable kernel (4.1.5) and
reverting commit from comment 6 seems to fix it.

-- 
You are receiving this mail because:
You are the assignee for the bug.

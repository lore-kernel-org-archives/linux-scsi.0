From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60644] MPT2SAS drops all HDDs when under high I/O
Date: Tue, 27 Aug 2013 06:48:16 +0000
Message-ID: <bug-60644-11613-e0ANQYsbRS@https.bugzilla.kernel.org/>
References: <bug-60644-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:49952 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057Ab3H0GsT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Aug 2013 02:48:19 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C52F62037F
	for <linux-scsi@vger.kernel.org>; Tue, 27 Aug 2013 06:48:18 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id F10AB202DB
	for <linux-scsi@vger.kernel.org>; Tue, 27 Aug 2013 06:48:17 +0000 (UTC)
In-Reply-To: <bug-60644-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60644

Per Zetterlund <per@pz.se> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |per@pz.se

--- Comment #18 from Per Zetterlund <per@pz.se> ---
Looks to be the same as https://bugzilla.kernel.org/show_bug.cgi?id=59301

I'm seeing the same thing with a LSI 9211-8i-card (firmware 16) with kernel
3.2, 3.5 and 3.8. My 5 SATA-drives gets dropped when resyncing a SW RAID-6 set.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

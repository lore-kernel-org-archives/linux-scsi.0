From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42969] Softlockup during boot during init_sd
Date: Thu, 10 May 2012 21:51:00 +0000 (UTC)
Message-ID: <20120510215100.E01BF11FCE0@bugzilla.kernel.org>
References: <bug-42969-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:40059 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761180Ab2EJVvF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 May 2012 17:51:05 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 877FB2024D
	for <linux-scsi@vger.kernel.org>; Thu, 10 May 2012 21:51:03 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id A39A220254
	for <linux-scsi@vger.kernel.org>; Thu, 10 May 2012 21:51:01 +0000 (UTC)
In-Reply-To: <bug-42969-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=42969


Stefan Pietsch <stefan.pietsch@lsexperts.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |stefan.pietsch@lsexperts.de




--- Comment #7 from Stefan Pietsch <stefan.pietsch@lsexperts.de>  2012-05-10 21:51:00 ---
Kernel 3.4-rc6 does not work either. The system seems to boot up after the soft
lockup, but hangs with "Setting sysfs variables".

Have a look at the attached log file.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

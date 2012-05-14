From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 36822] Slow boot with dc395x compiled into the kernel.
Date: Mon, 14 May 2012 14:23:23 +0000 (UTC)
Message-ID: <20120514142323.CBE8C11FCE3@bugzilla.kernel.org>
References: <bug-36822-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:55571 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756628Ab2ENOX2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 May 2012 10:23:28 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D39FA20247
	for <linux-scsi@vger.kernel.org>; Mon, 14 May 2012 14:23:26 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id CE12F20407
	for <linux-scsi@vger.kernel.org>; Mon, 14 May 2012 14:23:23 +0000 (UTC)
In-Reply-To: <bug-36822-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=36822


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |alan@lxorguk.ukuu.org.uk
         Resolution|                            |DOCUMENTED




--- Comment #1 from Alan <alan@lxorguk.ukuu.org.uk>  2012-05-14 14:23:23 ---
Not unusual - the card reader has had more time to get itself ready before the
kernel waits for it

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

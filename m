From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 31192] ioctl SG_GET_REQUEST_TABLE returns 64-bit structure to
 32-bit app.
Date: Mon, 20 Aug 2012 14:59:55 +0000 (UTC)
Message-ID: <20120820145955.E24C511FC6E@bugzilla.kernel.org>
References: <bug-31192-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:56785 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754308Ab2HTO76 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Aug 2012 10:59:58 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C5E9120332
	for <linux-scsi@vger.kernel.org>; Mon, 20 Aug 2012 14:59:57 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id C13C4202AA
	for <linux-scsi@vger.kernel.org>; Mon, 20 Aug 2012 14:59:56 +0000 (UTC)
In-Reply-To: <bug-31192-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=31192


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |alan@lxorguk.ukuu.org.uk
         Resolution|                            |INVALID




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

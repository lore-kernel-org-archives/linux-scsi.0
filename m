From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 8221] RACE: Lock is expected before calling
 ips_removeq_scb_head, but in some call chains not held!
Date: Mon, 23 Dec 2013 18:41:34 +0000
Message-ID: <bug-8221-11613-WsoURSqtQI@https.bugzilla.kernel.org/>
References: <bug-8221-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:52120 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab3LWSlg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Dec 2013 13:41:36 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id BC36620778
	for <linux-scsi@vger.kernel.org>; Mon, 23 Dec 2013 18:41:35 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id DF3642076A
	for <linux-scsi@vger.kernel.org>; Mon, 23 Dec 2013 18:41:34 +0000 (UTC)
In-Reply-To: <bug-8221-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=8221

Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |alan@lxorguk.ukuu.org.uk
         Resolution|---                         |OBSOLETE
         Regression|---                         |No

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

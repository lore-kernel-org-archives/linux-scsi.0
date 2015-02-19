From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15562] SCSI Generic block io queueing can lock up
Date: Thu, 19 Feb 2015 15:41:36 +0000
Message-ID: <bug-15562-11613-N9bPeGnXys@https.bugzilla.kernel.org/>
References: <bug-15562-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40612 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809AbbBSPlj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Feb 2015 10:41:39 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E8D96202F0
	for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2015 15:41:37 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 57B7C202BE
	for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2015 15:41:36 +0000 (UTC)
In-Reply-To: <bug-15562-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=15562

Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |alan@lxorguk.ukuu.org.uk
         Resolution|---                         |OBSOLETE

--- Comment #2 from Alan <alan@lxorguk.ukuu.org.uk> ---
This bug relates to a very old kernel. Closing as obsolete.

-- 
You are receiving this mail because:
You are the assignee for the bug.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 10554] scsi_scan doesn't set the queue depth for tape drive
Date: Thu, 19 Feb 2015 15:12:15 +0000
Message-ID: <bug-10554-11613-6smmNXtA4k@https.bugzilla.kernel.org/>
References: <bug-10554-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:37626 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbbBSPMS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Feb 2015 10:12:18 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 36A9A202DD
	for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2015 15:12:17 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 58753202B8
	for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2015 15:12:16 +0000 (UTC)
In-Reply-To: <bug-10554-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=10554

Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |alan@lxorguk.ukuu.org.uk
         Resolution|---                         |INSUFFICIENT_DATA
         Regression|---                         |No

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

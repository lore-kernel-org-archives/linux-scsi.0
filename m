From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16058] [BUG] Cannot boot any kernel from 2.6.27 on if a 256
 byte sector SCSI disk is attached
Date: Thu, 19 Feb 2015 15:49:15 +0000
Message-ID: <bug-16058-11613-YYxukOijNL@https.bugzilla.kernel.org/>
References: <bug-16058-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41603 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbbBSPtS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Feb 2015 10:49:18 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4311C2024C
	for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2015 15:49:17 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 6D5F9202AE
	for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2015 15:49:16 +0000 (UTC)
In-Reply-To: <bug-16058-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16058

Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |alan@lxorguk.ukuu.org.uk
         Resolution|---                         |OBSOLETE

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

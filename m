From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 18652] mptscsih: ioc0: attempting task abort when heavy disk
 operations on MPT SAS
Date: Tue, 10 Dec 2013 22:06:14 +0000
Message-ID: <bug-18652-11613-UKime3B0eq@https.bugzilla.kernel.org/>
References: <bug-18652-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:45526 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043Ab3LJWGR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Dec 2013 17:06:17 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0E81220690
	for <linux-scsi@vger.kernel.org>; Tue, 10 Dec 2013 22:06:16 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id A5E3020673
	for <linux-scsi@vger.kernel.org>; Tue, 10 Dec 2013 22:06:14 +0000 (UTC)
In-Reply-To: <bug-18652-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=18652

Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |alan@lxorguk.ukuu.org.uk
         Resolution|---                         |OBSOLETE

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

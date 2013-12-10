From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15561] SCSI Generic READ_10 to SATA fails when starting
 multiple processes
Date: Tue, 10 Dec 2013 18:14:21 +0000
Message-ID: <bug-15561-11613-zWvQ0hk79s@https.bugzilla.kernel.org/>
References: <bug-15561-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:58254 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188Ab3LJSOY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Dec 2013 13:14:24 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 743B6205E5
	for <linux-scsi@vger.kernel.org>; Tue, 10 Dec 2013 18:14:23 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 68066205E3
	for <linux-scsi@vger.kernel.org>; Tue, 10 Dec 2013 18:14:22 +0000 (UTC)
In-Reply-To: <bug-15561-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=15561

Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |alan@lxorguk.ukuu.org.uk
         Resolution|---                         |OBSOLETE

-- 
You are receiving this mail because:
You are the assignee for the bug.

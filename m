From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 49461] scsi/bfa/bfad.c:1037: possible off by one in strncpy ?
Date: Tue, 19 Nov 2013 22:35:44 +0000
Message-ID: <bug-49461-11613-J4MEc38nGU@https.bugzilla.kernel.org/>
References: <bug-49461-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:59466 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723Ab3KSWfr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Nov 2013 17:35:47 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 74901205BC
	for <linux-scsi@vger.kernel.org>; Tue, 19 Nov 2013 22:35:46 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id ABE8E205B6
	for <linux-scsi@vger.kernel.org>; Tue, 19 Nov 2013 22:35:45 +0000 (UTC)
In-Reply-To: <bug-49461-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=49461

Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

-- 
You are receiving this mail because:
You are the assignee for the bug.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 85751] iSCSI initiator lockup during logout
Date: Tue, 07 Oct 2014 16:34:07 +0000
Message-ID: <bug-85751-11613-yUafTXqBeP@https.bugzilla.kernel.org/>
References: <bug-85751-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:48780 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbaJGQeL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Oct 2014 12:34:11 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CDD5C20251
	for <linux-scsi@vger.kernel.org>; Tue,  7 Oct 2014 16:34:09 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id E74EC20222
	for <linux-scsi@vger.kernel.org>; Tue,  7 Oct 2014 16:34:08 +0000 (UTC)
In-Reply-To: <bug-85751-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=85751

Bart Van Assche <bvanassche@acm.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
            Summary|iSCSI initiator lockup      |iSCSI initiator lockup
                   |during login                |during logout

-- 
You are receiving this mail because:
You are the assignee for the bug.

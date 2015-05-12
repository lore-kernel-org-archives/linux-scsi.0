From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16058] [BUG] Cannot boot any kernel from 2.6.27 on if a 256
 byte sector SCSI disk is attached
Date: Tue, 12 May 2015 13:46:12 +0000
Message-ID: <bug-16058-11613-kJEtWhABQi@https.bugzilla.kernel.org/>
References: <bug-16058-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35711 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933080AbbELNqP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 May 2015 09:46:15 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6941E20429
	for <linux-scsi@vger.kernel.org>; Tue, 12 May 2015 13:46:14 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 8F82F2041E
	for <linux-scsi@vger.kernel.org>; Tue, 12 May 2015 13:46:13 +0000 (UTC)
In-Reply-To: <bug-16058-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16058

--- Comment #19 from Mark Hounschell <dmarkh@cfl.rr.com> ---
Feel free to add my signed off by:

Signed-off-by: Mark Hounschell <dmarkh@cfl.rr.com>

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

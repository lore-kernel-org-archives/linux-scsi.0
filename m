From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 62811] [PATCH]Don't Modify the scsi subcmd as LUN value when
 using VENDOR cmd
Date: Wed, 13 Nov 2013 13:39:48 +0000
Message-ID: <bug-62811-11613-Q9ri7Q3x2B@https.bugzilla.kernel.org/>
References: <bug-62811-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:43431 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418Ab3KMNj6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Nov 2013 08:39:58 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3A93420627
	for <linux-scsi@vger.kernel.org>; Wed, 13 Nov 2013 13:39:54 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id C24A32061B
	for <linux-scsi@vger.kernel.org>; Wed, 13 Nov 2013 13:39:48 +0000 (UTC)
In-Reply-To: <bug-62811-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=62811

Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
            Summary|Don't Modify the scsi       |[PATCH]Don't Modify the
                   |subcmd as LUN value when    |scsi subcmd as LUN value
                   |using VENDOR cmd            |when using VENDOR cmd

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

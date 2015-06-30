From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 98171] [Regression] Marvell SE91xx SATA 3 controllers not
 recognized correctly
Date: Tue, 30 Jun 2015 10:51:15 +0000
Message-ID: <bug-98171-11613-qGNZIxhShy@https.bugzilla.kernel.org/>
References: <bug-98171-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:49314 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453AbbF3KvS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Jun 2015 06:51:18 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 313D1205E5
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2015 10:51:17 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 4CFB5205BE
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2015 10:51:16 +0000 (UTC)
In-Reply-To: <bug-98171-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=98171

--- Comment #3 from Tom Yan <tom.ty89@gmail.com> ---
By the way why would it be related to mvsas/libsas? Aren't those controllers
SATA ones which use the ahci driver?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

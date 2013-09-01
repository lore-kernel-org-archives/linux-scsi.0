From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60758] module scsi_wait_scan not found kernel panic on boot
Date: Sun, 01 Sep 2013 00:48:37 +0000
Message-ID: <bug-60758-11613-K4PlN2afQf@https.bugzilla.kernel.org/>
References: <bug-60758-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:47686 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278Ab3IAAsl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 31 Aug 2013 20:48:41 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0ED5D2029B
	for <linux-scsi@vger.kernel.org>; Sun,  1 Sep 2013 00:48:40 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 2766F20278
	for <linux-scsi@vger.kernel.org>; Sun,  1 Sep 2013 00:48:38 +0000 (UTC)
In-Reply-To: <bug-60758-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60758

--- Comment #17 from zakrzewskim@wp.pl ---
It doesn't work too. I don't know what's wrong. Only 3.10.4-1 works fine and I
need to stick with it :/

-- 
You are receiving this mail because:
You are the assignee for the bug.

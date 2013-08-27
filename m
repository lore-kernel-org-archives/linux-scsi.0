From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60644] MPT2SAS drops all HDDs when under high I/O
Date: Tue, 27 Aug 2013 15:29:28 +0000
Message-ID: <bug-60644-11613-RzebnXYSpy@https.bugzilla.kernel.org/>
References: <bug-60644-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:41995 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183Ab3H0P3g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Aug 2013 11:29:36 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9D48E204EC
	for <linux-scsi@vger.kernel.org>; Tue, 27 Aug 2013 15:29:31 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 74D52204E7
	for <linux-scsi@vger.kernel.org>; Tue, 27 Aug 2013 15:29:30 +0000 (UTC)
In-Reply-To: <bug-60644-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60644

--- Comment #22 from liveaxle@live.com ---
Hi . Thank you Hannes very much for the patch .

I compiled it inside a 3.11-rc7 , and put "mpt2sas.disable_watchdog=1" in the
boot parameters .

It helped the driver to survive longer -around an hour longer than before- but
then it failed . But this time , it hard-locked the machine (ssh sessions are
closed , new sessions time-out , iscsi targets are dropped) I had to hard-reset
the server .

Thank you .

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

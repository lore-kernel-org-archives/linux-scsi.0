From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60644] MPT2SAS drops all HDDs when under high I/O
Date: Fri, 02 Aug 2013 10:44:20 +0000
Message-ID: <bug-60644-11613-FdGroXURfs@https.bugzilla.kernel.org/>
References: <bug-60644-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:36611 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234Ab3HBKoW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Aug 2013 06:44:22 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id F083420597
	for <linux-scsi@vger.kernel.org>; Fri,  2 Aug 2013 10:44:21 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id E1DF620593
	for <linux-scsi@vger.kernel.org>; Fri,  2 Aug 2013 10:44:20 +0000 (UTC)
In-Reply-To: <bug-60644-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60644

--- Comment #17 from liveaxle@live.com ---
Hi .

Today , I ran some tests on all 8 drives connected to the LSI 2308 .

The results are rather surprising . The controller goes non-operational under
high READ workloads , while WRITE workloads always complete just fine .

I'll run more tests , but at this point I can safely say that heavy READ
operations (md5 checks , btrfs scrub , torrent files checking , etc) are the
problem , while heavy WRITE workloads (dd , copy , rsync) always complete
successfully .

I hope that can be useful in nailing this bug .

Thank you .

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

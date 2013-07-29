From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60644] MPT2SAS drops all HDDs when under high I/O
Date: Mon, 29 Jul 2013 14:12:36 +0000
Message-ID: <bug-60644-11613-ezGjVEiWLd@https.bugzilla.kernel.org/>
References: <bug-60644-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:51549 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755940Ab3G2OMk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Jul 2013 10:12:40 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 653F5201EB
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jul 2013 14:12:39 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 471BB201DA
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jul 2013 14:12:37 +0000 (UTC)
In-Reply-To: <bug-60644-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60644

--- Comment #4 from liveaxle@live.com ---
Hi .

I'll attach it , however dmesg only shows the last 16000 events . I hope it
would be enough .

Sorry for being a noob in reporting my first bug , but can you tell me how can
I find the exact IO rate ?

It doesn't happen under daily workload , though . (rsync cronjob , writing a
gzipped root backup to the RAID) .

Thank you .

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 90601] panic on write to 3ware raid array
Date: Sun, 19 Apr 2015 04:05:12 +0000
Message-ID: <bug-90601-11613-q3b4eXGIOT@https.bugzilla.kernel.org/>
References: <bug-90601-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56588 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbbDSEFQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Apr 2015 00:05:16 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9B10D2045A
	for <linux-scsi@vger.kernel.org>; Sun, 19 Apr 2015 04:05:15 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id AE38E20454
	for <linux-scsi@vger.kernel.org>; Sun, 19 Apr 2015 04:05:12 +0000 (UTC)
In-Reply-To: <bug-90601-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=90601

--- Comment #24 from Justin Keogh <kernel.org@v6y.net> ---
Created attachment 174461
  --> https://bugzilla.kernel.org/attachment.cgi?id=174461&action=edit
dmesg for panic without zfs modules

-- 
You are receiving this mail because:
You are the assignee for the bug.

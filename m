From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 90601] panic on write to 3ware raid array
Date: Sun, 19 Apr 2015 04:04:01 +0000
Message-ID: <bug-90601-11613-2f4bJYJNAk@https.bugzilla.kernel.org/>
References: <bug-90601-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56513 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbbDSEEE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Apr 2015 00:04:04 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9AFCD2045E
	for <linux-scsi@vger.kernel.org>; Sun, 19 Apr 2015 04:04:03 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id E473E20454
	for <linux-scsi@vger.kernel.org>; Sun, 19 Apr 2015 04:04:01 +0000 (UTC)
In-Reply-To: <bug-90601-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=90601

--- Comment #23 from Justin Keogh <kernel.org@v6y.net> ---
Created attachment 174451
  --> https://bugzilla.kernel.org/attachment.cgi?id=174451&action=edit
dmesg for commit 'scsi: convert device_busy to atomic_t'

-- 
You are receiving this mail because:
You are the assignee for the bug.

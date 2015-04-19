From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 90601] panic on write to 3ware raid array
Date: Sun, 19 Apr 2015 04:00:05 +0000
Message-ID: <bug-90601-11613-ThuJfaekYW@https.bugzilla.kernel.org/>
References: <bug-90601-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56352 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbbDSEAJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Apr 2015 00:00:09 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C912820461
	for <linux-scsi@vger.kernel.org>; Sun, 19 Apr 2015 04:00:08 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 0AFEA2045A
	for <linux-scsi@vger.kernel.org>; Sun, 19 Apr 2015 04:00:08 +0000 (UTC)
In-Reply-To: <bug-90601-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=90601

--- Comment #21 from Justin Keogh <kernel.org@v6y.net> ---
Created attachment 174431
  --> https://bugzilla.kernel.org/attachment.cgi?id=174431&action=edit
git bisect log between 3.14.33 and 3.18.7

-- 
You are receiving this mail because:
You are the assignee for the bug.

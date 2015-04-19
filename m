From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 90601] panic on write to 3ware raid array
Date: Sun, 19 Apr 2015 04:00:55 +0000
Message-ID: <bug-90601-11613-uwxgCqzggT@https.bugzilla.kernel.org/>
References: <bug-90601-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56434 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbbDSEA7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Apr 2015 00:00:59 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2898420462
	for <linux-scsi@vger.kernel.org>; Sun, 19 Apr 2015 04:00:57 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 65D1C20456
	for <linux-scsi@vger.kernel.org>; Sun, 19 Apr 2015 04:00:55 +0000 (UTC)
In-Reply-To: <bug-90601-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=90601

--- Comment #22 from Justin Keogh <kernel.org@v6y.net> ---
Created attachment 174441
  --> https://bugzilla.kernel.org/attachment.cgi?id=174441&action=edit
.config

-- 
You are receiving this mail because:
You are the assignee for the bug.

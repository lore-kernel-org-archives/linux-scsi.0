From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 90601] panic on write to 3ware raid array
Date: Mon, 13 Apr 2015 16:16:33 +0000
Message-ID: <bug-90601-11613-qPf8tgMO7F@https.bugzilla.kernel.org/>
References: <bug-90601-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48580 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252AbbDMQQj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Apr 2015 12:16:39 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 71A9920340
	for <linux-scsi@vger.kernel.org>; Mon, 13 Apr 2015 16:16:38 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 530DC202F8
	for <linux-scsi@vger.kernel.org>; Mon, 13 Apr 2015 16:16:34 +0000 (UTC)
In-Reply-To: <bug-90601-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=90601

--- Comment #16 from merlin@liao.homelinux.org ---
Created attachment 173931
  --> https://bugzilla.kernel.org/attachment.cgi?id=173931&action=edit
panic_screenshot

screenshot of kernel panic

-- 
You are receiving this mail because:
You are the assignee for the bug.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 90601] panic on write to 3ware raid array
Date: Mon, 13 Apr 2015 16:16:43 +0000
Message-ID: <bug-90601-11613-g3ke9HuWcU@https.bugzilla.kernel.org/>
References: <bug-90601-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48640 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753826AbbDMQQu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Apr 2015 12:16:50 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 076AA20265
	for <linux-scsi@vger.kernel.org>; Mon, 13 Apr 2015 16:16:49 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 2B06D202F8
	for <linux-scsi@vger.kernel.org>; Mon, 13 Apr 2015 16:16:44 +0000 (UTC)
In-Reply-To: <bug-90601-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=90601

--- Comment #17 from merlin@liao.homelinux.org ---
I am unable to get a dmesg output since the system crashes on boot.
It looks like it's happening when udev is initialized.

Sorry for the screenshot but the system crashed before any network came up.

-- 
You are receiving this mail because:
You are the assignee for the bug.

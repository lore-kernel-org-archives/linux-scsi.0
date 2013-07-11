From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 59601] commit 97dec564fd4948e0e560869c80b76e166ca2a83e breaks
 communication with XYRATEX disk shelves
Date: Thu, 11 Jul 2013 11:09:35 +0000
Message-ID: <bug-59601-11613-HTYxvZ1JdT@https.bugzilla.kernel.org/>
References: <bug-59601-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:43789 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932111Ab3GKLJi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jul 2013 07:09:38 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2AF052018E
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jul 2013 11:09:37 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id E69752017A
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jul 2013 11:09:35 +0000 (UTC)
In-Reply-To: <bug-59601-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=59601

--- Comment #9 from Saurav Kashyap <saurav.kashyap@qlogic.com> ---
Created attachment 106870
  --> https://bugzilla.kernel.org/attachment.cgi?id=106870&action=edit
Properly-set-the-tagging-for-commands

Hi Jack,
Try this patch and see if this resolves this issue.

thanks,
~Saurav

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

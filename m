From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60644] MPT2SAS drops all HDDs when under high I/O
Date: Tue, 30 Jul 2013 05:00:01 +0000
Message-ID: <bug-60644-11613-VUvpDD5bK5@https.bugzilla.kernel.org/>
References: <bug-60644-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:54639 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409Ab3G3FAF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Jul 2013 01:00:05 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 22DCD201E3
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jul 2013 05:00:04 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 4A768201DE
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jul 2013 05:00:02 +0000 (UTC)
In-Reply-To: <bug-60644-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60644

--- Comment #8 from Sreekanth Reddy <sreekanth.reddy@lsi.com> ---
Hi,

Can you please provide me the /var/log/message file as dmesg logs is not enough
to analysize this issue.

Thanks,
Sreekanth

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 59601] commit 97dec564fd4948e0e560869c80b76e166ca2a83e breaks
 communication with XYRATEX disk shelves
Date: Wed, 19 Jun 2013 18:31:39 +0000 (UTC)
Message-ID: <20130619183139.2B64711FB35@bugzilla.kernel.org>
References: <bug-59601-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:53278 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756776Ab3FSSbp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Jun 2013 14:31:45 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6B4E520425
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jun 2013 18:31:44 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 2E9042040D
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jun 2013 18:31:39 +0000 (UTC)
In-Reply-To: <bug-59601-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=59601





--- Comment #6 from Saurav Kashyap <saurav.kashyap@qlogic.com>  2013-06-19 18:31:38 ---
Created an attachment (id=105401)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=105401)
Patch for dumping the incoming packet to the driver.

Apply this patch, enable ql2xextended_error_logging and share the logs. This
dumps the pkt coming to the  driver.

Thanks,
~Saurav

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

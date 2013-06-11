From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 59601] commit 97dec564fd4948e0e560869c80b76e166ca2a83e breaks
 communication with XYRATEX disk shelves
Date: Tue, 11 Jun 2013 18:23:45 +0000 (UTC)
Message-ID: <20130611182345.D612311FB35@bugzilla.kernel.org>
References: <bug-59601-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:57764 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755957Ab3FKSXt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jun 2013 14:23:49 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C17A42045B
	for <linux-scsi@vger.kernel.org>; Tue, 11 Jun 2013 18:23:47 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id DAC1F20457
	for <linux-scsi@vger.kernel.org>; Tue, 11 Jun 2013 18:23:45 +0000 (UTC)
In-Reply-To: <bug-59601-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=59601





--- Comment #1 from Saurav Kashyap <saurav.kashyap@qlogic.com>  2013-06-11 18:23:45 ---
HI Jack,
Please provide the driver logs for both good and bad case with
ql2xextended_error_logging=1. The commit you have mentioned don't effect 2G
cards.

Have you tried reverting the commit? Did it resolved the problem?

Thanks,
~Saurav

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

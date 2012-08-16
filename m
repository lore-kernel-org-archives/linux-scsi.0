From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 46031] kswapd0 moving to uninterruptible sleep (STAT D)
Date: Thu, 16 Aug 2012 12:44:35 +0000 (UTC)
Message-ID: <20120816124435.A265C11FC6E@bugzilla.kernel.org>
References: <bug-46031-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:44397 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754757Ab2HPMoi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Aug 2012 08:44:38 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 02FFA20241
	for <linux-scsi@vger.kernel.org>; Thu, 16 Aug 2012 12:44:37 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 1CD0B201C7
	for <linux-scsi@vger.kernel.org>; Thu, 16 Aug 2012 12:44:36 +0000 (UTC)
In-Reply-To: <bug-46031-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=46031





--- Comment #1 from Markus Hetzmannseder <Markus.Hetzmannseder@jku.at>  2012-08-16 12:44:35 ---
Full kern.log is to big for attachment, you can find it under:
http://oban.stoch.uni-linz.ac.at/kern.log

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 59601] commit 97dec564fd4948e0e560869c80b76e166ca2a83e breaks
 communication with XYRATEX disk shelves
Date: Mon, 17 Jun 2013 14:14:03 +0000 (UTC)
Message-ID: <20130617141403.D88BA11FB51@bugzilla.kernel.org>
References: <bug-59601-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:37487 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755731Ab3FQOOK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Jun 2013 10:14:10 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7E20B20322
	for <linux-scsi@vger.kernel.org>; Mon, 17 Jun 2013 14:14:09 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id D932220271
	for <linux-scsi@vger.kernel.org>; Mon, 17 Jun 2013 14:14:03 +0000 (UTC)
In-Reply-To: <bug-59601-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=59601





--- Comment #4 from Jack Hill <jackhill@jackhill.us>  2013-06-17 14:14:03 ---
Hi,

I have attached dmesg output from good ad bad kernels with extended error
logging.

Reverting the commit solved the problem. I was not able to revert the commit on
3.10-rc4 because it resulted in conficts, and I'm not familiar enough with that
code to resolve them by hand.

Best,
Jack

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

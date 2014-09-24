From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 85101] hpsa + P410 does not show connected HP SAS port
 expanders
Date: Wed, 24 Sep 2014 22:32:13 +0000
Message-ID: <bug-85101-11613-6AY0dkEYw1@https.bugzilla.kernel.org/>
References: <bug-85101-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:42818 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbaIXWcP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2014 18:32:15 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A23E02028D
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2014 22:32:14 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 4220220274
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2014 22:32:13 +0000 (UTC)
In-Reply-To: <bug-85101-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=85101

--- Comment #3 from Robert Elliott <elliott@hp.com> ---
Controller lockup means the firmware crashed (e.g. an ASSERT statement
triggered).  That can be due to hardware problems or firmware bugs.  You might
see if it boots with nothing attached; then with one expander; then with two;
then with drives attached to the expanders.

If you're not really using the P410, though, just use sg_write_buffer through
the Adaptec 7805H HBA.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

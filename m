From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42142] mpt2sas: Number specified in wrong base.
Date: Wed, 4 Apr 2012 15:04:19 GMT
Message-ID: <201204041504.q34F4JXL008642@bugzilla.kernel.org>
References: <bug-42142-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:41625 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756415Ab2DDPEU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Apr 2012 11:04:20 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q34F4J46008643
	for <linux-scsi@vger.kernel.org>; Wed, 4 Apr 2012 15:04:19 GMT
In-Reply-To: <bug-42142-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=42142


Florian Mickler <florian@mickler.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |florian@mickler.org




--- Comment #1 from Florian Mickler <florian@mickler.org>  2012-04-04 15:04:18 ---
A patch referencing this bug report has been merged in Linux v3.4-rc1:

commit 714be35885093305b7491cc3eea959bb3e1be6f2
Author: Sathisha Nanjappa <sathisha.nanjappa@hp.com>
Date:   Tue Mar 13 11:59:28 2012 -0700

    [SCSI] mpt2sas: remove extraneous sas_log_info messages

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

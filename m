From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 101841] iommu memory handling cause mmblock devices stop
 working
Date: Wed, 17 Aug 2016 22:19:03 +0000
Message-ID: <bug-101841-11613-lfL2YNLa42@https.bugzilla.kernel.org/>
References: <bug-101841-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56000 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582AbcHQW0O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Aug 2016 18:26:14 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C6DE32013A
	for <linux-scsi@vger.kernel.org>; Wed, 17 Aug 2016 22:19:05 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id D99B72013D
	for <linux-scsi@vger.kernel.org>; Wed, 17 Aug 2016 22:19:03 +0000 (UTC)
In-Reply-To: <bug-101841-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=101841

ingvarthorvald@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |ingvarthorvald@gmail.com

--- Comment #2 from ingvarthorvald@gmail.com ---
Can you test this on a newer kernel and see if you get the same results.

-- 
You are receiving this mail because:
You are the assignee for the bug.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42918] fcoe: Enabling VN2VN mode triggers a circular locking
 complaint
Date: Thu, 15 Mar 2012 01:21:49 GMT
Message-ID: <201203150121.q2F1Ln8l003505@bugzilla.kernel.org>
References: <bug-42918-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:56773 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760721Ab2COBVu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Mar 2012 21:21:50 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q2F1Ln0s003506
	for <linux-scsi@vger.kernel.org>; Thu, 15 Mar 2012 01:21:49 GMT
In-Reply-To: <bug-42918-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=42918





--- Comment #1 from Robert Love <robert.w.love@intel.com>  2012-03-15 01:21:48 ---
Fix was posted to linux-scsi here:
http://www.spinics.net/lists/linux-scsi/msg58027.html

Note that I Nacked my own patch but that others commented that the patch is
correct. Please ignore the Nack; the patch is good.

Can the submitted please verify that this fixes their issue?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

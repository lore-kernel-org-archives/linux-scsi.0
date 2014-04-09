From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71231] System unresponsable after a lot of LUNs have been added
 to the system
Date: Wed, 09 Apr 2014 10:22:24 +0000
Message-ID: <bug-71231-11613-dSeoOLOcW4@https.bugzilla.kernel.org/>
References: <bug-71231-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:53218 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932187AbaDIKW3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Apr 2014 06:22:29 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4CE422053B
	for <linux-scsi@vger.kernel.org>; Wed,  9 Apr 2014 10:22:28 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 3E6E72053F
	for <linux-scsi@vger.kernel.org>; Wed,  9 Apr 2014 10:22:25 +0000 (UTC)
In-Reply-To: <bug-71231-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=71231

--- Comment #11 from Alex <alexandernaumann@gmx.de> ---
Does anyboy has any hitn how I can solve this problem?
It occures with any server and any storage with kernel 3.10 and kernel 3.12.

Using bisect has not given my any logical hint which patch might be the reason
why it crashes or why it does not crash anymore.

-- 
You are receiving this mail because:
You are the assignee for the bug.

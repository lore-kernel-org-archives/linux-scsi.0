From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71231] System unresponsable after a lot of LUNs have been added
 to the system
Date: Fri, 28 Feb 2014 19:37:36 +0000
Message-ID: <bug-71231-11613-FY6UyMzW70@https.bugzilla.kernel.org/>
References: <bug-71231-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:33511 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743AbaB1Thk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Feb 2014 14:37:40 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 743D720260
	for <linux-scsi@vger.kernel.org>; Fri, 28 Feb 2014 19:37:39 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id EF54C202DD
	for <linux-scsi@vger.kernel.org>; Fri, 28 Feb 2014 19:37:36 +0000 (UTC)
In-Reply-To: <bug-71231-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=71231

Saurav Kashyap <saurav.kashyap@qlogic.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |saurav.kashyap@qlogic.com

--- Comment #6 from Saurav Kashyap <saurav.kashyap@qlogic.com> ---
HI Alex,
Try "git bisect", it will help in finding the patch that introduced this
problem.

Thanks,
~Saurav

-- 
You are receiving this mail because:
You are the assignee for the bug.

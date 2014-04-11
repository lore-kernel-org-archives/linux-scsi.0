From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71231] System unresponsable after a lot of LUNs have been added
 to the system
Date: Fri, 11 Apr 2014 08:20:21 +0000
Message-ID: <bug-71231-11613-PZpXIyS82p@https.bugzilla.kernel.org/>
References: <bug-71231-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:39044 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755672AbaDKIU0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2014 04:20:26 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 60F4320829
	for <linux-scsi@vger.kernel.org>; Fri, 11 Apr 2014 08:20:25 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id A2073207FB
	for <linux-scsi@vger.kernel.org>; Fri, 11 Apr 2014 08:20:23 +0000 (UTC)
In-Reply-To: <bug-71231-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=71231

--- Comment #13 from Alex <alexandernaumann@gmx.de> ---
Thanks for these tips.
It looks like disabling serial console helps.

But I need this one.
I will try to get his patches working so that I can enbale serial console
again.

-- 
You are receiving this mail because:
You are the assignee for the bug.

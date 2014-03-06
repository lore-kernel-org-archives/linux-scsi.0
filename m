From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71231] System unresponsable after a lot of LUNs have been added
 to the system
Date: Thu, 06 Mar 2014 09:40:04 +0000
Message-ID: <bug-71231-11613-vkgrxjrgbH@https.bugzilla.kernel.org/>
References: <bug-71231-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:43885 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbaCFJkG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Mar 2014 04:40:06 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 571A520212
	for <linux-scsi@vger.kernel.org>; Thu,  6 Mar 2014 09:40:05 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 9E2A5201F7
	for <linux-scsi@vger.kernel.org>; Thu,  6 Mar 2014 09:40:04 +0000 (UTC)
In-Reply-To: <bug-71231-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=71231

--- Comment #8 from Alex <alexandernaumann@gmx.de> ---
If this patch is commited I get the error.
I am still wondering because this patch does not look like it should be
relevant.
But before this patch everythign works and with git bisect next (this patch) I
will get the errors.

-- 
You are receiving this mail because:
You are the assignee for the bug.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60758] module scsi_wait_scan not found kernel panic on boot
Date: Thu, 29 Aug 2013 05:13:08 +0000
Message-ID: <bug-60758-11613-uN0h89JOr7@https.bugzilla.kernel.org/>
References: <bug-60758-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:55697 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156Ab3H2FNL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Aug 2013 01:13:11 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 710E02037D
	for <linux-scsi@vger.kernel.org>; Thu, 29 Aug 2013 05:13:10 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 17F7D2035C
	for <linux-scsi@vger.kernel.org>; Thu, 29 Aug 2013 05:13:09 +0000 (UTC)
In-Reply-To: <bug-60758-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60758

Jeff Zhou <jz.researcher@yahoo.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jz.researcher@yahoo.com

--- Comment #3 from Jeff Zhou <jz.researcher@yahoo.com> ---
Looks like a dependency failure, would you like to show the two .config files?

-- 
You are receiving this mail because:
You are the assignee for the bug.

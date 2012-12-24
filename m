From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 51881] HighPoint RocketRAID 2720 fail to detect some SATA hdd
Date: Mon, 24 Dec 2012 07:24:46 +0000 (UTC)
Message-ID: <20121224072446.9B46711FF01@bugzilla.kernel.org>
References: <bug-51881-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:58978 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076Ab2LXHYu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Dec 2012 02:24:50 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E324820106
	for <linux-scsi@vger.kernel.org>; Mon, 24 Dec 2012 07:24:49 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 73C7620150
	for <linux-scsi@vger.kernel.org>; Mon, 24 Dec 2012 07:24:47 +0000 (UTC)
In-Reply-To: <bug-51881-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=51881


Shane Huang <shane.huang@amd.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |shane.huang@amd.com




--- Comment #5 from Shane Huang <shane.huang@amd.com>  2012-12-24 07:24:46 ---
Can you help to try whether the attached patch make something different or not?
Thanks.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

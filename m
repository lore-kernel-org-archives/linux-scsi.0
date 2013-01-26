From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 51881] HighPoint RocketRAID 2720 fail to detect some SATA hdd
Date: Sat, 26 Jan 2013 10:53:02 +0000 (UTC)
Message-ID: <20130126105302.302CC11FE02@bugzilla.kernel.org>
References: <bug-51881-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:36754 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399Ab3AZKxH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Jan 2013 05:53:07 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 26596201B2
	for <linux-scsi@vger.kernel.org>; Sat, 26 Jan 2013 10:53:04 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 3ACA4201A3
	for <linux-scsi@vger.kernel.org>; Sat, 26 Jan 2013 10:53:02 +0000 (UTC)
In-Reply-To: <bug-51881-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=51881





--- Comment #10 from Florian Mickler <florian@mickler.org>  2013-01-26 10:53:01 ---
A patch referencing this bug report has been merged in Linux v3.8-rc5:

commit 803739d25c2343da6d2f95eebdcbc08bf67097d4
Author: Shane Huang <shane.huang@amd.com>
Date:   Mon Dec 17 23:18:59 2012 +0800

    [libata] replace sata_settings with devslp_timing

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

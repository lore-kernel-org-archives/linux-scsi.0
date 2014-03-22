From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71941] LSI SAS2116 does not detect disks
Date: Sat, 22 Mar 2014 14:13:03 +0000
Message-ID: <bug-71941-11613-2PyeearESK@https.bugzilla.kernel.org/>
References: <bug-71941-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:39141 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbaCVONG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Mar 2014 10:13:06 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 723AB202FF
	for <linux-scsi@vger.kernel.org>; Sat, 22 Mar 2014 14:13:05 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 18B67202E6
	for <linux-scsi@vger.kernel.org>; Sat, 22 Mar 2014 14:13:04 +0000 (UTC)
In-Reply-To: <bug-71941-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=71941

--- Comment #2 from kernel-bugzilla.20.drkshadow@spamgourmet.com ---
Created attachment 130291
  --> https://bugzilla.kernel.org/attachment.cgi?id=130291&action=edit
Patch to LSI 18.00.00.00 driver to compile on 3.13.6

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

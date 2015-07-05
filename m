From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 101011] Kernel Oops when disconnecting a mounted ext4 usb stick
Date: Sun, 05 Jul 2015 20:20:28 +0000
Message-ID: <bug-101011-11613-DcweFxcRy4@https.bugzilla.kernel.org/>
References: <bug-101011-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:53053 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918AbbGEUUb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 5 Jul 2015 16:20:31 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 351C62063F
	for <linux-scsi@vger.kernel.org>; Sun,  5 Jul 2015 20:20:30 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 8D7052063C
	for <linux-scsi@vger.kernel.org>; Sun,  5 Jul 2015 20:20:28 +0000 (UTC)
In-Reply-To: <bug-101011-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=101011

--- Comment #4 from konradsa@gmail.com ---
Created attachment 181971
  --> https://bugzilla.kernel.org/attachment.cgi?id=181971&action=edit
lspci -vvnn

-- 
You are receiving this mail because:
You are the assignee for the bug.

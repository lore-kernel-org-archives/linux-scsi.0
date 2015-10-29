From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 106841] do not output error for simple subenclosure (handle
 Short Enclosure Status diagnostic page)
Date: Thu, 29 Oct 2015 04:27:40 +0000
Message-ID: <bug-106841-11613-gMP7VSnxNZ@https.bugzilla.kernel.org/>
References: <bug-106841-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60532 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbbJ2E1n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Oct 2015 00:27:43 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4416C209C4
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2015 04:27:42 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id CB42E209E7
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2015 04:27:40 +0000 (UTC)
In-Reply-To: <bug-106841-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=106841

--- Comment #1 from Tom Yan <tom.ty89@gmail.com> ---
Oops I missed the lsscsi output:
[tom@localhost ~]$ sudo lsscsi -g | grep WD
[7:0:0:0]    disk    WD       My Passport 083A 1065  /dev/sdc   /dev/sg3 
[7:0:0:1]    enclosu WD       SES Device       1065  -          /dev/sg4

-- 
You are receiving this mail because:
You are the assignee for the bug.

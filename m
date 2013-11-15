From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 64171] Block SCSI Generic Driver does not keep data
Date: Fri, 15 Nov 2013 15:52:33 +0000
Message-ID: <bug-64171-11613-baOUBgA2jT@https.bugzilla.kernel.org/>
References: <bug-64171-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:37181 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554Ab3KOPwk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Nov 2013 10:52:40 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0B0F1208B1
	for <linux-scsi@vger.kernel.org>; Fri, 15 Nov 2013 15:52:35 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 3942B2094D
	for <linux-scsi@vger.kernel.org>; Fri, 15 Nov 2013 15:52:33 +0000 (UTC)
In-Reply-To: <bug-64171-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=64171

--- Comment #3 from Andrew Falanga <af300wsm@gmail.com> ---
Doug,

Thanks for the comments.  My team decided that this constituted too much
instability to rely upon BSG for our needs.  The major draw back is  we were
looking for this driver specifically for large CDBs (> 16 bytes).  Until this
driver is fixed, which my organization is very interested in, we're informing
our customers that they'll have to use LSI HBAs in order to support pass
through capability of CDBs in excess of 16 bytes.

Incidentally, I couldn't find an e-mail for FUJITA Tomonori, the currently
listed maintainer of this driver, within bugzilla.  Is his e-mail in bugzilla
under a different address than the one listed in MAINTAINERS?  From
MAINTAINERS: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

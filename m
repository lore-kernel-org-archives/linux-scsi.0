From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60644] MPT2SAS drops all HDDs when under high I/O
Date: Fri, 20 Sep 2013 10:28:40 +0000
Message-ID: <bug-60644-11613-X1znMV8Q5U@https.bugzilla.kernel.org/>
References: <bug-60644-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:44772 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195Ab3ITK2o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Sep 2013 06:28:44 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6CED220455
	for <linux-scsi@vger.kernel.org>; Fri, 20 Sep 2013 10:28:43 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 44D67203E1
	for <linux-scsi@vger.kernel.org>; Fri, 20 Sep 2013 10:28:41 +0000 (UTC)
In-Reply-To: <bug-60644-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60644

--- Comment #33 from pasik@iki.fi ---

You might want to try the latest P17 firmware aswell, it has been out for a
couple of weeks now. There's not much in the changelogs, but it seems to fix
some other SGPIO related issues at least.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

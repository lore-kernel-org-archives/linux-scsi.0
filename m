From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 114401] crash dump aic94xx
Date: Thu, 07 Apr 2016 18:51:02 +0000
Message-ID: <bug-114401-11613-p357RiHEje@https.bugzilla.kernel.org/>
References: <bug-114401-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:36737 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932078AbcDGSvH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Apr 2016 14:51:07 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3FA3E201D3
	for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2016 18:51:05 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id DB83620256
	for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2016 18:51:02 +0000 (UTC)
In-Reply-To: <bug-114401-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=114401

--- Comment #3 from bastienphilbert@gmail.com ---
That seems to be due to a WARN_ON that only triggers once. Does this work OK
now besides the warning.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

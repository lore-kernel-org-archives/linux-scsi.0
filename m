From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 46891] [CHECK]scsi/bnx2fc/bnx2fc_io.c:1810: bad call to memset
Date: Tue, 19 Nov 2013 23:19:58 +0000
Message-ID: <bug-46891-11613-SmJZTTrwhd@https.bugzilla.kernel.org/>
References: <bug-46891-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:35945 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421Ab3KSXUB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Nov 2013 18:20:01 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8A70920675
	for <linux-scsi@vger.kernel.org>; Tue, 19 Nov 2013 23:20:00 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 8DA1720670
	for <linux-scsi@vger.kernel.org>; Tue, 19 Nov 2013 23:19:59 +0000 (UTC)
In-Reply-To: <bug-46891-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=46891

Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
            Summary|scsi/bnx2fc/bnx2fc_io.c:181 |[CHECK]scsi/bnx2fc/bnx2fc_i
                   |0: bad call to memset       |o.c:1810: bad call to
                   |                            |memset

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

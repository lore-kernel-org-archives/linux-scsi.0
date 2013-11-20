From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 46891] [CHECK]scsi/bnx2fc/bnx2fc_io.c:1810: bad call to memset
Date: Wed, 20 Nov 2013 13:33:00 +0000
Message-ID: <bug-46891-11613-X3VclPVr5o@https.bugzilla.kernel.org/>
References: <bug-46891-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:39756 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775Ab3KTNdF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Nov 2013 08:33:05 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 43B3520149
	for <linux-scsi@vger.kernel.org>; Wed, 20 Nov 2013 13:33:03 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 3A54620736
	for <linux-scsi@vger.kernel.org>; Wed, 20 Nov 2013 13:33:01 +0000 (UTC)
In-Reply-To: <bug-46891-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=46891

Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |CLOSED

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15565] SCSI Generic queueing completes commands in reverse
 order
Date: Thu,  5 Jul 2012 16:12:52 +0000 (UTC)
Message-ID: <20120705161252.3A06E11FA64@bugzilla.kernel.org>
References: <bug-15565-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:52750 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635Ab2GEQM6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jul 2012 12:12:58 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A7301201A6
	for <linux-scsi@vger.kernel.org>; Thu,  5 Jul 2012 16:12:57 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id EE3582027F
	for <linux-scsi@vger.kernel.org>; Thu,  5 Jul 2012 16:12:52 +0000 (UTC)
In-Reply-To: <bug-15565-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=15565


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |alan@lxorguk.ukuu.org.uk
         Resolution|                            |OBSOLETE




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

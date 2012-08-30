From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 41552] Performance of writing and reading from multiple drives
 decreases by 40% when going from Linux Kernel 2.6.36.4 to 2.6.37 (and beyond)
Date: Thu, 30 Aug 2012 10:41:22 +0000 (UTC)
Message-ID: <20120830104122.BF4E711FC43@bugzilla.kernel.org>
References: <bug-41552-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:49724 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852Ab2H3Kl0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Aug 2012 06:41:26 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 04B4C202B8
	for <linux-scsi@vger.kernel.org>; Thu, 30 Aug 2012 10:41:25 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 525D52029D
	for <linux-scsi@vger.kernel.org>; Thu, 30 Aug 2012 10:41:23 +0000 (UTC)
In-Reply-To: <bug-41552-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=41552


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

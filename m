From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 46891] scsi/bnx2fc/bnx2fc_io.c:1810: bad call to memset
Date: Mon,  3 Sep 2012 15:36:01 +0000 (UTC)
Message-ID: <20120903153601.C28CC11FC43@bugzilla.kernel.org>
References: <bug-46891-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:41535 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932260Ab2ICPgH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Sep 2012 11:36:07 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 25FE620334
	for <linux-scsi@vger.kernel.org>; Mon,  3 Sep 2012 15:36:04 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 6790A20336
	for <linux-scsi@vger.kernel.org>; Mon,  3 Sep 2012 15:36:02 +0000 (UTC)
In-Reply-To: <bug-46891-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=46891


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alan@lxorguk.ukuu.org.uk
          Component|Other                       |Other
         AssignedTo|drivers_other@kernel-bugs.o |scsi_drivers-other@kernel-b
                   |sdl.org                     |ugs.osdl.org
            Product|Drivers                     |SCSI Drivers




--- Comment #1 from Alan <alan@lxorguk.ukuu.org.uk>  2012-09-03 15:36:01 ---
Yes this does appear to be the case - the warning is confusing though.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

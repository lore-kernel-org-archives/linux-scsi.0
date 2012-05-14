From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 18362] Possible kernel memory corruption due to wrong usage of
 CDROM_SEND_PACKET
Date: Mon, 14 May 2012 14:51:23 +0000 (UTC)
Message-ID: <20120514145123.02D3011FCE5@bugzilla.kernel.org>
References: <bug-18362-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:57066 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402Ab2ENOv0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 May 2012 10:51:26 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id EBBBC2042F
	for <linux-scsi@vger.kernel.org>; Mon, 14 May 2012 14:51:24 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 95DF420426
	for <linux-scsi@vger.kernel.org>; Mon, 14 May 2012 14:51:23 +0000 (UTC)
In-Reply-To: <bug-18362-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=18362


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alan@lxorguk.ukuu.org.uk
          Component|Other                       |SCSI
         AssignedTo|io_other@kernel-bugs.osdl.o |linux-scsi@vger.kernel.org
                   |rg                          |




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

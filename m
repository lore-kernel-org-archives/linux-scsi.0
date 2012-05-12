From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43085] BUG: unable to handle kernel NULL pointer dereference
 (in scsi_send_eh_cmnd)
Date: Sat, 12 May 2012 01:05:19 +0000 (UTC)
Message-ID: <20120512010519.8FD2111FCE1@bugzilla.kernel.org>
References: <bug-43085-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:50960 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757039Ab2ELBFX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 May 2012 21:05:23 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id BC47620280
	for <linux-scsi@vger.kernel.org>; Sat, 12 May 2012 01:05:22 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 957C120284
	for <linux-scsi@vger.kernel.org>; Sat, 12 May 2012 01:05:19 +0000 (UTC)
In-Reply-To: <bug-43085-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=43085


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alan@lxorguk.ukuu.org.uk
          Component|Other                       |USB
         AssignedTo|scsi_drivers-other@kernel-b |greg@kroah.com
                   |ugs.osdl.org                |
            Product|SCSI Drivers                |Drivers




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

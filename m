From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43801] st: fixed-block reads near end-of-data can fail
 incorrectly
Date: Thu, 30 Aug 2012 17:05:08 +0000 (UTC)
Message-ID: <20120830170508.DC2A011FC43@bugzilla.kernel.org>
References: <bug-43801-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:34151 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907Ab2H3RFP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Aug 2012 13:05:15 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6AA2520306
	for <linux-scsi@vger.kernel.org>; Thu, 30 Aug 2012 17:05:14 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 97E39202FD
	for <linux-scsi@vger.kernel.org>; Thu, 30 Aug 2012 17:05:09 +0000 (UTC)
In-Reply-To: <bug-43801-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=43801


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alan@lxorguk.ukuu.org.uk
          Component|Other                       |Other
         AssignedTo|drivers_other@kernel-bugs.o |scsi_drivers-other@kernel-b
                   |sdl.org                     |ugs.osdl.org
            Product|Drivers                     |SCSI Drivers




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

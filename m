From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11646] QLA2xxx: Kernel deadlock on high load somewhere after 2.6.20
Date: Fri, 26 Sep 2008 06:59:41 -0700 (PDT)
Message-ID: <20080926135941.ED387108058@picon.linux-foundation.org>
References: <bug-11646-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751962AbYIZOAA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Sep 2008 10:00:00 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m8QDxfuE017837
	for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2008 06:59:43 -0700
In-Reply-To: <bug-11646-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11646


seokmann.ju@qlogic.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |seokmann.ju@qlogic.com




------- Comment #5 from seokmann.ju@qlogic.com  2008-09-26 06:59 -------
One thing, could you redirect console output to serial port so that we could
grab as much information as the kernel provides?
If I understood correctly, this helps in the situation where the system gets
locked up or hung.
Hope it will provide further direction for us to go.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

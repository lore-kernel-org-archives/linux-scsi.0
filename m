From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10711] BUG: unable to handle kernel paging request - scsi_bus_uevent
Date: Fri, 23 May 2008 12:45:22 -0700 (PDT)
Message-ID: <20080523194522.8C1D411D109@picon.linux-foundation.org>
References: <bug-10711-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754837AbYEWTpx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 May 2008 15:45:53 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m4NJjMEL030650
	for <linux-scsi@vger.kernel.org>; Fri, 23 May 2008 12:45:23 -0700
In-Reply-To: <bug-10711-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10711





------- Comment #3 from sitsofe@yahoo.com  2008-05-23 12:45 -------
This seems to have been resolved by James's patch in
http://groups.google.com/group/fa.linux.kernel/browse_frm/thread/b64dbe94dea882cb/c60bafa089f89c6b?#c60bafa089f89c6b
for me...


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

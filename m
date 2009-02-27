From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11646] QLA2xxx: Kernel deadlock on high load somewhere after 2.6.20
Date: Fri, 27 Feb 2009 01:50:30 -0800 (PST)
Message-ID: <20090227095030.5DDB8108041@picon.linux-foundation.org>
References: <bug-11646-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754376AbZB0JvE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2009 04:51:04 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1R9oUE5016407
	for <linux-scsi@vger.kernel.org>; Fri, 27 Feb 2009 01:50:31 -0800
In-Reply-To: <bug-11646-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11646





------- Comment #19 from grin@grin.hu  2009-02-27 01:50 -------
Created an attachment (id=20377)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=20377&action=view)
syslog when starting up multipath

Maybe this contains some info, because the debug values don't say anything to
me. To prevent things from crashing we actualy keep one path down by switching
off one (qlogic fibre) switch. This way we only have occasional crashes (but
since I cannot conjure external console, I'm stuck at that point). 

Someone switched on accidentally the switch, activating the multipath. I'm
attaching what happens. (It goes on and on further, end position of the log is
arbitrary.)


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

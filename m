From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10711] BUG: unable to handle kernel paging request - scsi_bus_uevent
Date: Tue, 20 May 2008 05:19:57 -0700 (PDT)
Message-ID: <20080520121957.3DF2811D108@picon.linux-foundation.org>
References: <bug-10711-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57115 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764275AbYETMU1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 May 2008 08:20:27 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m4KCJv8d014354
	for <linux-scsi@vger.kernel.org>; Tue, 20 May 2008 05:19:58 -0700
In-Reply-To: <bug-10711-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10711





------- Comment #1 from zdenek.kabelac@gmail.com  2008-05-20 05:19 -------
Bug happend at least twice on my desktop with 2.6.26-rc3 - thought now I do not
have such a backtrace as this deadlock now kills the machine -  I just know
that RIP was from scsi_bus_uevent. If it would be worth to add - I could try to
add a camera snapshost - but the trace is far from complete (just some bottom
lines :( ).

The error happens once per couple reboots - but it is unpredicteble and hard to
check. But it is definitely present in -rc3


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12164] cciss driver hangs on boot
Date: Sun,  4 Jan 2009 15:54:02 -0800 (PST)
Message-ID: <20090104235402.1474F10800E@picon.linux-foundation.org>
References: <bug-12164-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49466 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751531AbZADXyi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Jan 2009 18:54:38 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n04Ns2Lv002646
	for <linux-scsi@vger.kernel.org>; Sun, 4 Jan 2009 15:54:03 -0800
In-Reply-To: <bug-12164-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12164


w@1wt.eu changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |w@1wt.eu
         AssignedTo|linux-scsi@vger.kernel.org  |w@1wt.eu
             Status|NEW                         |ASSIGNED




------- Comment #2 from w@1wt.eu  2009-01-04 15:54 -------
Hi,

sorry for the delay, I've not been much available these weeks.

With which compiler(s) have you tried ? I have vague memories of a few of the
changes you outlined above (eg: gcc-3.4 fixes). Those were done with a lot of
care, so I would bet they're OK. But maybe the updates 1-5 contain something
wrong. I still find it strange that nobody encountered any problem with this
driver for the last 4 years. Do you think that your setup has something
specific
which could explain why others are not affected ?

Willy


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
You are the assignee for the bug, or are watching the assignee.

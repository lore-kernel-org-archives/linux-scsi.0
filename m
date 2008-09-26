From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11646] QLA2xxx: Kernel deadlock on high load somewhere after 2.6.20
Date: Fri, 26 Sep 2008 06:48:10 -0700 (PDT)
Message-ID: <20080926134811.04A99108057@picon.linux-foundation.org>
References: <bug-11646-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37195 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751673AbYIZNsM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Sep 2008 09:48:12 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m8QDmB4S016623
	for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2008 06:48:12 -0700
In-Reply-To: <bug-11646-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11646





------- Comment #4 from grin@grin.hu  2008-09-26 06:48 -------
I have put some screenshots of the crashes to the same location, though I am
not sure anything useful could be prayed out of them. 

Can I provide any more info? Were there anything useful? Or any idea on a way I
could deliberately crash it (so I can try on a test machine any kernel
versions/patches you like)?


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

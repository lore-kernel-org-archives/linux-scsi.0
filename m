From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 9133] aacraid driver fails with Dell PowerEdge Expandable RAID Controller 3/Di
Date: Sun, 20 Apr 2008 05:40:36 -0700 (PDT)
Message-ID: <20080420124037.0467910805F@picon.linux-foundation.org>
References: <bug-9133-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49350 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753754AbYDTMlH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Apr 2008 08:41:07 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m3KCebNU002721
	for <linux-scsi@vger.kernel.org>; Sun, 20 Apr 2008 05:40:38 -0700
In-Reply-To: <bug-9133-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=9133


Matt_Domsch@dell.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |linux-bugs@dell.com




------- Comment #7 from Matt_Domsch@dell.com  2008-04-20 05:40 -------
If specific firmware versions (e.g. less than X) for a given card are known to
be problematic, the driver init routine should detect these and warn loudly, if
not fail to load all together.  We did this with the megaraid_legacy driver a
long time ago to avoid firmware-induced data corruption.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

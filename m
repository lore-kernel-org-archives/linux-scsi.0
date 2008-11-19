From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11404] BUG: in 2.6.23-rc3-git7 in do_cciss_intr
Date: Wed, 19 Nov 2008 11:39:26 -0800 (PST)
Message-ID: <20081119193926.3A0E9108042@picon.linux-foundation.org>
References: <bug-11404-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55575 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752305AbYKSTj6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Nov 2008 14:39:58 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mAJJdQeo015187
	for <linux-scsi@vger.kernel.org>; Wed, 19 Nov 2008 11:39:27 -0800
In-Reply-To: <bug-11404-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11404


randy.dunlap@oracle.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |REJECTED
         Resolution|                            |INVALID




------- Comment #8 from randy.dunlap@oracle.com  2008-11-19 11:39 -------
This currently only happens when loading a new kernel via kexec
and the first kernel is "old" (like 2.6.18; using 2.6.25 to load
the kernel-under-test works OK).


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

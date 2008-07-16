From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11045] Bug in MPT Fusion 2.6.26-rc7 unbootable
Date: Wed, 16 Jul 2008 13:40:35 -0700 (PDT)
Message-ID: <20080716204035.67E6E11D108@picon.linux-foundation.org>
References: <bug-11045-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753050AbYGPUkh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jul 2008 16:40:37 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m6GKeZXr032049
	for <linux-scsi@vger.kernel.org>; Wed, 16 Jul 2008 13:40:36 -0700
In-Reply-To: <bug-11045-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11045


rjw@sisk.pl changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |CLOSED
         Resolution|                            |CODE_FIX




------- Comment #22 from rjw@sisk.pl  2008-07-16 13:40 -------
Fixed by:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=27898988174bb211fd962ea73b9c6dc09f888705


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

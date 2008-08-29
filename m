From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11120] aacraid driver stalls on high-load SMP machines
Date: Thu, 28 Aug 2008 22:41:40 -0700 (PDT)
Message-ID: <20080829054140.81C2311D107@picon.linux-foundation.org>
References: <bug-11120-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46916 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751079AbYH2FmL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Aug 2008 01:42:11 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m7T5feZj019388
	for <linux-scsi@vger.kernel.org>; Thu, 28 Aug 2008 22:41:41 -0700
In-Reply-To: <bug-11120-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11120


smurf@smurf.noris.de changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         AssignedTo|scsi_drivers-aacraid@kernel-|smurf@smurf.noris.de
                   |bugs.osdl.org               |
             Status|NEW                         |ASSIGNED




------- Comment #3 from smurf@smurf.noris.de  2008-08-28 22:41 -------
Thank you. I will test this workaround today.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
You are the assignee for the bug, or are watching the assignee.

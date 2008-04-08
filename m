From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 7630] os_scsi_tapes_lock should not be acquired before calling new_tape_buffer
Date: Tue,  8 Apr 2008 15:50:36 -0700 (PDT)
Message-ID: <20080408225036.780D9108065@picon.linux-foundation.org>
References: <bug-7630-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752294AbYDHWvM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Apr 2008 18:51:12 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m38Moa2t008372
	for <linux-scsi@vger.kernel.org>; Tue, 8 Apr 2008 15:50:37 -0700
In-Reply-To: <bug-7630-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=7630


protasnb@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |protasnb@gmail.com,
                   |                            |jejb@steeleye.com




------- Comment #5 from protasnb@gmail.com  2008-04-08 15:50 -------
Lin, can you update status on this bug please. I am not sure which comment was
in error, but you can just re-state what you were intending to write.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

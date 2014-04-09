From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71231] System unresponsable after a lot of LUNs have been added
 to the system
Date: Wed, 09 Apr 2014 17:50:49 +0000
Message-ID: <bug-71231-11613-HwCpzf3hDd@https.bugzilla.kernel.org/>
References: <bug-71231-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:52874 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933143AbaDIRuw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Apr 2014 13:50:52 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DE8B1206BD
	for <linux-scsi@vger.kernel.org>; Wed,  9 Apr 2014 17:50:51 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 13472206B1
	for <linux-scsi@vger.kernel.org>; Wed,  9 Apr 2014 17:50:51 +0000 (UTC)
In-Reply-To: <bug-71231-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=71231

Hannes Reinecke <hare@suse.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |hare@suse.de

--- Comment #12 from Hannes Reinecke <hare@suse.de> ---
Comment #3 is the well-known printk lockup.

Try to increase the speed on the serial console.
Or alternatively try the patch by Jan Kara, should've been posted to lkml.

Nothing to do with SCSI, except for the number of messages printed.

-- 
You are receiving this mail because:
You are the assignee for the bug.

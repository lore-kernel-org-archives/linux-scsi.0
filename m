From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12945] SCSI Generic (sg): BUG: sleeping function called from
 invalid context
Date: Mon, 25 Jan 2010 13:10:48 GMT
Message-ID: <201001251310.o0PDAmRl028446@demeter.kernel.org>
References: <bug-12945-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:37159 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab0AYNKt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jan 2010 08:10:49 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0PDAmeV028447
	for <linux-scsi@vger.kernel.org>; Mon, 25 Jan 2010 13:10:48 GMT
In-Reply-To: <bug-12945-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12945


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |alan@lxorguk.ukuu.org.uk
         Resolution|                            |CODE_FIX




--- Comment #4 from Alan <alan@lxorguk.ukuu.org.uk>  2010-01-25 13:10:46 ---
commit c96952ed7031e7c576ecf90cf95b8ec099d5295a

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

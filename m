From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14258] Memory leak in SCSI initialization
Date: Mon, 16 Nov 2009 23:00:29 GMT
Message-ID: <200911162300.nAGN0T4T004111@demeter.kernel.org>
References: <bug-14258-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:45101 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775AbZKPXAY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2009 18:00:24 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAGN0TBM004112
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2009 23:00:29 GMT
In-Reply-To: <bug-14258-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14258


Rafael J. Wysocki <rjw@sisk.pl> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |CLOSED
         Resolution|PATCH_ALREADY_AVAILABLE     |CODE_FIX




--- Comment #2 from Rafael J. Wysocki <rjw@sisk.pl>  2009-11-16 23:00:26 ---
Fixed by commit 37e6ba00720c2786330dec2a9a5081e9e049422f .

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

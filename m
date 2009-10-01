From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14136] readcd Oops
Date: Thu, 1 Oct 2009 22:46:20 GMT
Message-ID: <200910012246.n91MkKBc015592@demeter.kernel.org>
References: <bug-14136-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:43284 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbZJAWqQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2009 18:46:16 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n91MkKEA015593
	for <linux-scsi@vger.kernel.org>; Thu, 1 Oct 2009 22:46:20 GMT
In-Reply-To: <bug-14136-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14136


Rafael J. Wysocki <rjw@sisk.pl> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |CLOSED
         Resolution|PATCH_ALREADY_AVAILABLE     |CODE_FIX




--- Comment #1 from Rafael J. Wysocki <rjw@sisk.pl>  2009-10-01 22:46:20 ---
Fixed by commit e71044ee2efa4792e21d243b03d49006db66aec9.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

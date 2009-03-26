From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12945] SCSI Generic (sg): BUG: sleeping function called from
 invalid context
Date: Thu, 26 Mar 2009 14:50:05 GMT
Message-ID: <200903261450.n2QEo5Yo028459@demeter.kernel.org>
References: <bug-12945-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40370 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759183AbZCZOuH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2009 10:50:07 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n2QEo5Ya028460
	for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2009 14:50:05 GMT
In-Reply-To: <bug-12945-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12945


Andrew Morton <akpm@osdl.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |akpm@osdl.org
         Regression|No                          |Yes




-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

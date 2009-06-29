From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13572] hdparm -W1 /dev/sda causes oops and hard lockup
Date: Mon, 29 Jun 2009 21:37:05 GMT
Message-ID: <200906292137.n5TLb5kJ018762@demeter.kernel.org>
References: <bug-13572-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:37427 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbZF2VhD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2009 17:37:03 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n5TLb5HN018763
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2009 21:37:05 GMT
In-Reply-To: <bug-13572-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13572


Andrew Morton <akpm@linux-foundation.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |akpm@linux-foundation.org
         AssignedTo|linux-scsi@vger.kernel.org  |minyard@acm.org




--- Comment #3 from Andrew Morton <akpm@linux-foundation.org>  2009-06-29 21:37:03 ---
Assigning this to Corey.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

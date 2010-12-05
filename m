From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16971] qla4xxx compile failure on 32-bit PowerPC: missing readq
 and writeq
Date: Sun, 5 Dec 2010 21:52:22 GMT
Message-ID: <201012052152.oB5LqMmA011154@demeter2.kernel.org>
References: <bug-16971-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:48021 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755757Ab0LEVwX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Dec 2010 16:52:23 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id oB5LqMT4011155
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 5 Dec 2010 21:52:22 GMT
In-Reply-To: <bug-16971-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16971





--- Comment #6 from Rafael J. Wysocki <rjw@sisk.pl>  2010-12-05 21:52:20 ---
On Sunday, December 05, 2010, Meelis Roos wrote:
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.35 and 2.6.36.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> 
> Yes, still present in yesterdays git.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

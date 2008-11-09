From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11404] BUG: in 2.6.23-rc3-git7 in do_cciss_intr
Date: Sun,  9 Nov 2008 15:24:28 -0800 (PST)
Message-ID: <20081109232428.C2999108041@picon.linux-foundation.org>
References: <bug-11404-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56516 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756467AbYKIXZD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Nov 2008 18:25:03 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mA9NOSLV002504
	for <linux-scsi@vger.kernel.org>; Sun, 9 Nov 2008 15:24:29 -0800
In-Reply-To: <bug-11404-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11404





------- Comment #6 from rjw@sisk.pl  2008-11-09 15:24 -------
On Sunday, 9 of November 2008, Randy Dunlap wrote:
> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.26 and 2.6.27.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.26 and 2.6.27.  Please verify if it still should
> > be listed and let me know (either way).
> 
> Yes, it should still be listed.
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11404
> > Subject		: BUG: in 2.6.23-rc3-git7 in do_cciss_intr
> > Submitter	: rdunlap <randy.dunlap@oracle.com>
> > Date		: 2008-08-21 5:52 (81 days old)
> > References	: http://marc.info/?l=linux-kernel&m=121929819616273&w=4
> > 		  http://marc.info/?l=linux-kernel&m=121932889105368&w=4
> > Handled-By	: Miller, Mike (OS Dev) <Mike.Miller@hp.com>
> > 		  James Bottomley <James.Bottomley@hansenpartnership.com>


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

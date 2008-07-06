From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10861] 2.6.26-rc4-git2 - long pause during boot
Date: Sun,  6 Jul 2008 10:12:49 -0700 (PDT)
Message-ID: <20080706171249.92FF3108047@picon.linux-foundation.org>
References: <bug-10861-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756816AbYGFRMv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Jul 2008 13:12:51 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m66HCnJZ011714
	for <linux-scsi@vger.kernel.org>; Sun, 6 Jul 2008 10:12:50 -0700
In-Reply-To: <bug-10861-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10861





------- Comment #7 from rjw@sisk.pl  2008-07-06 10:12 -------
On Sunday, 6 of July 2008, James Bottomley wrote:
> On Sun, 2008-07-06 at 13:45 +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.25.  Please verify if it still should be listed.
> 
> Erm, this isn't a kernel regression, it's a udev rule problem.
> 
> The rule has been identified and fixed; the reporter confirms it fixes
> the problem and the upstream maintainer of udev is putting out a release
> with it in ... what more exactly needs to be done?


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10861] 2.6.26-rc4-git2 - long pause during boot
Date: Sun, 15 Jun 2008 03:40:46 -0700 (PDT)
Message-ID: <20080615104046.4AA8C108038@picon.linux-foundation.org>
References: <bug-10861-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40392 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754804AbYFOKkr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Jun 2008 06:40:47 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m5FAekfx002010
	for <linux-scsi@vger.kernel.org>; Sun, 15 Jun 2008 03:40:47 -0700
In-Reply-To: <bug-10861-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10861





------- Comment #3 from rjw@sisk.pl  2008-06-15 03:40 -------
On Sunday, 15 of June 2008, Chris Clayton wrote:
> On Saturday 14 June 2008, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.25.  Please verify if it still should be listed.
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10861
> > Subject		: 2.6.26-rc4-git2 - long pause during boot
> > Submitter	: Chris Clayton <chris2553@googlemail.com>
> > Date		: 2008-06-01 4:15 (14 days old)
> > References	: http://marc.info/?l=linux-kernel&m=121229382917834&w=4
> 
> Well, we know how to create (and to avoid) the problem. Since the original patch 
> adversely affects existing user space, it could be argued that it is a 
> regression, but I see that there is a counter argument that the udev rule that 
> triggers the problem is quite simply a bad rule.
> 
> I'll leave to those more closely concerned that rule on that.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

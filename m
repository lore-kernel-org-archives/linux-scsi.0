From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10861] 2.6.26-rc4-git2 - long pause during boot
Date: Wed,  2 Jul 2008 09:18:40 -0700 (PDT)
Message-ID: <20080702161840.DEF36108047@picon.linux-foundation.org>
References: <bug-10861-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754566AbYGBQTM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Jul 2008 12:19:12 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m62GIeqg011391
	for <linux-scsi@vger.kernel.org>; Wed, 2 Jul 2008 09:18:41 -0700
In-Reply-To: <bug-10861-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10861





------- Comment #6 from rjw@sisk.pl  2008-07-02 09:18 -------
On Monday, 30 of June 2008, Chris Clayton wrote:
> Rafael
> 
> On Sunday 29 June 2008, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.25.  Please verify if it still should be listed.
> >
> 
> As far as I'm concerned, the entry can be closed.. As I've said before, the 
> patch did have a bad effect on existing user space, but, as Kay pointed out, 
> there's no getting away from the fact that the rule in Slackware rules 
> distributed with udev is a bad rule. the Slackware distribution does not 
> include that rule in its udev rules.
> 
> I assume Kay will fix it in the udev package.
> 
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10861
> > Subject		: 2.6.26-rc4-git2 - long pause during boot
> > Submitter	: Chris Clayton <chris2553@googlemail.com>
> > Date		: 2008-06-01 4:15 (29 days old)
> > References	: http://marc.info/?l=linux-kernel&m=121229382917834&w=4


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10374] sym53c8xx: weird behavior with udev
Date: Tue,  1 Apr 2008 15:30:37 -0700 (PDT)
Message-ID: <20080401223037.5F62A11D108@picon.linux-foundation.org>
References: <bug-10374-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44639 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756457AbYDAWaj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Apr 2008 18:30:39 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m31MUbon023725
	for <linux-scsi@vger.kernel.org>; Tue, 1 Apr 2008 15:30:38 -0700
In-Reply-To: <bug-10374-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10374





------- Comment #9 from seraph@xs4all.nl  2008-04-01 15:30 -------
On Tue, 01 Apr 2008 16:14:14 -0500
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> Yes ... that's what I guess.  Just as one last grasp at a straw, is
> there any difference in /proc/iomem or /proc/ioports for the working
> case (sungem loaded first followed by sym2)?

Nope, exactly the same.

> > > I'm afraid I can't see anything relevant looking over the sym2 changes,
> > > so you might need to bisect this to identify the culprit.

First results are in: 2.6.23-rc1 could not boot, 2.6.23-rc2 already had the
problem.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

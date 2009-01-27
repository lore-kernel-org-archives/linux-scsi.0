From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12544] megaraid kernel oops during smartd poll
Date: Mon, 26 Jan 2009 22:49:33 -0800 (PST)
Message-ID: <20090127064933.CC533108040@picon.linux-foundation.org>
References: <bug-12544-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41714 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750940AbZA0Gtg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jan 2009 01:49:36 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0R6nYB2016866
	for <linux-scsi@vger.kernel.org>; Mon, 26 Jan 2009 22:49:35 -0800
In-Reply-To: <bug-12544-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12544





------- Comment #2 from dimetrios@gmail.com  2009-01-26 22:49 -------
> 
> On Mon, 26 Jan 2009 12:54:29 -0800 (PST)
> bugme-daemon@bugzilla.kernel.org wrote:

> googling for `megaraid_queue_command oops' elicits a long and sorry tale.
>

It's sad :(

> Seems that this bug (or a very similar one) was also present in
> 2.6.9-42.0.2.ELsmp (http://lkml.org/lkml/2007/3/8/467) so perhaps it
> isn't a regression.
> 

For two years this machine worked under RHEL4
2.6.9-42.0.8.EL.smp/2.6.9-55.EL.smp as MySQL server (uptime 80 days and more).
And there were no problems.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

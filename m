From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12544] megaraid kernel oops during smartd poll
Date: Mon, 26 Jan 2009 13:16:05 -0800 (PST)
Message-ID: <20090126211605.46B2210800F@picon.linux-foundation.org>
References: <bug-12544-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751632AbZAZVQH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jan 2009 16:16:07 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0QLG5Jf015633
	for <linux-scsi@vger.kernel.org>; Mon, 26 Jan 2009 13:16:06 -0800
In-Reply-To: <bug-12544-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12544





------- Comment #1 from anonymous@kernel-bugs.osdl.org  2009-01-26 13:16 -------
Reply-To: akpm@linux-foundation.org

On Mon, 26 Jan 2009 12:54:29 -0800 (PST)
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=12544
> 
>            Summary: megaraid kernel oops during smartd poll

googling for `megaraid_queue_command oops' elicits a long and sorry tale.

Seems that this bug (or a very similar one) was also present in
2.6.9-42.0.2.ELsmp (http://lkml.org/lkml/2007/3/8/467) so perhaps it
isn't a regression.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

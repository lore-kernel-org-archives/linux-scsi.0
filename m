From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10846] Slow write on LSISAS1068E (SAS6/iR) on kernel >= 2.6.22
Date: Tue,  3 Jun 2008 09:09:02 -0700 (PDT)
Message-ID: <20080603160902.B120A10805D@picon.linux-foundation.org>
References: <bug-10846-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39638 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752352AbYFCQJd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jun 2008 12:09:33 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m53G928i023167
	for <linux-scsi@vger.kernel.org>; Tue, 3 Jun 2008 09:09:03 -0700
In-Reply-To: <bug-10846-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10846





------- Comment #5 from dom.lalot@gmail.com  2008-06-03 09:09 -------
James,

Should we consider, that such a difference is normal. You suggest that before
the kernel was dangerous at writing data?
So unpacking linux kernel (for example) is 5x times slower and it is not a
problem. That's just new way of caching data? We seldom see crashes (thanks to
linux) and we have power supply.

I'd like testing on same hardware windows to see its behaviour and speed.
Anyway thanks for the clarifying of cache: write through. As you say, it was
not evident. 

So, now, what can we do to keep 2.6.21 behaviour? That's for a mail system
writing lots of little files and performance matters too.

Dom


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

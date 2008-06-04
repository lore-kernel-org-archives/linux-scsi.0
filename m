From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10846] Slow write on LSISAS1068E (SAS6/iR) on kernel >= 2.6.22
Date: Wed,  4 Jun 2008 08:22:42 -0700 (PDT)
Message-ID: <20080604152242.3333E10805E@picon.linux-foundation.org>
References: <bug-10846-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49635 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754592AbYFDPWn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jun 2008 11:22:43 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m54FMgU3028762
	for <linux-scsi@vger.kernel.org>; Wed, 4 Jun 2008 08:22:43 -0700
In-Reply-To: <bug-10846-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10846





------- Comment #8 from dom.lalot@gmail.com  2008-06-04 08:22 -------
Well,

I don't know what to say as a conclusion. We checked on another machine (sata
devices). We confirmed the difference between the kernels.
I don't know the algorythum about the write caching, in fact we have seen a
difference. If we stay under 80Mo, we stay in cache without effect from the
write back or write through written in dmesg. 2.6.21 and above are OK.
It you test for 600Mo, you get hardware speed on 2.6.22+

As a conclusion: I was not lucky in doing such a test on a new hardware. I
believed it comes from SAS and finaly that's more a change in Memory
Management. By the way, if somebody can tell me where we can tune the max
memory cache in kernel, that would be great. Anyway, for our purpose, it's not
usefull.

Thanks

Dominique

Can you close the bug, or should I? 


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

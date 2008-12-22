From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12207] block reads/writes > 122880 bytes to USB tape drive gives EBUSY
Date: Mon, 22 Dec 2008 10:08:25 -0800 (PST)
Message-ID: <20081222180825.F213810800D@picon.linux-foundation.org>
References: <bug-12207-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56250 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752945AbYLVSI1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Dec 2008 13:08:27 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBMI8Qw0016721
	for <linux-scsi@vger.kernel.org>; Mon, 22 Dec 2008 10:08:27 -0800
In-Reply-To: <bug-12207-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12207





------- Comment #2 from philipm@sybase.com  2008-12-22 10:08 -------
Yes, I've tried right up to 2.6.27 with the same failure.  I did not try 2.6.14
or 2.6.15 because I don't have a machine on hand with those kernels, but 2.6.13
worked fine.  

Based on the behaviour I'm seeing, I'm guessing it's the third thing you
listed, but the limit appears to have changed to something that's unreasonably
small for a tape device.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

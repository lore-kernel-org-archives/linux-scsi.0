From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12207] block reads/writes > 122880 bytes to USB tape drive gives EBUSY
Date: Sun, 22 Mar 2009 13:52:14 -0700 (PDT)
Message-ID: <20090322205214.A305C108042@picon.linux-foundation.org>
References: <bug-12207-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753183AbZCVUwx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Mar 2009 16:52:53 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n2MKqFu1014173
	for <linux-scsi@vger.kernel.org>; Sun, 22 Mar 2009 13:52:50 -0700
In-Reply-To: <bug-12207-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12207





------- Comment #23 from philipm@sybase.com  2009-03-22 13:52 -------
Okay, I *finally* managed to try it out.  It does seem to solve the problem.

Thanks,
Phil


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

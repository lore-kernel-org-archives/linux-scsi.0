From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12207] block reads/writes > 122880 bytes to USB tape drive gives EBUSY
Date: Tue, 30 Dec 2008 11:39:44 -0800 (PST)
Message-ID: <20081230193944.7137311D10B@picon.linux-foundation.org>
References: <bug-12207-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752571AbYL3TkM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Dec 2008 14:40:12 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBUJdicj027909
	for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2008 11:39:45 -0800
In-Reply-To: <bug-12207-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12207





------- Comment #18 from stern@rowland.harvard.edu  2008-12-30 11:39 -------
Does James's patch fix the problem?

If it does, would we be better off making 0xFFFF the default
max_sectors value and then explicitly decreasing it to 240 only for
disk-type devices?  Or would that be liable to cause problems for 
things like CD writers and cdrecord?

Alan Stern

PS: Why is 0xFFFF the accepted maximum value?  Historical reasons?  In 
theory, the real maximum should be one less than the number of sectors 
in 4 GB, i.e., ((1 << (32-9)) - 1 or 0x7FFFFF.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12207] block reads/writes > 122880 bytes to USB tape drive gives EBUSY
Date: Tue, 23 Dec 2008 06:48:13 -0800 (PST)
Message-ID: <20081223144813.B4400108047@picon.linux-foundation.org>
References: <bug-12207-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751159AbYLWOso (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Dec 2008 09:48:44 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBNEmDuv016539
	for <linux-scsi@vger.kernel.org>; Tue, 23 Dec 2008 06:48:14 -0800
In-Reply-To: <bug-12207-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12207





------- Comment #9 from anonymous@kernel-bugs.osdl.org  2008-12-23 06:48 -------
Reply-To: bharrosh@panasas.com

bugme-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=12207
> 
> 
> 
> 
> 
> ------- Comment #6 from stern@rowland.harvard.edu  2008-12-23 05:59 -------
> You can change the max_sectors setting through sysfs.  However the last time I
> looked, the block layer limited max_sectors to 512 KB or something on that
> order, so you can't get too much improvement.
> 
> Why is a limit of 120 KB unreasonably small?  All it means is that you have to
> use more system calls to transfer the same amount of data.  Is anything wrong
> with that?
> 
> 

This is not true BIOs can be chained and also SGs can be chained.
You should be able to configure a very large transfer

Boaz


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

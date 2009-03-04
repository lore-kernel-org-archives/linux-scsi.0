From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11646] QLA2xxx: Kernel deadlock on high load somewhere after 2.6.20
Date: Wed,  4 Mar 2009 08:14:05 -0800 (PST)
Message-ID: <20090304161405.C988A11D10A@picon.linux-foundation.org>
References: <bug-11646-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38521 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753038AbZCDQOl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2009 11:14:41 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n24GE6Gw021904
	for <linux-scsi@vger.kernel.org>; Wed, 4 Mar 2009 08:14:07 -0800
In-Reply-To: <bug-11646-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11646





------- Comment #24 from daniel@economicmodeling.com  2009-03-04 08:14 -------
I do not use multipathd, and the qlogic timeouts still crash my system. I
believe Seokman Ju's multipathd errors are caused by the qlogic driver. Notice
how the timestamps for the qlogic events are before the multipath errors.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

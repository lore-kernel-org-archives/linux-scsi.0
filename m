From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10711] BUG: unable to handle kernel paging request - scsi_bus_uevent
Date: Fri, 23 May 2008 14:25:24 -0700 (PDT)
Message-ID: <20080523212524.6992C11D108@picon.linux-foundation.org>
References: <bug-10711-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55274 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753264AbYEWVZy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 May 2008 17:25:54 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m4NLPOUk004494
	for <linux-scsi@vger.kernel.org>; Fri, 23 May 2008 14:25:25 -0700
In-Reply-To: <bug-10711-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10711





------- Comment #4 from zdenek.kabelac@gmail.com  2008-05-23 14:25 -------
Is this the bugfix - or just the patch hides the real problem ?
I would have assumed that scsi_bus_uevent should not have been called at all
for the non-scsi device


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10711] BUG: unable to handle kernel paging request - scsi_bus_uevent
Date: Mon, 16 Jun 2008 14:49:31 -0700 (PDT)
Message-ID: <20080616214931.59918108035@picon.linux-foundation.org>
References: <bug-10711-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751439AbYFPVtd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jun 2008 17:49:33 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m5GLnV6O011309
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jun 2008 14:49:32 -0700
In-Reply-To: <bug-10711-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10711





------- Comment #10 from sitsofe@yahoo.com  2008-06-16 14:49 -------
There WAS a commit fixing this bug directly - it was carried in the SCSI fixes
tree and was commit [1f42ea7bc0ddfadebd9e1c5362b41b53902dbcb1] and started
turned up first in the next-20080526 tree and was committed to v2.6.26-rc5 (if
gitk is right).


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

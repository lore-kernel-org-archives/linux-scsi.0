From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10711] BUG: unable to handle kernel paging request - scsi_bus_uevent
Date: Tue, 20 May 2008 14:19:48 -0700 (PDT)
Message-ID: <20080520211948.5CE3611D108@picon.linux-foundation.org>
References: <bug-10711-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761013AbYETVUV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 May 2008 17:20:21 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m4KLJmxk022266
	for <linux-scsi@vger.kernel.org>; Tue, 20 May 2008 14:19:49 -0700
In-Reply-To: <bug-10711-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10711





------- Comment #2 from sitsofe@yahoo.com  2008-05-20 14:19 -------
Yes I still see it too despite the patches mentioned in
http://groups.google.com/group/fa.linux.kernel/browse_frm/thread/b64dbe94dea882cb/a8f1d83328fcbdc3?#a8f1d83328fcbdc3
. I bisected it down in
http://groups.google.com/group/fa.linux.kernel/msg/c36e78f19fc4aaa3 and
reverting the commit [dc16f5f2ede8cc2acf8ac22857a7fecf3a4296c2] PNP: make
generic pnp_add_dma_resource() semmed to make the problem go away.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

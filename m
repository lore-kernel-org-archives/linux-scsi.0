From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12222] kernel BUG at drivers/pci/intel-iommu.c:1373!
Date: Sun, 14 Dec 2008 13:21:58 -0800 (PST)
Message-ID: <20081214212158.27D9F10800E@picon.linux-foundation.org>
References: <bug-12222-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38864 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751556AbYLNVWA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Dec 2008 16:22:00 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBELLwcV017789
	for <linux-scsi@vger.kernel.org>; Sun, 14 Dec 2008 13:21:59 -0800
In-Reply-To: <bug-12222-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12222


john.blbec@centrum.cz changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |john.blbec@centrum.cz




------- Comment #3 from john.blbec@centrum.cz  2008-12-14 13:21 -------
thanks for the answer :o)

results:

1) intel_iommu=strict ... it does not solve the issue
2) intel_iommu=off ...... yes, it is a workaround, bonnie++ finished correctly

well, I have two  questions. what performance impact should I expect and is
there any odds the bug will be fixed in the next linux kernel version?


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

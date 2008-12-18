From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12223] kernel BUG at drivers/pci/intel-iommu.c:1373!
Date: Thu, 18 Dec 2008 02:32:28 -0800 (PST)
Message-ID: <20081218103228.31F83108040@picon.linux-foundation.org>
References: <bug-12223-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59137 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751506AbYLRKca (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Dec 2008 05:32:30 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBIAWSXX009167
	for <linux-scsi@vger.kernel.org>; Thu, 18 Dec 2008 02:32:29 -0800
In-Reply-To: <bug-12223-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12223


alan@lxorguk.ukuu.org.uk changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |DUPLICATE




------- Comment #1 from alan@lxorguk.ukuu.org.uk  2008-12-18 02:32 -------


*** This bug has been marked as a duplicate of bug 12222 ***


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

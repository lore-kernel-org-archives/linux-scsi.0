From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12222] kernel BUG at drivers/pci/intel-iommu.c:1373!
Date: Sun, 14 Dec 2008 09:59:49 -0800 (PST)
Message-ID: <20081214175949.7891310800E@picon.linux-foundation.org>
References: <bug-12222-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53434 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750950AbYLNSAV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Dec 2008 13:00:21 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBEHxnSU009281
	for <linux-scsi@vger.kernel.org>; Sun, 14 Dec 2008 09:59:50 -0800
In-Reply-To: <bug-12222-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12222





------- Comment #1 from john.blbec@centrum.cz  2008-12-14 09:59 -------
a photo of bug is taken in console so nvidia module has been removed even one
is in my cat /proc/modules. all tests has been run without nvidia module, of
course...


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

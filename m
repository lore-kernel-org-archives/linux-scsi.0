From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11898] mke2fs hang on AIC79 device.
Date: Tue, 18 Nov 2008 17:49:03 -0800 (PST)
Message-ID: <20081119014903.68419108043@picon.linux-foundation.org>
References: <bug-11898-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751737AbYKSBth (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Nov 2008 20:49:37 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mAJ1n3IF025450
	for <linux-scsi@vger.kernel.org>; Tue, 18 Nov 2008 17:49:04 -0800
In-Reply-To: <bug-11898-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11898





------- Comment #40 from yanmin_zhang@linux.intel.com  2008-11-18 17:49 -------
James,

Would you like to push the new patch to 2.6.28-rc6? My machines still hang with
2.6.28-rc5.

Thanks,
Yanmin


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

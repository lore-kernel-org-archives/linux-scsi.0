From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11898] mke2fs hang on AIC79 device.
Date: Sun,  9 Nov 2008 18:15:06 -0800 (PST)
Message-ID: <20081110021506.69EF2108048@picon.linux-foundation.org>
References: <bug-11898-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750904AbYKJCPj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Nov 2008 21:15:39 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mAA2F6om011903
	for <linux-scsi@vger.kernel.org>; Sun, 9 Nov 2008 18:15:07 -0800
In-Reply-To: <bug-11898-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11898





------- Comment #32 from alex.shi@intel.com  2008-11-09 18:15 -------
the comment #28 patch works on my scsi devices!

but seems copy&paster this patch from the website is hard to be patched in
kernel source directly. seems some strange char was inducted into patch that
make "patch -p1" get a regect. 

patching file drivers/scsi/scsi_lib.c
Hunk #1 FAILED at 567.
Hunk #2 FAILED at 591.
Hunk #3 FAILED at 612.

Seems the attached patch works better.  


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42783] Kernel ooops when disconnecting the USB flash disk, in
 which I've just modified partition table
Date: Sat, 18 Feb 2012 17:37:24 GMT
Message-ID: <201202181737.q1IHbOEx027858@bugzilla.kernel.org>
References: <bug-42783-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:39083 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab2BRRhY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Feb 2012 12:37:24 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q1IHbOUP027859
	for <linux-scsi@vger.kernel.org>; Sat, 18 Feb 2012 17:37:24 GMT
In-Reply-To: <bug-42783-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=42783





--- Comment #5 from WZab <wzab@ise.pw.edu.pl>  2012-02-18 17:37:23 ---
hal was probably installed by my distribution Debian/testing.
it's installation was forced by gnome-volume-manager
also the libthunar-vfs-1-2 requires libhal-storage1 package
and libwine requires libhal

So it seems, that I can't get rid of hal.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

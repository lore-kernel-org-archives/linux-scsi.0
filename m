From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 11646] QLA2xxx: Kernel deadlock on high load somewhere after
 2.6.20
Date: Sun, 31 Jan 2010 22:06:18 GMT
Message-ID: <201001312206.o0VM6IUC015855@demeter.kernel.org>
References: <bug-11646-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:59130 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab0AaWGT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Jan 2010 17:06:19 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o0VM6IQi015856
	for <linux-scsi@vger.kernel.org>; Sun, 31 Jan 2010 22:06:18 GMT
In-Reply-To: <bug-11646-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11646





--- Comment #31 from Csillag Tamas <cstamas@digitus.itk.ppke.hu>  2010-01-31 22:04:39 ---
Dear Andrew,

Now that is a good question. I remember that when I experienced this problem
the only solution that helped me was the kernel downgrade. As far as I remember
I tried the nomsi workaround but it did not helped (But I am *not* 100% sure on
this).

Is there a way to get the firmware version info from a live system (maybe
without reboot?)

For the old one I can get it from another server which is from the same order
as this one.

For the new:
I do not know if this info is sufficient:
-rwxr-xr-x 1 root root 1048576 Dec 11  2007 i24af143.bin
72ed710f260788aec4f725659bf54dcd  i24af143.bin

this is the file from the floppy used for the flashing.

If this does not help I can schedule a reboot and get it from the boot screen.

Thanks
--
Regards,
  CSILLAG Tamas

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

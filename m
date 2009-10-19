From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13783] udev causes high cpu usage
Date: Mon, 19 Oct 2009 03:46:26 GMT
Message-ID: <200910190346.n9J3kQsj026955@demeter.kernel.org>
References: <bug-13783-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:46859 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbZJSDqV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Oct 2009 23:46:21 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n9J3kQ8M026956
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2009 03:46:26 GMT
In-Reply-To: <bug-13783-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13783





--- Comment #19 from Wendall Cada <wendallc@83864.com>  2009-10-19 03:46:23 ---
What's interesting is that the cpu usage is spread across several processes:
devkit-disks-daemon 3%-8% (user)
gvfs-gdu-volume-monitor 3%-8% (system)
dbus-daemon 3%-8% (system)
gdu-notification-daemon 3%-8% (user)
udevd 1%-2% (system)

The cpu spikes to about 35%-40% usage for 30 seconds, then drops down to about
15%-20% for around a second and repeats the cycle.

I'm not sure which process I should provide an strace for. Or even if this is a
udev bug at this point. Suggestions?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

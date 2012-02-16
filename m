From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42783] Kernel ooops when disconnecting the USB flash disk, in
 which I've just modified partition table
Date: Thu, 16 Feb 2012 14:54:47 GMT
Message-ID: <201202161454.q1GEslfK032230@bugzilla.kernel.org>
References: <bug-42783-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:60948 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab2BPOyr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Feb 2012 09:54:47 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q1GEslXB032231
	for <linux-scsi@vger.kernel.org>; Thu, 16 Feb 2012 14:54:47 GMT
In-Reply-To: <bug-42783-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=42783





--- Comment #1 from WZab <wzab@ise.pw.edu.pl>  2012-02-16 14:54:46 ---
In the console there was an additional information, which was not stored in
/var/log/messages:

[ 5021.465121] usb 4-1.3: USB disconnect, device number 4
[ 5021.465800] scsi 7:0:0:0: killing request
[ 5021.465869] BUG: unable to handle kernel NULL pointer dereference at
0000000000000008
[ 5021.465942] IP: [<ffffffffa00bf7f4>] sd_revalidate_disk+0x39/0x1603 [sd_mod]
[ 5021.466008] PGD 1b9242067 PUD 1b3401067 PMD 0 
[ 5021.466052] Oops: 0000 [#1] PREEMPT SMP 
[ 5021.466093] CPU 3 
[ 5021.466110] Modules linked in: nls_utf8 nls_cp437 vfat fat snd_hrtimer tun
ebtable_nat ebtables acpi_cpufreq mperf cpufreq_conservative cpufreq_userspace
...

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11800] New: building SES support fails w/ gcc-3.4.5
Date: Tue, 21 Oct 2008 11:36:12 -0700 (PDT)
Message-ID: <bug-11800-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753251AbYJUSgo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Oct 2008 14:36:44 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m9LIaCos027422
	for <linux-scsi@vger.kernel.org>; Tue, 21 Oct 2008 11:36:13 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11800

           Summary: building SES support fails w/ gcc-3.4.5
           Product: SCSI Drivers
           Version: 2.5
     KernelVersion: 2.6.27.1
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: bugzilla.kernel.org@beej.org


[beej@dell ~]$ cat /etc/redhat-release
CentOS release 4.3 (Final)
[beej@dell ~]$ rpm -qf `which gcc`
gcc-3.4.5-2
[beej@dell linux-2.6.27.1]$ diff .config .config.old
4c4
< # Tue Oct 21 14:07:00 2008
---
> # Thu Oct 16 17:54:42 2008
1006c1006
< # CONFIG_SCSI_ENCLOSURE is not set
---
> CONFIG_SCSI_ENCLOSURE=m

using .config.old,
[beej@dell linux-2.6.27.1]$ make
<snip>
Kernel: arch/x86/boot/bzImage is ready  (#2)
  Building modules, stage 2.
  MODPOST 668 modules
ERROR: "__you_cannot_kmalloc_that_much" [drivers/scsi/ses.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

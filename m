From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14037] New: missing Via VT8251 chipset driver missing in newer
 kernels
Date: Sat, 22 Aug 2009 06:14:56 GMT
Message-ID: <bug-14037-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:52523 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932419AbZHVGOy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Aug 2009 02:14:54 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n7M6EuwF024909
	for <linux-scsi@vger.kernel.org>; Sat, 22 Aug 2009 06:14:56 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14037

           Summary: missing Via VT8251 chipset driver missing in newer
                    kernels
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: >2.6.29.x
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: leonine999@hotmail.com
        Regression: No


Driver for VT8251 sata controllers is missing in kernel >2.6.29.x.

Earlier kernels versions used in Fedora Core 4,5,6 and the contemporary kernels
used in other distros were detecting it easily but the latest release no longer
detect it.

While manually compiling latest kernels in gentoo and fedora I found the
drivers to detect sata controllers were missing.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

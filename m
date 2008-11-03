From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11943] New: Boot fails at scsi0:MESH with hde: lost interrupt, AEC6260
Date: Sun,  2 Nov 2008 23:58:34 -0800 (PST)
Message-ID: <bug-11943-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754532AbYKCH6g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Nov 2008 02:58:36 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mA37wYt0004729
	for <linux-scsi@vger.kernel.org>; Sun, 2 Nov 2008 23:58:35 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11943

           Summary: Boot fails at scsi0:MESH with hde: lost interrupt,
                    AEC6260
           Product: IO/Storage
           Version: 2.5
     KernelVersion: 2.6.25.2.3
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: eshaffer1@mac.com


Latest working kernel version: none
Earliest failing kernel version: 2.6.24-19
Distribution: Ubuntu
Hardware Environment: PowerMac B&W G3(rev.1) upgraded to G4 600 mHz cpu,
AEC6260 (ide-pci card)
Software Environment: Ubuntu Intrepid
Problem Description: Install successful from Live CD (Hardy) and Alternate CD
(Hardy / Intrepid). Boot proceeds normally until:
scsi0:MESH 
hde: max request size: 128KiB
boot hangs with repeated lost interrupt, DMA recovery messages. Boot cannot
proceed beyond this point. 


Steps to reproduce:


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

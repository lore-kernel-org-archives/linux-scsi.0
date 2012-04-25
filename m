From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43164] New: FC card not detected/mounted via external multicard
 reader
Date: Wed, 25 Apr 2012 19:48:10 GMT
Message-ID: <bug-43164-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:59046 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab2DYTsL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Apr 2012 15:48:11 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q3PJmAZU024147
	for <linux-scsi@vger.kernel.org>; Wed, 25 Apr 2012 19:48:10 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=43164

           Summary: FC card not detected/mounted via external multicard
                    reader
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 3.0.0-17-generic
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: damjan.zemljic@gmail.com
        Regression: No


Hi,
trying to mount compact flash card via external multicard reader gives
different results on different ports, but it fails in all cases to detect and
mount the card.

If reader is attached directly to the laptop (Thinkpad W510) to the ports on
the left side of it, the reader is recognized, but not CF card insterted
afterwards (...xhci_hcd 0000:0f:00.0: xHCI xhci_drop_endpoint called with
disabled ep...)

In case reader is attached via ports on docking station, it fails to accept
even the reader itself (kernel loops trying to accept it: ... READ CAPACITY
failed ...)


Kernel version:
Linux version 3.0.0-17-generic (buildd@yellow) (gcc version 4.6.1
(Ubuntu/Linaro 4.6.1-9ubuntu3) ) #30-Ubuntu SMP Thu Mar 8 20:45:39 UTC 2012

No Oopses...

TIA,
Damjan

P.S.: it seems only one file can be attached at the bug report time. I expect
the rest can be uploaded afterwards.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

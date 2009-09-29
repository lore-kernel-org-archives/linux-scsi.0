From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14258] New: Memory leak in SCSI initialization
Date: Tue, 29 Sep 2009 21:56:12 GMT
Message-ID: <bug-14258-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:48178 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbZI2V4I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Sep 2009 17:56:08 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n8TLuCFb010717
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2009 21:56:12 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14258

           Summary: Memory leak in SCSI initialization
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 2.6.31
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: rjw@sisk.pl
            Blocks: 13615
        Regression: Yes


Subject    : [2.6.31] Memory leak in SCSI initialization?
Submitter  : Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Date       : 2009-09-22 4:18
References : http://marc.info/?l=linux-kernel&m=125359311312243&w=4
Handled-By : Michael Ellerman <michael@ellerman.id.au>
Patch      : http://patchwork.kernel.org/patch/49258/

This entry is being used for tracking a regression from 2.6.30.  Please don't
close it until the problem is fixed in the mainline.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

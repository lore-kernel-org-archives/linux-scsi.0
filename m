From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14136] New: readcd Oops
Date: Sun, 6 Sep 2009 19:19:34 GMT
Message-ID: <bug-14136-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:32780 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbZIJWRP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Sep 2009 18:17:15 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n8AMFKpK021183
	for <linux-scsi@vger.kernel.org>; Thu, 10 Sep 2009 22:17:18 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14136

           Summary: readcd Oops
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 2.6.31-rc8
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


Subject    : [BUG] 2.6.31-rc8 readcd Oops
Submitter  : Bob Tracy <rct@gherkin.frus.com>
Date       : 2009-09-03 3:39
References : http://marc.info/?l=linux-kernel&m=125195043617418&w=4
Handled-By : Michal Schmidt <mschmidt@redhat.com>
Patch      : http://patchwork.kernel.org/patch/45347/

This entry is being used for tracking a regression from 2.6.30.  Please don't
close it until the problem is fixed in the mainline.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

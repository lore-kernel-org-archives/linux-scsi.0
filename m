From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15563] New: SCSI Generic timeout is NOOP
Date: Wed, 17 Mar 2010 22:18:27 GMT
Message-ID: <bug-15563-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:37557 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab0CQWSa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2010 18:18:30 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2HMIR5R015265
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2010 22:18:28 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15563

           Summary: SCSI Generic timeout is NOOP
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 2.6.18-2.6.32
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: mh-linux-kernel@loup.net
        Regression: No


When sg_io_hdr.timeout is set to say 20000 ms, READ_10 and WRITE_10 commands
succeed after 30 or even 40 seconds without an error.  SCSI Generic HOWTO
documents timeout as an actual limit to how long the command has to run.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

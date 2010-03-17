From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15564] New: SCSI Generic queueing of insufficient dxferlen for
 command can succeed
Date: Wed, 17 Mar 2010 22:24:28 GMT
Message-ID: <bug-15564-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:33332 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122Ab0CQWYa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2010 18:24:30 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2HMOSEV016678
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2010 22:24:29 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15564

           Summary: SCSI Generic queueing of insufficient dxferlen for
                    command can succeed
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


If dxferlen is less than the READ_10 data transferlen, the SCSI
command sometimes reports success when it shouldn't succeed.  This
is corruption and makes debugging very difficult; don't ask me
how I know :-)

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

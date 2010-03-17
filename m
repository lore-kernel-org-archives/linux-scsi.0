From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15566] New: SCSI Generic queueing info result never indicates
 direct data transfer?
Date: Wed, 17 Mar 2010 22:39:30 GMT
Message-ID: <bug-15566-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:51001 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172Ab0CQWjb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2010 18:39:31 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2HMdUun020313
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2010 22:39:30 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15566

           Summary: SCSI Generic queueing info result never indicates
                    direct data transfer?
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


The sg info result never returns a nonzero result despite
SG_FLAG_DIRECT_IO flag and aligned READ_10 and WRITE_10 data buffer.
Is direct io occuring as requested?  If not, why not?  If so, why
doesn't the info value behave as documented in the HOWTO?

I've run both over usb (which I can understand why not direct) and
to SATA drives that normally work fine with O_DIRECT read/write.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

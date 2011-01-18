From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 26992] New: iscsi session re-establishment by client does not
 work (auth method rejected by target)
Date: Tue, 18 Jan 2011 00:12:00 GMT
Message-ID: <bug-26992-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:56470 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab1ARAMB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Jan 2011 19:12:01 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p0I0C0nW012050
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 18 Jan 2011 00:12:00 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=26992

           Summary: iscsi session re-establishment by client does not work
                    (auth method rejected by target)
           Product: IO/Storage
           Version: 2.5
    Kernel Version: >=2.6.33
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: bugzilla-kernel-org-sux2k0@mstier.de
                CC: bugzilla-kernel-org-sux2k0@mstier.de
        Regression: No


Latest client kernel version known to work: 2.6.32.27 (vanilla)
First client kernel version known NOT to work: 2.6.33 (vanilla)

I'm doing sanboot via iSCSI/TCP using gPXE 1.0.1 from etherboot.org. The gPXE
chain boot loader registers the iSCSI target lun as boot disk and when the
Ubuntu OS starts iscsid, session re-establishment fails when using kernel
2.6.33 or higher on the client (session startup configured as manual). Works
perfectly with 2.6.32.27 on the client.

The client machine uses open-iscsi v2.0-871 (Ubuntu 10.04/Lucid).

Tested against:
iscsi-target v1.4.20.2
and
stgt v1.0.12
(running on kernel 2.6.35.8)

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

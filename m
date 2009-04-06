From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13022] New: comparison of distinct pointer types lacks a cast
Date: Mon, 6 Apr 2009 09:03:27 GMT
Message-ID: <bug-13022-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:45228 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101AbZDFJD3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Apr 2009 05:03:29 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n3693RX1015356
	for <linux-scsi@vger.kernel.org>; Mon, 6 Apr 2009 09:03:27 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=3D13022

           Summary: comparison of distinct pointer types lacks a cast
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.29.1
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: blubaustin@gmail.com
        Regression: No


Compiling kernel, and this error message appears:
CC [M]  drivers/scsi/lpfc/lpfc_scsi.o
drivers/scsi/lpfc/lpfc_scsi.c: In function =E2=80=98lpfc_parse_bg_err=E2=
=80=99:
drivers/scsi/lpfc/lpfc_scsi.c:1397: warning: comparison of distinct poi=
nter
types lacks a cast
drivers/scsi/lpfc/lpfc_scsi.c:1397: warning: right shift count >=3D wid=
th of type
drivers/scsi/lpfc/lpfc_scsi.c:1397: warning: passing argument 1 of =E2=80=
=98__div64_32=E2=80=99
from incompatible pointer type

Still compiles kernel ok.

--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 35682] New: killing requests for dead queue
Date: Mon, 23 May 2011 10:34:04 GMT
Message-ID: <bug-35682-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:40006 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793Ab1EWKeG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 May 2011 06:34:06 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p4NAY41G026860
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 23 May 2011 10:34:04 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=35682

           Summary: killing requests for dead queue
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 2.6.39
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: zb@jabster.pl
        Regression: No


When yesterday booted newly compiled 2.6.39 kernel up - directly after the
compilation - there wasn't anything bad. But today in the morning system was
unable to complete boot-up, staying at the message: "sde: 
killing requests for dead queue".

Maybe new kernel doesn't like my USB card reader? "cat /proc/scsi/scsi" shows:

Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: STM3320418AS     Rev: CC38
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: HL-DT-ST Model: DVD-RAM GH22LS30 Rev: 1.01
  Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 00
  Vendor: Generic  Model: USB SD Reader    Rev: 1.00
  Type:   Direct-Access                    ANSI  SCSI revision: 00
Host: scsi4 Channel: 00 Id: 00 Lun: 01
  Vendor: Generic  Model: USB CF Reader    Rev: 1.01
  Type:   Direct-Access                    ANSI  SCSI revision: 00
Host: scsi4 Channel: 00 Id: 00 Lun: 02
  Vendor: Generic  Model: USB SM Reader    Rev: 1.02
  Type:   Direct-Access                    ANSI  SCSI revision: 00
Host: scsi4 Channel: 00 Id: 00 Lun: 03
  Vendor: Generic  Model: USB MS Reader    Rev: 1.03
  Type:   Direct-Access                    ANSI  SCSI revision: 00

No memory cards neither USB sticks were inserted during boot-up.

It seems, that issue discussed in the thread, which I've found at:

https://lkml.org/lkml/2011/4/11/175

...still hasn't been resolved. Well, at least not completely.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

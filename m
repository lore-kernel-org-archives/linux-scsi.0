From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14579] New: Devices disappear; on bus reset machine hangs; on
 I/O machine hangs
Date: Tue, 10 Nov 2009 15:28:24 GMT
Message-ID: <bug-14579-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:50468 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbZKJP2S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2009 10:28:18 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAAFSOdQ004749
	for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2009 15:28:24 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14579

           Summary: Devices disappear; on bus reset machine hangs; on I/O
                    machine hangs
           Product: IO/Storage
           Version: 2.5
    Kernel Version: Linux version 2.6.30-1-amd64 (Debian
                    2.6.30-5+techfaklenny1)
                    (sfrey@TechFak.Uni-Bielefeld.DE) (gcc version 4.3.2
                    (Debian 4.3.2-1.1) ) #1 SMP Sat Aug 15 11:20:08 UTC
                    2009
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: sfrey@techfak.uni-bielefeld.de
        Regression: No


Created an attachment (id=23729)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=23729)
lspci -vvv output

On our soon-to-be primary backup machine with an Adaptec 52445 (for the disk
pool) and an LSI Logic / Symbios Logic SAS1068E PCI-Express Fusion-MPT SAS (for
the Tape Library), we see random failures:
On Tape-IO (using btape from bacula), a few minutes into the writes, the
changer device and both tape devices disappear from the system. Rescanning the
bus sometimes helps, but sometimes results in a hardy freeze.

On Tape-IO, a few minutes into the writes, the system freezes.

lspci -vvv, lsscsi and dmesg and /proc/modules are attached, this might also be
related to #14577 as it's the same machine. Attached is also a screenshot of
the oops we saw on the last crash that happened durign a btape run.

The system uses stock Debian/Lenny with a custom built 2.6.30.5 kernel.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.

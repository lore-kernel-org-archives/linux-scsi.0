From: "Patrick J. LoPresti" <patl@users.sourceforge.net>
Subject: Success with new Megaraid driver
Date: 25 Aug 2004 16:44:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <s5gn00jge8h.fsf@patl=users.sf.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ext.curl.com ([66.228.88.132]:26887 "HELO
	mail-ext.curl.com") by vger.kernel.org with SMTP id S268675AbUHYUoo
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Aug 2004 16:44:44 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Mukker, Atul" <Atulm@lsil.com>

My group has been stress-testing the 2.6 kernel on a Dell PowerEdge
650 with a PERC 4/SC RAID card.  It has two drives configured as RAID
1 in a single logical drive.  Our stress test consists of several
clients hammering our revision control system (Perforce) in parallel.

Using the vanilla 2.6.8.1 kernel and megaraid driver, we can
consistently make the machine fall over within 12 hours.  Here "fall
over" means getting some kind of I/O error and then having the logical
drive enter read-only mode.

The hardware passes Dell's diagnostics.  But it also works fine under
moderate I/O load, so perhaps that does not mean much.

After applying the megaraid-2.20.3.0 patch and using the megaraid_mbox
driver, however, everything looks much better.  Our stress test now
has been running for 72 hours without issue.  As far as we are
concerned, the sooner the new driver hits mainline, the better :-).

Just a data point from a random user.  And a "thank you" to the LSI
folks!

 - Pat

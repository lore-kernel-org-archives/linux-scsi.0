From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Can someone explain "Data Phase Error"
Date: Fri, 17 Dec 2004 16:23:24 -0500
Message-ID: <87f94c3704121713233f8499d8@mail.gmail.com>
Reply-To: Greg Freemyer <greg.freemyer@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.197]:29606 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262132AbULQVXZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Dec 2004 16:23:25 -0500
Received: by wproxy.gmail.com with SMTP id 36so131891wra
        for <linux-scsi@vger.kernel.org>; Fri, 17 Dec 2004 13:23:24 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

All,

Environment:
kernel - 2.6.8-24  (from SUSE 9.2)
tape drive - IBM LTO-1 (scsi-wide)
scsi controller - Adaptec 2940

Issue:
I am trying to build a pair of new Linux based tape servers.

I have written exactly one tape on each, I then swapped the tapes
beween the units and tried to do a restore.  One seems to be working
fine on this first test, but with the other I get:

Dec 17 08:52:04 linux kernel: st0: Error with sense data: Info
fld=0x40000, ILI Current st0: sense = f0 2b
Dec 17 08:52:04 linux kernel: Additional sense: Data phase error

I would suspect a bad tape, but a simple "dd if=/dev/st0 of=/dev/null
bs=256k" fails at a different number of blocks each time.

i.e. I have 130 GB of data on the tape, but I have not yet read back
more than 6 GB of it.  The data itself is unimportant, I'm just
testing the process.

I am continueing to test and am now trying another tape, but I want to
understand this initial failure if I can.

Thanks for any help.
Greg
-- 
Greg Freemyer

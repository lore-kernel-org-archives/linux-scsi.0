From: "Ross Macintyre" <raz@macs.hw.ac.uk>
Subject: Interpreting errors in /var/log/megaserv.log and using megamgr
Date: Tue, 16 Mar 2004 12:28:58 -0000 (GMT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4417.137.195.14.4.1079440138.squirrel@www.macs.hw.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from izanami.macs.hw.ac.uk ([137.195.13.6]:7917 "EHLO
	izanami.macs.hw.ac.uk") by vger.kernel.org with ESMTP
	id S261194AbUCPM3G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Mar 2004 07:29:06 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, support@lsil.com
Cc: cos@macs.hw.ac.uk, ian@eclipsecomputing.co.uk

I have 2 machines with LSILogic MegaRAID 320-1 cards, each with 4
disks running RAID 5. They both run RedHat 8.0 and LSILogic's
software MegaServ.
I have the LSI 1L26 firmware revisions applied and they seem to work
fine.

I am a bit confused though in how to interpret the messages in
/var/log/megaserv.log and also the information that is shown when
you look at disk info when running megamgr.


In particular I see this in /var/log/megaserv.log:
  Adapter 1 Channel 1 Target 0:  Media Error Count=0, Other Error Count=1

I take it this is the same error that I see when I run 'megamgr' and
choose Configure/View_Add Configuration/F2(Drv.Info):
   Media Errors 0                Other Errors 1

What I am wondering is, is this 'Other error' anything to worry
about? You see, there was a hardware error on this disk(Target 0) a
while back but this was fixed by changing the disk and rebuilding.
I now notice that each time the machine has been rebooted, and
MegaServ runs that this message is put in the log:
  Adapter 1 Channel 1 Target 0:  Media Error Count=0, Other Error Count=1
(there are many occurences of this)

So is this 'Other Errors 1' that I see in megamgr, just a count of
all previous errors, and is this the same as the 'Other Error Count=1'
in the log, and is it anything to worry about?
For example, if I were to have another hardware error on Target 0 would
this be incremented to 2?

Thanks in advance for any help with this.

Ross

-- 
Ross Macintyre (raz@macs.hw.ac.uk)

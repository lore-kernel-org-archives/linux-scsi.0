From: "Michael W. Shaffer" <mwshaffer@yahoo.com>
Subject: No volumes detected by cciss driver
Date: Fri, 6 Feb 2004 15:24:19 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040206232419.42563.qmail@web10402.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web10402.mail.yahoo.com ([216.136.130.94]:65464 "HELO
	web10402.mail.yahoo.com") by vger.kernel.org with SMTP
	id S265598AbUBFXYU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2004 18:24:20 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have a brand new Compaq DL380 G3 system which I am trying
to install Debian Linux on, with little success. The system
has a SmartArray 6400 RAID controller onboard, with six
physical disk drives, configured into two RAID volumes in
the RAID array BIOS.

When I boot the system from the Debian CD, choosing the
bf24 kernel, I see only one line of output from the
cciss driver, just saying "device detected at 0x...".
No further messages are printed, and no disk devices of
any sort appear to be available to the installation
system. I am aware that the devices files would be in
the directory /dev/cciss, and there are device nodes
in there, but none of them are useable.

I can't see anything to indicate that my hardware should
not be supported by a recent 2.4 kernel, at least from
looking at the files in the kernel Documentation directory
on some recent 2.4 and 2.6 kernels.

Any clue how I can further troubleshoot this to find out
why the device is detected but no volumes are enumerated?
Any prediction on specific kernel versions known to work
on recent Compaq DL380 hardware with this controller?

Thanks in advance for any help.


__________________________________
Do you Yahoo!?
Yahoo! Finance: Get your refund fast by filing online.
http://taxes.yahoo.com/filing.html

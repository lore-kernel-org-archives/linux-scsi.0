From: "Michael W. Shaffer" <mwshaffer@yahoo.com>
Subject: Re: No volumes detected by cciss driver
Date: Fri, 6 Feb 2004 16:56:46 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040207005646.2433.qmail@web10406.mail.yahoo.com>
References: <20040206232419.42563.qmail@web10402.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web10406.mail.yahoo.com ([216.136.130.98]:4613 "HELO
	web10406.mail.yahoo.com") by vger.kernel.org with SMTP
	id S265662AbUBGA4r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2004 19:56:47 -0500
In-Reply-To: <20040206232419.42563.qmail@web10402.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

> When I boot the system from the Debian CD, choosing the
> bf24 kernel, I see only one line of output from the
> cciss driver, just saying "device detected at 0x...".
> No further messages are printed, and no disk devices of
> any sort appear to be available to the installation
> system. I am aware that the devices files would be in
> the directory /dev/cciss, and there are device nodes
> in there, but none of them are useable.

Some clarification on this:

Upon closer inspection, it appears that the controller which
is detected is the onboard or integrated SmartArray 5i, which
does not in fact have any disks connected to it, making the
failure to detect any disk volumes less than surprising. Also,
the exact kernel version is 2.4.18. The information in the
/proc/driver/cciss/cciss0 file confirms the model and details
of the integrated card which is detected.

So, the real question is if anyone can help me figure why
the SmartArray 6400 controller is not detected at all by
the kernel, or if there is some minimum version of the 2.4
kernel which I need to be running in order to use this
controller. Looking at the Documentation/cciss.txt file in
the kernel source for 2.4.21, it explicitly mentions the
SmartArray 6400 as supported, but I don't have the 2.4.18
source around anywhere to check that specific version.


__________________________________
Do you Yahoo!?
Yahoo! Finance: Get your refund fast by filing online.
http://taxes.yahoo.com/filing.html

From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [RFC] scsi host sysfs support [0/4]
Date: Mon, 14 Apr 2003 16:47:31 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030414234731.GB5584@beaverton.ibm.com>
References: <20030414183759.GA4162@beaverton.ibm.com> <Pine.LNX.4.44.0304141600070.15980-100000@cherise>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:48092 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S263947AbTDNXdt (for <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Apr 2003 19:33:49 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0304141600070.15980-100000@cherise>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mochel <mochel@osdl.org>
Cc: linux-scsi@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net, mdharm-scsi@one-eyed-alien.net

Patrick Mochel [mochel@osdl.org] wrote:
> Then you need to fix the code, or do some work to fix up the class 
> support. You have no right to promote scsi to a top-level subsystem, and I 
> will not support. I'll not even read the rest of the patches. 
> 

To fix the LLDDs would force drivers that have a parent bus not converted
to the driver model to take on a excessive amount of code to show up as a
class (properly).

I also believed the "pseudo" driver I had to create to use classes was a
abuse of the interface. I will look into the changes happening with
classes.

> I realize that block and net are top-level subsystems. They are there for 
> two reasons - 1) they _are_ that important, and 2) they're temporary steps 
> to them being converted to classes. 
> 

Where are the attributes written down for evaluating important vs not
important subsystems.

> I realize that you think SCSI is just as important as block devices or net 
> devices, but it's just not true for most systems, and I will not open the 
> flood gates for you to abuse even more interfaces.

What interfaces am I abusing. I have used api's documented by you.

-andmike
--
Michael Anderson
andmike@us.ibm.com


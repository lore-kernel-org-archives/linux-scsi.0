From: Patrick Mochel <mochel@osdl.org>
Subject: Re: [RFC] scsi host sysfs support [0/4]
Date: Mon, 14 Apr 2003 16:48:10 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0304141645210.15980-100000@cherise>
References: <20030414234731.GB5584@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from air-2.osdl.org ([65.172.181.6]:11189 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S263967AbTDNXiV (for <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Apr 2003 19:38:21 -0400
In-Reply-To: <20030414234731.GB5584@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net, mdharm-scsi@one-eyed-alien.net


On Mon, 14 Apr 2003, Mike Anderson wrote:

> Patrick Mochel [mochel@osdl.org] wrote:
> > Then you need to fix the code, or do some work to fix up the class 
> > support. You have no right to promote scsi to a top-level subsystem, and I 
> > will not support. I'll not even read the rest of the patches. 
> > 
> 
> To fix the LLDDs would force drivers that have a parent bus not converted
> to the driver model to take on a excessive amount of code to show up as a
> class (properly).

Then convert them to the driver model. 

> > I realize that block and net are top-level subsystems. They are there for 
> > two reasons - 1) they _are_ that important, and 2) they're temporary steps 
> > to them being converted to classes. 
> > 
> 
> Where are the attributes written down for evaluating important vs not
> important subsystems.

They're not - they're completely subjective, and I reserve the right to 
reserve that right. Basically, only subsystems that are always present 
should be in the top-level directory. 

Sure, networking may not always be present, but that case is rare, and as 
I said before, it's on its way to becoming a device class. 

But, taking a step back, is SCSI a bus type? Yes, then it should go under 
bus/scsi/. You can implement an object under there, just as you would 
under scsi/ 

> > I realize that you think SCSI is just as important as block devices or net 
> > devices, but it's just not true for most systems, and I will not open the 
> > flood gates for you to abuse even more interfaces.
> 
> What interfaces am I abusing. I have used api's documented by you.

Hopefully none ATM, though that doesn't count the code I've seen in the 
past.


	-pat


From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [RFC] scsi host sysfs support [0/4]
Date: Mon, 14 Apr 2003 17:25:02 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030415002502.GA7727@beaverton.ibm.com>
References: <20030414234731.GB5584@beaverton.ibm.com> <Pine.LNX.4.44.0304141645210.15980-100000@cherise>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:3463 "EHLO e34.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S264005AbTDOALR (for <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Apr 2003 20:11:17 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0304141645210.15980-100000@cherise>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mochel <mochel@osdl.org>
Cc: linux-scsi@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net, mdharm-scsi@one-eyed-alien.net

Patrick Mochel [mochel@osdl.org] wrote:
> > To fix the LLDDs would force drivers that have a parent bus not converted
> > to the driver model to take on a excessive amount of code to show up as a
> > class (properly).
> 
> Then convert them to the driver model. 
> 

In past evaluations this looked like a large task, and was not a
requirement for getting the ref counting / release capabilities we
needed. Even though you did not like where the kobject was rooted the
parent / child and release functionality appears to be working.

> But, taking a step back, is SCSI a bus type? Yes, then it should go under 
> bus/scsi/. You can implement an object under there, just as you would 
> under scsi/ 
> 

Ok I could root scsi_host under /bus/scsi. 

-andmike
--
Michael Anderson
andmike@us.ibm.com


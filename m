From: Andre Hedrick <andre@linux-ide.org>
Subject: Re: Support for CDB length > 16
Date: Tue, 18 Nov 2003 03:21:18 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.10.10311180320290.594-100000@master.linux-ide.org>
References: <3FB9E777.6020404@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from astound-64-85-224-253.ca.astound.net ([64.85.224.253]:22534
	"EHLO master.linux-ide.org") by vger.kernel.org with ESMTP
	id S262564AbTKRLWx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Nov 2003 06:22:53 -0500
In-Reply-To: <3FB9E777.6020404@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Liran Schour <LIRANS@il.ibm.com>, linux-scsi@vger.kernel.org


I suspect this is midlayer injection for SAS.

Andre Hedrick
LAD Storage Consulting Group

On Tue, 18 Nov 2003, Douglas Gilbert wrote:

> Liran Schour wrote:
> > 
> > I need a support from the Linux SCSI subsystem for CDB length > 16 byte.
> > Is it possible to do that without recompiling the kernel with a new
> > MAX_COMMAND_SIZE definition. 
> 
> It is hard to imagine any other way at the moment (definitely
> in lk 2.4 and it is probably a bit late for lk 2.6).
> 
> Is there an upper limit on the size of the cdb you are interested in
> (e.g. XDWRITE EXTENDED in SBC-2 is 64 bytes)?
> 
> How were you planning to pass the cdb (length > 16) to the kernel?
> 
> Doug Gilbert
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Requested changes for the SCSI error handler
Date: Sat, 5 Jun 2004 18:41:35 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0406051840070.6444-100000@netrider.rowland.org>
References: <20040604232344.GA3214@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:5645 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S262238AbUFEWlg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 5 Jun 2004 18:41:36 -0400
In-Reply-To: <20040604232344.GA3214@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 4 Jun 2004, Mike Anderson wrote:

> Alan Stern [stern@rowland.harvard.edu] wrote:
> > 
> > How does this look?
> > 
> 
> Looks ok. I know your patch is in line with James requests, but I had a
> counter idea that allows for setting the settle delays up, down, or to
> zero post scsi_host_alloc. If the LLDD does nothing behavior should not
> change. This would allow increasing settle if some LLDD wanted it and
> also set it through sysfs if we wanted that in the future.  You can
> throw this patch in the bit bucket if you want to go the previously
> stated direction.

Either approach is fine with me.  James?

Alan Stern


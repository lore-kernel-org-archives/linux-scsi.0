From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: PATCH: Stop megaraid trashing other i960 based devices
Date: Sat, 22 May 2004 12:07:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040522170706.GA27386@lists.us.dell.com>
References: <20040522154659.GA17320@devserv.devel.redhat.com> <20040522160205.GA8643@infradead.org> <20040522160328.GA22256@devserv.devel.redhat.com> <20040522160718.GA8736@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from linux.us.dell.com ([143.166.224.162]:206 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S261673AbUEVRId
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 May 2004 13:08:33 -0400
Content-Disposition: inline
In-Reply-To: <20040522160718.GA8736@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org, Alan Cox <alan@redhat.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, akpm@osdl.org

On Sat, May 22, 2004 at 12:07:18PM -0400, hch@infradead.org wrote:
> On Sat, May 22, 2004 at 12:03:28PM -0400, Alan Cox wrote:
> > Most of the megaraids don't have subvendor ids... so that doesn't work at
> > all.
> 
> Okay.  In that case we should apply the patch and shoot some megraid
> hardware engineer.

Now, I love a good megaraid bashing as much as the next guy.  Just ask
Peter Jarrett and Atul Mukker.  But in this case I have to side with
them.  The cards w/o subsystem IDs all predate the existance of
subsystem IDs in the PCI spec, and I'm pretty sure the IDs in the i960
of that vintage are hard-coded so AMI couldn't have changed them if
they wanted to.  So their magic words were the equivalent of what we
now do with subsystem IDs.  It's only the older cards that have a
problem, AFAIK.

Thanks,
Matt

-- 
Matt Domsch
Sr. Software Engineer, Lead Engineer
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com

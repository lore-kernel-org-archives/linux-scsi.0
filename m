From: hch@infradead.org
Subject: Re: PATCH: Stop megaraid trashing other i960 based devices
Date: Sat, 22 May 2004 13:11:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040522171140.GA9714@infradead.org>
References: <20040522154659.GA17320@devserv.devel.redhat.com> <20040522160205.GA8643@infradead.org> <20040522160328.GA22256@devserv.devel.redhat.com> <20040522160718.GA8736@infradead.org> <20040522170706.GA27386@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canuck.infradead.org ([205.233.217.7]:10762 "EHLO
	canuck.infradead.org") by vger.kernel.org with ESMTP
	id S261682AbUEVRLn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 May 2004 13:11:43 -0400
Content-Disposition: inline
In-Reply-To: <20040522170706.GA27386@lists.us.dell.com>
List-Id: linux-scsi@vger.kernel.org
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: Alan Cox <alan@redhat.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, akpm@osdl.org

On Sat, May 22, 2004 at 12:07:06PM -0500, Matt Domsch wrote:
> Now, I love a good megaraid bashing as much as the next guy.  Just ask
> Peter Jarrett and Atul Mukker.  But in this case I have to side with
> them.  The cards w/o subsystem IDs all predate the existance of
> subsystem IDs in the PCI spec, and I'm pretty sure the IDs in the i960
> of that vintage are hard-coded so AMI couldn't have changed them if
> they wanted to.  So their magic words were the equivalent of what we
> now do with subsystem IDs.  It's only the older cards that have a
> problem, AFAIK.

Okay, so let's shoot an i960 engineer instead.  Intel bashing is even
more fun anyway ;-)


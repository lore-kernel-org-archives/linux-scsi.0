From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [BUG] Unable to handle kernel NULL pointer dereference...as_move_to_dispatch+0x11/0x135
Date: Fri, 2 Feb 2007 20:30:24 -0800
Message-ID: <20070203043024.GC11332@plap2.qlogic.org>
References: <20070122183510.GA19905@andrew-vasquezs-computer.local> <20070201232302.905962b6.akpm@linux-foundation.org> <20070202205630.GI3737@andrew-vasquezs-computer.local> <20070202162541.20e1e930.akpm@linux-foundation.org> <20070202171810.5f089b38.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:55313 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946315AbXBCEa3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Feb 2007 23:30:29 -0500
Content-Disposition: inline
In-Reply-To: <20070202171810.5f089b38.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Nigel Kirkland <nigel.kirkland@qlogic.com>

On Fri, 02 Feb 2007, Randy Dunlap wrote:

> On Fri, 2 Feb 2007 16:25:41 -0800 Andrew Morton wrote:
> 
> > On Fri, 2 Feb 2007 12:56:30 -0800
> > Andrew Vasquez <andrew.vasquez@qlogic.com> wrote:
> > 
> > > > >         dt of=/dev/raw/raw1 procs=8 oncerr=abort bs=16k disable=stats limit=2m passes=1000000 pattern=iot dlimit=2048
> > 
> > What is this mysterious dt command, btw?
> 
> I expect that it's the one here:
> http://www.scsifaq.org/RMiller_Tools/index.html

yep, that's the one.

From: Sonny Rao <sonny@burdell.org>
Subject: Re: lpfc driver in 2.6.13-rc6 broken on ppc64 ?
Date: Thu, 11 Aug 2005 17:17:14 -0400
Message-ID: <20050811211714.GA10312@kevlar.burdell.org>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C20F43C7@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 66-23-228-155.clients.speedfactory.net ([66.23.228.155]:29603
	"EHLO kevlar.burdell.org") by vger.kernel.org with ESMTP
	id S932489AbVHKVTE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Aug 2005 17:19:04 -0400
Content-Disposition: inline
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C20F43C7@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Aug 11, 2005 at 05:03:10PM -0400, James.Smart@Emulex.Com wrote:
> This signature is consistent with having out of date firmware on the adapter.
> 
> See http://www.emulex.com/ts/indexemu.html.  There are some hints on downloading firmware at the tail end of  http://sourceforge.net/forum/forum.php?thread_id=1130082&forum_id=355154. 
> 
> Thanks.

Ah ok, thanks.  An error message to this effect from the driver would
probably save your from having to answer these pesky emails and noise
on the mailing lists if it is possible to correctly detect this.

Thanks for your help and quick response

Sonny


> 
> > -----Original Message-----
> > From: Sonny Rao [mailto:sonny@burdell.org]
> > Sent: Thursday, August 11, 2005 4:00 PM
> > To: Smart, James
> > Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org
> > Subject: lpfc driver in 2.6.13-rc6 broken on ppc64 ?
> > 
> > 
> > Hi, I am having problems using some older Emulex fibre adapters on a
> > ppc64 machine, whenever I load the lpfc driver I get a large 
> > number of 
> > 
> > "lpfc 0001:d8:01.0: 1:0321 Unknown IOCB command Data: x0 x3 x0 x0"
> > 
> > with several hundred messages per adapter
> > 
> > and finally I get this message:
> > 
> > lpfc 0001:d8:01.0: 1:0222 Initial FLOGI timeout
> > lpfc 0001:d8:01.0: 1:0127 ELS timeout Data: x4000000 xfffffe x8a x23
> > 
> > 
> > Is this a known issue ?
> > 
> > Let me know if you need patches tested, thanks.
> > 
> > Sonny Rao
> > IBM LTC Performance
> > 
> > 
> > 

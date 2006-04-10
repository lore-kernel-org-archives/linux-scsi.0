From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] deinline some functions in aic7xxx drivers, save 80k
	of text
Date: Mon, 10 Apr 2006 18:20:40 +0200
Message-ID: <1144686041.2876.2.camel@laptopd505.fenrus.org>
References: <200604100844.12151.vda@ilport.com.ua>
	 <200604100903.35431.eike-kernel@sf-tec.de>
	 <200604101015.36869.vda@ilport.com.ua>
	 <200604100919.23244.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [4.79.56.4] ([4.79.56.4]:16014 "EHLO localhost.localdomain")
	by vger.kernel.org with ESMTP id S932172AbWDJXc6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Apr 2006 19:32:58 -0400
In-Reply-To: <200604100919.23244.eike-kernel@sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Denis Vlasenko <vda@ilport.com.ua>, SCSI List <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org

On Mon, 2006-04-10 at 09:19 +0200, Rolf Eike Beer wrote:
> [Full quote and readded CC adresses. My fault, pressed wrong button]
> 
> Denis Vlasenko wrote:
> > On Monday 10 April 2006 10:03, Rolf Eike Beer wrote:
> > > Am Montag, 10. April 2006 07:49 schrieben Sie:
> > > > On Monday 10 April 2006 08:44, Denis Vlasenko wrote:
> > > > > I also spotted two bugs in the process, patches
> > > > > for those will follow.
> > > >
> > > > ahd_delay(usec) is buggy. Just think how would it work
> > > > with usec == 1024*100 + 1...
> > >
> > > This is unneeded. The biggest argument this function is ever called with
> > > is 1000.
> >
> > I know.
> >
> > > I would suggest to delete this function completely. If one ever has to
> > > wait for a longer period mdelay() is the right function to call.
> >
> > I am leaving it up to maintainer to decide. After all, the driver
> > is for multiple OSes, other OS may lack mdelay().


actually this driver isn't shared anymore with other oses so it's ok to
remove (buggy) abstractions


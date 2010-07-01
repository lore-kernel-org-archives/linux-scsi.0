From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [Lsf10-pc] [ATTEND] Want to attend LSF 2010
Date: Thu, 1 Jul 2010 14:40:43 -0400
Message-ID: <20100701184043.GK3039@think>
References: <20100701180430.GD2705@redhat.com>
 <4C2CD9FE.8060707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:20074 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757884Ab0GASmE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jul 2010 14:42:04 -0400
Content-Disposition: inline
In-Reply-To: <4C2CD9FE.8060707@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, James Bottomley <James.Bottomley@suse.de>, lsf10-pc@lists.linuxfoundation.org, linux-scsi@vger.kernel.org

On Thu, Jul 01, 2010 at 02:10:06PM -0400, Ric Wheeler wrote:
> On 07/01/2010 02:04 PM, Vivek Goyal wrote:
> > Resending this mail. This time also CCing linux-scsi mailing list. Sorry
> > for the duplicate copy.
> >
> > Hi,
> >
> > I wanted to attend LSF 2010. Sepcifically I was interested in discussing
> > couple of things.
> >
> > - CFQ performance issues on higher end storage
> >          - Deadline outperforms CFQ on higher end storage (storage arrays
> >            and also on host based hardware RAID). I was wondering if there
> >            is a way to fix it or it is just design limitation. In the past
> >            Jens had mentioned that he wants to get rid of deadline also and
> >            be replaced with CFQ. Are we still targeting that and if yes,
> >            how to achieve that (some kind of auto tuning).
> >
> > - Max bandwidth IO controller
> >          - A basic proportional weight controller (blkio) based off CFQ is
> >            now in. Now there is also a need to implement throttling/max
> >            bandwidth controller. Wanted to get some ideas on how to go
> >            go about it and what is the best place to impement it. Implement
> >            it in CFQ or a new device mapper target or something else.
> >
> > Thanks
> > Vivek
> >
> 
> Thanks Vivek,
> 
> I know that this IO scheduling issue has been a hot issue for us in our 
> performance testing. We would love to figure out how to get CFQ to displace 
> deadline totally and definitely it would be very interesting to have a 
> conversation around what needs done/what can be done.
> 

I'll second that...one scheduler to rule them all.

-chris


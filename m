From: Andrew Schulman <andrex@alumni.utexas.net>
Subject: Re: dc395x: can't write to tape
Date: Wed, 26 Jan 2005 20:13:20 -0500
Message-ID: <200501262013.20664.andrex@alumni.utexas.net>
References: <200501060518.25782.andrex@alumni.utexas.net> <20050109125116.GA6293@twibble.org> <Pine.LNX.4.60.0501222356400.5769@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sccrmhc11.comcast.net ([204.127.202.55]:25991 "EHLO
	sccrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S262484AbVA0BNh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Jan 2005 20:13:37 -0500
In-Reply-To: <Pine.LNX.4.60.0501222356400.5769@poirot.grange>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Jamie Lenehan <lenehan@twibble.org>, linux-scsi@vger.kernel.org

> > > I could try to improve the highmem situation / sg-handling. Or do you
> > > plan to do it, Jamie?
> >
> > It's on my list of things to do, but I doubt I'll have any time to do
> > anything about in the next few months. So if you have the time and
> > desire please go ahead! I'll can test any changes you make (with a
> > CD-R/W, tape-drive and HDD), although it may take me a week or two to
> > get around to it.
>
> Ok, less than 2 weeks and here comes the first attempt. It removes
> page_to_virt and maps sg lists dynamically. Please, review, test. Slightly
> tested here - without highmem.

Guennadi and Jamie, thanks for your help on this.  However, I'm afraid I have 
to bail out at this point.  My tape drive was the only reason I was keeping 
my old DC395UW controller going, and it has now gone bad.  So I've had to 
yank both the card and tape drive and install a different backup solution.  
So, I can't test any patches.

Good luck, and my highest regards to both of you for your continuing work on 
this project.  You are making one corner of Linux and open source software 
work.

Andrew.

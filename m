From: Andrew Schulman <andrex@alumni.utexas.net>
Subject: Re: dc395x: CD writer causes endless "sg_to_virt failed" loop
Date: Tue, 6 Apr 2004 12:06:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200404061206.08426.andrex@alumni.utexas.net>
References: <20040327161034.GA9963@twibble.org> <200404050120.56111.andrex@alumni.utexas.net> <20040406140123.GA9884@twibble.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sccrmhc11.comcast.net ([204.127.202.55]:30623 "EHLO
	sccrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S263871AbUDFQGr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Apr 2004 12:06:47 -0400
In-Reply-To: <20040406140123.GA9884@twibble.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Jamie Lenehan <lenehan@twibble.org>
Cc: linux-scsi@vger.kernel.org, dc395x@twibble.org

> > I'm now running kernel 2.6.5.  The good news is that my CD writer (HP
> > 9200i) works again.  The bad news is that I'm still getting e.g.
> >
> > Apr  5 00:46:50 helium kernel: dc395x: sg_update_list: sg_to_virt failed
> > Apr  5 00:47:21 helium last message repeated 576 times
> > Apr  5 00:48:22 helium last message repeated 974 times
> > Apr  5 00:49:23 helium last message repeated 979 times
> > Apr  5 00:50:24 helium last message repeated 971 times
> > Apr  5 00:51:25 helium last message repeated 970 times
> > Apr  5 00:52:26 helium last message repeated 974 times
> > Apr  5 00:52:40 helium last message repeated 228 times
> >
> > (result of burning a CD).  This isn't great, but it's tolerable and at
> > least the CD writer works again.
>
> Have you verified that the CD(s) were actually written correctly?
> That's the one thing I'd really be concerned about. If so then you
> can always just comment the message out of the source code for now.

Yes, I've used the CDs and they're fine.

> I'll look over that code again and see if I can see why it thinks it
> cannot find the address it's looking for (and if it matters).
>
> What would be helpful (if your bored!) would be to enable the
> debugging at the top of dc395x.c and do a very short run (half a
> dozen copies of the message is enough, no need for 10k of them ;) and
> then compress the logs and put them somewhere I can grab them (or
> e-mail them if < 5MB).

Okay, I'll do this when I have time.  A.

From: Michele Baldessari <michele-lists@pupazzo.org>
Subject: Re: 2.6.15-rc4 error messages with multiple qla2300 hba ports on fabric
Date: Fri, 2 Dec 2005 18:05:05 +0100
Message-ID: <20051202170505.GC4758@michele.pupazzo.org>
References: <B179AE41C1147041AA1121F44614F0B0012AD98D@AVEXCH02.qlogic.org> <43907957.70402@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mgrava.tizianodinca.com ([195.47.199.19]:62653 "EHLO
	mail2.rhx.it") by vger.kernel.org with ESMTP id S1750823AbVLBRFG
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Dec 2005 12:05:06 -0500
Content-Disposition: inline
In-Reply-To: <43907957.70402@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi@vger.kernel.org

* Michael Reed (mdr@sgi.com) wrote:
> > 
> > Sidenote:  I'm on the east-coast until hopefully tonight -- won't
> > have a chance to look at debugging this for a couple of days...
> > 
> >> I've been testing with the qla2300 driver with 2.6.14.3 and 2.6.15-rc4.
> >> I've observed two sets of error messages which are not present with
> >> 2.6.14.3.
> >>
> >> First, the qla2300 driver is generating soft lockups.
> > 
> > Have a backtrace?
> 
> In the previously attached dmesg file, extracted below.  Is the driver polling
> for mailbox interrupt?

Just adding a me too, the platform here is a dual P4-Xeon IBM
box (happens on both 2.6.14.x and 2.6.15rc1).

My report is here : http://lkml.org/lkml/mbox/2005/11/16/262

(Trace is quite the same as Michael's)

thanks,
Michele

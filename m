From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: sg utils sg_io -i 0x24 -y "12 00:00:00 24 00"
Date: 07 Nov 2003 10:17:30 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068225450.2286.159.camel@patrh9>
References: <1068165515.28505.29.camel@patrh9>
	 <1068222286.2286.50.camel@patrh9>  <1068224213.2286.115.camel@patrh9>
	 <1068224969.2286.142.camel@patrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:3001 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264494AbTKGRSA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Nov 2003 12:18:00 -0500
In-Reply-To: <1068224969.2286.142.camel@patrh9>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: patmans@us.ibm.com, linux-scsi@vger.kernel.org

> > > Perhaps we should be looking at 
> > > implementing camcontrol in Linux.
> > 
> > Implementing, yes.  Copying, no.
> > I have a series of arguments, ...

Or maybe not so very many.  Mostly, I find camcontrol disappointingly
large.  

> > > Unix Man Page For 8 camcontrol
> > > http://www.svbug.com/cgi-bin/man.cgi?comd=8+camcontrol
> 
> I think arg parsing is an issue.
> 
> I see the camcontrol man page includes such off-putting ...

Personally I think even my own plscsi/ is too large.  I'm hoping gccscsi
by contrast is small enough to demo kernel trouble (and proposed plug 'n
play patches).

For example, offline recently I thought I saw someone report that a
cdb-unexpectedly-short doesn't pass thru 2.6.0 to usb mass.  Seeing
plscsi say that doesn't tell us the kernel has an issue there: we have
to ask, and we cannot easily answer, does plscsi have an issue there.

I care most here about transparency: easily establishing more confidence
that I know what I asked the kernel than if I had written an ad hoc test
program

I figure I can achieve transparency by remembering reuse proves my
general test program free of the simple errors I might make in an ad hoc
test program, but I have to keep my general test program small enough to
let me easily read over, step thru, maybe even copy-paste-edit out, just
the lines of code that I need.

Pat LaVarre



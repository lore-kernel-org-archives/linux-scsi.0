From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] Re: [linux-usb-devel] [2.6-test] Bug in
	usb-storage or scsi?
Date: 11 Sep 2003 14:04:54 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1063310694.3347.1.camel@patehci2>
References: <3F5E434D.6080801@unixsol.org>
	 <Pine.LNX.4.44L0.0309101219190.905-100000@ida.rowland.org>
	 <20030910170227.C3367@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:24527 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261483AbTIKUD4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Sep 2003 16:03:56 -0400
In-Reply-To: <20030910170227.C3367@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: patmans@us.ibm.com
Cc: stern@rowland.harvard.edu, mdharm-usb@one-eyed-alien.net, usb-storage@one-eyed-alien.net, linux-scsi@vger.kernel.org


> http://marc.theaimsgroup.com/?t=104839042700001&r=1&w=2

Thanks, there I find 44 posts dated since 2003-03 with Subject's like:
"PATCH: exclude certain commands from emulated SCSI hosts".

By the way, Google yields a slightly different set of 44 posts:
http://groups.google.com/groups?threadm=linux.scsi.20030322193705.C17056%40one-eyed-alien.net

In both archives I think I see much sense:

> > From: Matthew Dharm <mdharm-usb () one-eyed-alien ! net> ...
> >
> > (a) don't ask for EVPD data, ...
> > (b) assume ... only 36-bytes of INQUIRY data, ...
> > (c) ... assume write-enabled for all disk-like media.
>
> From: Linus Torvalds <torvalds () transmeta ! com>
>
> suggest ... make the Linux SCSI layer
> ... use the sequences of commands that "that other OS" uses ...
> "don't use commands that haven't gotten much testing" ...

I haven't yet reviewed the rest.

Pat LaVarre




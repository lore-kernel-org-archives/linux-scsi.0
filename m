From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: [PATCH] Re: libata: BLKFLSBUF ioctl broken
Date: Mon, 25 Oct 2004 13:24:07 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF20EE6AFA.E4E1BF6A-ON88256F38.006F6CCF-88256F38.006FF7BE@us.ibm.com>
References: <200410221942.i9MJguMR017671@falcon30.maxeymade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:5762 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261281AbUJYUWP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Oct 2004 16:22:15 -0400
In-Reply-To: <200410221942.i9MJguMR017671@falcon30.maxeymade.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Maxey <dwm@maxeymade.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jens Axboe <axboe@suse.de>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, Mark Lord <lsml@rtr.ca>

>What about the case of "This is normally a valid command, but this
>particulat device is incapable of this particular subcommand"?
>
>Hypothetical instance: a disk drive that indicates it is not capable of 
>changing it's write cache setting?

I believe there is a fundamental difference between "A device of this kind 
can't do that" and "that doesn't make any sense for a device of this 
kind."  It's the difference between a request to boil the ocean and a 
request to boil Christmas.  ENOTTY is for the request to boil Christmas. 
If you look at the history (from when it just meant "hey, this isn't a 
terminal (tty)"), it's clear:  An ioctl to set the backspace character on 
a disk drive isn't impossible -- it's nonsensical.

--
Bryan Henderson                          IBM Almaden Research Center
San Jose CA                              Filesystems

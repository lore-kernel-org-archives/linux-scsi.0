From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [Question] Does the kernel ignore errors writng to disk?
Date: Fri, 29 Apr 2005 01:22:34 +0200
Message-ID: <58cb370e050428162221be7338@mail.gmail.com>
References: <20050427184022.GA16129@beardog.cca.cpqcorp.net>
	 <1114700283.24687.193.camel@localhost.localdomain>
Reply-To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.202]:59128 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262325AbVD1XWj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Apr 2005 19:22:39 -0400
Received: by wproxy.gmail.com with SMTP id 68so920753wra
        for <linux-scsi@vger.kernel.org>; Thu, 28 Apr 2005 16:22:34 -0700 (PDT)
In-Reply-To: <1114700283.24687.193.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: mike.miller@hp.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, brace@hp.com

On 4/28/05, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Mer, 2005-04-27 at 19:40, mike.miller@hp.com wrote:
> > It looks like the OS/filesystem (ext2/3 and reiserfs) does not wait for for a successful completion. Is this assumption correct?
> 
> Of course it doesn't. At 250 ops/second for a decent disk no OS waits
> for completions, all batch and asynchronously queue I/O. See man fsync
> and also O_DIRECT if you need specific "to disk" support. If you do that
> be aware that you must also turn write caching off on the IDE disk. I've
> repeatedly asked the "maintainer" of the IDE layer to do this
> automatically but gave up bothering long ago. Without that setting users

WTF is wrong with you Alan?

We agreed on this but it is you to do coding, if you want it,
not me (and there was never any patch from you).

It is not my (unpaid) job to fulfill any requirement you come up with.

BTW I was supposed to push git update today but I wasted this time 
on replying your complaints (didn't even bother with personal insults). 

> are playing with fire quite honestly.
> 
> The alternative with latest 2.6 stuff is to turn on Jens Axboe's barrier
> work which seems to give better performance on a drive new enough to
> have cache flush operations.

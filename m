From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] include/scsi/scsi.h replace u8 in 2.5.69
Date: Wed, 14 May 2003 14:14:55 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030514141455.A20912@infradead.org>
References: <3EC1E4AF.6040404@torque.net> <20030514090218.A7371@infradead.org> <3EC24043.6070109@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.mvhi.com ([195.224.96.167]:45841 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262195AbTENNCI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 May 2003 09:02:08 -0400
Content-Disposition: inline
In-Reply-To: <3EC24043.6070109@torque.net>; from dougg@torque.net on Wed, May 14, 2003 at 11:10:27PM +1000
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Wed, May 14, 2003 at 11:10:27PM +1000, Douglas Gilbert wrote:
> Christoph,
> That's naive. In some case glibc's headers and libraries
> (e.g. mknod) are an impediment to development.
> 
> If I add one define to ~linux/include/scsi/sg.h just
> how long do you think it takes for it to appear in
> /usr/include/scsi/sg.h?

As long as it takes you to send the same diff to Ullrich.

> It can take over a year in my experience.
> 
> Put another way, the sg.h header that applications use
> should match the sg driver in the kernel

What kernel?  I run everything from 2.2.2x + local hacks to latest
2.5 on one box.

> It is one thing to state a policy (e.g. "no user program
> should include kernel headers") it is another thing to
> gratuitously break those few programs that have good
> reason not to follow that policy.

So get declarations for u8 into your program.  It's a kernel
header for a reason and if you ignore the advise _you_ have
to work around the problems arising from it not the kernel.


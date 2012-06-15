From: Nick Bowler <nbowler@elliptictech.com>
Subject: Re: [PATCH] scsi: Silence unnecessary warnings about ioctl to
 partition
Date: Fri, 15 Jun 2012 09:58:25 -0400
Message-ID: <20120615135825.GA12847@elliptictech.com>
References: <1339757457-15646-1-git-send-email-jack@suse.cz>
 <4FDB13B1.8040100@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx.scalarmail.ca ([98.158.95.75]:47747 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755043Ab2FOOII (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jun 2012 10:08:08 -0400
Content-Disposition: inline
In-Reply-To: <4FDB13B1.8040100@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, James Bottomley <JBottomley@parallels.com>

On 2012-06-15 12:51 +0200, Jens Axboe wrote:
> On 06/15/2012 12:50 PM, Jan Kara wrote:
> > Sometimes, warnings about ioctls to partition happen often enough that they
> > form majority of the warnings in the kernel log and users complain. In some
> > cases warnings are about ioctls such as SG_IO so it's not good to get rid of
> > the warnings completely as they can ease debugging of userspace problems
> > when ioctl is refused.
> > 
> > Since I have seen warnings from lots of commands, including some proprietary
> > userspace applications, I don't think disallowing the ioctls for processes
> > with CAP_SYS_RAWIO will happen in the near future if ever. So lets just
> > stop warning for processes with CAP_SYS_RAWIO for which ioctl is allowed.
> 
> Agree, merged, finally.

Hurray!

This should be -stable material as well, as >=3.2.y kernel versions are
affected (I think 3.0.y is OK?).

Thanks,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)


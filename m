From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] scsi: Silence unnecessary warnings about ioctl to
 partition
Date: Wed, 2 May 2012 11:54:47 +0100
Message-ID: <20120502115447.7dcc3a54@pyramind.ukuu.org.uk>
References: <1335953452-10460-1-git-send-email-jack@suse.cz>
	<4FA1092E.9090603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55787 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab2EBKwQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 May 2012 06:52:16 -0400
In-Reply-To: <4FA1092E.9090603@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

On Wed, 02 May 2012 12:15:10 +0200
Paolo Bonzini <pbonzini@redhat.com> wrote:

> Il 02/05/2012 12:10, Jan Kara ha scritto:
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
> NACK.  I would bet that all the warnings you've seen are for ioctl that
> would have failed anyway with ENOTTY.

Then we don't need the bogus warning do we.

Alan

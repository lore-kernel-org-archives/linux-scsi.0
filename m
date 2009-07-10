From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [GIT PULL resend] exofs/osd tree for 2.6.31-rc2
Date: Fri, 10 Jul 2009 18:21:58 -0400
Message-ID: <4A57BF06.1070601@garzik.org>
References: <4A54666C.5010407@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:57615 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756719AbZGJWWP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jul 2009 18:22:15 -0400
In-Reply-To: <4A54666C.5010407@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>, linux-scsi <linux-scsi@vger.kernel.org>

Boaz Harrosh wrote:
> Linus
> 
> Please pull the following exofs/OSD changes from the git repository at:
> 
>   git://git.open-osd.org/linux-open-osd.git for-linus
> 
> These are a few fixes/cleanups and mainly a new block-device driver
> from Jeff Garzik, that can export an OSD object to block-based users
> like filesystems.
> 
> Since they are all small bug fixes, the copyrights adjustment should be looked
> at as a bug in the file ownership. (the original removal request came from IBM.)
> And one new driver. It might be said that we do not violate -rc rules with this.
> 
> Boaz Harrosh (5):
>       exofs: Fix bio leak in error handling path (sync read)
>       exofs: Remove IBM copyrights
>       exofs: Avoid using file_fsync()
>       MAINTAINERS: Add osd maintained files (F:)
>       osdblk: Adjust queue limits to lower device's limits
> 
> Jeff Garzik (1):
>       osdblk: a Linux block device for OSD objects

Ping...   is there a problem with this pull?

Maybe Linus is expecting exofs stuff through James?

	Jeff





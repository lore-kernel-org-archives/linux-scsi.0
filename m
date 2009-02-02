From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [GIT PULL] block bits
Date: Mon, 02 Feb 2009 19:31:31 +0200
Message-ID: <49872DF3.3060401@panasas.com>
References: <20090202131502.GH30821@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:17509 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbZBBRbj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Feb 2009 12:31:39 -0500
In-Reply-To: <20090202131502.GH30821@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>

Jens Axboe wrote:
> Hi Linus,
> 
> One critical bit in here, which fixes a reported oops from the iostat
> patch. The others are either trivial/minor or documentation. Please
> pull.
> 
>   git://git.kernel.dk/linux-2.6-block.git for-linus
> 
> Alberto Bertogli (2):
>       Fix misleading comment in bio.h
>       bio.h: If they MUST be inlined, then use __always_inline
> 
> Jens Axboe (3):
>       block: fix oops in blk_queue_io_stat()
>       block: fix inconsistent parenthesisation of QUEUE_FLAG_DEFAULT
>       block: add text file detailing queue/ sysfs files
> 

Hi Jens.

The bsg sense handling bug fix, is I think, a security breach in that
Kernel copies dangling Kernel stack back to user-mode. It might even
need a stable release.

At the time I was thinking that since bsg is marked EXPERIMENTAL in
Kconfig then it must not be included in distro's Kernels by default,
but Benny noted that it is included in Fedora since FC8 or FC9.

The patch I sent still applies I think?

Thanks
Boaz

From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: blk request timeout handler against 2.6.26
Date: Wed, 7 May 2008 09:43:57 +0200
Message-ID: <20080507074357.GP329@kernel.dk>
References: <20080503020000.GU14976@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:12710 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932436AbYEGHoA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 May 2008 03:44:00 -0400
Content-Disposition: inline
In-Reply-To: <20080503020000.GU14976@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Fri, May 02 2008, Matthew Wilcox wrote:
> 
> This patch is a forward-port of the patch Jens posted last October.
> gdth_proc needs some loving, I just #if 0'd it out for the moment.

There's a version from November 7th in my git tree, you may want to base
forward ports on that:

http://git.kernel.dk/?p=linux-2.6-block.git;a=shortlog;h=refs/heads/timeout

-- 
Jens Axboe


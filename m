From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] limit recursion when flushing shost->starved_list
Date: Mon, 21 Aug 2006 09:04:29 +0200
Message-ID: <20060821070429.GM4290@suse.de>
References: <20060809153116.GA14043@lion28.ibm.com> <1156019429.3726.18.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965064AbWHUHCU@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1156019429.3726.18.camel@mulgrave.il.steeleye.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andreas Herrmann <aherrman@de.ibm.com>, James Bottomley <jejb@SteelEye.com>, Linux SCSI <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Aug 19 2006, James Bottomley wrote:
> On Wed, 2006-08-09 at 17:31 +0200, Andreas Herrmann wrote:
> > Attached is a patch that should limit a possible recursion that can
> > lead to a stack overflow like follows:
> 
> Well, OK, initially I'll put this in scsi-misc, since I acknowledge its
> a problem.   However, it is one that block queue grouping should be able
> to get us out of ... and at that time, this code (and most of the
> starved list handling) should exit the scsi mid-layer.

Yep, the patch is a little nasty but I don't see a better way currently.
So the above outline sounds good to me.

-- 
Jens Axboe

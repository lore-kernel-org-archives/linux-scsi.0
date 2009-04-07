From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] osdblk: a Linux block device for OSD objects
Date: Tue, 7 Apr 2009 09:26:23 +0200
Message-ID: <20090407072623.GB1408@ucw.cz>
References: <20090402015455.GA14087@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090402015455.GA14087@havoc.gtf.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Wed 2009-04-01 21:54:55, Jeff Garzik wrote:
> 
> As I promised in older exofs threads, here is a client for libosd
> _other_ than exofs.  This block driver exports a single OSD object
> as a Linux block device.
> 
> See the comment block at the top of the driver for usage instructions.

I see it is not yet signed off... but maybe docs should go to
documentation directory?

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

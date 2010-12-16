From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCHSET] block/SCSI: implement in-kernel disk event handling,
 take#2
Date: Thu, 16 Dec 2010 12:00:30 -0500
Message-ID: <20101216170030.GA13585@infradead.org>
References: <1291838262-21274-1-git-send-email-tj@kernel.org>
 <4D0A3EE1.4050404@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D0A3EE1.4050404@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, kay.sievers@vrfy.org, jack@suse.cz, James.Bottomley@HansenPartnership.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Dec 16, 2010 at 05:31:29PM +0100, Tejun Heo wrote:
> On 12/08/2010 08:57 PM, Tejun Heo wrote:
> > This is the second take of in-kernel-disk-event patchset which
> > implements in-kernel disk event handling framework and adds support
> > for it to sr and sd.  This is largely to move media presence polling
> > into kernel as userspace implementation turned out to be quite
> > problematic over the years.
> 
> Kay, Jens, James, how does this look to you guys?

Any chance could could conver all block drivers to the new methods
instead of leaving us with yet another incomplete transition?


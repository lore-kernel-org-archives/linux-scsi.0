From: mikem <mikem@beardog.cca.cpqcorp.net>
Subject: Re: cciss update [2/2] fixes for Steeleye Lifekeeper
Date: Wed, 20 Oct 2004 15:15:21 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20041020201521.GB21452@beardog.cca.cpqcorp.net>
References: <20041013212253.GB9866@beardog.cca.cpqcorp.net> <20041014083900.GB7747@infradead.org> <1097764660.2198.11.camel@mulgrave> <20041014183948.GA12325@infradead.org> <1097852716.1718.9.camel@mulgrave> <20041018163532.GA24511@beardog.cca.cpqcorp.net> <1098128731.2011.296.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S270550AbUJTUYy@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1098128731.2011.296.camel@mulgrave>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@osdl.org>, Jens Axboe <axboe@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 18, 2004 at 02:45:24PM -0500, James Bottomley wrote:
> On Mon, 2004-10-18 at 11:35, mikem wrote:
> > This patch only registers the controller if no logical drives are configured. It will not result in all possible logical drives being added. I added printk's to the driver to show me what I'm registering.
> > What I see is the controller registers every time, and only drives that are phsically configured are registered. That is true for reserved drives, also.
> 
> It also looks like this device is always the one used when the array
> comes on line, so it's only a shadow for as long as the actual array has
> none of it's storage configured.  OK.
> 
> The code also seems to imply that we use a single block queue for all of
> the array devices ... isn't that a bit inefficient?
> 
> James
Yes, it's not a perfect solution, but I have yet to complete my fairness algorithm for the per drive queues.

mikem
> 
> 
> 
> 

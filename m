From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/3] ps3: Disk Storage Driver
Date: Tue, 24 Jul 2007 09:43:44 -0700
Message-ID: <20070724094344.c3cabf31.akpm@linux-foundation.org>
References: <20070716161539.075822000@pademelon.sonytel.be>
	<20070716162206.392129000@pademelon.sonytel.be>
	<20070718163637.3f0e0164.akpm@linux-foundation.org>
	<46A5E610.7000508@shadowen.org> <46A5F275.7060905@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org>
In-Reply-To: <46A5F275.7060905@garzik.org>
List-Unsubscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=unsubscribe>
List-Archive: <http://ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@ozlabs.org?subject=help>
List-Subscribe: <https://ozlabs.org/mailman/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@ozlabs.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Jens@ozlabs.org, Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, Alessandro Rubini <rubini@vision.unipv.it>, linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 24 Jul 2007 08:37:09 -0400 Jeff Garzik <jeff@garzik.org> wrote:

> Andy Whitcroft wrote:
> > Andrew Morton wrote:
> > 
> >>> +	start_sector = req->sector*priv->blocking_factor;
> >>> +	sectors = req->nr_sectors*priv->blocking_factor;
> >> s/*/ * /.  checkpatch missed this.
> > 
> > Ok, this is something we need to decide on.  Currently we only ask for
> > consistent spacing on all the mathematic operators.  This is mostly as
> > we do see a large number of non-spaced uses in defines and the like.
> > 
> > I am happy to expand these tests so they are always spaced on both sides
> > style if that is the preference.
> 
> That is most definitely the preference:  spaces surround operators.
> 

I must say that I find it hard to object to

	start = radix_tree_next_hole(&mapping->page_tree, offset, max+1);

but when the expression is more complex the spaces help.

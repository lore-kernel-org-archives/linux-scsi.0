From: Christoph Hellwig <hch@lst.de>
Subject: Re: Patch?: linux-2.5.45/drivers/scsi/hosts.[ch] - Eliminate scsi_host_tmpl_list
Date: Tue, 5 Nov 2002 23:58:52 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021105235852.A27180@lst.de>
References: <200211051220.EAA26599@adam.yggdrasil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200211051220.EAA26599@adam.yggdrasil.com>; from adam@yggdrasil.com on Tue, Nov 05, 2002 at 04:20:15AM -0800
List-Id: linux-scsi@vger.kernel.org
To: "Adam J. Richter" <adam@yggdrasil.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Tue, Nov 05, 2002 at 04:20:15AM -0800, Adam J. Richter wrote:
> 	Oops, I see that Chrisoph Hellwig posted a patch 19.5 earlier
> than mine that did this clean up and some other related ones, so please
> disregard my patch and apply Christoph's.
> 
> 	Chistoph, since you're in the process of doing similar
> clean-ups, you might want to try my untested patch that eliminated
> Scsi_Host_Name:
> 
> 	 http://marc.theaimsgroup.com/?l=linux-scsi&m=103643303212376&w=2
> 
> 	If it works and looks OK to you, Christoph, I'd encourage you
> to put it into your patch stream if you want, so as to reduce patch
> conflicts for James, Linus, et al.  On the other hand, if that just
> creates work for you that you weren't keen on doing, don't worry about
> it.  I don't mean to impose.

I'll take a look at it now.


From: Greg KH <greg@kroah.com>
Subject: Re: [stable] [patch 29/29] bug in gdth.c crashing machine
Date: Wed, 7 Mar 2007 09:40:21 -0800
Message-ID: <20070307174021.GA25066@kroah.com>
References: <200703061046.l26AksTi020093@shell0.pdx.osdl.net> <1173288505.3771.33.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:45847 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965589AbXCGRl6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Mar 2007 12:41:58 -0500
Content-Disposition: inline
In-Reply-To: <1173288505.3771.33.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, rdunlap@xenotime.net
Cc: akpm@linux-foundation.org, Achim_Leubner@adaptec.com, joerg@dorchain.net, stable@kernel.org, linux-scsi@vger.kernel.org

On Wed, Mar 07, 2007 at 11:28:25AM -0600, James Bottomley wrote:
> On Tue, 2007-03-06 at 02:46 -0800, akpm@linux-foundation.org wrote:
> > From: Joerg Dorchain <joerg@dorchain.net>
> > 
> > Undocumented...
> 
> This is a bit of a problem, isn't it?
> 
> I have no report of any problem this fixes, and no input from the gdth
> maintainer about this.  The first I actually knew of this patch request
> is that it appeared in an akpm patch stream yesterday.
> 
> I really think we need more details before this gets applied to
> anything, let alone the stable tree.

Randy did forward it to the stable team a while ago too, but I didn't
know even what tree it applied to as the patch level was a bit off.  I
think he might have some more information about it?

thanks,

greg k-h

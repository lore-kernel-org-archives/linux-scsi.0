From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [stable] [patch 29/29] bug in gdth.c crashing machine
Date: Wed, 7 Mar 2007 11:16:16 -0800
Message-ID: <20070307111616.16e5e641.akpm@linux-foundation.org>
References: <200703061046.l26AksTi020093@shell0.pdx.osdl.net>
	<1173288505.3771.33.camel@mulgrave.il.steeleye.com>
	<20070307174021.GA25066@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50916 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422964AbXCGTRp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Mar 2007 14:17:45 -0500
In-Reply-To: <20070307174021.GA25066@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, rdunlap@xenotime.net, Achim_Leubner@adaptec.com, joerg@dorchain.net, stable@kernel.org, linux-scsi@vger.kernel.org

On Wed, 7 Mar 2007 09:40:21 -0800 Greg KH <greg@kroah.com> wrote:

> On Wed, Mar 07, 2007 at 11:28:25AM -0600, James Bottomley wrote:
> > On Tue, 2007-03-06 at 02:46 -0800, akpm@linux-foundation.org wrote:
> > > From: Joerg Dorchain <joerg@dorchain.net>
> > > 
> > > Undocumented...
> > 
> > This is a bit of a problem, isn't it?
> > 
> > I have no report of any problem this fixes, and no input from the gdth
> > maintainer about this.  The first I actually knew of this patch request
> > is that it appeared in an akpm patch stream yesterday.
> > 
> > I really think we need more details before this gets applied to
> > anything, let alone the stable tree.
> 
> Randy did forward it to the stable team a while ago too, but I didn't
> know even what tree it applied to as the patch level was a bit off.  I
> think he might have some more information about it?
> 

Achim did reply:  http://lkml.org/lkml/2007/2/23/138

So we don't know what the patch does, but it should be merged into -stable
(and mainline, heaven forfend)


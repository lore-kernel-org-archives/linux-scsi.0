From: Anders Henke <anders.henke@1und1.de>
Subject: Re: broken dpt_i2o in 2.6.23 (was: ext2 check page: bad entry in directory) (fwd)
Date: Wed, 12 Dec 2007 14:43:42 +0100
Message-ID: <20071212134342.GR6770@1und1.de>
References: <20071212105841.GN6770@1und1.de> <20071212033808.6fb92139.akpm@linux-foundation.org> <1197464879.20796.15.camel@n2o.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mxintern.schlund.de ([212.227.126.204]:56775 "EHLO
	mxintern.schlund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbXLLNpH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Dec 2007 08:45:07 -0500
Content-Disposition: inline
In-Reply-To: <1197464879.20796.15.camel@n2o.xs4all.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Miquel van Smoorenburg <miquels@cistron.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, matthew@wil.cx, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Am 12.12.2007 schrieb Miquel van Smoorenburg:
> On Wed, 2007-12-12 at 03:38 -0800, Andrew Morton wrote:
> > On Wed, 12 Dec 2007 11:58:41 +0100 Anders Henke <anders.henke@1und1.de> wrote:
> > 
> > > Hi,
> > > 
> > > I'd like to let you now that my boxes are running a 32-bit kernel, so
> > > the 64-bit-uncleanliness shouldn't apply to my boxes; however,
> > > 
> > > http://www.miquels.cistron.nl/linux/dpt_i2o-64bit-2.6.23.patch
> > > 
> > > fixed the issue on my testbox.
> > > 
> > > I took a clean 2.6.23, applied patch, recompiled the kernel, reboot: works.
> > 
> > What a huge patch :(
> > 
> > We already reverted the offening patch so I assume that 2.6.24-rc5 is
> > working for you?
> > 
> > I guess we need to look at restoring "dpt_i2o: convert to SCSI hotplug
> > model" and then absorbing what Miquel has done there.
> 
> This was just a patch I had lying around, if it worked it would confirm
> my suspicion, which it has.
> 
> The minimal patch which is suitable for 2.6.23-stable and 2.6.24 would
> be the attached one-liner. The "dpt_i2o: convert to SCSI hotplug model"
> patch could be restored then.
> 
> (if the list eats the attachment, it's also available here:
> http://www.miquels.cistron.nl/linux/linux-2.6.23+24-dpt_i2o-dma64.patch 
> )
> 
> Anders, does this one-liner patch work for you ?

Got it - and it works!

I took a clean 2.6.23, applied the patch, recompiled the kernel and
rebooted my testbox: came up with the fresh-compiled kernel 
(verified by "uname -a").


Regards,

Anders
-- 
1&1 Internet AG              System Design
Brauerstrasse 48             v://49.721.91374.50
D-76135 Karlsruhe            f://49.721.91374.225

Amtsgericht Montabaur HRB 6484
Vorstand: Henning Ahlert, Ralph Dommermuth, Matthias Ehrlich, Andreas Gauger,
Thomas Gottschlich, Matthias Greve, Robert Hoffmann, Norbert Lang, Achim Weiss
Aufsichtsratsvorsitzender: Michael Scheeren

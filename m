From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] ncr53c8xx updates
Date: Mon, 7 Mar 2005 00:40:15 +0000
Message-ID: <20050307004015.GA7697@infradead.org>
References: <20050306201153.GV28741@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from pentafluge.infradead.org ([213.146.154.40]:59302 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261598AbVCGAkR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Mar 2005 19:40:17 -0500
Content-Disposition: inline
In-Reply-To: <20050306201153.GV28741@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Sun, Mar 06, 2005 at 08:11:53PM +0000, Matthew Wilcox wrote:
> This isn't for applying so much as it is for showing people where I am
> with this driver.  As with the sym2 driver, I commit each piece to the
> parisc-linux CVS tree (since parisc is currently the only user of this
> driver, it makes even more sense to do development there).

It's also used on i386/voyager (or in theory every MCA i386 system).

> This patch
> contains workarounds for a bug that is fixed in scsi-misc-2.6, so I'm
> waiting for that to be merged with Linus, then I'll submit this patch
> minus those workarounds.

While we're at it, is there anyce chance to kill/rename sym53c8xx_defs.h
and sym53c8xx_comm.h which are only ever used by the ncr53c8xx driver.

In fact I'd really love to see the driver organized similarly to the sym2
driver - ncr53c8xx.c is too f***ing large for it's own sake.


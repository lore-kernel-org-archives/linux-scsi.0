From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] qla1280 compile fix for CONFIG_HOTPLUG in 2.6
Date: Mon, 12 Jan 2004 15:10:18 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040112151018.A3222@infradead.org>
References: <16386.38762.670634.620111@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:28173 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S266101AbUALPKX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jan 2004 10:10:23 -0500
Content-Disposition: inline
In-Reply-To: <16386.38762.670634.620111@gargle.gargle.HOWL>; from jes@trained-monkey.org on Mon, Jan 12, 2004 at 07:47:38AM -0500
List-Id: linux-scsi@vger.kernel.org
To: Jes Sorensen <jes@trained-monkey.org>
Cc: akpm@osdl.org, linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com

On Mon, Jan 12, 2004 at 07:47:38AM -0500, Jes Sorensen wrote:
> Hi Andrew,
> 
> Would you mind adding this patch on top of 2.6.1-mmX. It fixes a compile
> problem with the 1280 driver when compiling it statically into the
> kernel when CONFIG_HOTPLUG is enabled in 2.6.

That patch is crap.  The ifdefs are gone in -mm and that's the way to go.
We have __devexit and __devexitp to take care of that.


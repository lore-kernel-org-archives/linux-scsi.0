From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] qla1280 compile fix for CONFIG_HOTPLUG in 2.6
Date: Mon, 12 Jan 2004 19:37:56 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040112193756.A6991@infradead.org>
References: <16386.38762.670634.620111@gargle.gargle.HOWL> <20040112151018.A3222@infradead.org> <yq0k73xci67.fsf@wildopensource.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:47119 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265594AbUALTiA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jan 2004 14:38:00 -0500
Content-Disposition: inline
In-Reply-To: <yq0k73xci67.fsf@wildopensource.com>; from jes@wildopensource.com on Mon, Jan 12, 2004 at 10:15:12AM -0500
List-Id: linux-scsi@vger.kernel.org
To: Jes Sorensen <jes@wildopensource.com>
Cc: akpm@osdl.org, linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com

On Mon, Jan 12, 2004 at 10:15:12AM -0500, Jes Sorensen wrote:
> Christoph> That patch is crap.  The ifdefs are gone in -mm and that's
> Christoph> the way to go.  We have __devexit and __devexitp to take
> Christoph> care of that.
> 
> If that works in 2.4 fine - send me a patch please.

the __devexit does not work in 2.4 due to the scsi layer function calling
qla1280_remove_one not beeing __devexit, but we already #define it away
in qla1280.c when we're compiling in 2.4.  The patch to just remove the
ifdefs already is in Andrew's patch, I think Adrian sent it you when
he found that issue, too (?)


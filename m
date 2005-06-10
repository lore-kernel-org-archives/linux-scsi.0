From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: DMA mapping (was Re: [PATCH] cciss 2.6; replaces DMA masks
	with kernel defines)
Date: Fri, 10 Jun 2005 22:45:06 +0200
Message-ID: <1118436306.5272.37.camel@laptopd505.fenrus.org>
References: <20050610143453.GA26476@beardog.cca.cpqcorp.net>
	 <42A9C60E.3080604@pobox.com>  <1118436000.6423.42.camel@mindpipe>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:20703 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261225AbVFJUpT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jun 2005 16:45:19 -0400
In-Reply-To: <1118436000.6423.42.camel@mindpipe>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Revell <rlrevell@joe-job.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, mike.miller@hp.com, akpm@osdl.org, axboe@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2005-06-10 at 16:39 -0400, Lee Revell wrote:
> On Fri, 2005-06-10 at 12:55 -0400, Jeff Garzik wrote:
> > mike.miller@hp.com wrote:
> > > This patch removes our homegrown DMA masks and uses the ones defined in
> > > the kernel instead.
> > > Thanks to Jens Axboe for the code. Please consider this for inclusion.
> > > 
> > > Signed-off-by: Mike Miller <mike.miller@hp.com>
> > 
> > You need to add '#include <linux/dma-mapping.h>'
> > 
> 
> Why doesn't this file define 29, 30, 31 bit DMA masks, required by many
> devices?  I know of at least 2 soundcards that need a 29 bit DMA mask.

your mail unfortunately was not in diff -u form ;)
I'm pretty sure that such constants are welcome



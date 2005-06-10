From: Lee Revell <rlrevell@joe-job.com>
Subject: Re: DMA mapping (was Re: [PATCH] cciss 2.6; replaces DMA masks
	with kernel defines)
Date: Fri, 10 Jun 2005 16:59:55 -0400
Message-ID: <1118437196.6423.60.camel@mindpipe>
References: <20050610143453.GA26476@beardog.cca.cpqcorp.net>
	 <42A9C60E.3080604@pobox.com>  <1118436000.6423.42.camel@mindpipe>
	 <1118436306.5272.37.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mustang.oldcity.dca.net ([216.158.38.3]:20884 "HELO
	mustang.oldcity.dca.net") by vger.kernel.org with SMTP
	id S261245AbVFJU7D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jun 2005 16:59:03 -0400
In-Reply-To: <1118436306.5272.37.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: alsa-devel <alsa-devel@lists.sourceforge.net>, Jeff Garzik <jgarzik@pobox.com>, mike.miller@hp.com, akpm@osdl.org, axboe@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2005-06-10 at 22:45 +0200, Arjan van de Ven wrote:
> On Fri, 2005-06-10 at 16:39 -0400, Lee Revell wrote:
> > On Fri, 2005-06-10 at 12:55 -0400, Jeff Garzik wrote:
> > > mike.miller@hp.com wrote:
> > > > This patch removes our homegrown DMA masks and uses the ones defined in
> > > > the kernel instead.
> > > > Thanks to Jens Axboe for the code. Please consider this for inclusion.
> > > > 
> > > > Signed-off-by: Mike Miller <mike.miller@hp.com>
> > > 
> > > You need to add '#include <linux/dma-mapping.h>'
> > > 
> > 
> > Why doesn't this file define 29, 30, 31 bit DMA masks, required by many
> > devices?  I know of at least 2 soundcards that need a 29 bit DMA mask.
> 
> your mail unfortunately was not in diff -u form ;)
> I'm pretty sure that such constants are welcome

Which reminds me, the SBLive has a 29 bit mask in the OSS driver but 31
in the ALSA driver.  I'm going to preserve the discrepancy, it seems
pointless to change the behavior of a deprecated driver.

Lee


From: Lee Revell <rlrevell@joe-job.com>
Subject: Re: DMA mapping (was Re: [PATCH] cciss 2.6; replaces DMA masks
	with kernel defines)
Date: Fri, 10 Jun 2005 16:49:48 -0400
Message-ID: <1118436589.6423.51.camel@mindpipe>
References: <20050610143453.GA26476@beardog.cca.cpqcorp.net>
	 <42A9C60E.3080604@pobox.com>  <1118436000.6423.42.camel@mindpipe>
	 <1118436306.5272.37.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mustang.oldcity.dca.net ([216.158.38.3]:39570 "HELO
	mustang.oldcity.dca.net") by vger.kernel.org with SMTP
	id S261239AbVFJUsy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jun 2005 16:48:54 -0400
In-Reply-To: <1118436306.5272.37.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, mike.miller@hp.com, akpm@osdl.org, axboe@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2005-06-10 at 22:45 +0200, Arjan van de Ven wrote: 
> > Why doesn't this file define 29, 30, 31 bit DMA masks, required by many
> > devices?  I know of at least 2 soundcards that need a 29 bit DMA mask.
> 
> your mail unfortunately was not in diff -u form ;)
> I'm pretty sure that such constants are welcome
> 

OK, I just wanted to see if there was a reason before posting it.

Anyone know of hardware that needs less than a 29 bit mask?

Lee


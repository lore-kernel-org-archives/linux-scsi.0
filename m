From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [TRIVIAL] [2.5 patch] remove an unused function from wd7000.c
Date: Thu, 04 Sep 2003 11:09:15 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1062670154.21777.3.camel@dhcp23.swansea.linux.org.uk>
References: <20030904033018.C07B42C10E@lists.samba.org>
	 <20030904082714.B26801@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pc1-cwma1-5-cust4.swan.cable.ntl.com ([80.5.120.4]:37585 "EHLO
	dhcp23.swansea.linux.org.uk") by vger.kernel.org with ESMTP
	id S264902AbTIDKKq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Sep 2003 06:10:46 -0400
In-Reply-To: <20030904082714.B26801@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Rusty Trivial Russell <trivial@rustcorp.com.au>, John Boyd <boyd@cis.ohio-state.edu>, Miroslav Zagorac <zaga@fly.cc.fer.hr>, linux-scsi@vger.kernel.org, axboe@suse.de

On Iau, 2003-09-04 at 08:27, Christoph Hellwig wrote:
> >   The patch below removes an unused function from drivers/scsi/wd7000.c .
> >   
> >   I've tested the compilation with 2.5.72-mm2.
> 
> Alan said he wanted to keep this for some reason.  Maybe #if 0 it out?

Because it needs converting to an eh_abort handler otherwise the card
will hang if you try and do anything much useful with it.


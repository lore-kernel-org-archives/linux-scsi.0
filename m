From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [PATCH][RFC 23/23]: Support for zero-copy TCP transmit of user space data
Date: Wed, 24 Dec 2008 17:44:22 +0300
Message-ID: <20081224144422.GA25089@ioremap.net>
References: <494C50BB.5030809@goop.org> <20081220020250.GA15064@gondor.apana.org.au> <494C8D57.7040808@goop.org> <20081220065105.GA16936@gondor.apana.org.au> <494CA226.9000200@goop.org> <20081220081045.GA17439@gondor.apana.org.au> <20081220103209.GA23632@ioremap.net> <49513909.1050100@vlnb.net> <20081223213817.GB16883@ioremap.net> <4952493F.10508@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from broadrack.ru ([195.178.208.66]:50814 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859AbYLXOoY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Dec 2008 09:44:24 -0500
Content-Disposition: inline
In-Reply-To: <4952493F.10508@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Jeremy Fitzhardinge <jeremy@goop.org>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Boaz Harrosh <bharrosh@panasas.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Bart Van Assche <bart.vanassche@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, netdev@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>, David Miller <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>

On Wed, Dec 24, 2008 at 05:37:51PM +0300, Vladislav Bolkhovitin (vst@vlnb.net) wrote:
> >Yes, it is simpler and cleaner, but it requires additional allocation.
> >This is additional (and quite noticeble) overhead.
> 
> Not necessary requires. For instance, in iscsi-scst sk_transaction_token 
> can (and should) be part of iSCSI cmd structure, so no additional 
> allocations would be needed.

This is special case, I'm not sure it is always possible to cache that
token and attach to every skb, but if it can be done, then of course
this does not end up with additional overhead.

-- 
	Evgeniy Polyakov

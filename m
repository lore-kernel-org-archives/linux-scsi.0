From: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH][RFC 23/23]: Support for zero-copy TCP transmit of user
 space data
Date: Fri, 19 Dec 2008 23:43:34 -0800
Message-ID: <494CA226.9000200@goop.org>
References: <494009D7.4020602@vlnb.net> <494012C4.7090304@vlnb.net> <494C0255.8010208@goop.org> <20081219220452.GB704@ioremap.net> <494C1E5E.7070809@goop.org> <20081219223314.GA2736@ioremap.net> <494C50BB.5030809@goop.org> <20081220020250.GA15064@gondor.apana.org.au> <494C8D57.7040808@goop.org> <20081220065105.GA16936@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw.goop.org ([64.81.55.164]:52165 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbYLTHnk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Dec 2008 02:43:40 -0500
In-Reply-To: <20081220065105.GA16936@gondor.apana.org.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Boaz Harrosh <bharrosh@panasas.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Bart Van Assche <bart.vanassche@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, netdev@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>, David Miller <davem@davemloft.net>

Herbert Xu wrote:
>> If so, how can it be solved?
>>     
>
> Well since each individual page can be pulled out I think you
> just have to track them.
>   

Hm.  So if I get a destructor call from the shared_info, can I go an 
inspect the page refcounts to see if its really the last use?

    J

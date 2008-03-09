From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: kernel BUG at drivers/scsi/aic7xxx/aic79xx_osm.c:1490!
Date: Sun, 09 Mar 2008 19:32:14 +0300
Message-ID: <47D4110E.4080709@msgid.tls.msk.ru>
References: <47D3C8A1.6040409@msgid.tls.msk.ru>	 <20080309212916T.tomof@acm.org>	 <1205075315.3792.12.camel@localhost.localdomain>	 <47D402C6.3070505@msgid.tls.msk.ru>  <47D40567.7070409@msgid.tls.msk.ru> <1205078371.3792.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hobbit.corpit.ru ([81.13.94.6]:24220 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbYCIQc3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Mar 2008 12:32:29 -0400
In-Reply-To: <1205078371.3792.20.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: FUJITA Tomonori <tomof@acm.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

James Bottomley wrote:
[]
>> (which doesn't look like a good thing, provided this
>> machine has 6Gb of memory...)
> 
> That's the root cause then.
> 
> There's a bug in the generic implementation of dma_get_required_mask(),
> a fix for which is below, if you could try it (still with the debugging
> patches to make sure it's working).

With the 2 patches applied:

DEBUG: RETURNED REQUIRED MASK 1ffffffff
DEBUG: SET 39 BIT ADDRESSING

I'm running the tests now.  But for some reason I
think it will be ok... ;)

Thanks!

/mjt

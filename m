From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: DMA mapping (was Re: [PATCH] cciss 2.6; replaces DMA masks with
 kernel defines)
Date: Sun, 12 Jun 2005 22:58:51 -0400
Message-ID: <42ACF66B.9050303@pobox.com>
References: <20050610143453.GA26476@beardog.cca.cpqcorp.net> <42A9C60E.3080604@pobox.com> <1118436000.6423.42.camel@mindpipe> <1118436306.5272.37.camel@laptopd505.fenrus.org> <1118436589.6423.51.camel@mindpipe> <20050611183246.GA3019@pentafluge.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:50913 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S261331AbVFMC7M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Jun 2005 22:59:12 -0400
In-Reply-To: <20050611183246.GA3019@pentafluge.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Revell <rlrevell@joe-job.com>
Cc: Arjan van de Ven <arjan@infradead.org>, mike.miller@hp.com, akpm@osdl.org, axboe@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

jgarzik@pentafluge.infradead.org wrote:
> On Fri, Jun 10, 2005 at 04:49:48PM -0400, Lee Revell wrote:
> 
>>On Fri, 2005-06-10 at 22:45 +0200, Arjan van de Ven wrote: 
>>
>>>>Why doesn't this file define 29, 30, 31 bit DMA masks, required by many
>>>>devices?  I know of at least 2 soundcards that need a 29 bit DMA mask.
>>>
>>>your mail unfortunately was not in diff -u form ;)
>>>I'm pretty sure that such constants are welcome
>>>
>>
>>OK, I just wanted to see if there was a reason before posting it.
>>
>>Anyone know of hardware that needs less than a 29 bit mask?
> 
> 
> ALS2000 sound device, which is basically an ISA SB chip on a PCI board.

ALS4000, excuse me.

	Jeff



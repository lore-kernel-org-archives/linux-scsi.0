From: Bob Doyle <doyle@primenet.com>
Subject: Re: BusLogic update - take 2
Date: Wed, 21 Jan 2004 20:45:19 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <400F474F.917B0AC0@primenet.com>
References: <40062183.D31421D7@primenet.com> <20040121134732.B29605@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.roc2.gblx.net ([64.215.96.100]:16041 "EHLO
	smtp1.roc2.gblx.net") by vger.kernel.org with ESMTP id S261872AbUAVDpa
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jan 2004 22:45:30 -0500
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
 
> What's this:?
> 
> +#ifndef FAILURE
> +#define FAILURE (-1)
> +#endif
> 
> else the patch looks okay to me

The BusLogic.c code does a #include "FlashPoint.c" which conditionally defines
FAILURE when CONFIG_SCSI_OMIT_FLASHPOINT is not defined...

Eventually I'd like to get rid of that stupid include, compile the BusLogic
and FlashPoint drivers separately, and have the BusLogic module conditionally
load FlashPoint module - or something.

I'm not sure I have the stomach to touch the FlashPoint code.

Bob.

From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: [PATCH] dead code and missing statics in lpfc
Date: Wed, 9 Jun 2004 09:55:44 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040609085544.GB17870@infradead.org>
References: <3356669BBE90C448AD4645C843E2BF28034F9464@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:54145 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S265716AbUFIIzq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jun 2004 04:55:46 -0400
Content-Disposition: inline
In-Reply-To: <3356669BBE90C448AD4645C843E2BF28034F9464@xbl.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.Com>
Cc: linux-scsi@vger.kernel.org

On Tue, Jun 08, 2004 at 10:45:14AM -0400, Smart, James wrote:
> Christoph,
> 
> We had not completed the effort relative to the comments. Sorry you thought
> your patch was ignored. They (including the prior one) was not.
> 
> I believe that this week we will have completely dealt with the statics and
> symbols. One caveat though.. we have a lot of diagnostic and test tools that
> like to do low level error injection, testing, and data sampling. Our
> automated test suites are built heavily on this infrastructure. The way we
> are approaching these tools is as a separate kernel module. Therefore, the
> tools use quite a few of the "dead" symbols/functions. One of our jobs is to
> ensure that, where we sliced the interface between the driver and the tool
> module, that we did so appropriately, dead code in the driver should
> actually be in the tool module, and that we are exporting the minimum number
> of symbols. I am pushing to have this completed for the next drop as well,
> so we can put these comments to rest.

In either case exported symbols in the driver and dead symbols are completely
uninteresting for a kernel submission, so make sure you get rid of them
before you try to submit the driver.


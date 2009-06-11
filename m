From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] Revert "block: WARN in __blk_put_request() for
 potential bio leak"
Date: Thu, 11 Jun 2009 19:10:38 +0900
Message-ID: <20090611191022W.fujita.tomonori@lab.ntt.co.jp>
References: <4A2F6B8E.8060700@panasas.com>
	<20090610172956C.fujita.tomonori@lab.ntt.co.jp>
	<4A2F7014.2030705@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:59824 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758607AbZFKKKt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jun 2009 06:10:49 -0400
In-Reply-To: <4A2F7014.2030705@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On Wed, 10 Jun 2009 11:34:28 +0300
Boaz Harrosh <bharrosh@panasas.com> wrote:

> On 06/10/2009 11:29 AM, FUJITA Tomonori wrote:
> > 
> > Read the code. I think that you totally misunderstand these functions.
> > 
> 
> Thanks for the detail explanation. This really help me a lot

I already explained before this mail (though I was wrong wrt the
bounce path, I think), see the forth and fifth lines from the bottom:

http://marc.info/?l=linux-scsi&m=124458845603617&w=2

You just repeated the same question without reading my mail or the
code. I don't know how to help such people.

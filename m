From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] Revert "block: WARN in __blk_put_request() for
 potential bio leak"
Date: Wed, 10 Jun 2009 17:52:27 +0900
Message-ID: <20090610175238P.fujita.tomonori@lab.ntt.co.jp>
References: <4A2F6B8E.8060700@panasas.com>
	<20090610172956C.fujita.tomonori@lab.ntt.co.jp>
	<4A2F729A.1060101@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:38437 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755607AbZFJIwf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jun 2009 04:52:35 -0400
In-Reply-To: <4A2F729A.1060101@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On Wed, 10 Jun 2009 11:45:14 +0300
Boaz Harrosh <bharrosh@panasas.com> wrote:

> On 06/10/2009 11:29 AM, FUJITA Tomonori wrote:
> > On Wed, 10 Jun 2009 11:15:10 +0300
> > Boaz Harrosh <bharrosh@panasas.com> wrote:
> >> That is a violation of block API. All block drivers must call
> >> blk_end_request().
> > 
> > Where can I find a documentation about it?
> > 
> 
> No documentation
> 
> > If not, can you stop claiming a new rule?
> > 
> 
> The fact that ALL block drivers call it for proper service of ALL ULDS,
> does it not make it a rule?

BSG SMP code is not ULD.


> > If you want to propose a new rule, you need to fix the existing users
> > first.
> > 
> 
> Sorry I missed them. I couldn't even imagine that there will be any.
> Will send patches, sorry.

I'll take care about it.


> >> If they do not, then they can not for example be
> >> called from inside Kernel. They relay on special bsg behavior
> >> that always uses map_user.
> > 
> > Of course, we send SMP requests only via BSG. SMP is the first reason
> > why we invented BSG.
> > 
> 
> Of course what? Show me the big fat comment that says:
>   only use from BSG!!! other wise broken block driver.

I think that the majority of SCSI people know that.

FYI, you live in a land where very few live.


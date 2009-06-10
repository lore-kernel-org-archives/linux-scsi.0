From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] Revert "block: WARN in __blk_put_request() for potential
 bio leak"
Date: Wed, 10 Jun 2009 12:21:19 +0300
Message-ID: <4A2F7B0F.1030205@panasas.com>
References: <4A2F6B8E.8060700@panasas.com>	<20090610172956C.fujita.tomonori@lab.ntt.co.jp>	<4A2F729A.1060101@panasas.com> <20090610175238P.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:64854 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757782AbZFJJVV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2009 05:21:21 -0400
Received: by fxm9 with SMTP id 9so600305fxm.37
        for <linux-scsi@vger.kernel.org>; Wed, 10 Jun 2009 02:21:23 -0700 (PDT)
In-Reply-To: <20090610175238P.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jens.axboe@oracle.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On 06/10/2009 11:52 AM, FUJITA Tomonori wrote:
> On Wed, 10 Jun 2009 11:45:14 +0300
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>>>
>> The fact that ALL block drivers call it for proper service of ALL ULDS,
>> does it not make it a rule?
> 
> BSG SMP code is not ULD.
> 

BSG is certainly a ULD, Upper-Layer-Driver that can issue block commands
through block layer and block-queue.

SMP is a block device class that has it's own LLDs.

The way I understand

|---------|      |--------------|      |-----------|
| ULD     |----->|  block layer |----->| block LLD |
|---------|      |--------------|      |-----------|

So I meant block ULD or block layer user code. That is what I meant
by ULD, what do you mean?

<snip>
> 
> FYI, you live in a land where very few live.
> 

I thought I was working on the Linux-Kernel. Is there another
place I should be?

Boaz

From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/8] exofs: Kbuild, Headers and osd utils
Date: Mon, 16 Feb 2009 12:29:06 +0200
Message-ID: <49993FF2.9050200@panasas.com>
References: <499928A3.60507@panasas.com>	<20090216180028C.fujita.tomonori@lab.ntt.co.jp>	<49992F99.1060404@panasas.com> <20090216183750H.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:10504 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750849AbZBPK3M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Feb 2009 05:29:12 -0500
In-Reply-To: <20090216183750H.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: avishay@gmail.com, jeff@garzik.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, osd-dev@open-osd.org, linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> On Mon, 16 Feb 2009 11:19:21 +0200
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>>>> Also looking
>>>> ahead I will have RAID 0, 1, 5, and 6 on objects of different devices. bio
>>>> is the perfect collector for memory information in this situation.
>>> You will add such features to exofs, handling multiple devices
>>> internally?
>>>
>> Multiple objects on Multiple devices, Yes.
> 
> I thought that exofs is kinda example (reference) file system.
> 
> Nobody has seen your code. Let's discuss when we have the
> code. Over-designing for what we've not seen is not a good idea.
> 

Thanks for the insults, and high credit ;)

Yes it's "kinda example (reference) file system" of a pNFS-objects
file system. What can I do life is tough.

> 
>>>> exofs is not the first and only file system who is using bios. Proof of
>>>> the matter is that block exports a bio submit routine.
>>> Seems that exofs just passes pages and the ULD sends a SCSI command
>>> including these pages. I don't see how exofs needs to handle bio
>>> directly.
>>>
>> How do you propose to collect these pages? and keep them without allocating
>> an extra list? without pre-allocating a struct request? and without re-inventing
>> the bio structure?
> 
> I don't think that allocating an extra list (or something) to keep
> them hurts performance. We can talk about it when you have the real
> performance results.

So you are the one that starts to invent the wheel here. I thought I was
the one that does that, only you only called me by names, because you never showed
me where.

But please only answer one question for me: Please don't write back if you do not
answer this question:

Why do other filesystems allow to use bios? are they going to stop? Who is going
to remove that?

And as I said, I am going to remove it for now, please be patient. You have never
herd from me that I refuse to do it, did you?

Boaz

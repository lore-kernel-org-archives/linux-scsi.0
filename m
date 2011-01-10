From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH] [BLOCK] Allow tag 0 to be generated
Date: Mon, 10 Jan 2011 20:31:49 +0100
Message-ID: <4D2B5EA5.9030900@fusionio.com>
References: <835205.47474.qm@web31809.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([64.244.102.30]:39948 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754339Ab1AJTb5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jan 2011 14:31:57 -0500
In-Reply-To: <835205.47474.qm@web31809.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "ltuikov@yahoo.com" <ltuikov@yahoo.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On 2011-01-10 20:27, Luben Tuikov wrote:
> --- On Mon, 1/10/11, Jens Axboe <jaxboe@fusionio.com> wrote:
>>> That commit isn't a valid sha in my tree. What commit
>> do you mean?
>>>
>>>> skipped tag 0 by virtue of setting last_tag to
>>>> 0. This commit sets it to -1, in order to start
>>>> and loop over from 0, thus generating tags
>>>> [0,max_tag-1], instead of [1,max_tag-1].
>>>
>>> Irregardless, patch looks good. That's definitely a
>> bug. Thanks!
>>
>> But not in my kernel, what tree are you looking at? I don't
>> remember
>> seeing any tag patches, and they should be in my tree if
>> there are.
> 
> It applies on top of this patch:
> 
> From 67869fb9fdfa04503b250d59e086c15f1698aea0 Mon Sep 17 00:00:00 2001

Ah I see. It doesn't make sense to mention shas in your own tree in
commit messages for patches you send, as they will not be valid unless
your tree is actually pulled from.

And since this patch is not in any tree, and at least I didn't agree
with it, then you should post your updated fixed patch instead of
sending a patch against a broken patch.

-- 
Jens Axboe


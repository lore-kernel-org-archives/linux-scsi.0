From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH] [BLOCK] Allow tag 0 to be generated
Date: Mon, 10 Jan 2011 19:52:12 +0100
Message-ID: <4D2B555C.5090109@fusionio.com>
References: <1266.36669.qm@web31807.mail.mud.yahoo.com> <4D2B54CE.3080301@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4D2B54CE.3080301@fusionio.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "ltuikov@yahoo.com" <ltuikov@yahoo.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2011-01-10 19:49, Jens Axboe wrote:
> On 2011-01-10 18:26, Luben Tuikov wrote:
>> Commit 67869fb9fdfa04503b250d59e086c15f1698aea0
> 
> That commit isn't a valid sha in my tree. What commit do you mean?
> 
>> skipped tag 0 by virtue of setting last_tag to
>> 0. This commit sets it to -1, in order to start
>> and loop over from 0, thus generating tags
>> [0,max_tag-1], instead of [1,max_tag-1].
> 
> Irregardless, patch looks good. That's definitely a bug. Thanks!

But not in my kernel, what tree are you looking at? I don't remember
seeing any tag patches, and they should be in my tree if there are.


-- 
Jens Axboe

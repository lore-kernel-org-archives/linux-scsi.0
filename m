From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 0/7] sg_ring: a ring of scatterlist arrays
Date: Mon, 07 Jan 2008 17:45:47 +0900
Message-ID: <4781E6BB.2010900@gmail.com>
References: <200712191731.26512.rusty@rustcorp.com.au> <200801071628.11381.rusty@rustcorp.com.au> <4781C8B5.6050207@gmail.com> <200801071934.01597.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200801071934.01597.rusty@rustcorp.com.au>
Sender: linux-ide-owner@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Rusty Russell wrote:
> On Monday 07 January 2008 17:37:41 Tejun Heo wrote:
>> Rusty Russell wrote:
>>> Hi Tejun,
>>>
>>>    Nice try!  Even ignoring the ugliness of undoing such an operation if
>>> the caller doesn't expect you to mangle their chains, consider a
>>> one-element sg array. :(
>> Heh heh, that can be dealt with by skipping the first chain if the first
>> chain is empty after chaining.  Please take a look at
>> ata_sg_setup_extra() in the following.
>>
>> http://git.kernel.org/?p=linux/kernel/git/tj/libata-dev.git;a=blob;f=driver
>> s/ata/libata-core.c;h=32dde5bbc75ed53e89ac17040da2cd0621a37161;hb=c8847e473a
>> 4a2844244784226eb362be10d52ce9
>>
>> That said, yeah, it's seriously ugly.  Restoring the original sg is ugly
>> too.  I definitely agree that we need some improvements here.
> 
> Erk, that's beyond ugly, into actual evil.

/me agrees.

> To make this general you need to find the last N 1-element chains (but SCSI 
> doesn't do this of course).  Oh the horror...

/me agrees.

> I'd be remiss if I didn't mention that the sg_ring ata patches were 
> straightforward, and indescribably beautiful if compared to this!

/me agrees.  As long as this can be made sane using one unified
interface, I don't care whether it's sg_ring, table or dish.

Thanks.

-- 
tejun

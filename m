From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH version 2] [SQUASHME] "FC Pass Thru support" fixed for
 block/for-2.6.31 tree
Date: Wed, 20 May 2009 08:54:13 -0400
Message-ID: <4A13FD75.6050100@emulex.com>
References: <4A12797B.2060901@panasas.com>	<4A12AC23.30808@panasas.com> <20090520111619.87f815b1.sfr@canb.auug.org.au> <4A13BB1D.10901@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756993AbZETNTK@vger.kernel.org>
In-Reply-To: <4A13BB1D.10901@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, James Bottomley <James.Bottomley@hansenpartnership.com>, Tejun Heo <tj@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <tomof@acm.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Jens Axboe <Jens.Axboe@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Fine by me.

-- james s

Acked-by: James Smart <james.smart@emulex.com>


Boaz Harrosh wrote:
> On 05/20/2009 04:16 AM, Stephen Rothwell wrote:
>   
>> On Tue, 19 May 2009 15:54:59 +0300 Boaz Harrosh <bharrosh@panasas.com> wrote:
>>     
>>> This patch should be squashed into
>>>     [SCSI] FC Pass Thru support
>>>
>>> If it needs to compile after Tejun's block-layer revamps
>>> (all of them)
>>>       
>> Is there some reason that the FC passthrough support (and any followup
>> patches) can't be pushed through the block tree.  It clearly currently
>> doesn't depend on anything new in the scsi tree ...
>>
>>     
>
> If it will go through block tree it needs James Bottomley's Ack, I
> guess?
>
> It does, in any case, need Ack from James Smart first. James ?
>
> Thanks
> Boaz
>
>   

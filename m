From: "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Subject: Re: [ufs]: [scsi]: BUG: spinlock recursion on CPU#4
Date: Mon, 5 Jun 2017 12:16:10 +0530
Message-ID: <94899e9e-abd3-5e70-838a-5a4659a9483e@codeaurora.org>
References: <bd79226b-833c-f53b-f92a-0c4ebffeb1ee@codeaurora.org>
 <1496325738.3075.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1496325738.3075.1.camel@sandisk.com>
Content-Language: en-US
Sender: linux-arm-msm-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



On 6/1/2017 7:32 PM, Bart Van Assche wrote:
> On Thu, 2017-06-01 at 12:28 +0530, Asutosh Das (asd) wrote:
>> Please can you check if this is actually a bug and my understanding is
>> correct.
> 
> Hello Asutosh,
> 
> Spinlock recursion is always a bug. With what kernel version did you encounter
> this? Was it with a kernel from kernel.org, a distro kernel or an Android kernel?
> Have you already tried to reproduce this with kernel debugging enabled? Enabling
> CONFIG_DEBUG_SPINLOCK and CONFIG_PROVE_LOCKING should provide more detailed
> information.
> 
> Bart.
> 

Hello Bart,
Thanks.

It's on 4.4 and its an Android kernel.

No - I haven't tried it out yet. I could get some clues from the 
call-stack itself, like I explained before. I can try these configs 
though. While I do that, I'd like to know your thoughts on my analysis. 
Do you think with the current data, it makes sense?

-- 
Asutosh.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project

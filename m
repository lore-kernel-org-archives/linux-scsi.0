From: ygardi@codeaurora.org
Subject: Re: [PATCH v2 17/17] scsi: ufs-qcom: fix compilation warnings
Date: Tue, 27 Oct 2015 18:22:04 -0000
Message-ID: <f66868db83a151ea8382b8dcd3e25930.squirrel@www.codeaurora.org>
References: <1445874072-25909-1-git-send-email-ygardi@codeaurora.org>
    <1445874072-25909-18-git-send-email-ygardi@codeaurora.org>
    <562EA19E.2070007@codeaurora.org>
    <723997f5afca9a1683db57b8ecb3cf44.squirrel@www.codeaurora.org>
    <562FB412.5050603@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <562FB412.5050603@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: ygardi@codeaurora.org, robherring2@gmail.com, james.bottomley@hansenpartnership.com, pebolle@tiscali.nl, hch@infradead.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

> On 10/27/2015 03:10 AM, ygardi@codeaurora.org wrote:
>>> On 10/26/2015 08:41 AM, Yaniv Gardi wrote:
>>>> Tnis patch fixes the following compilation warnings:
>>>> ...ufs-qcom.c:1201:40:
>>>> 	warning: incorrect type in argument 1 (different address spaces)
>>>> ...ufs-qcom.c:1201:40:
>>>> 	expected void const *ptr
>>>> ...ufs-qcom.c:1201:40:
>>>> 	got void [noderef] <asn:2>*dev_ref_clk_ctrl_mmio
>>>> ...ufs-qcom.c:1207:53:
>>>> 	warning: incorrect type in argument 1 (different address spaces)
>>>> ...ufs-qcom.c:1207:53:
>>>> 	expected void const *ptr
>>>> ...ufs-qcom.c:1207:53:
>>>> 	got void [noderef] <asn:2>*dev_ref_clk_ctrl_mmio
>>>>
>>>> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>>>>
>>>> ---
>>> What version of sparse do you use? You shouldn't need to do this.
>>>
>> i just updated my sparse to the newest -
>> so i'm using sparse 0.4.4
>> and the command i use is:
>> make ARCH=arm C=1  CF="-Wsparse-all"
>> and i still get all the warnings.
>> with my patch, the are no warnings.
>>
>
> That is not the latest version of sparse. I'm not sure when sparse was
> updated, but I have the git version which shows v0.5.0-51-ga53cea28f0db
>

Stephen, is this something you insist on?
i think the patch can stay as it is.
please let me know, as i wouldn't like this issue to block the entire patch

Yaniv

> --
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> a Linux Foundation Collaborative Project
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

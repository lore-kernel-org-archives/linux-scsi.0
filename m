From: Vivek Gautam <vivek.gautam-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH 0/5] qcom-ufs: phy/hcd: Refactor phy initialization code
Date: Wed, 9 Aug 2017 12:14:44 +0530
Message-ID: <CAFp+6iF7m5vgGZcrOTXcxtPinVYUn0iPq1vAjXT909zfHu+wVQ@mail.gmail.com>
References: <1501829332-5183-1-git-send-email-vivek.gautam@codeaurora.org>
 <c29e3a7c-62cc-f25a-4e0b-231c69e01afa@ti.com> <b69ecef93852cf5a7bf342550de16f19@codeaurora.org>
 <d49316e0-8ccc-21b3-e952-ddb0a941f3b3@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d49316e0-8ccc-21b3-e952-ddb0a941f3b3-l0cyMroinI0@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Subhash Jadavani <subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Kishon Vijay Abraham I <kishon-l0cyMroinI0@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, robh+dt <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-arm-msm <linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bjorn Andersson <bjorn.andersson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, Vinayak Holikatti <vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-arm-msm-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi Martin, Subhash


On Wed, Aug 9, 2017 at 11:18 AM, Kishon Vijay Abraham I <kishon-l0cyMroinI0@public.gmane.org> wrote:
> Vivek,
>
> On Tuesday 08 August 2017 09:20 PM, Vivek Gautam wrote:
>> Hi Koshon,
>>
>> On 2017-08-08 17:39, Kishon Vijay Abraham I wrote:
>>> Hi,
>>>
>>> On Friday 04 August 2017 12:18 PM, Vivek Gautam wrote:
>>>> Refactoring the qcom-ufs phy and host controller code to move
>>>> further towards the generic phy usage. Right now the qcom-ufs exports
>>>> a bunch of APIs that are used by the host controller to initialize
>>>> the phy.
>>>> With this patch series, we populate the phy_init() which was a no-op
>>>> earlier. The host controller then calls the phy_init() at the designated
>>>> place rather than doing it invariably in ufs_hcd_init().
>>>>
>>>> As part of this series, we introduce phy modes for ufs phy.
>>>> The M-PHY has two data rates defined for each generations (Gears) -
>>>> Rate A and Rate B. These can serve as the two modes of ufs HS phy.
>>>> Host controller can direct the phy to set the respective configurations
>>>> based on the phy modes.
>>>>
>>>> The patch-series has been tested with necessary dt patches on db820c.
>>>
>>> Can the first 3 patches go independently of the other 2 or should all this be
>>> merged together?
>>
>> The first 3 patches are independent, but the next 2 patches depend on those 3
>> for functionality.
>> I would prefer all to go in one tree. If you want to pull these in the phy tree,
>> I will request Subhash/Martin to ack the patches.

Can you kindly review this patch series (for UFS controller changes) and
consider giving your Ack so that Kishon can pull in the series through phy tree.
Thanks.

best regards
Vivek

>
> sure, that should be fine!
>
> Thanks
> Kishon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

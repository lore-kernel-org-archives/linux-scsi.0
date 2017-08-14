From: "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Subject: Re: [PATCH 0/5] qcom-ufs: phy/hcd: Refactor phy initialization code
Date: Mon, 14 Aug 2017 10:47:34 +0530
Message-ID: <1595aa1a-d88d-0208-9c44-d7ef42570264@codeaurora.org>
References: <1501829332-5183-1-git-send-email-vivek.gautam@codeaurora.org>
 <c29e3a7c-62cc-f25a-4e0b-231c69e01afa@ti.com>
 <b69ecef93852cf5a7bf342550de16f19@codeaurora.org>
 <d49316e0-8ccc-21b3-e952-ddb0a941f3b3@ti.com>
 <CAFp+6iF7m5vgGZcrOTXcxtPinVYUn0iPq1vAjXT909zfHu+wVQ@mail.gmail.com>
 <yq1y3qr2cog.fsf@oracle.com>
 <CAFp+6iGXR6Qk3xvWuWTu17LDrh5dOzJrZmn57zG30UjZrFm-Rg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59610 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750876AbdHNFRn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Aug 2017 01:17:43 -0400
In-Reply-To: <CAFp+6iGXR6Qk3xvWuWTu17LDrh5dOzJrZmn57zG30UjZrFm-Rg@mail.gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vivek Gautam <vivek.gautam@codeaurora.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Subhash Jadavani <subhashj@codeaurora.org>, Kishon Vijay Abraham I <kishon@ti.com>, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, robh+dt <robh+dt@kernel.org>, linux-arm-msm <linux-arm-msm@vger.kernel.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, jejb@linux.vnet.ibm.com, Vinayak Holikatti <vinholikatti@gmail.com>, linux-arm-msm-owner@vger.kernel.org

Vivek,

On 8/11/2017 12:42 PM, Vivek Gautam wrote:
> On Fri, Aug 11, 2017 at 5:33 AM, Martin K. Petersen
> <martin.petersen@oracle.com> wrote:
>>
>> Vivek,
>>
>>> Can you kindly review this patch series (for UFS controller changes)
>>> and consider giving your Ack so that Kishon can pull in the series
>>> through phy tree.
>>
>> SCSI piece looks OK.
> 
> Thank you Martin for your review.
>>
>> Would still like Subhash to review the rest.
> 
> Subhash is on vacation with limited access to emails. I will ask
> his team to take a look.
> 
Looks good to me.
> regards
> Vivek
> 
>>
>> --
>> Martin K. Petersen      Oracle Linux Engineering
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 

-- 
Asutosh Das (asd)
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project

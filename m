From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: Re: [PATCH 0/5] qcom-ufs: phy/hcd: Refactor phy initialization code
Date: Tue, 08 Aug 2017 21:20:35 +0530
Message-ID: <b69ecef93852cf5a7bf342550de16f19@codeaurora.org>
References: <1501829332-5183-1-git-send-email-vivek.gautam@codeaurora.org>
 <c29e3a7c-62cc-f25a-4e0b-231c69e01afa@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58374 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752014AbdHHPug (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2017 11:50:36 -0400
In-Reply-To: <c29e3a7c-62cc-f25a-4e0b-231c69e01afa@ti.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, robh+dt@kernel.org, linux-arm-msm@vger.kernel.org, subhashj@codeaurora.org, bjorn.andersson@linaro.org, devicetree@vger.kernel.org, jejb@linux.vnet.ibm.com, vinholikatti@gmail.com, linux-arm-msm-owner@vger.kernel.org

Hi Koshon,

On 2017-08-08 17:39, Kishon Vijay Abraham I wrote:
> Hi,
> 
> On Friday 04 August 2017 12:18 PM, Vivek Gautam wrote:
>> Refactoring the qcom-ufs phy and host controller code to move
>> further towards the generic phy usage. Right now the qcom-ufs exports
>> a bunch of APIs that are used by the host controller to initialize
>> the phy.
>> With this patch series, we populate the phy_init() which was a no-op
>> earlier. The host controller then calls the phy_init() at the 
>> designated
>> place rather than doing it invariably in ufs_hcd_init().
>> 
>> As part of this series, we introduce phy modes for ufs phy.
>> The M-PHY has two data rates defined for each generations (Gears) -
>> Rate A and Rate B. These can serve as the two modes of ufs HS phy.
>> Host controller can direct the phy to set the respective 
>> configurations
>> based on the phy modes.
>> 
>> The patch-series has been tested with necessary dt patches on db820c.
> 
> Can the first 3 patches go independently of the other 2 or should all 
> this be
> merged together?

The first 3 patches are independent, but the next 2 patches depend on 
those 3 for functionality.
I would prefer all to go in one tree. If you want to pull these in the 
phy tree,
I will request Subhash/Martin to ack the patches.


Regards
Vivek

> 
> Thanks
> Kishon
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

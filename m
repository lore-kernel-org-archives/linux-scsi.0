From: Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH 0/5] qcom-ufs: phy/hcd: Refactor phy initialization code
Date: Tue, 8 Aug 2017 17:39:11 +0530
Message-ID: <c29e3a7c-62cc-f25a-4e0b-231c69e01afa@ti.com>
References: <1501829332-5183-1-git-send-email-vivek.gautam@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fllnx209.ext.ti.com ([198.47.19.16]:16078 "EHLO
        fllnx209.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752179AbdHHMKm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2017 08:10:42 -0400
In-Reply-To: <1501829332-5183-1-git-send-email-vivek.gautam@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vivek Gautam <vivek.gautam@codeaurora.org>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, robh+dt@kernel.org
Cc: linux-arm-msm@vger.kernel.org, subhashj@codeaurora.org, bjorn.andersson@linaro.org, devicetree@vger.kernel.org, jejb@linux.vnet.ibm.com, vinholikatti@gmail.com

Hi,

On Friday 04 August 2017 12:18 PM, Vivek Gautam wrote:
> Refactoring the qcom-ufs phy and host controller code to move
> further towards the generic phy usage. Right now the qcom-ufs exports
> a bunch of APIs that are used by the host controller to initialize
> the phy.
> With this patch series, we populate the phy_init() which was a no-op
> earlier. The host controller then calls the phy_init() at the designated
> place rather than doing it invariably in ufs_hcd_init().
> 
> As part of this series, we introduce phy modes for ufs phy.
> The M-PHY has two data rates defined for each generations (Gears) -
> Rate A and Rate B. These can serve as the two modes of ufs HS phy.
> Host controller can direct the phy to set the respective configurations
> based on the phy modes.
> 
> The patch-series has been tested with necessary dt patches on db820c.

Can the first 3 patches go independently of the other 2 or should all this be
merged together?

Thanks
Kishon

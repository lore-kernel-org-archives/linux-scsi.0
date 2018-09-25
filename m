From: Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH 0/3] scsi: ufs-qcom: Remove all direct calls to qcom-ufs
 phy
Date: Tue, 25 Sep 2018 12:12:49 +0530
Message-ID: <75d4820c-d154-cc5c-e7b6-72defdfdce5e@ti.com>
References: <20180904101719.18049-1-vivek.gautam@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180904101719.18049-1-vivek.gautam@codeaurora.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Gautam <vivek.gautam@codeaurora.org>, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: subhashj@codeaurora.org, bjorn.andersson@linaro.org, evgreen@chromium.org, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Vivek,

On Tuesday 04 September 2018 03:47 PM, Vivek Gautam wrote:
> Cleaning up the ufs-qcom host further to remove all direct calls
> into qcom-ufs driver.
> Only phy-qcom-ufs-qmp-20nm phy handles these direct calls from ufs host
> and this phy is not used in any supported qcom platform in current kernel.
> So, while we free up the host from all the ufs_qcom_phy_*() API calls
> we should declare 20nm phy as broken.
> For this we fork out couple of configs from PHY_QCOM_UFS -
> PHY_QCOM_UFS_14NM and PHY_QCOM_UFS_20NM out of which we declare
> PHY_QCOM_UFS_20NM as 'broken'.
> 
> This series helps in a clean use of ufs phy support for sdm845
> and further SoCs that will also use phy-qcom-qmp phy driver.

I think this entire series should go via linux-phy tree. I need ACK from UFS
MAINTAINER for the second patch.

Thanks
Kishon

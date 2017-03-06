From: Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH v5 02/11] phy: exynos-ufs: add UFS PHY driver for EXYNOS
 SoC
Date: Mon, 6 Mar 2017 19:01:42 +0530
Message-ID: <58BD64BE.3000502@ti.com>
References: <1447046787-480-1-git-send-email-alim.akhtar@samsung.com>
 <1447046787-480-3-git-send-email-alim.akhtar@samsung.com>
 <564AC63F.1000508@ti.com> <564AE11F.50908@samsung.com>
 <CGME20170203092123epcas4p20b1d56d7a6fdec46903c41fc65718795@epcas4p2.samsung.com>
 <564DD11D.2060101@ti.com> <aae976f6-18cf-7241-4f76-f842317229d4@samsung.com>
 <CAGOxZ50gh_SErTiDbkjqNTCds-8ghgxXofSgzSwp6hicAcw23Q@mail.gmail.com>
 <58B3B87B.7010302@ti.com> <bcab9fcc-1308-7adb-ad2a-88eeea5565c7@samsung.com>
 <58B4EFC8.2060300@ti.com> <12decf59-0486-9efd-63de-12fee95a8cea@samsung.com>
 <58B64FF1.3020808@ti.com> <973e0776-7b7b-d4af-cb64-025142af9f0f@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fllnx210.ext.ti.com ([198.47.19.17]:46650 "EHLO
        fllnx210.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753173AbdCFNof (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2017 08:44:35 -0500
In-Reply-To: <973e0776-7b7b-d4af-cb64-025142af9f0f@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alim Akhtar <alim.akhtar@samsung.com>, Alim Akhtar <alim.akhtar@gmail.com>
Cc: linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@odin.com>, vinayak holikatti <vinholikatti@gmail.com>, Jaehoon Chung <jh80.chung@samsung.com>, Seungwon Jeon <essuuj@gmail.com>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Pankaj Dubey <pankaj.dubey@samsung.com>, vivek.gautam@codeaurora.org, subhashj@codeaurora.org

Hi,

On Monday 06 March 2017 05:12 PM, Alim Akhtar wrote:
> Hi Kishon
> 
> On 03/01/2017 10:07 AM, Kishon Vijay Abraham I wrote:
>> Hi,
>>
>> On Tuesday 28 February 2017 01:51 PM, Alim Akhtar wrote:
>>> Hi Kishon,
>>>
>>> On 02/28/2017 09:04 AM, Kishon Vijay Abraham I wrote:
>>>> Hi,
>>>>
>>>> On Monday 27 February 2017 07:40 PM, Alim Akhtar wrote:
>>>>> Hi Kishon,
>>>>>
>>>>> On 02/27/2017 10:56 AM, Kishon Vijay Abraham I wrote:
>>>>>> Hi,
>>>>>>
>>>>>> On Thursday 23 February 2017 12:20 AM, Alim Akhtar wrote:
>>>>>>> On Fri, Feb 3, 2017 at 2:49 PM, Alim Akhtar <alim.akhtar@samsung.com> wrote:
>>>>>>>> Hi Kishon,
>>>>>>>>
>>>>>>>>
>>>>>>>> On 11/19/2015 07:09 PM, Kishon Vijay Abraham I wrote:
>>>>>>>>>
>>>>>>>>> Hi,
>>>>>>>>>
>>>>>>>>> On Tuesday 17 November 2015 01:41 PM, Alim Akhtar wrote:
>>>>>>>>>>
>>>>>>>>>> Hi
>>>>>>>>>> Thanks again for looking into this.
>>>>>>>>>>
>>>>>>>>>> On 11/17/2015 11:46 AM, Kishon Vijay Abraham I wrote:
>>>>>>>>>>>
>>>>>>>>>>> Hi,
>>>>>>>>>>>
>>>>>>>>>>> On Monday 09 November 2015 10:56 AM, Alim Akhtar wrote:
>>>>>>>>>>>>
>>>>>>>>>>>> From: Seungwon Jeon <essuuj@gmail.com>
>>>>>>>>>>>>
>>>>>>>>>>>> This patch introduces Exynos UFS PHY driver. This driver
>>>>>>>>>>>> supports to deal with phy calibration and power control
>>>>>>>>>>>> according to UFS host driver's behavior.
>>>>>>>>>>>>
>>>>>>>>>>>> Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
>>>>>>>>>>>> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
>>>>>>>>>>>> Cc: Kishon Vijay Abraham I <kishon@ti.com>
>>>>>>>>>>>> ---
>>>>>>>>>>>>   drivers/phy/Kconfig                |    7 ++
>>>>>>>>>>>>   drivers/phy/Makefile               |    1 +
>>>>>>>>>>>>   drivers/phy/phy-exynos-ufs.c       |  241
>>>>>>>>>>>> ++++++++++++++++++++++++++++++++++++
>>>>>>>>>>>>   drivers/phy/phy-exynos-ufs.h       |   85 +++++++++++++
>>>>>>>>>>>>   drivers/phy/phy-exynos7-ufs.h      |   89 +++++++++++++
>>>>>>>>>>>>   include/linux/phy/phy-exynos-ufs.h |   85 +++++++++++++
>>>>>>>>>>>>   6 files changed, 508 insertions(+)
>>>>>>>>>>>>   create mode 100644 drivers/phy/phy-exynos-ufs.c
>>>>>>>>>>>>   create mode 100644 drivers/phy/phy-exynos-ufs.h
>>>>>>>>>>>>   create mode 100644 drivers/phy/phy-exynos7-ufs.h
>>>>>>>>>>>>   create mode 100644 include/linux/phy/phy-exynos-ufs.h
>>>>>>>>>>>>
>>>>>>>>>>>> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
>>>>>>>>>>>> index 7eb5859dd035..7d38a92e0297 100644
>>>>>>>>>>>> --- a/drivers/phy/Kconfig
>>>>>>>>>>>> +++ b/drivers/phy/Kconfig
>>>>>>>>>>>> @@ -389,4 +389,11 @@ config PHY_CYGNUS_PCIE
>>>>>>>>>>>>         Enable this to support the Broadcom Cygnus PCIe PHY.
>>>>>>>>>>>>         If unsure, say N.
>>>>>>>>>>>>
>>>>>>>>>>>> +config PHY_EXYNOS_UFS
>>>>>>>>>>>> +    tristate "EXYNOS SoC series UFS PHY driver"
>>>>>>>>>>>> +    depends on OF && ARCH_EXYNOS || COMPILE_TEST
>>>>>>>>>>>> +    select GENERIC_PHY
>>>>>>>>>>>> +    help
>>>>>>>>>>>> +      Support for UFS PHY on Samsung EXYNOS chipsets.
>>>>>>>>>>>> +
>>>>>>>>>>>>   endmenu
>>>>>>>>>>>> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
>>>>>>>>>>>> index 075db1a81aa5..9bec4d1a89e1 100644
>>>>>>>>>>>> --- a/drivers/phy/Makefile
>>>>>>>>>>>> +++ b/drivers/phy/Makefile
>>>>>>>>>>>> @@ -10,6 +10,7 @@ obj-$(CONFIG_ARMADA375_USBCLUSTER_PHY)    +=
>>>>>>>>>>>> phy-armada375-usb2.o
>>>>>>>>>>>>   obj-$(CONFIG_BCM_KONA_USB2_PHY)        += phy-bcm-kona-usb2.o
>>>>>>>>>>>>   obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)    += phy-exynos-dp-video.o
>>>>>>>>>>>>   obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)    += phy-exynos-mipi-video.o
>>>>>>>>>>>> +obj-$(CONFIG_PHY_EXYNOS_UFS)    += phy-exynos-ufs.o
>>>>>>>>>>>>   obj-$(CONFIG_PHY_LPC18XX_USB_OTG)    += phy-lpc18xx-usb-otg.o
>>>>>>>>>>>>   obj-$(CONFIG_PHY_PXA_28NM_USB2)        += phy-pxa-28nm-usb2.o
>>>>>>>>>>>>   obj-$(CONFIG_PHY_PXA_28NM_HSIC)        += phy-pxa-28nm-hsic.o
>>>>>>>>>>>> diff --git a/drivers/phy/phy-exynos-ufs.c
>>>>>>>>>>>> b/drivers/phy/phy-exynos-ufs.c
>>>>>>>>>>>> new file mode 100644
>>>>>>>>>>>> index 000000000000..cb1aeaa3d4eb
>>>>>>>>>>>> --- /dev/null
>>>>>>>>>>>> +++ b/drivers/phy/phy-exynos-ufs.c
>>>>>>>>>>>> @@ -0,0 +1,241 @@
>>>>>>>>>>>> +/*
>>>>>>>>>>>> + * UFS PHY driver for Samsung EXYNOS SoC
>>>>>>>>>>>> + *
>>>>>>>>>>>> + * Copyright (C) 2015 Samsung Electronics Co., Ltd.
>>>>>>>>>>>> + * Author: Seungwon Jeon <essuuj@gmail.com>
>>>>>>>>>>>> + *
>>>>>>>>>>>> + * This program is free software; you can redistribute it and/or
>>>>>>>>>>>> modify
>>>>>>>>>>>> + * it under the terms of the GNU General Public License as published
>>>>>>>>>>>> by
>>>>>>>>>>>> + * the Free Software Foundation; either version 2 of the License, or
>>>>>>>>>>>> + * (at your option) any later version.
>>>>>>>>>>>> + */
>>>>>>>>>>>> +#include <linux/clk.h>
>>>>>>>>>>>> +#include <linux/delay.h>
>>>>>>>>>>>> +#include <linux/err.h>
>>>>>>>>>>>> +#include <linux/io.h>
>>>>>>>>>>>> +#include <linux/iopoll.h>
>>>>>>>>>>>> +#include <linux/mfd/syscon.h>
>>>>>>>>>>>> +#include <linux/module.h>
>>>>>>>>>>>> +#include <linux/of.h>
>>>>>>>>>>>> +#include <linux/phy/phy.h>
>>>>>>>>>>>> +#include <linux/phy/phy-exynos-ufs.h>
>>>>>>>>>>>> +#include <linux/platform_device.h>
>>>>>>>>>>>> +#include <linux/regmap.h>
>>>>>>>>>>>> +
>>>>>>>>>>>> +#include "phy-exynos-ufs.h"
>>>>>>>>>>>> +
>>>>>>>>>>>> +#define for_each_phy_lane(phy, i) \
>>>>>>>>>>>> +    for (i = 0; i < (phy)->lane_cnt; i++)
>>>>>>>>>>>> +#define for_each_phy_cfg(cfg) \
>>>>>>>>>>>> +    for (; (cfg)->id; (cfg)++)
>>>>>>>>>>>> +
>>>>>>>>>>>> +#define PHY_DEF_LANE_CNT    1
>>>>>>>>>>>> +
>>>>>>>>>>>> +static void exynos_ufs_phy_config(struct exynos_ufs_phy *phy,
>>>>>>>>>>>> +            const struct exynos_ufs_phy_cfg *cfg, u8 lane)
>>>>>>>>>>>> +{
>>>>>>>>>>>> +    enum {LANE_0, LANE_1}; /* lane index */
>>>>>>>>>>>> +
>>>>>>>>>>>> +    switch (lane) {
>>>>>>>>>>>> +    case LANE_0:
>>>>>>>>>>>> +        writel(cfg->val, (phy)->reg_pma + cfg->off_0);
>>>>>>>>>>>> +        break;
>>>>>>>>>>>> +    case LANE_1:
>>>>>>>>>>>> +        if (cfg->id == PHY_TRSV_BLK)
>>>>>>>>>>>> +            writel(cfg->val, (phy)->reg_pma + cfg->off_1);
>>>>>>>>>>>> +        break;
>>>>>>>>>>>> +    }
>>>>>>>>>>>> +}
>>>>>>>>>>>> +
>>>>>>>>>>>> +static bool match_cfg_to_pwr_mode(u8 desc, u8 required_pwr)
>>>>>>>>>>>> +{
>>>>>>>>>>>> +    if (IS_PWR_MODE_ANY(desc))
>>>>>>>>>>>> +        return true;
>>>>>>>>>>>> +
>>>>>>>>>>>> +    if (IS_PWR_MODE_HS(required_pwr) && IS_PWR_MODE_HS_ANY(desc))
>>>>>>>>>>>> +        return true;
>>>>>>>>>>>> +
>>>>>>>>>>>> +    if (COMP_PWR_MODE(required_pwr, desc))
>>>>>>>>>>>> +        return true;
>>>>>>>>>>>> +
>>>>>>>>>>>> +    if (COMP_PWR_MODE_MD(required_pwr, desc) &&
>>>>>>>>>>>> +        COMP_PWR_MODE_GEAR(required_pwr, desc) &&
>>>>>>>>>>>> +        COMP_PWR_MODE_SER(required_pwr, desc))
>>>>>>>>>>>> +        return true;
>>>>>>>>>>>> +
>>>>>>>>>>>> +    return false;
>>>>>>>>>>>> +}
>>>>>>>>>>>> +
>>>>>>>>>>>> +int exynos_ufs_phy_calibrate(struct phy *phy,
>>>>>>>>>>>> +                    enum phy_cfg_tag tag, u8 pwr)
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> This is similar to the first version of your patch without
>>>>>>>>>>> EXPORT_SYMBOL.
>>>>>>>>>>>
>>>>>>>>>>> I think you have to create a new generic PHY_OPS for calibrate PHY while
>>>>>>>>>>> making
>>>>>>>>>>> sure that it is as generic as possible (which means calibrate_phy
>>>>>>>>>>> shouldn't
>>>>>>>>>>> have tag and pwr arguments or a strong justification as to why those
>>>>>>>>>>> arguments
>>>>>>>>>>> are required in a generic API).
>>>>>>>>>>
>>>>>>>>>> I don't see the advantage to making this a generic phy_ops, this is
>>>>>>>>>> exynos
>>>>>>>>>> specific ufs-phy, please have a look at other implementations
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> only the implementation is specific to exynos. I've seen lot of other
>>>>>>>>> vendors
>>>>>>>>> want to do something like calibrate phy.
>>>>>>>>>
>>>>>>>>> So if we add something like (*calibrate)(struct phy *phy), then it can be
>>>>>>>>> used
>>>>>>>>> by others as well. Russell King also want to minimize the code to program
>>>>>>>>> calibration settings. So it would be good to come up with a set of
>>>>>>>>> standard
>>>>>>>>> bindings like 'phy,tx-swing', 'phy,emphasis', 'phy,amplitude' etc.. to
>>>>>>>>> program
>>>>>>>>> these settings.
>>>>>>>>>>
>>>>>>>>>> drivers/phy/phy-qcom-ufs.c (which I belive mereged recently)
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> Thats why I hate when someone else merge PHY drivers :-( That driver can
>>>>>>>>> as
>>>>>>>>> well be in drivers/misc as it doesn't use PHY framework as it is supposed
>>>>>>>>> to be
>>>>>>>>> used. It just exports a dozen of API's to be used by controller drivers.
>>>>>>>>> ick..
>>>>>>>>>
>>>>>>>>>> may be other vendors might come with there own implementation of phy.
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> right, it's all about providing the correct callback functions.
>>>>>>>>>>
>>>>>>>>>> I am using what is currently provided by the generic phy framework.
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> I think for your use case, what is currently provided in the PHY framework
>>>>>>>>> is
>>>>>>>>> not sufficient.
>>>>>>>>>
>>>>>>>> Its little over a year since last time we discuss about adding a generic
>>>>>>>> calibration API. I can see in the past people tried adding *calibration* API
>>>>>>>> [1] but not sure why [1] was not landed in mainline.
>>>>>>>> Anyway now we have many users of phy_calibration API, like UFS, USB and may
>>>>>>>> be PCIe, there is a real need to add this functionality. So, here is my
>>>>>>>> approach:
>>>>>>
>>>>>> Agree, there are quite a few users that require calibration of phy parameters.
>>>>>> I think previously it was accommodated in phy_init, hence it was not merged.
>>>>> Ok, thanks for this information.
>>>>>
>>>>>>>>  * Along with [1], we can add a void *priv for handling device specific phy
>>>>>>>> private data, and before calling phy_calibration() from phy consumer,
>>>>>>>> phy->priv is populated with private data.
>>>>>>
>>>>>> Not sure how you plan to use priv here?
>>>>>>
>>>>>  From ufs driver I am populating PHY _priv_ data and calling phy_calibrate()
>>>>>
>>>>> e.g
>>>>> ----------------------- from ufs-exynos.c
>>>>> Instead of using below code earlier
>>>>> - exynos_ufs_phy_calibrate(generic_phy,CFG_PRE_INIT,PWR_MODE_ANY);
>>>>>
>>>>> Now I am using below from ufs-exynos driver
>>>>>
>>>>> + generic_phy->priv =(void*)CFG_PRE_INIT;
>>>>> + phy_calibrate(generic_phy);
>>>>>
>>>>> and in drivers/phy/phy-exynos-ufs.c
>>>>> using phy->priv in calibration function.
>>>>
>>>> Don't prefer passing of such private pointers between drivers. Why is this needed?
>>>>
>>> As already explained before, this is needed to pass the calibration
>>> point (when you want to do the calibration?, like before init, after
>>> init or before/after _mode_ change etc).
>>>
>>> I Don't think we have much option here, if we want to make
>>> phy_calibration generic enough.
>>>
>>> We have few options:
>>> 1> One way is to have phy_calibration takes some argument like
>>> calibration point (which was part of  my v3~v5), but looking at the
>>> current implementation of phy-qcom-ufs.c, this approach might not be
>>> generic enough.
>>>
>>> 2> And using EXPORT_SYMBOL way is not encourage (as in my V1, even
>>> though others in phy drivers uses it).
>>>
>>> 3> the current proposal of using _priv_ data.
>>>
>>> Out of the above 3 option, I feel using _priv_ data is more generic way
>>> (and most of the major sub-system in Linux uses it).
>>>
>>> lets see what other people think about __priv__ approach.
>>>
>>> Please suggest your prefer way to handle this.
>>
>> Generally calibration has to be done at a single point. Having to do
>> calibration in multiple places seems to be specific to Exynos.
>>
> Ok, calibration as such in not Exynos specific, calibration point may be.
>> Can implementing a small state machine in exynos driver help?
>>
> Sorry I didn't get you here. What do mean by implement a state machine? 
> when it can be easy handled with the proposed generic _calibration_ 
> method. Why to complicate the thing?

I meant implementing a state machine instead of passing the _priv_ pointer in
calibrate ops. IIUC the _priv_ pointer is used to perform different settings
based on different calibration points? Instead of _priv_ pointer, maintain a
state machine within the driver and based on the current state, the calibrate
ops should perform different settings,
> 
> You said, you "don't prefer passing a _priv_ pointer between driver", 
> can you please explain why? what is the potential problem do you see 
> with _priv_ pointer?

It's easy to start abusing such API's. One driver can pass an address in it's
address space to be written by another driver. Moreover it's better to have
clearly defined API's and arguments so that it's easier to review/test/debug.

> 
> Look at the current implementation of 
> "drivers/phy/phy-qcom-ufs-qmp-14nm.c" they have used "specific ops for 
> Phy" and that too with the EXPORT_SYMBOL, don't you think this can be 
> correct if we have a generic phy_calibration call back?

yes, that has to be cleaned up as well.

Thanks
Kishon

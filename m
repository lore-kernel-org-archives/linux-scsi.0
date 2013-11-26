From: Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH v3 3/4] ata: Add APM X-Gene SoC SATA host controller driver
Date: Tue, 26 Nov 2013 15:41:41 +0530
Message-ID: <529473DD.1090804@ti.com>
References: <1384465153-29902-1-git-send-email-lho@apm.com>	<1384465153-29902-3-git-send-email-lho@apm.com>	<1384465153-29902-4-git-send-email-lho@apm.com>	<201311151448.16279.arnd@arndb.de>	<CAPw-ZTmaz3nnV3ThRgecT_RaYYW0bmfWvL8Kr-S3z1aKyUWc+w@mail.gmail.com> <CAPw-ZTn1N7+EFu9L6U+P9=9ii3k1BjycYXdNCdxCVPb8SaJWxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:50963 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab3KZKMS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Nov 2013 05:12:18 -0500
In-Reply-To: <CAPw-ZTn1N7+EFu9L6U+P9=9ii3k1BjycYXdNCdxCVPb8SaJWxA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Loc Ho <lho@apm.com>, Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>, Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Jon Masters <jcm@redhat.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

Hi,

On Wednesday 20 November 2013 02:52 AM, Loc Ho wrote:
> Hi Kishon,
> 
>>>> +
>>>> +/* Temporary function until the PHY parameter API */
>>>> +extern void xgene_ahci_phy_set_pq(struct phy *phy, int chan, int data);
>>>> +extern void xgene_ahci_phy_set_spd(struct phy *phy, int chan, int gen);
>>>
>>> Ah, that should have been mentioned in the changeset text. Do you think you
>>> can remove these for the final version?
>> [Loc Ho]
>> Yes... Krishon, can you provide an patch that allows me to accommodate
>> this? Or should I come up one? I will trying to get rip of the first
>> one. But I will need the function to set the PHY speed - for
>> Gen2/Gen1. Let's plan on add these function:
>>
>> a. int (*set_speed)(int gen_speed) where gen_speed is either AUTO,
>> GEN1, GEN2, or GEN3.
>> b. Change the PHY init function to take an optional parameter. This
>> would help my first function in case I can get rip of it.
>>
> [Loc Ho]
> I will provide this patch as part of my next version to include an
> function as follow:

sure..
> 
> int set_speed(struct *phy, int lane, u64 speed);

it should be phy_set_speed.
> 
> where lane indicates the lane of the PHY and speed is the PHY speed in hertz.

Does lane here means the number of lanes? Is the lane also obtained after the
training sequence?

Thanks
Kishon

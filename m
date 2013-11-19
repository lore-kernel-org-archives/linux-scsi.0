From: Loc Ho <lho@apm.com>
Subject: Re: [PATCH v3 3/4] ata: Add APM X-Gene SoC SATA host controller driver
Date: Tue, 19 Nov 2013 13:22:44 -0800
Message-ID: <CAPw-ZTn1N7+EFu9L6U+P9=9ii3k1BjycYXdNCdxCVPb8SaJWxA@mail.gmail.com>
References: <1384465153-29902-1-git-send-email-lho@apm.com>
	<1384465153-29902-3-git-send-email-lho@apm.com>
	<1384465153-29902-4-git-send-email-lho@apm.com>
	<201311151448.16279.arnd@arndb.de>
	<CAPw-ZTmaz3nnV3ThRgecT_RaYYW0bmfWvL8Kr-S3z1aKyUWc+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAPw-ZTmaz3nnV3ThRgecT_RaYYW0bmfWvL8Kr-S3z1aKyUWc+w@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Kishon Vijay Abraham I <kishon@ti.com>
Cc: Olof Johansson <olof@lixom.net>, Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Jon Masters <jcm@redhat.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

Hi Kishon,

>>> +
>>> +/* Temporary function until the PHY parameter API */
>>> +extern void xgene_ahci_phy_set_pq(struct phy *phy, int chan, int data);
>>> +extern void xgene_ahci_phy_set_spd(struct phy *phy, int chan, int gen);
>>
>> Ah, that should have been mentioned in the changeset text. Do you think you
>> can remove these for the final version?
> [Loc Ho]
> Yes... Krishon, can you provide an patch that allows me to accommodate
> this? Or should I come up one? I will trying to get rip of the first
> one. But I will need the function to set the PHY speed - for
> Gen2/Gen1. Let's plan on add these function:
>
> a. int (*set_speed)(int gen_speed) where gen_speed is either AUTO,
> GEN1, GEN2, or GEN3.
> b. Change the PHY init function to take an optional parameter. This
> would help my first function in case I can get rip of it.
>
[Loc Ho]
I will provide this patch as part of my next version to include an
function as follow:

int set_speed(struct *phy, int lane, u64 speed);

where lane indicates the lane of the PHY and speed is the PHY speed in hertz.

-Loc

From: zhangfei <zhangfei.gao@linaro.org>
Subject: Re: [PATCH 09/25] scsi: hisi_sas: add phy SAS ADDR initialization
Date: Thu, 15 Oct 2015 11:36:53 +0800
Message-ID: <561F1F55.9070606@linaro.org>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com> <561E1501.2070507@suse.de> <561E6F31.9050804@huawei.com> <5841294.bjnFQrbOU2@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35139 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703AbbJODg7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Oct 2015 23:36:59 -0400
Received: by pacao1 with SMTP id ao1so8766604pac.2
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2015 20:36:59 -0700 (PDT)
In-Reply-To: <5841294.bjnFQrbOU2@wuerfel>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, John Garry <john.garry@huawei.com>
Cc: Hannes Reinecke <hare@suse.de>, James.Bottomley@hansenpartnership.com, devicetree@vger.kernel.org, linuxarm@huawei.com, linux-scsi@vger.kernel.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie



On 10/14/2015 11:18 PM, Arnd Bergmann wrote:
> On Wednesday 14 October 2015 16:05:21 John Garry wrote:
>>
>> OK, we can look at adding the ability to read the SAS HBA address from a
>> FW image or EFI variables.
>>
>
> The easiest way is usually to have a DT property that gets updated
> by the firmware.
>

Yes
In net subsystem, there is mac-address.

In dts, we set default mac-address, which will be modified by 
boot-loader, if all 0 random address will be used.
mac-address = [00 00 00 00 00 00];

In driver, mac-address can be get via of_get_mac_address.

Can we use the similar method here?

Thanks

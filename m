From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 09/25] scsi: hisi_sas: add phy SAS ADDR initialization
Date: Thu, 15 Oct 2015 10:43:11 +0200
Message-ID: <10528737.V03dqLA43T@wuerfel>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com> <5841294.bjnFQrbOU2@wuerfel> <561F1F55.9070606@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:54113 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbbJOIn3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Oct 2015 04:43:29 -0400
In-Reply-To: <561F1F55.9070606@linaro.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: zhangfei <zhangfei.gao@linaro.org>
Cc: John Garry <john.garry@huawei.com>, Hannes Reinecke <hare@suse.de>, James.Bottomley@hansenpartnership.com, devicetree@vger.kernel.org, linuxarm@huawei.com, linux-scsi@vger.kernel.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie

On Thursday 15 October 2015 11:36:53 zhangfei wrote:
> On 10/14/2015 11:18 PM, Arnd Bergmann wrote:
> > On Wednesday 14 October 2015 16:05:21 John Garry wrote:
> >>
> >> OK, we can look at adding the ability to read the SAS HBA address from a
> >> FW image or EFI variables.
> >>
> >
> > The easiest way is usually to have a DT property that gets updated
> > by the firmware.
> >
> 
> Yes
> In net subsystem, there is mac-address.
> 
> In dts, we set default mac-address, which will be modified by 
> boot-loader, if all 0 random address will be used.
> mac-address = [00 00 00 00 00 00];
> 
> In driver, mac-address can be get via of_get_mac_address.
> 
> Can we use the similar method here?

Good idea, I think this is the best way.

	Arnd

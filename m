From: edwin_rong <edwin_rong@realsil.com.cn>
Subject: Re: Is it possible for Realtek card reader driver to reside in SCSIsubsystem?
Date: Mon, 23 Apr 2012 16:00:11 +0800
Message-ID: <4F950C0B.10804@realsil.com.cn>
References: <4F94D132.7070109@realsil.com.cn> <1335166767.3051.4.camel@dabdike.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([60.250.210.242]:35660 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab2DWIA0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Apr 2012 04:00:26 -0400
In-Reply-To: <1335166767.3051.4.camel@dabdike.lan>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@suse.de" <gregkh@suse.de>, =?UTF-8?B?546L54Kc?= <wei_wang@realsil.com.cn>

On 04/23/2012 03:39 PM, James Bottomley wrote:
> On Mon, 2012-04-23 at 11:49 +0800, edwin_rong wrote:
>> Dear James and all :
>>
>> Sorry to disturb you again!
>>
>> I'm an software engineer of Realtek corporation, responsible for writing
>> driver for Realtek Card Reader chips.
>>
>> Our device supports SD/MMC/MS/MSpro/xD series of cards, etc., which is
>> implemented as an SCSI device in our driver,
>> and now our driver rts_pstor is under staging folder of linux kernel, so
>> I want to know whether it is possible to move it out of staging folder,
>> and reside in SCSI subsystem?
>>
>> I also know that both "mmc" and "memstick" subsystem exist in kernel
>> now, but our device is a composition of these types of cards,
>> so it seems not suitable for keeping our driver there.
>>
>> All replies are appreciated.
> The general rule is that if the device itself speaks SCSI ... as in
> either the firmware or the underlying disk does, then you should be
> using SCSI (This doesn't mean you have to have an actual SCSI device
> anywhere ... lots of USB devices are some wierd flash or IDE device
> fronted by a chip that does SCSI<->whatever translation [usually
> badly]).  Conversely if you would be writing your SCSI command emulation
> in the driver, don't ... you should be using another subsystem.
>
> James
>
Dear James,

Got it, thanks for your response, sincerely.

As to my case, which subsystem do you think is fit for our driver to 
stay, could you give me some suggestions?

Thanks & BRs
Edwin


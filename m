From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: Re: scsi-next fail to be compiled
Date: Wed, 28 Jul 2010 15:54:53 +0530
Message-ID: <BB2B56E9-3B01-4BC4-ADDA-C92E7BA71728@qlogic.com>
References: <4C4F2BC0.6030905@kernel.org> ,<1280257446.2833.268.camel@mulgrave.site> <5E4F49720D0BAD499EE1F01232234BA871287C9628@AVEXMB1.qlogic.org> <1280263949.2833.441.camel@mulgrave.site>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset="US-ASCII"; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:47206 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab0G1KZA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jul 2010 06:25:00 -0400
In-Reply-To: <1280263949.2833.441.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@suse.de>
Cc: Ravi Anand <ravi.anand@qlogic.com>, Yinghai Lu <yinghai@kernel.org>, Karen Higgins <karen.higgins@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Jul 28, 2010, at 2:22 AM, James Bottomley wrote:

> On Tue, 2010-07-27 at 13:45 -0700, Ravi Anand wrote:
>>
>>> On Tue, 2010-07-27 James Bottomley wrote:
>>> On Tue, 2010-07-27 at 11:56 -0700, Yinghai Lu wrote:
>>> LD      drivers/scsi/built-in.o
>>> drivers/scsi/qla4xxx/built-in.o: In function `qla82xx_idc_unlock':
>>> (.text+0x8814): multiple definition of `qla82xx_idc_unlock'
>>> drivers/scsi/qla2xxx/built-in.o:(.text+0x2ea14): first defined here
>>> drivers/scsi/qla2xxx/built-in.o:(.text+0x30c56): first defined here
>>> make[1]: *** [drivers/scsi/built-in.o] Error 1
>>> make: *** [drivers/scsi/] Error 2
>>
>>> This is because exactly the same functions appear in the qla2xxx/  
>>> and
>>> qla4xxx/ directories
>>
>>> Qlogic people, please get this sorted out now, otherwise I'll drop  
>>> the
>>> qla4xxx update before sending to Linus
>>
>> We will try to resolve this ASAP.
>
> Thanks
>
>>  When are you planning to send it to Linus ?
>
> Whenever he opens the merge window ... he's been making noises like it
> will be this week.
>
>>> The best option would be to separate out the 82xx functions so  
>>> that both
>>> 2xxx and 4xxx can use them.  In the interim, you could add a
>>> discriminator prefix.
>>
>> We will put in discriminator prefix and  repost the patches.
>
> Just the one patch that adds the 82xx support, if possible ... that  
> way
> I can just swap the bad one out.

I am sending new 82xx support patch in next mail which address this  
issue.
We added new discriminator prefix "qla4_8xxx_*" for qla4xxx drive  
module.

Please swap new 82xx patch with earlier patch.

Thanks,
Vikas.

>
> James
>
>
>


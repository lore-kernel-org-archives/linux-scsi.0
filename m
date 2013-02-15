From: merez@codeaurora.org
Subject: Re: [PATCH V6 0/4] [SCSI] ufs: Adds glue drivers to ufshcd
Date: Fri, 15 Feb 2013 14:30:03 -0800
Message-ID: <340aa7e0584e68b3066f20ed54d64fda.squirrel@www.codeaurora.org>
References: <511137ce.0657420a.5b57.ffffa7db@mx.google.com>
    <CAKVbJB8=HU=Rc7u2siKSQmKQf461=dz0v-k2Ww6XMZdUBTQkcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40109 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab3BOWaE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Feb 2013 17:30:04 -0500
In-Reply-To: <CAKVbJB8=HU=Rc7u2siKSQmKQf461=dz0v-k2Ww6XMZdUBTQkcA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, santoshsy@gmail.com, patches@linaro.org, linux-samsung-soc@vger.kernel.org, arnd@linaro.org, venkat@linaro.org, subhashj@codeaurora.org, sthumma@codeaurora.org, vinholikatti@gmail.com

Tested-by: Maya Erez <merez@codeaurora.org>

> Hi James,
>
> look like these patches are fine. Can you please integrate these
> patches in your tree.
>
>
> On Tue, Feb 5, 2013 at 10:17 PM,  <vinholikatti@gmail.com> wrote:
>> From: Vinayak Holikatti <vinholikatti@gmail.com>
>>
>> This patch set adds following features
>>  - Seggregate PCI specific code in ufshcd.c and corrected copyright
>>  - Adds PCI glue driver ufshcd-pci.c and ufshcd.c become core module
>>  - Adds Platform glue driver ufshcd-pltfrm.c
>>  - Update correct transfer size in Command UPIU
>>
>> Vinayak Holikatti (4):
>>   [SCSI] drivers/scsi/ufs: Seggregate PCI Specific Code
>>   [SCSI] drivers/scsi/ufs: Separate PCI code into glue driver
>>   [SCSI] ufs: Add Platform glue driver for ufshcd
>>   [SCSI] ufs: Correct the expected data transfersize
>>
>>  drivers/scsi/ufs/Kconfig         |   87 +++++---
>>  drivers/scsi/ufs/Makefile        |    2 +
>>  drivers/scsi/ufs/ufs.h           |   44 ++---
>>  drivers/scsi/ufs/ufshcd-pci.c    |  211 +++++++++++++++++++
>>  drivers/scsi/ufs/ufshcd-pltfrm.c |  217 +++++++++++++++++++
>>  drivers/scsi/ufs/ufshcd.c        |  426
>> ++++++++------------------------------
>>  drivers/scsi/ufs/ufshcd.h        |  202 ++++++++++++++++++
>>  drivers/scsi/ufs/ufshci.h        |   44 ++---
>>  8 files changed, 811 insertions(+), 422 deletions(-)
>>  create mode 100644 drivers/scsi/ufs/ufshcd-pci.c
>>  create mode 100644 drivers/scsi/ufs/ufshcd-pltfrm.c
>>  create mode 100644 drivers/scsi/ufs/ufshcd.h
>>
>> --
>> 1.7.5.4
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Maya Erez
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation


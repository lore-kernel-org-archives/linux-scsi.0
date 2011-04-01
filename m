From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 5/14] megaraid_sas: Fix probe_one to clear MSI-X flags
 in kdump
Date: Fri, 01 Apr 2011 18:31:19 +0200
Message-ID: <4D95FDD7.7070703@redhat.com>
References: <AANLkTimG4HbXCNUdkcpGHbP7D2oNmvymbyKMOkCFNxJD@mail.gmail.com>	<4D93227E.4040407@redhat.com> <AANLkTim2KJV9iz5SCExNfKD_Z+y6Nj34n3hE_jLhupr7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758266Ab1DAQ6u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2011 12:58:50 -0400
In-Reply-To: <AANLkTim2KJV9iz5SCExNfKD_Z+y6Nj34n3hE_jLhupr7@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

On 03/31/2011 08:50 PM, adam radford wrote:
> On Wed, Mar 30, 2011 at 5:30 AM, Tomas Henzl <thenzl@redhat.com> wrote:
>
>   
>> Hi Adam,
>> sorry I'm late, but this is still not applied I think.
>>     
> Yes, it is here:
>
> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=66192dfe1e74eae31a76cfc36092dabdba1324e6
>
>   
>> The above #define are already defined in msi.h and pci_regs.h
>> I'd prefer to include those files instead of define the values.
>>
>>     
> msi_control_reg() macro is defined in drivers/pci/msi.h _not_
> include/linux/msi.h.
>
> Are you suggesting I try to include drivers/pci/msi.h ?
>   
That doesn't look that good, probably better would be to put the definition
to some other place. The patch is already accepted and the priority for me low...

The PCI_MSIX_FLAGS_ENABLE is defined in pci_regs.h this is included in linux/pci.h and this is included 
in megaraid_sas_base.c - I think the definition could be simply removed from your patch, isn't it so?
Again this is low priority I expect no immediate action from you :)

Tomas

> -Adam
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   


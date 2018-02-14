From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] libsas: Fix kernel-doc headers
Date: Wed, 14 Feb 2018 16:29:39 +0000
Message-ID: <409ec182-c8bc-50e9-cd12-14abac4f8621@huawei.com>
References: <20180212184500.26562-1-bart.vanassche@wdc.com>
 <34669efa-8426-97f8-5054-03e3bfd7e922@huawei.com>
 <37878dc7-1000-9046-b29c-99bbd95ff326@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:37434 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1032397AbeBNQ34 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Feb 2018 11:29:56 -0500
In-Reply-To: <37878dc7-1000-9046-b29c-99bbd95ff326@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Linuxarm <linuxarm@huawei.com>

On 13/02/2018 17:49, Bart Van Assche wrote:
> On 02/13/18 02:17, John Garry wrote:
>> On 12/02/2018 18:45, Bart Van Assche wrote:
>>> [ ... ]
>>> -/**
>>> +/*
>>>   * sas_init_disc -- initialize the discovery struct in the port
>>>   * @port: pointer to struct port
>>
>> I wonder why you get no complaint that @disc argument is not mentioned,
>

Hi Bart,

> Hello John,
>
> Since I was not sure how to document the 'disc' argument I changed /**
> into /* to make the kernel-doc tool skip the sas_init_disc() function.
> Any suggestion for how to document the 'disc' argument would be welcome.

I see now.

For this @disc pointer, I would just write "port discovery structure".

In fact I think that we could just change the code to accept the @port 
argument, as the @disc argument is the port->disc. But that's another job.

>
>>>
>>> -/**
>>> +/*
>>>   * sas_configure_parent -- configure routing table of parent
>>> - * parent: parent expander
>>> - * child: child expander
>>> - * sas_addr: SAS port identifier of device directly attached to child
>>> + * @parent: parent expander
>>> + * @child: child expander
>>> + * @sas_addr: SAS port identifier of device directly attached to child
>>
>> and no mention of @include here
>
> Also for the 'include' argument, a suggestion of how to document it
> would be welcome.

To be honest, I am not so fimilar with this specific part of the code.

As I see, the @include argument is to flag whether we want to setup or 
tear down a routing for parent (upstream) expander device.

I am not 100% sure on this so you could stick with making it a 
non-kerneldoc comments. It is static.

>
>>>  /**
>>>   * sas_revalidate_domain -- revalidate the domain
>>
>> This function name seems incorrect. [ ... ]  And I would write "port
>> domain device"
>
> Thanks, will fix.
>
>>> -/**
>>> +/*
>>
>> If the build does not complain about this for W=1, then should we
>> include it? I ask, as I see many other instances of "/**". I don't
>> mind cleaning them up in a separate patch.
>
> The kernel-doc tool only analyzes function headers that start with
> "/**". Any changes of "/**" into "/*" mean that I did not know how to
> document the arguments about which the kernel-doc tool complained that
> documentation was missing.
>
> Thanks,
>
> Bart.
>
> .

Regards,
John

>

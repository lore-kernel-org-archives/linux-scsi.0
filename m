From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [PATCH] libsas: Fix kernel-doc headers
Date: Tue, 13 Feb 2018 09:49:14 -0800
Message-ID: <37878dc7-1000-9046-b29c-99bbd95ff326@wdc.com>
References: <20180212184500.26562-1-bart.vanassche@wdc.com>
 <34669efa-8426-97f8-5054-03e3bfd7e922@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:19644 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965426AbeBMRtV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Feb 2018 12:49:21 -0500
In-Reply-To: <34669efa-8426-97f8-5054-03e3bfd7e922@huawei.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Linuxarm <linuxarm@huawei.com>

On 02/13/18 02:17, John Garry wrote:
> On 12/02/2018 18:45, Bart Van Assche wrote:
>> [ ... ]
>> -/**
>> +/*
>>   * sas_init_disc -- initialize the discovery struct in the port
>>   * @port: pointer to struct port
> 
> I wonder why you get no complaint that @disc argument is not mentioned, 

Hello John,

Since I was not sure how to document the 'disc' argument I changed /** 
into /* to make the kernel-doc tool skip the sas_init_disc() function. 
Any suggestion for how to document the 'disc' argument would be welcome.

>>
>> -/**
>> +/*
>>   * sas_configure_parent -- configure routing table of parent
>> - * parent: parent expander
>> - * child: child expander
>> - * sas_addr: SAS port identifier of device directly attached to child
>> + * @parent: parent expander
>> + * @child: child expander
>> + * @sas_addr: SAS port identifier of device directly attached to child
> 
> and no mention of @include here

Also for the 'include' argument, a suggestion of how to document it 
would be welcome.

>>  /**
>>   * sas_revalidate_domain -- revalidate the domain
> 
> This function name seems incorrect. [ ... ]  And I would write "port domain device"

Thanks, will fix.

>> -/**
>> +/*
> 
> If the build does not complain about this for W=1, then should we 
> include it? I ask, as I see many other instances of "/**". I don't mind 
> cleaning them up in a separate patch.

The kernel-doc tool only analyzes function headers that start with 
"/**". Any changes of "/**" into "/*" mean that I did not know how to 
document the arguments about which the kernel-doc tool complained that 
documentation was missing.

Thanks,

Bart.

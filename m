From: John Garry <john.garry@huawei.com>
Subject: Re: SSP frame iu defines
Date: Thu, 8 Oct 2015 15:47:36 +0100
Message-ID: <56168208.2020404@huawei.com>
References: <56167B0D.5040303@huawei.com> <5172892.J8LUuCdX1I@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:5000 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933257AbbJHOsC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Oct 2015 10:48:02 -0400
In-Reply-To: <5172892.J8LUuCdX1I@wuerfel>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, hare@suse.de, zhangfei <zhangfei.gao@linaro.org>, john.garry2@mail.dcu.ie, "xuwei (O)" <xuwei5@hisilicon.com>

On 08/10/2015 15:22, Arnd Bergmann wrote:
> On Thursday 08 October 2015 15:17:49 John Garry wrote:
>> Hi,
>>
>> For a new driver I am preparing for a SAS controller, I need defintions
>> for the SSP command and TMF iu structures. Currently these are defined
>> in the following:
>> ssp_command_iu, ssp_task_iu: drivers/scsi/aic94xx_sas.h
>> ssp_cmd_iu, ssp_task_iu: drivers/scsi/isci/sas.h
>>
>> I plan to move them to include/scsi/sas.h . Any objections?
>
> Hi John,
>
> I think a question like this is better asked by sending a patch,
> to make it easier to see what the resulting change is.
>
> 	Arnd
>
>
OK, can I put this together.
I feel that the code may get messy due to byte-ordering difference in 
isci versions.

Regards,
John


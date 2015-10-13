From: John Garry <john.garry@huawei.com>
Subject: Re: SSP frame iu defines
Date: Tue, 13 Oct 2015 18:17:32 +0100
Message-ID: <561D3CAC.7080305@huawei.com>
References: <56167B0D.5040303@huawei.com> <5172892.J8LUuCdX1I@wuerfel>
 <56168208.2020404@huawei.com> <1444661720.2205.5.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:52921 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932421AbbJMR2H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Oct 2015 13:28:07 -0400
In-Reply-To: <1444661720.2205.5.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Arnd Bergmann <arnd@arndb.de>, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, hare@suse.de, zhangfei <zhangfei.gao@linaro.org>, john.garry2@mail.dcu.ie, "xuwei (O)" <xuwei5@hisilicon.com>


>> OK, can I put this together.
>> I feel that the code may get messy due to byte-ordering difference in
>> isci versions.
>
> That's why we develop with the show me the code model.  Rather than
> arguing theoretically about whether something should or should not be
> done, you propose the actual change.  If it looks like a dog's breakfast
> and all attempts to clean it up fail, chances are it's a bad change and
> it won't go in.  However, if it looks good, chances are it will.
>
> James
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> .
>

There is a patch for this in "[PATCH 01/25] [SCSI] sas: centralise ssp 
frame information units".

Thanks,
John


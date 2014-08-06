From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 05/14] block: Deprecate the use of the term sector in
 the context of block integrity
Date: Wed, 06 Aug 2014 16:43:46 +0300
Message-ID: <53E23112.8060201@dev.mellanox.co.il>
References: <1406320469-29352-1-git-send-email-martin.petersen@oracle.com> <1406320469-29352-6-git-send-email-martin.petersen@oracle.com> <53E22E5E.3060107@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:47950 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaHFNnw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Aug 2014 09:43:52 -0400
Received: by mail-wi0-f169.google.com with SMTP id n3so9540905wiv.4
        for <linux-scsi@vger.kernel.org>; Wed, 06 Aug 2014 06:43:51 -0700 (PDT)
In-Reply-To: <53E22E5E.3060107@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On 8/6/2014 4:32 PM, Sagi Grimberg wrote:
> On 7/25/2014 11:34 PM, Martin K. Petersen wrote:
>> The protection interval is not necessarily tied to the logical block
>> size of a block device. Stop using the terms "sector" and "sectors".
>>
>> Going forward we will use the term "seed" to describe the initial
>> reference tag value for a given I/O. "Interval" will be used to describe
>> the portion of the data buffer that a given piece of protection
>> information is associated with.
>>
>> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
>
> Looks good to me,
>
> Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
>

Following this patch we should modify scsi layer to compute with
interval instead of sector_size.

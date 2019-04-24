From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 0/6] libsas: Some minor improvements and tidy-up
Date: Wed, 24 Apr 2019 21:00:28 +0100
Message-ID: <4a597316-4d52-13bb-35ce-676350b19f5d@huawei.com>
References: <1555059478-36224-1-git-send-email-john.garry@huawei.com>
 <yq1v9zehmij.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1v9zehmij.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jejb@linux.vnet.ibm.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, yanaijie@huawei.com, chenxiang66@hisilicon.com, luojiaxing@huawei.com
List-Id: linux-scsi@vger.kernel.org

On 16/04/2019 00:33, Martin K. Petersen wrote:
>
> John,
>
>> This patchset introduces some minor improvements and tidy-up, including:
>> - fix PHY info in sysfs for PHY events
>> - min pathway rate programming improvement
>> - some other tidy-up and neatening
>
> Applied to 5.2/scsi-queue, thanks!
>

Hi Martin,

Sorry for the slow response.

> One thing that always bugged me is the ambiguous "ex" prefix for many
> libsas log messages.And in a way, your patch #3 makes things worse by
> replacing the more descriptive "Expander" with "ex". It does make things
> more consistent, though.

OK, understood. Personally I prefer the brevity of "ex". However, apart 
from this, adding the SAS address to the log does add value.

>
> I'd really like to see all the libsas messages be cleaned up with a
> sensible prefix and a consistent format where possible.

So all libsas messages do have the "sas: " prefix, but they still can be 
vague/inconsistent at times.

Anyway, I'll check what can be done here.

Thanks,


>

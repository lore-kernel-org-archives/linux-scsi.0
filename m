From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: libsas, lldds: Use dev_is_expander()
Date: Fri, 7 Jun 2019 14:29:45 +0100
Message-ID: <fcc8598c-00c7-52be-3bb3-5296c825658a@huawei.com>
References: <1559751143-168560-1-git-send-email-john.garry@huawei.com>
 <yq1k1dymkyh.fsf@oracle.com> <yq1v9xhjzl9.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1v9xhjzl9.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jejb@linux.ibm.com, intel-linux-scu@intel.com, artur.paszkiewicz@intel.com, jinpu.wang@profitbricks.com, lindar_liu@usish.com, yanaijie@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

On 07/06/2019 14:26, Martin K. Petersen wrote:
>
> John,
>
>>> Many times in libsas, and in LLDDs which use libsas, the check for an
>>> expander device is re-implemented or open coded.
>>
>> Applied to 5.3/scsi-queue, thanks.
>
> Dropped again. Breaks isci. Please fix.
>

Hi Martin,

I assume that you mean that it breaks the isci build. I thought that I 
did build it. Anyway, I'll check.

Thanks,
john

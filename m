From: Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH] scsi: switch to scsi-mq by default
Date: Wed, 11 Jul 2018 11:31:37 +0300
Message-ID: <6cf082e4-6fff-21dd-4df5-a6e9e4f2847c@intel.com>
References: <20180704085356.10888-1-jthumshirn@suse.de>
 <yq1d0vupjq2.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1d0vupjq2.fsf@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jthumshirn@suse.de>
Cc: Hannes Reinecke <hare@suse.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Ming Lei <tom.leiming@gmail.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 11/07/18 05:52, Martin K. Petersen wrote:
> 
> Johannes,
> 
>> It has been more than one year since we tried to change the default
>> from legacy to multi queue in SCSI with commit c279bd9e406 ("scsi:
>> default to scsi-mq"). But due to issues with suspend/resume and
>> performance problems it had been reverted again with commit
>> cbe7dfa26eee ("Revert "scsi: default to scsi-mq"").
>>
>> In the meantime there have been a substantial amount of performance
>> improvements and suspend/resume got fixed as well, thus we can
>> re-enable scsi-mq without a significant performance penalty.
> 
> Applied to 4.19/scsi-queue, thanks!
> 

But there is no runtime pm support, is there?  I tried enabling runtime PM
for UFS SCSI devices with scsi-mq and it didn't work, which is a regression.

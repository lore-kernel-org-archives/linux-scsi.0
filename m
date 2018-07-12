From: Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH] scsi: switch to scsi-mq by default
Date: Thu, 12 Jul 2018 09:17:33 +0300
Message-ID: <0f4af58b-5684-eba8-961a-b912a60befff@intel.com>
References: <20180704085356.10888-1-jthumshirn@suse.de>
 <yq1d0vupjq2.fsf@oracle.com> <6cf082e4-6fff-21dd-4df5-a6e9e4f2847c@intel.com>
 <CACVXFVOSssuveZDN185FUYpjX1i0ma59Cn30XBSJ1dAHDKLnLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACVXFVOSssuveZDN185FUYpjX1i0ma59Cn30XBSJ1dAHDKLnLQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 11/07/18 19:35, Ming Lei wrote:
> On Wed, Jul 11, 2018 at 4:31 PM, Adrian Hunter <adrian.hunter@intel.com> wrote:
>> On 11/07/18 05:52, Martin K. Petersen wrote:
>>>
>>> Johannes,
>>>
>>>> It has been more than one year since we tried to change the default
>>>> from legacy to multi queue in SCSI with commit c279bd9e406 ("scsi:
>>>> default to scsi-mq"). But due to issues with suspend/resume and
>>>> performance problems it had been reverted again with commit
>>>> cbe7dfa26eee ("Revert "scsi: default to scsi-mq"").
>>>>
>>>> In the meantime there have been a substantial amount of performance
>>>> improvements and suspend/resume got fixed as well, thus we can
>>>> re-enable scsi-mq without a significant performance penalty.
>>>
>>> Applied to 4.19/scsi-queue, thanks!
>>>
>>
>> But there is no runtime pm support, is there?  I tried enabling runtime PM
>> for UFS SCSI devices with scsi-mq and it didn't work, which is a regression.
> 
> I just posted one RFC patchset for supporting runtime PM on scsi_mq, and
> looks it works in my test on usb-storage.
> 
> https://marc.info/?l=linux-block&m=153132657922233&w=2

Cool, please cc me on the next revision of your patch set.

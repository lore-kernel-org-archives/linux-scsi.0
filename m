From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [GIT PULL] SCSI fixes for 4.13-rc6
Date: Thu, 24 Aug 2017 09:49:55 +0900
Message-ID: <90e92658-eb4b-8f32-6dd3-b5fd0c229fdc@wdc.com>
References: <1503470559.2729.4.camel@HansenPartnership.com>
 <1503500560.2484.1.camel@wdc.com> <yq1vale9ueb.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1vale9ueb.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On 8/24/17 00:27, Martin K. Petersen wrote:
> 
> Hi Bart,
> 
>> Had you noticed that Damien had asked not to send the "sd_zbc: Write
>> unlock zone from sd_uninit_cmnd()" patch to Linus without my "scsi-mq:
>> Always unprepare before requeuing a request" patch?
> 
> He did change his mind later in that thread, though.
> 
> However, what's more important is that we still need a good version of
> your patch for 4.13. I took Brian's workaround for ipr but I still think
> Christoph's concerns need to be addressed for me to put your change back
> in.

Yes, I did ask for the patch to be kept since it does not make things
worse for the SMR/mq case (still have a potential dispatch deadlock) but
does cleanup the code in the legacy/sq case.

Since it looks like the jiffies_at_alloc and retry counter
initialization fixes are progressing, we hopefully should be able to get
Bart's pacth back in soon (this week ?) and remove the mq dispatch deadlock.

Best regards.

-- 
Damien Le Moal,
Western Digital Research

From: Xiubo Li <lixiubo@cmss.chinamobile.com>
Subject: Re: [PATCH] tcmu: Fix possbile memory leak when recalculating thecmd
 base size
Date: Tue, 11 Jul 2017 17:37:58 +0800
Message-ID: <5d46280b-72f7-3dbf-23ac-25e2d75fe57c@cmss.chinamobile.com>
References: <1499760357-15120-1-git-send-email-lixiubo@cmss.chinamobile.com>
 <8284220f-3ec6-06db-8e09-127f997a774c@cmss.chinamobile.com>
 <1499765039.16582.3.camel@wdc.com>
 <1499765654.28145.59.camel@haakon3.daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1499765654.28145.59.camel@haakon3.daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: "mchristi@redhat.com" <mchristi@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "bryantly@linux.vnet.ibm.com" <bryantly@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org



On 2017年07月11日 17:34, Nicholas A. Bellinger wrote:
> On Tue, 2017-07-11 at 09:24 +0000, Damien Le Moal wrote:
>> Xiubo,
>>
>> Well done ! This fixed my problem. The ZBC test suite now passes all tests on
>> my target without crashing the kernel.
>>
>> Please see some comments/nitpicks below.
>>
>> Otherwise, please feel free to add my "tested-by"
>>
> Great, thanks for the quick turn-around.
>   
> Xiubo, please pick-up Damien's extra bits and repost for v2.  Also,
> please update the patch topic + commit log to mention it addresses a
> general protection fault OOPs, so others can find it easily when looking
> through git log.
>
> Damien's OOPs would probably be the best one to include in the commit
> log, since Bryant's was on POWER.  ;)
Sure, I will repost for v2 later.

> Btw, since it's a regression fix related to commit fe25cc34795, I assume
> it should be CC'ed to stable for v4.12.y, right..?
>
Yes, it is.

Thanks

BRs
Xiubo

From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [GIT PULL] SCSI fixes for 4.13-rc6
Date: Wed, 23 Aug 2017 11:27:24 -0400
Message-ID: <yq1vale9ueb.fsf@oracle.com>
References: <1503470559.2729.4.camel@HansenPartnership.com>
        <1503500560.2484.1.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1503500560.2484.1.camel@wdc.com> (Bart Van Assche's message of
        "Wed, 23 Aug 2017 15:02:42 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Hi Bart,

> Had you noticed that Damien had asked not to send the "sd_zbc: Write
> unlock zone from sd_uninit_cmnd()" patch to Linus without my "scsi-mq:
> Always unprepare before requeuing a request" patch?

He did change his mind later in that thread, though.

However, what's more important is that we still need a good version of
your patch for 4.13. I took Brian's workaround for ipr but I still think
Christoph's concerns need to be addressed for me to put your change back
in.

-- 
Martin K. Petersen	Oracle Linux Engineering

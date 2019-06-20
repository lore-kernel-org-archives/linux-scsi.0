From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] scsi: devinfo: BLIST_TRY_VPD_PAGES for SanDisk Cruzer Blade
Date: Thu, 20 Jun 2019 16:31:32 -0400
Message-ID: <yq18stwrobf.fsf@oracle.com>
References: <20190618013146.21961-1-marcos.souza.org@gmail.com>
        <20190618013146.21961-2-marcos.souza.org@gmail.com>
        <yq1r27quuod.fsf@oracle.com> <20190619094540.GA26980@continental>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190619094540.GA26980@continental> (Marcos Paulo de Souza's
        message of "Wed, 19 Jun 2019 06:45:43 -0300")
Sender: linux-kernel-owner@vger.kernel.org
To: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.ibm.com>
List-Id: linux-scsi@vger.kernel.org


Marcos,

>> What's your confidence level wrt. all Cruzer Blades handling this
>> correctly? How many devices have you tested this change with?
>
> I've tested three Cruzer Blades that I have at hand, and all of them
> have VPD support, and also checked with a friend of mine that also
> have one. I can't say about "all others" but so far, 4/4 devices that
> I tested have VPD. (They were all SPC-3 or SPC-4 compliant).

That's not a very large sample. However, SanDisk have traditionally been
pretty good wrt. spec compliance.

-- 
Martin K. Petersen	Oracle Linux Engineering

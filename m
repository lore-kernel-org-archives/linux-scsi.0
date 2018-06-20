From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sd: Optimal I/O size should be a multiple of physical block size
Date: Tue, 19 Jun 2018 21:29:41 -0400
Message-ID: <yq1lgbafdoa.fsf@oracle.com>
References: <207561f82d5638c8f513f9aaf970a07098bfbb0f.camel@scientia.net>
        <20180607015123.17862-1-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180607015123.17862-1-martin.petersen@oracle.com> (Martin
        K. Petersen's message of "Wed, 6 Jun 2018 21:51:23 -0400")
Sender: stable-owner@vger.kernel.org
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Christoph,

> It was reported that some devices report an OPTIMAL TRANSFER LENGTH of
> 0xFFFF blocks. That looks bogus, especially for a device with a
> 4096-byte physical block size.
>
> Ignore OPTIMAL TRANSFER LENGTH if it is not a multiple of the device's
> reported physical block size.

Did you get a chance to test the updated patch?

-- 
Martin K. Petersen	Oracle Linux Engineering

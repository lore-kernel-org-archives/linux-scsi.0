From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sd: fix entropy gathering for most rotational disks
Date: Tue, 12 Feb 2019 11:59:27 -0500
Message-ID: <yq1zhr1t028.fsf@oracle.com>
References: <1549987525.3173.17.camel@HansenPartnership.com>
        <e9a411a2-49e2-4897-4e02-1cf790465cbd@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e9a411a2-49e2-4897-4e02-1cf790465cbd@kernel.dk> (Jens Axboe's
        message of "Tue, 12 Feb 2019 09:06:29 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Xuewei Zhang <xueweiz@google.com>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Mikael Pettersson <mikpelinux@gmail.com>
List-Id: linux-scsi@vger.kernel.org


Jens,

>> The fix is to set the non-rotational and add-randomness flags
>> unconditionally early on in the disk initialization path, so they can
>> be reset only if the device actually reports being non-rotational via
>> the VPD page.
>
> Reviewed-by: Jens Axboe <axboe@kernel.dk>

Yeah, this looks good to me. I'll queue it up for fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering

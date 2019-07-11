From: James Bottomley <jejb@linux.ibm.com>
Subject: Re: [PATCH] scsi: aha1740: Use !x in place of NULL comparisons
Date: Thu, 11 Jul 2019 16:52:04 -0700
Message-ID: <1562889124.2915.5.camel@linux.ibm.com>
References: <20190711234833.27475-1-iamkeyur96@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190711234833.27475-1-iamkeyur96@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Keyur Patel <iamkeyur96@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2019-07-11 at 19:48 -0400, Keyur Patel wrote:
> Change (x == NULL) to !x and (x != NULL) to x, to fix
> following checkpatch.pl warnings:
> CHECK: Comparison to NULL could be written "!x".

This is one of our significantly older drivers.  We try not to touch it
unless we really have to, so I'd rather not have patches like this
applied to it.

I also don't really think the replacement adds anything to readability,
so it should probably be removed from the checkpatch warnings.

Thanks,

James

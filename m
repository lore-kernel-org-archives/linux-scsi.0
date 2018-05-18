From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: ufshcd: Remove VLA usage
Date: Fri, 18 May 2018 10:38:59 -0400
Message-ID: <yq1tvr5gha4.fsf@oracle.com>
References: <20180502235809.GA13998@beast>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180502235809.GA13998@beast> (Kees Cook's message of "Wed, 2
        May 2018 16:58:09 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Kees,

> On the quest to remove all VLAs from the kernel[1] this moves buffers
> off the stack. In the second instance, this collapses two separately
> allocated buffers into a single buffer, since they are used
> consecutively, which saves 256 bytes (QUERY_DESC_MAX_SIZE + 1) of
> stack space.

Applied to 4.18/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering

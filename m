From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: 3w-{sas,9xxx}: Use unsigned char for cdb
Date: Tue, 23 Oct 2018 21:29:03 -0400
Message-ID: <yq11s8ggmjk.fsf@oracle.com>
References: <20181018215541.4768-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181018215541.4768-1-natechancellor@gmail.com> (Nathan
        Chancellor's message of "Thu, 18 Oct 2018 14:55:41 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: Adam Radford <aradford@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Nathan,

> Clang warns a few times:
>
> drivers/scsi/3w-sas.c:386:11: warning: implicit conversion from 'int' to
> 'char' changes value from 128 to -128 [-Wconstant-conversion]
>         cdb[4] = TW_ALLOCATION_LENGTH; /* allocation length */
>                ~ ^~~~~~~~~~~~~~~~~~~~
>
> Update cdb's type to unsigned char, which matches the type of the cdb
> member in struct TW_Command_Apache.

Applied to 4.20/scsi-queue. Thank you.

-- 
Martin K. Petersen	Oracle Linux Engineering

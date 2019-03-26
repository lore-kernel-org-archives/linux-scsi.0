From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: gdth: Only call dma_free_coherent when buf is not NULL in ioc_general
Date: Mon, 25 Mar 2019 22:23:16 -0400
Message-ID: <yq1h8bqz84r.fsf@oracle.com>
References: <20190307231839.3330-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190307231839.3330-1-natechancellor@gmail.com> (Nathan
        Chancellor's message of "Thu, 7 Mar 2019 16:18:39 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Achim Leubner <achim_leubner@adaptec.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com, Nick Desaulniers <ndesaulniers@google.com>
List-Id: linux-scsi@vger.kernel.org


Nathan,

> When building with -Wsometimes-uninitialized, Clang warns:
>
> drivers/scsi/gdth.c:3662:6: warning: variable 'paddr' is used
> uninitialized whenever 'if' condition is false
> [-Wsometimes-uninitialized]
>
> Don't attempt to call dma_free_coherent when buf is NULL (meaning that
> we never called dma_alloc_coherent and initialized paddr), which avoids
> this warning.

Applied to 5.2/scsi-queue, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering

From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: libosd: Remove VLA usage
Date: Mon, 14 May 2018 22:33:27 -0400
Message-ID: <yq1o9hhmyvc.fsf@oracle.com>
References: <20180502225545.GA45533@beast>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180502225545.GA45533@beast> (Kees Cook's message of "Wed, 2
        May 2018 15:55:45 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Boaz Harrosh <ooo@electrozaur.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Kees,

> On the quest to remove all VLAs from the kernel[1] this rearranges the
> code to avoid a VLA warning under -Wvla (gcc doesn't recognize "const"
> variables as not triggering VLA creation). Additionally cleans up variable
> naming to avoid 80 character column limit.

Applied to 4.18/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering

From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qla2xxx: Remove unnecessary self assignment
Date: Tue, 16 Oct 2018 18:20:12 -0400
Message-ID: <yq18t2xr0tf.fsf@oracle.com>
References: <20180920221706.4948-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180920221706.4948-1-natechancellor@gmail.com> (Nathan
        Chancellor's message of "Thu, 20 Sep 2018 15:17:06 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Nathan,

> Clang warns when a variable is assigned to itself.
>
> drivers/scsi/qla2xxx/qla_mbx.c:1514:4: warning: explicitly assigning
> value of variable of type 'uint64_t' (aka 'unsigned long long') to
> itself [-Wself-assign]
>         l = l;
>         ~ ^ ~
> 1 warning generated.

Applied to 4.20/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering

From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qla2xxx: Simplify conditional check
Date: Tue, 16 Oct 2018 18:27:21 -0400
Message-ID: <yq1zhvdplx2.fsf@oracle.com>
References: <20180921002723.16600-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180921002723.16600-1-natechancellor@gmail.com> (Nathan
        Chancellor's message of "Thu, 20 Sep 2018 17:27:23 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Nathan,

> Clang generates a warning when it sees a logical not followed by a
> conditional operator like ==, >, or < because it thinks that the logical
> not should be applied to the whole statement:

> Link: https://github.com/ClangBuiltLinux/linux/issues/80
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Applied to 4.20/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering

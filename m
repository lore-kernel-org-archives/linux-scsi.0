From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: bfa: Remove unused functions
Date: Tue, 16 Oct 2018 18:21:56 -0400
Message-ID: <yq14ldlr0qj.fsf@oracle.com>
References: <20180920230212.22227-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180920230212.22227-1-natechancellor@gmail.com> (Nathan
        Chancellor's message of "Thu, 20 Sep 2018 16:02:12 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Nathan,

> However, upon further inspection, these functions aren't actually used
> anywhere; they're just defined. Rather than just removing the self
> assignments, remove all of this dead code.
>
> Link: https://github.com/ClangBuiltLinux/linux/issues/148
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Applied to 4.20/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering

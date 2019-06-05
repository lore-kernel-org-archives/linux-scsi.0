From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3] scsi: ibmvscsi: Don't use rc uninitialized in ibmvscsi_do_work
Date: Tue, 04 Jun 2019 22:39:19 -0400
Message-ID: <yq1ef48rc14.fsf@oracle.com>
References: <20190603221941.65432-1-natechancellor@gmail.com>
        <20190603234405.29600-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190603234405.29600-1-natechancellor@gmail.com> (Nathan
        Chancellor's message of "Mon, 3 Jun 2019 16:44:06 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: Tyrel Datwyler <tyreld@linux.ibm.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com, Michael Ellerman <mpe@ellerman.id.au>
List-Id: linux-scsi@vger.kernel.org


Nathan,

> clang warns:
>
> drivers/scsi/ibmvscsi/ibmvscsi.c:2126:7: warning: variable 'rc' is used
> uninitialized whenever switch case is taken [-Wsometimes-uninitialized]
>         case IBMVSCSI_HOST_ACTION_NONE:
>              ^~~~~~~~~~~~~~~~~~~~~~~~~

Applied to 5.3/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering

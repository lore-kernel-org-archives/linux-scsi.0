From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ibmvfc: constify dev_pm_ops structures.
Date: Sat, 01 Jul 2017 17:05:40 -0400
Message-ID: <yq17ezrx3yz.fsf@oracle.com>
References: <c0ec5db7e2c3313cb7b417e76330520fd2b6136c.1498722828.git.arvind.yadav.cs@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c0ec5db7e2c3313cb7b417e76330520fd2b6136c.1498722828.git.arvind.yadav.cs@gmail.com>
        (Arvind Yadav's message of "Thu, 29 Jun 2017 13:24:41 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: tyreld@linux.vnet.ibm.com, benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arvind,

> dev_pm_ops are not supposed to change at runtime. All functions
> working with dev_pm_ops provided by <linux/device.h> work with const
> dev_pm_ops. So mark the non-const structs as const.

Applied to 4.13/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering

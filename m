From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ncr5380: constify pnp_device_id
Date: Wed, 16 Aug 2017 20:54:55 -0400
Message-ID: <yq14lt7ovxc.fsf@oracle.com>
References: <60c34272432b3411cd5d55728c62481e133f32a6.1502859040.git.arvind.yadav.cs@gmail.com>
        <1125161eb43bc7ee7f748a040ab06b40cc1537dd.1502859040.git.arvind.yadav.cs@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1125161eb43bc7ee7f748a040ab06b40cc1537dd.1502859040.git.arvind.yadav.cs@gmail.com>
        (Arvind Yadav's message of "Wed, 16 Aug 2017 10:28:40 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: fthain@telegraphics.com.au, schmitzmic@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arvind,

> pnp_device_id are not supposed to change at runtime. All functions
> working with pnp_device_id provided by <linux/pnp.h> work with
> const pnp_device_id. So mark the non-const structs as const.

Applied to 4.14/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering

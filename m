From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: hisi_sas: select CONFIG_RAS
Date: Fri, 03 Nov 2017 11:24:03 -0400
Message-ID: <yq1shdv75d8.fsf@oracle.com>
References: <20171102165059.213216-1-arnd@arndb.de>
        <bdb263f7-7e1f-47ab-881b-2feeeeccfbf5@huawei.com>
        <CAK8P3a3fvRQ+oUg=EUuWxdyyyMGHiL7sQMLhCY53sfCRyinOAA@mail.gmail.com>
        <50ad8f0e-9b21-4277-4be9-dfd6b82e5554@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <50ad8f0e-9b21-4277-4be9-dfd6b82e5554@huawei.com> (John Garry's
        message of "Fri, 3 Nov 2017 12:02:16 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Xiang Chen <chenxiang66@hisilicon.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linuxarm <linuxarm@huawei.com>, Shiju Jose <shiju.jose@huawei.com>
List-Id: linux-scsi@vger.kernel.org


John,

> Actually this interface is intended for logging UEFI CPER non-standard
> records from kernel RAS/APEI framework to userspace. It is not intended
> for kernel peripheral driver logging (like this case). Until we get a
> community concensus on whether this is acceptable, I would rather revert
> the original patch.

OK, dropped it for now.

-- 
Martin K. Petersen	Oracle Linux Engineering

From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: hisi_sas: fix SATA dependency
Date: Wed, 29 Mar 2017 22:45:47 -0400
Message-ID: <yq17f374h44.fsf@oracle.com>
References: <20170328142212.1816773-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170328142212.1816773-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Tue, 28 Mar 2017 16:22:03 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: John Garry <john.garry@huawei.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Xiang Chen <chenxiang66@hisilicon.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> Removing the 'select SCSI_SAS_LIBSAS' statement in Kconfig resulted
> in a link failure in configurations that have hisi_sas built-in
> but libsas as a loadable module:

Applied to 4.12/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering

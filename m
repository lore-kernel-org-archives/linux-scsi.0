From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 4/4] scsi: ufs: hisi: fix ufs_hba_variant_ops passing
Date: Wed, 06 Mar 2019 12:45:31 -0500
Message-ID: <yq15zsvzykk.fsf@oracle.com>
References: <20190304193917.702601-1-arnd@arndb.de>
        <20190304193917.702601-4-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190304193917.702601-4-arnd@arndb.de> (Arnd Bergmann's message
        of "Mon, 4 Mar 2019 20:39:11 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Wei Li <liwei213@huawei.com>, Subhash Jadavani <subhashj@codeaurora.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> Without CONFIG_OF, the of_match_node() helper does not evaluate
> its argument, and the compiler warns about the unused variable:
>
> drivers/scsi/ufs/ufs-hisi.c: In function 'ufs_hisi_probe':
> drivers/scsi/ufs/ufs-hisi.c:673:17: error: unused variable 'dev' [-Werror=unused-variable]

Applied to 5.1/scsi-queue, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering

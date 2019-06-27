From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 0/3] scsi: ufs: typo fixes and improvement
Date: Wed, 26 Jun 2019 22:26:53 -0400
Message-ID: <yq1k1d7lq4y.fsf@oracle.com>
References: <BN7PR08MB5684A44F56972BCE0972B28EDBE10@BN7PR08MB5684.namprd08.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BN7PR08MB5684A44F56972BCE0972B28EDBE10@BN7PR08MB5684.namprd08.prod.outlook.com>
        (Bean Huo's message of "Sun, 23 Jun 2019 17:37:56 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: "Bean Huo (beanhuo)" <beanhuo@micron.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Evan Green <evgreen@chromium.org>, Stanley Chu <stanley.chu@mediatek.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Bean,

> This series patch is to fix several typos and fix one issue of twice
> completing ufs-bsg job in case of UPIU/DME command failed.
>
> Changed since v1:
>     - split v1 patch
>     - add fixes tag
>     - delete needless blank line

Applied to 5.3/scsi-queue. Mostly by hand. Please use git send-email to
post patches. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering

From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: ufs: Configure clock in .hce_enable_notify() in Cadence UFS
Date: Wed, 07 Aug 2019 21:51:06 -0400
Message-ID: <yq1wofoctmd.fsf@oracle.com>
References: <20190802112112.18714-1-aniljoy@cadence.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190802112112.18714-1-aniljoy@cadence.com> (Anil Varughese's
        message of "Fri, 2 Aug 2019 12:21:12 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Varughese <aniljoy@cadence.com>
Cc: alim.akhtar@samsung.com, avri.altman@wdc.com, pedrom.sousa@synopsys.com, jejb@linux.ibm.com, martin.petersen@oracle.com, hare@suse.de, rafalc@cadence.com, mparab@cadence.com, jank@cadence.com, pawell@cadence.com, vigneshr@ti.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Anil,

> Configure CDNS_UFS_REG_HCLKDIV in .hce_enable_notify() instead of
> .setup_clock() because if UFSHCD resets the controller ip because
> of phy or device related errors then CDNS_UFS_REG_HCLKDIV is
> reset to default value and .setup_clock() is not called later
> in the sequence whereas .hce_enable_notify will be called everytime
> controller is reenabled.

Applied to 5.4/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering

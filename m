From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: Fix RX_TERMINATION_FORCE_ENABLE define value
Date: Mon, 29 Apr 2019 08:16:45 -0400
Message-ID: <yq1a7g90zwy.fsf@oracle.com>
References: <87405e9b14c6eb01b395f01eac4ab085e8020ff7.1555614814.git.sousa@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <87405e9b14c6eb01b395f01eac4ab085e8020ff7.1555614814.git.sousa@synopsys.com>
        (Pedro Sousa's message of "Thu, 18 Apr 2019 21:13:34 +0200")
Sender: stable-owner@vger.kernel.org
To: Pedro Sousa <PedroM.Sousa@synopsys.com>
Cc: alim.akhtar@samsung.com, avri.altman@wdc.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Pedro,

> Fix RX_TERMINATION_FORCE_ENABLE define value from 0x0089 to 0x00A9
> according to MIPI Alliance MPHY specification.

Applied to 5.2/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering

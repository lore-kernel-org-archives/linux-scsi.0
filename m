From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 1/4] scsi: ufs: Change HCI macro to actual bit position
Date: Wed, 11 Oct 2017 13:45:18 -0400
Message-ID: <yq1zi8xfuj5.fsf@oracle.com>
References: <CGME20171003152909epcas2p4e6e80cb1c544c38c33267a2d2767e40e@epcas2p4.samsung.com>
        <1507044085-16905-1-git-send-email-alim.akhtar@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1507044085-16905-1-git-send-email-alim.akhtar@samsung.com> (Alim
        Akhtar's message of "Tue, 03 Oct 2017 20:51:22 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Alim Akhtar <alim.akhtar@samsung.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, vinholikatti@gmail.com, martin.petersen@oracle.com, subhashj@codeaurora.org, Bart.VanAssche@wdc.com
List-Id: linux-scsi@vger.kernel.org


Alim,

> Currently UFS HCI uses UFS_BIT() macro to get various bit position for
> the hardware registers status bits. Which makes code longer instead of
> shorter. This macro does not improve code readability as well.  Lets
> re-write these macro definition with the actual bit position.

Applied patches 1-4 to 4.15/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering

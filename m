From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/4] Add required changes to ufshcd to support exynos ufs hci
Date: Fri, 18 May 2018 10:52:52 -0400
Message-ID: <yq1po1tggmz.fsf@oracle.com>
References: <CGME20180506102636epcas2p3432b71e5c867f6cfec16cf2a8c74b0e2@epcas2p3.samsung.com>
        <1525601658-31989-1-git-send-email-alim.akhtar@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1525601658-31989-1-git-send-email-alim.akhtar@samsung.com> (Alim
        Akhtar's message of "Sun, 06 May 2018 15:44:14 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Alim Akhtar <alim.akhtar@samsung.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, vivek.gautam@codeaurora.org, subhashj@codeaurora.org, vinholikatti@gmail.com, olof@lixom.net
List-Id: linux-scsi@vger.kernel.org


Alim,

> These patches are part of a larger patch series [1] which attempts
> upstreaming EXYNOS UFS driver support. There was not much activities
> after v5 of that series. In between I saw there were other teams in
> Samsung tried upstreaming the same, but that has not really gone
> anywhere.  I have taken this task again and here is another attempt to
> upstream exynos-ufs driver support. I have divided the patches into
> two series, one which adds required infra in the ufshcd core needed by
> exynos-ufs driver and other part will have actual exynos-ufs
> driver. Splitting this has a advantage of less reviewing over head.

Applied to 4.18/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering

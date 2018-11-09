From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RESEND][PATCH v3] scsi: ufs: Fix hynix ufs bug with quirk on hi36xx SoC
Date: Thu, 08 Nov 2018 21:29:24 -0500
Message-ID: <yq1pnvfvv97.fsf@oracle.com>
References: <1541696909-31620-1-git-send-email-john.stultz@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1541696909-31620-1-git-send-email-john.stultz@linaro.org> (John
        Stultz's message of "Thu, 8 Nov 2018 09:08:29 -0800")
Sender: linux-kernel-owner@vger.kernel.org
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Wei Li <liwei213@huawei.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Dmitry Shmidt <dimitrysh@google.com>
List-Id: linux-scsi@vger.kernel.org


John,

> Hynix ufs has deviations on hi36xx platform which will result in ufs
> bursts transfer failures.

Applied to 4.20/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering

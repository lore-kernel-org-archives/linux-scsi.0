From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] fnic: Use time64_t to represent trace timestamps
Date: Tue, 11 Oct 2016 16:28:35 -0400
Message-ID: <yq1pon6ocjw.fsf@sermon.lab.mkp.net>
References: <1475365694-8582-1-git-send-email-deepa.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1475365694-8582-1-git-send-email-deepa.kernel@gmail.com> (Deepa
        Dinamani's message of "Sat, 1 Oct 2016 16:48:14 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, y2038@lists.linaro.org, Hiral Patel <hiralpat@cisco.com>, Suma Ramars <sramars@cisco.com>, Brian Uchino <buchino@cisco.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Deepa" == Deepa Dinamani <deepa.kernel@gmail.com> writes:

Deepa> trace timestamps use struct timespec and CURRENT_TIME which are
Deepa> not y2038 safe.  These timestamps are only part of the trace log
Deepa> on the machine and are not shared with the fnic.  Replace then
Deepa> with y2038 safe struct timespec64 and ktime_get_real_ts64(),
Deepa> respectively.

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering

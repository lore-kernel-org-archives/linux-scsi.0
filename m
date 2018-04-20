From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] scsi: st: Replace GFP_ATOMIC with GFP_KERNEL in st_probe
Date: Fri, 20 Apr 2018 18:38:06 -0400
Message-ID: <yq1y3hhh5bl.fsf@oracle.com>
References: <1523363879-31242-1-git-send-email-baijiaju1990@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1523363879-31242-1-git-send-email-baijiaju1990@gmail.com>
        (Jia-Ju Bai's message of "Tue, 10 Apr 2018 20:37:59 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: Kai.Makisara@kolumbus.fi, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Jia-Ju,

> st_probe() is never called in atomic context.

Applied patches 1 and 2 to 4.18/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering

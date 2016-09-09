From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] [SCSI] aacraid: mark aac_src_select_comm() static
Date: Fri, 09 Sep 2016 07:09:30 -0400
Message-ID: <yq1d1kdgwid.fsf@sermon.lab.mkp.net>
References: <1472971630-4765-1-git-send-email-baoyou.xie@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1472971630-4765-1-git-send-email-baoyou.xie@linaro.org> (Baoyou
        Xie's message of "Sun, 4 Sep 2016 14:47:10 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Baoyou Xie <baoyou.xie@linaro.org>
Cc: aacraid@microsemi.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, xie.baoyou@zte.com.cn
List-Id: linux-scsi@vger.kernel.org

>>>>> "Baoyou" == Baoyou Xie <baoyou.xie@linaro.org> writes:

Baoyou> We get 1 warning when building kernel with W=1:
Baoyou> drivers/scsi/aacraid/src.c:616:5: warning: no previous prototype
Baoyou> for 'aac_src_select_comm' [-Wmissing-prototypes]

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering

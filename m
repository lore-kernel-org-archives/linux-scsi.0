From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] lpfc: mark symbols static where possible
Date: Mon, 26 Sep 2016 20:37:55 -0400
Message-ID: <yq14m5241p8.fsf@sermon.lab.mkp.net>
References: <1474782295-25644-1-git-send-email-baoyou.xie@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1474782295-25644-1-git-send-email-baoyou.xie@linaro.org> (Baoyou
        Xie's message of "Sun, 25 Sep 2016 13:44:55 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Baoyou Xie <baoyou.xie@linaro.org>
Cc: james.smart@avagotech.com, dick.kennedy@avagotech.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, xie.baoyou@zte.com.cn
List-Id: linux-scsi@vger.kernel.org

>>>>> "Baoyou" == Baoyou Xie <baoyou.xie@linaro.org> writes:

Baoyou> In fact, these functions are only used in the file in which they
Baoyou> are declared and don't need a declaration, but can be made
Baoyou> static.  so this patch marks these functions with 'static'.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering

From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: smartpqi: call pqi_free_interrupts() in pqi_shutdown()
Date: Thu, 20 Dec 2018 19:39:00 -0500
Message-ID: <yq1k1k3d87v.fsf@oracle.com>
References: <1545294755-29565-1-git-send-email-yanjiang.jin@hxt-semitech.com>
        <1545294755-29565-2-git-send-email-yanjiang.jin@hxt-semitech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1545294755-29565-2-git-send-email-yanjiang.jin@hxt-semitech.com>
        (Yanjiang Jin's message of "Thu, 20 Dec 2018 16:32:35 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Yanjiang Jin <yanjiang.jin@hxt-semitech.com>
Cc: don.brace@microsemi.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, yu.zheng@hxt-semitech.com, jinyanjiang@gmail.com, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Yanjiang,

> We must free all irqs during shutdown, else kexec's 2nd kernel would
> hang in pqi_wait_for_completion_io() as below:

Applied to 4.21/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering

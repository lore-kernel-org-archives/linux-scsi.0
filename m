From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH -next] advansys: remove set but not used variable 'srb_tag' in adv_isr_callback
Date: Wed, 17 Oct 2018 21:02:26 -0400
Message-ID: <yq1pnw8kqxp.fsf@oracle.com>
References: <20181017123432.18304-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181017123432.18304-1-yuehaibing@huawei.com>
        (yuehaibing@huawei.com's message of "Wed, 17 Oct 2018 20:34:32 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>
Cc: willy@infradead.org, hare@suse.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


YueHaibing,

> drivers/scsi/advansys.c: In function 'adv_isr_callback':
> drivers/scsi/advansys.c:5952:6: warning:
>  variable 'srb_tag' set but not used [-Wunused-but-set-variable]
>
> It never used since introduction in
> commit 9c17c62aedb0 ("advansys: use shared host tag map for command lookup")

Applied to 4.20/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering

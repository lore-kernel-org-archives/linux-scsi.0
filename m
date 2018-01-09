From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: mptfusion: use strlcpy() instead of strncpy()
Date: Mon, 08 Jan 2018 21:54:43 -0500
Message-ID: <yq1shbfoi6k.fsf@oracle.com>
References: <1515415753-10534-1-git-send-email-wangxiongfeng2@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1515415753-10534-1-git-send-email-wangxiongfeng2@huawei.com>
        (Xiongfeng Wang's message of "Mon, 8 Jan 2018 20:49:13 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Cc: suganath-prabu.subramani@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de
List-Id: linux-scsi@vger.kernel.org


Xiongfeng,

> gcc-8 reports
>
> drivers/message/fusion/mptbase.c: In function 'mpt_display_event_info':
> ./include/linux/string.h:245:9: warning: '__builtin_strncpy' specified
> bound 100 equals destination size [-Wstringop-truncation]
>
> We need to use strlcpy() to make sure the dest string is
> nul-terminated.

Applied to 4.16/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering

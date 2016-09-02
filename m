From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: add missing declaration in ufshcd.h
Date: Fri, 02 Sep 2016 06:58:55 -0400
Message-ID: <yq18tvatvo0.fsf@sermon.lab.mkp.net>
References: <1472371282-14691-1-git-send-email-baoyou.xie@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1472371282-14691-1-git-send-email-baoyou.xie@linaro.org> (Baoyou
        Xie's message of "Sun, 28 Aug 2016 16:01:22 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Baoyou Xie <baoyou.xie@linaro.org>
Cc: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@linaro.org, xie.baoyou@zte.com.cn
List-Id: linux-scsi@vger.kernel.org

>>>>> "Baoyou" == Baoyou Xie <baoyou.xie@linaro.org> writes:

Baoyou> We get 1 warning about global functions without a declaration in
Baoyou> the scsi ufshcd driver when building with W=1:
Baoyou> drivers/scsi/ufs/ufshcd.c:1991:5: warning: no previous prototype
Baoyou> for 'ufshcd_query_descriptor_retry' [-Wmissing-prototypes]

Baoyou> in fact, this function is implemented in ufshcd.c and exported
Baoyou> but need to be declared in header file.

ufshcd_query_descriptor_retry doesn't appear to be used outside of
ufshcd.c.

-- 
Martin K. Petersen	Oracle Linux Engineering

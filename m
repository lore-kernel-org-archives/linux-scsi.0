From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] [SCSI] aacraid: mark aac_src_select_comm() static
Date: Mon, 05 Sep 2016 13:50:17 +0200
Message-ID: <29596889.mEYM5UttnR@wuerfel>
References: <1472971630-4765-1-git-send-email-baoyou.xie@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1472971630-4765-1-git-send-email-baoyou.xie@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Baoyou Xie <baoyou.xie@linaro.org>
Cc: aacraid@microsemi.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, xie.baoyou@zte.com.cn
List-Id: linux-scsi@vger.kernel.org

On Sunday, September 4, 2016 2:47:10 PM CEST Baoyou Xie wrote:
> We get 1 warning when building kernel with W=1:
> drivers/scsi/aacraid/src.c:616:5: warning: no previous prototype for 'aac_src_select_comm' [-Wmissing-prototypes]
> 
> In fact, this function is only used in the file in which it is
> declared and don't need a declaration, but can be made static.
> so this patch marks this function with 'static'.
> 
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>

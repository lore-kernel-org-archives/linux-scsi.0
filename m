From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] lpfc: mark symbols static where possible
Date: Mon, 05 Sep 2016 13:14:26 +0200
Message-ID: <5736452.ArzUdR1RZm@wuerfel>
References: <1472972847-5174-1-git-send-email-baoyou.xie@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:51688 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752268AbcIELTi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Sep 2016 07:19:38 -0400
In-Reply-To: <1472972847-5174-1-git-send-email-baoyou.xie@linaro.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Baoyou Xie <baoyou.xie@linaro.org>
Cc: james.smart@avagotech.com, dick.kennedy@avagotech.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, xie.baoyou@zte.com.cn

On Sunday, September 4, 2016 3:07:27 PM CEST Baoyou Xie wrote:
> We get a few warnings when building kernel with W=1:
> drivers/scsi/lpfc/lpfc_sli.c:5693:1: warning: no previous prototype for 'lpfc_set_features' [-Wmissing-prototypes]
> drivers/scsi/lpfc/lpfc_sli.c:8972:1: warning: no previous prototype for 'lpfc_sli_calc_ring' [-Wmissing-prototypes]
> drivers/scsi/lpfc/lpfc_mbox.c:2264:1: warning: no previous prototype for 'lpfc_mbx_cmpl_rdp_link_stat' [-Wmissing-prototypes]
> ....
> 
> In fact, these functions are only used in the file in which they are
> declared and don't need a declaration, but can be made static.
> so this patch marks these functions with 'static'.
> 
> Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>

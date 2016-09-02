From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] fix:pmcraid: mark symbols static where possible
Date: Fri, 02 Sep 2016 06:56:25 -0400
Message-ID: <yq1d1kmtvs6.fsf@sermon.lab.mkp.net>
References: <1472312964-20944-1-git-send-email-baoyou.xie@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22514 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752780AbcIBK4h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Sep 2016 06:56:37 -0400
In-Reply-To: <1472312964-20944-1-git-send-email-baoyou.xie@linaro.org> (Baoyou
        Xie's message of "Sat, 27 Aug 2016 23:49:24 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Baoyou Xie <baoyou.xie@linaro.org>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@linaro.org, xie.baoyou@zte.com.cn

>>>>> "Baoyou" == Baoyou Xie <baoyou.xie@linaro.org> writes:

Baoyou> We get 4 warnings about global functions without a declaration
Baoyou> in the scsi pmcraid driver when building with W=1:
Baoyou> drivers/scsi/pmcraid.c:309:6: warning: no previous prototype for
Baoyou> 'pmcraid_init_cmdblk' [-Wmissing-prototypes]
Baoyou> drivers/scsi/pmcraid.c:404:6: warning: no previous prototype for
Baoyou> 'pmcraid_return_cmd' [-Wmissing-prototypes]
Baoyou> drivers/scsi/pmcraid.c:1713:6: warning: no previous prototype
Baoyou> for 'pmcraid_ioasc_logger' [-Wmissing-prototypes]
Baoyou> drivers/scsi/pmcraid.c:3141:1: warning: no previous prototype
Baoyou> for 'pmcraid_init_ioadls' [-Wmissing-prototypes]

Baoyou> In fact, these functions are only used in the file in which it
Baoyou> is declared and don't need a declaration, but can be made
Baoyou> static.  so this patch marks it 'static'.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering

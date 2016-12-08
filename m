From: Martin George <marting@netapp.com>
Subject: Re: [PATCH v2] scsi_devinfo: remove synchronous ALUA for NETAPP
 devices
Date: Fri, 9 Dec 2016 01:21:28 +0530
Message-ID: <3dfc9887-0115-be36-2ab1-33cb82d83dc6@netapp.com>
References: <20161111164949.2322-1-xose.vazquez@gmail.com>
 <2F2F999B-934D-4D63-A759-2FC777CF16B0@netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx142.netapp.com ([216.240.21.19]:20924 "EHLO mx142.netapp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752030AbcLHTv6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 8 Dec 2016 14:51:58 -0500
In-Reply-To: <2F2F999B-934D-4D63-A759-2FC777CF16B0@netapp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Stewart, Sean" <Sean.Stewart@netapp.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: "Stankey, Robert" <Robert.Stankey@netapp.com>, "Schremmer, Steven" <Steve.Schremmer@netapp.com>, Hannes Reinecke <hare@suse.de>, Christophe Varoqui <christophe.varoqui@opensvc.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, SCSI ML <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>

On 12/8/2016 1:05 AM, Stewart, Sean wrote:
> On 11/11/16, 10:49 AM, "Xose Vazquez Perez" <xose.vazquez@gmail.com> wrote:
>
>      NetApp did confirm this is not required.
>      
>      Cc: Martin George <Martin.George@netapp.com>
>      Cc: Robert Stankey <Robert.Stankey@netapp.com>
>      Cc: Steven Schremmer <Steven.Schremmer@netapp.com>
>      Cc: Sean Stewart <Sean.Stewart@netapp.com>
>      Cc: Hannes Reinecke <hare@suse.de>
>      Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
>      Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
>      Cc: Martin K. Petersen <martin.petersen@oracle.com>
>      Cc: SCSI ML <linux-scsi@vger.kernel.org>
>      Cc: device-mapper development <dm-devel@redhat.com>
>      Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>      ---
>       drivers/scsi/scsi_devinfo.c | 2 --
>       1 file changed, 2 deletions(-)
>      
>      diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
>      index 2464569..28fea83 100644
>      --- a/drivers/scsi/scsi_devinfo.c
>      +++ b/drivers/scsi/scsi_devinfo.c
>      @@ -220,8 +220,6 @@ static struct {
>       	{"NAKAMICH", "MJ-5.16S", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
>       	{"NEC", "PD-1 ODX654P", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
>       	{"NEC", "iStorage", NULL, BLIST_REPORTLUN2},
>      -	{"NETAPP", "LUN C-Mode", NULL, BLIST_SYNC_ALUA},
>      -	{"NETAPP", "INF-01-00", NULL, BLIST_SYNC_ALUA},
>       	{"NRC", "MBR-7", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
>       	{"NRC", "MBR-7.4", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
>       	{"PIONEER", "CD-ROM DRM-600", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
>      --
>      2.10.2
>      
> Reviewed-by: Sean Stewart <sean.stewart@netapp.com>
>

Reviewed-by: Martin George <marting@netapp.com>

Thanks,
-Martin

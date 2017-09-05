From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: scsi_transport_sas: select BLK_DEV_BSGLIB
Date: Tue, 05 Sep 2017 08:24:40 -0400
Message-ID: <yq1d175s587.fsf@oracle.com>
References: <20170905074956.469733-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38751 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750805AbdIEMZD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2017 08:25:03 -0400
In-Reply-To: <20170905074956.469733-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Tue, 5 Sep 2017 09:49:23 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinicke <hare@suse.de>, Finn Thain <fthain@telegraphics.com.au>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


Arnd,

> Without CONFIG_BLK_DEV_BSGLIB, we get a link error here:
>
> drivers/scsi/scsi_transport_sas.o: In function `sas_bsg_initialize':
> scsi_transport_sas.c:(.text+0xcc0): undefined reference to `bsg_setup_queue'
> scsi_transport_sas.c:(.text+0xd10): undefined reference to `bsg_setup_queue'
> drivers/scsi/scsi_transport_sas.o: In function `sas_smp_dispatch':
> scsi_transport_sas.c:(.text+0xe8c): undefined reference to `bsg_job_done'
>
> This modifies the Kconfig 'select' statement accordingly, and matching
> what we do for the other two scsi_transport implementations that use
> bsglib.
>
> Fixes: 651a01364994 ("scsi: scsi_transport_sas: switch to bsg-lib for SMP passthrough")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied to 4.14/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering

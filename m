From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi_devinfo: remove synchronous ALUA for NETAPP devices
Date: Wed, 07 Dec 2016 18:14:36 -0500
Message-ID: <yq1h96fs55v.fsf@sermon.lab.mkp.net>
References: <20161111164949.2322-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21058 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932141AbcLGXOv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Dec 2016 18:14:51 -0500
In-Reply-To: <20161111164949.2322-1-xose.vazquez@gmail.com> (Xose Vazquez
        Perez's message of "Fri, 11 Nov 2016 17:49:49 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Martin George <Martin.George@netapp.com>, Robert Stankey <Robert.Stankey@netapp.com>, Steven Schremmer <Steven.Schremmer@netapp.com>, Sean Stewart <Sean.Stewart@netapp.com>, Hannes Reinecke <hare@suse.de>, Christophe Varoqui <christophe.varoqui@opensvc.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, SCSI ML <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>

>>>>> "Xose" == Xose Vazquez Perez <xose.vazquez@gmail.com> writes:

Xose> NetApp did confirm this is not required.

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering

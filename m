From: Chad Dupuis <chad.dupuis@cavium.com>
Subject: Re: [PATCH] scsi: qedf: Fix defective logging format and argument
 mismatches
Date: Mon, 6 Mar 2017 14:33:00 -0500 (EST)
Message-ID: <alpine.OSX.2.00.1703061432140.1895@administrators-macbook-pro.local>
References: <b75448afd5e48f342ad9f1785c6546eee7948af9.1488614805.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0050.outbound.protection.outlook.com ([104.47.36.50]:45308
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752782AbdCFTd2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 6 Mar 2017 14:33:28 -0500
In-Reply-To: <b75448afd5e48f342ad9f1785c6546eee7948af9.1488614805.git.joe@perches.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: QLogic-Storage-Upstream@cavium.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


On Sat, 4 Mar 2017, 8:07am -0000, Joe Perches wrote:

> Add __printf compiler verification of format and arguments.
> Fix fallout.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/scsi/qedf/qedf_dbg.h | 13 ++++++++-----
>  drivers/scsi/qedf/qedf_fip.c |  2 +-
>  drivers/scsi/qedf/qedf_io.c  |  4 ++--
>  3 files changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/qedf/qedf_dbg.h b/drivers/scsi/qedf/qedf_dbg.h

Thanks.

Acked-by: Chad Dupuis <chad.dupuis@cavium.com>

From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v2] libfc: fix seconds_since_last_reset miscalculation
Date: Thu, 17 Nov 2016 09:40:29 -0800
Message-ID: <e7dea378-8178-e351-42a6-be7e63a0b972@sandisk.com>
References: <1479386367-63443-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0069.outbound.protection.outlook.com ([104.47.36.69]:34947
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S941515AbcKQRkk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Nov 2016 12:40:40 -0500
In-Reply-To: <1479386367-63443-1-git-send-email-jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>

On 11/17/2016 04:39 AM, Johannes Thumshirn wrote:
> Commit 540eb1eef 'scsi: libfc: fix seconds_since_last_reset calculation'
> removed the use of 'struct timespec' from fc_get_host_stats(). This broke the
> output of 'fcoeadm -s' after kernel 4.8-rc1.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>

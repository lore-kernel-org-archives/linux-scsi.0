From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Subject: Re: [PATCH] scsi/eh: fix hang adding ehandler wakeups after
 decrementing host_busy
Date: Tue, 21 Nov 2017 11:39:55 +0300
Message-ID: <e8ee72f8-8588-9fae-a029-20b225529d42@virtuozzo.com>
References: <20170905125424.15412-1-ptikhomirov@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-db5eur01on0137.outbound.protection.outlook.com ([104.47.2.137]:36096
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751502AbdKUIkC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Nov 2017 03:40:02 -0500
In-Reply-To: <20170905125424.15412-1-ptikhomirov@virtuozzo.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>, devel@openvz.org

JFYI these patch is in Virtuozzo7 kernel from September, and we have no 
issues found with it until now by out testing, and initial problem does 
not reproduce for 2.5 months.

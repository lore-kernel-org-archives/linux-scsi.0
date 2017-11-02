From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: fix CDROM dependency on BLK_DEV
Date: Thu, 2 Nov 2017 08:27:12 -0600
Message-ID: <212c24f4-7329-f1f5-93c8-090727ed7226@kernel.dk>
References: <20171102111952.4021454-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:50973 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755519AbdKBO1P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Nov 2017 10:27:15 -0400
Received: by mail-io0-f172.google.com with SMTP id 97so14373526iok.7
        for <linux-scsi@vger.kernel.org>; Thu, 02 Nov 2017 07:27:15 -0700 (PDT)
In-Reply-To: <20171102111952.4021454-1-arnd@arndb.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "David S. Miller" <davem@davemloft.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bart.vanassche@wdc.com>, Hannes Reinecke <hare@suse.com>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On 11/02/2017 05:19 AM, Arnd Bergmann wrote:
> After the cdrom cleanup, I get randconfig warnings for some configurations:
> 
> warning: (BLK_DEV_IDECD && BLK_DEV_SR) selects CDROM which has unmet direct dependencies (BLK_DEV)
> 
> This adds an explicit BLK_DEV dependency for both drivers. The other
> drivers that select 'CDROM' already have this and don't need a change.

Thanks Arnd, applied.

-- 
Jens Axboe

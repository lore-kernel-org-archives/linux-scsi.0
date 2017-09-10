From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCH 3/3] fcoe: open-code fcoe_destroy_work() for
 NETDEV_UNREGISTER
Date: Sun, 10 Sep 2017 10:38:57 -0700
Message-ID: <309ffcca-c01b-e5c7-656a-f5bdcf198b45@suse.com>
References: <1504171174-37989-1-git-send-email-hare@suse.de>
 <1504171174-37989-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43612 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750949AbdIJRjC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 10 Sep 2017 13:39:02 -0400
In-Reply-To: <1504171174-37989-4-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Hannes Reinecke <hare@suse.com>



On 08/31/2017 02:19 AM, Hannes Reinecke wrote:
> When a NETDEV_UNREGISTER notification is received the network
> device is _deleted_ after the callback returns.
> So we cannot use a workqueue here, as this would cause an
> inversion when removing the device as the netdev is already gone.
> This manifests with a nasty warning during shutdown:
> 
< ...
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>
-- 
Lee Duncan
SUSE Labs

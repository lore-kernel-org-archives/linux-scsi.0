From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] storvsc: use default I/O timeout handler for FC devices
Date: Tue, 13 Jun 2017 10:13:42 +0200
Message-ID: <8b293fe7-7e14-2e56-5485-c56c9c3bf4ae@suse.de>
References: <1497313417-14815-1-git-send-email-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54283 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751753AbdFMINp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Jun 2017 04:13:45 -0400
In-Reply-To: <1497313417-14815-1-git-send-email-longli@exchange.microsoft.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Long Li <longli@exchange.microsoft.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, KY Srinivasan <kys@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>
Cc: Long Li <longli@microsoft.com>

On 06/13/2017 02:23 AM, Long Li wrote:
> From: Long Li <longli@microsoft.com>
> 
> FC disks are usually setup in a multipath system, and they don't want to 
> unconditionaly reset I/O on timeout. I/O timeout is detected by multipath 
> as a good time to failover and recover.
> 
> Signed-off-by: Long Li <longli@microsoft.com>
> ---

Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

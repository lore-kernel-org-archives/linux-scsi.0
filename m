From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] hpsa: fix uninitialized variable
Date: Tue, 22 Nov 2016 22:09:55 +0100
Message-ID: <7054278.Pn2WfKAvzG@wuerfel>
References: <1479827138-2211-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:59294 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932967AbcKVVLU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Nov 2016 16:11:20 -0500
In-Reply-To: <1479827138-2211-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Tuesday, November 22, 2016 4:05:38 PM CET Hannes Reinecke wrote:
> With the recent patch to hpsa this warning is issued:
> 
> drivers/scsi/hpsa.c: In function 'hpsa_slave_alloc':
> drivers/scsi/hpsa.c:2033:5: error: 'sd' may be used uninitialized in this function [-Werror=maybe-uninitialized]
> 
> The patch that caused this is marked for stable backports,
> so this one has to be backported on top as well.
> 
> Fixes: 4eb307f7b18d ("scsi: hpsa: use bus '3' for legacy HBA devices")
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> 

Reported-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Arnd Bergmann <arnd@arndb.de>

Thanks!

	Arnd

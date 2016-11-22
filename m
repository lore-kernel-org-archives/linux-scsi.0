From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH] hpsa: fix uninitialized variable
Date: Tue, 22 Nov 2016 17:32:03 +0100
Message-ID: <0e07702a-eb51-56df-cdbc-c6d661b26f30@redhat.com>
References: <1479827138-2211-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41680 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755584AbcKVQd0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Nov 2016 11:33:26 -0500
In-Reply-To: <1479827138-2211-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Hannes Reinecke <hare@suse.com>

On 22.11.2016 16:05, Hannes Reinecke wrote:
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

Looks good.

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas


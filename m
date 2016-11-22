From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] hpsa: fix uninitialized variable
Date: Tue, 22 Nov 2016 16:57:29 -0500
Message-ID: <yq1vavfw52u.fsf@sermon.lab.mkp.net>
References: <1479827138-2211-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40805 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751028AbcKVV6w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Nov 2016 16:58:52 -0500
In-Reply-To: <1479827138-2211-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Tue, 22 Nov 2016 16:05:38 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Hannes Reinecke <hare@suse.com>

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> With the recent patch to hpsa this warning is issued:
Hannes> drivers/scsi/hpsa.c: In function 'hpsa_slave_alloc':
Hannes> drivers/scsi/hpsa.c:2033:5: error: 'sd' may be used
Hannes> uninitialized in this function [-Werror=maybe-uninitialized]

I amended your original patch.

-- 
Martin K. Petersen	Oracle Linux Engineering

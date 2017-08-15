From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv3 2/5] scsi: Export blacklist flags to sysfs
Date: Mon, 14 Aug 2017 23:18:46 -0400
Message-ID: <yq18tilwmax.fsf@oracle.com>
References: <1502461401-94630-1-git-send-email-hare@suse.de>
        <1502461401-94630-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40916 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752972AbdHODUO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Aug 2017 23:20:14 -0400
In-Reply-To: <1502461401-94630-3-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Fri, 11 Aug 2017 16:23:18 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Alan Stern <stern@rowland.harvard.edu>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>


Hannes,

> +		name = sdev_bflags_name(bflags);
> +		if (name)
> +			blen = snprintf(ptr, strlen(name) + 1,
> +					"%s", name);
> +		else
> +			blen = snprintf(ptr, 67, "0x%X", bflags);

It seems this else statement facilitates papering over the fact that
scsi_sysfs.c and scsi_devinfo.h can get out of sync.

-- 
Martin K. Petersen	Oracle Linux Engineering

From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 3/7] sd: Cleanup sd_done sense data handling
Date: Mon, 24 Apr 2017 19:11:23 -0400
Message-ID: <yq14lxdh04k.fsf@oracle.com>
References: <20170424075115.30337-1-damien.lemoal@wdc.com>
        <20170424075115.30337-4-damien.lemoal@wdc.com>
        <20170424153535.GE895@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31320 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S978627AbdDXXLf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Apr 2017 19:11:35 -0400
In-Reply-To: <20170424153535.GE895@lst.de> (Christoph Hellwig's message of
        "Mon, 24 Apr 2017 17:35:35 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: damien.lemoal@wdc.com, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Hannes Reinecke <hare@suse.de>


Christoph,

> Use a switch for the sense key, and remove two pointless variables
> that are only used once.

> -				if (unmap)

The rationale behind the unmap variable was clarity and avoiding magic
values.

I'm OK with this, however:

> +				if (SCpnt->cmnd[1] & 8) { /* UNMAP */

So I committed with that change.

-- 
Martin K. Petersen	Oracle Linux Engineering

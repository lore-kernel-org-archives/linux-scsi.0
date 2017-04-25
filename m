From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 3/7] sd: Cleanup sd_done sense data handling
Date: Tue, 25 Apr 2017 13:03:38 -0400
Message-ID: <yq1shkwe7x1.fsf@oracle.com>
References: <20170424075115.30337-1-damien.lemoal@wdc.com>
        <20170424075115.30337-4-damien.lemoal@wdc.com>
        <20170424153535.GE895@lst.de> <yq14lxdh04k.fsf@oracle.com>
        <a9fecd09-3f80-f26c-eb33-cdb5a3ea3734@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43434 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1951361AbdDYRD5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Apr 2017 13:03:57 -0400
In-Reply-To: <a9fecd09-3f80-f26c-eb33-cdb5a3ea3734@wdc.com> (Damien Le Moal's
        message of "Tue, 25 Apr 2017 10:54:11 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Bart Van Assche <Bart.VanAssche@sandisk.com>, Hannes Reinecke <hare@suse.de>


Damien,

> good_bytes is already set to 0 at the beginning of sd_done() when
> result != 0 and again within the initial switch-case for
> REQ_OP_DISCARD and REQ_OP_WRITE_SAME cases, which are the only
> commands that can lead to hitting that "else" part in the sense data
> processing.  I may be missing something, but I think that that
> assignment is redundant.

Fixed this up, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering

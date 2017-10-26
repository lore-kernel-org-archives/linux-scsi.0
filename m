From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2.2] sd: Micro-optimize READ / WRITE CDB encoding
Date: Thu, 26 Oct 2017 02:31:59 -0400
Message-ID: <yq11slqifmo.fsf@oracle.com>
References: <20171026050603.14856-1-dgilbert@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16847 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750949AbdJZGcU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Oct 2017 02:32:20 -0400
In-Reply-To: <20171026050603.14856-1-dgilbert@interlog.com> (Douglas Gilbert's
        message of "Thu, 26 Oct 2017 01:06:03 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org, Bart.VanAssche@wdc.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, hch@lst.de, hare@suse.com, jthumshirn@suse.de


Doug,

> The sd_setup_read_write_cmnd() function is on the "fast path" for
> block system access to SCSI devices (logical units). Rewrite this
> function to improve speed and readability.

Please do any optimizations on top of my scsi-work branch which has the
sd_setup_read_write_cmnd() rewrite. I'm at kernel summit this week but
will rebase when time permits.

-- 
Martin K. Petersen	Oracle Linux Engineering

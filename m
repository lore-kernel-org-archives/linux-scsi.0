From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 0/5] scsi_debug: add write scattered support
Date: Mon, 08 Jan 2018 22:20:24 -0500
Message-ID: <yq1373fogzr.fsf@oracle.com>
References: <20171223174814.3902-1-dgilbert@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:34528 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750913AbeAIDUe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jan 2018 22:20:34 -0500
In-Reply-To: <20171223174814.3902-1-dgilbert@interlog.com> (Douglas Gilbert's
        message of "Sat, 23 Dec 2017 12:48:09 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, Bart.VanAssche@wdc.com, hare@suse.de


Douglas,

> While testing the WRITE SCATTERED command support in a new sg3_utils
> utility (sg_write_x) it was helpful to have a target that supported
> this command. This command might be attractive to other kernel
> subsystems. Even if end devices don't support this command yet, it
> would most likely be a performance win if SCSI LLDs supported it (by
> breaking it down to a series of WRITE commands), as that would cut
> down the overhead of the block layer, the ULD (e.g. sd) and the SCSI
> midlevel.

Applied to 4.16/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering

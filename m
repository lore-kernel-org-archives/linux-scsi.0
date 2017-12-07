From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi_debug: add cdb_len paramete
Date: Wed, 06 Dec 2017 21:06:56 -0500
Message-ID: <yq1fu8nxpdr.fsf@oracle.com>
References: <20171205050549.31526-1-dgilbert@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40694 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752243AbdLGCHI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Dec 2017 21:07:08 -0500
In-Reply-To: <20171205050549.31526-1-dgilbert@interlog.com> (Douglas Gilbert's
        message of "Tue, 5 Dec 2017 00:05:49 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, hare@suse.de, bart.vanassche@sandisk.com, James.Bottomley@HansenPartnership.com


Doug,

> While testing "sd: Micro-optimize READ / WRITE CDB encoding" patches
> it was helpful to check various code paths associated with READ/WRITE
> 6, 10 and 16 byte cdb variants. There seems to be no user space
> "knobs" to twiddle use_10_for_rw and friends in the scsi_device
> structure.  So add a parameter to scsi_debug called "cdb_len" for this
> purpose.

Applied to 4.16/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering

From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] hpsa: correct scsi 6byte lba calculation
Date: Mon, 19 Sep 2016 11:55:07 -0400
Message-ID: <yq1mvj3anqc.fsf@sermon.lab.mkp.net>
References: <147405566295.22004.7072671003857458219.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28661 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751008AbcISPz5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Sep 2016 11:55:57 -0400
In-Reply-To: <147405566295.22004.7072671003857458219.stgit@brunhilda> (Don
        Brace's message of "Fri, 16 Sep 2016 14:54:23 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com, linux-scsi@vger.kernel.org

>>>>> "Don" == Don Brace <don.brace@microsemi.com> writes:

Don> From: Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>
Don> Missing 5 bits of byte 1 in the LBA issued by SML

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering

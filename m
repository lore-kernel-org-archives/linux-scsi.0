From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V1] smartpqi: raid bypass lba calculation fix
Date: Mon, 19 Sep 2016 11:55:59 -0400
Message-ID: <yq1intranow.fsf@sermon.lab.mkp.net>
References: <147405611157.22243.14980631065860596720.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29113 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751441AbcISP4b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Sep 2016 11:56:31 -0400
In-Reply-To: <147405611157.22243.14980631065860596720.stgit@brunhilda> (Don
        Brace's message of "Fri, 16 Sep 2016 15:01:51 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com, linux-scsi@vger.kernel.org

>>>>> "Don" == Don Brace <don.brace@microsemi.com> writes:

Don> From: kevin Barnett <kevin.barnett@microsemi.com> In the ioaccel
Don> path, the calculation of the starting LBA for READ(6)/WRITE(6) SCSI
Don> commands does not take into account the most significant 5 bits of
Don> the LBA: it only uses the least significant 16 bits of the starting
Don> LBA.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering

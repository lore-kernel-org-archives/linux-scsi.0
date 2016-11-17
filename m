From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V2] hpsa: correct logical resets
Date: Wed, 16 Nov 2016 20:27:19 -0500
Message-ID: <yq1k2c2c2vc.fsf@sermon.lab.mkp.net>
References: <147924273290.3204.4516045603924193508.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50747 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932688AbcKQB3J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Nov 2016 20:29:09 -0500
In-Reply-To: <147924273290.3204.4516045603924193508.stgit@brunhilda> (Don
        Brace's message of "Tue, 15 Nov 2016 14:45:32 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com, POSWALD@suse.com, linux-scsi@vger.kernel.org

>>>>> "Don" == Don Brace <don.brace@microsemi.com> writes:

Don> - driver was not calling done in some cases which causes
Don>   the volume to be offlined.
Don> - avoid doing rescan during a reset.

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering

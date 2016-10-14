From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] mptscsih: remove bogus interpretation of request->ioprio
Date: Fri, 14 Oct 2016 16:16:14 -0400
Message-ID: <yq160oulm9d.fsf@sermon.lab.mkp.net>
References: <1476348401-22724-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36153 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755995AbcJNUQV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Oct 2016 16:16:21 -0400
In-Reply-To: <1476348401-22724-1-git-send-email-hch@lst.de> (Christoph
        Hellwig's message of "Thu, 13 Oct 2016 10:46:41 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Having an I/O priority does not mean we should send all
Christoph> requests as HEAD OF QUEUE tags.

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering

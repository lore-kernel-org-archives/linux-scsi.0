From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] qla4xxx: switch to pci_alloc_irq_vectors
Date: Tue, 29 Nov 2016 11:45:05 -0500
Message-ID: <yq1r35unsku.fsf@sermon.lab.mkp.net>
References: <1479453321-18036-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19358 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932411AbcK2QpS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Nov 2016 11:45:18 -0500
In-Reply-To: <1479453321-18036-1-git-send-email-hch@lst.de> (Christoph
        Hellwig's message of "Fri, 18 Nov 2016 08:15:21 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: Christoph Hellwig <hch@lst.de>, QLogic-Storage-Upstream@qlogic.com, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> And simplify the MSI-X logic in general - just request the
Christoph> two vectors directly instead of going through an indirection
Christoph> table.

Vikas: Please review!

-- 
Martin K. Petersen	Oracle Linux Engineering

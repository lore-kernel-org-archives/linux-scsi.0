From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] be2iscsi: switch to pci_alloc_irq_vectors
Date: Thu, 30 Mar 2017 11:37:54 -0400
Message-ID: <yq14lya3hd9.fsf@oracle.com>
References: <1484324988-30962-1-git-send-email-hch@lst.de>
        <yq1lgu5gswf.fsf@oracle.com>
        <29f55cdbd89162f2885494cd7d0472db@mail.gmail.com>
        <20170330084733.GA11989@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25058 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933970AbdC3PiF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Mar 2017 11:38:05 -0400
In-Reply-To: <20170330084733.GA11989@lst.de> (Christoph Hellwig's message of
        "Thu, 30 Mar 2017 10:47:33 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jitendra Bhivare <jitendra.bhivare@broadcom.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Subramanian Seetharaman <subbu.seetharaman@broadcom.com>, Ketan Mukadam <ketan.mukadam@broadcom.com>, linux-scsi@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:

> Any progress on that? I'd like to get be2iscsi off the old MSI-X API
> for 4.12.

Applied to 4.12/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering

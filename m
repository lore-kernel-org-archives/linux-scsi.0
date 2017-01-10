From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] pmcraid: switch to pci_alloc_irq_vectors
Date: Mon, 09 Jan 2017 23:47:33 -0500
Message-ID: <yq1lgujcyhm.fsf@oracle.com>
References: <1479450496-14331-1-git-send-email-hch@lst.de>
        <yq1vav6nsp0.fsf@sermon.lab.mkp.net>
        <20170108150043.GA8072@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23234 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751759AbdAJEsQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jan 2017 23:48:16 -0500
In-Reply-To: <20170108150043.GA8072@infradead.org> (Christoph Hellwig's
        message of "Sun, 8 Jan 2017 07:00:43 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

Christoph> On Tue, Nov 29, 2016 at 11:42:35AM -0500, Martin K. Petersen wrote:
>> >>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:
>> 
>> Somebody please review.

Christoph> review ping^2

Applied to 4.11/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering

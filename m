From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v5 2/5] qla2xxx: Utilize
 pci_alloc_irq_vectors/pci_free_irq_vectors calls.
Date: Tue, 13 Dec 2016 04:14:48 -0800
Message-ID: <20161213121448.GA16734@infradead.org>
References: <1481582409-22027-1-git-send-email-himanshu.madhani@cavium.com>
 <1481582409-22027-3-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45678 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753507AbcLMMOv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2016 07:14:51 -0500
Content-Disposition: inline
In-Reply-To: <1481582409-22027-3-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org

Looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

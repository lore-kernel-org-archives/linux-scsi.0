From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v4 4/6] qla2xxx: Add multiple queue pair functionality.
Date: Fri, 9 Dec 2016 05:10:16 -0800
Message-ID: <20161209131016.GA15254@infradead.org>
References: <1481051266-32362-1-git-send-email-himanshu.madhani@cavium.com>
 <1481051266-32362-5-git-send-email-himanshu.madhani@cavium.com>
 <20161207190502.GB29031@infradead.org>
 <693AAE59-413D-4416-837A-8E60A7C73455@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45801 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932474AbcLINKT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2016 08:10:19 -0500
Content-Disposition: inline
In-Reply-To: <693AAE59-413D-4416-837A-8E60A7C73455@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Cc: Christoph Hellwig <hch@infradead.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Ok.  We'll still need to use PCI_IRQ_AFFINITY here after it's removed
i nthe previous patch, but with pci_irq_alloc_vectors_affinity so that
we can get the separate non-assignment vector right as in the previous
discussion.

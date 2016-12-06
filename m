From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] qla4xxx: switch to pci_alloc_irq_vectors
Date: Tue, 6 Dec 2016 14:55:48 +0100
Message-ID: <20161206135548.GA20111@lst.de>
References: <1479453321-18036-1-git-send-email-hch@lst.de> <D46C98D7.43136%nilesh.javali@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53584 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751803AbcLFNzu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 6 Dec 2016 08:55:50 -0500
Content-Disposition: inline
In-Reply-To: <D46C98D7.43136%nilesh.javali@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Javali, Nilesh" <Nilesh.Javali@cavium.com>
Cc: Christoph Hellwig <hch@lst.de>, "QLogic-Storage-Upstream@qlogic.com" <QLogic-Storage-Upstream@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Nilesh,

> > try_msi:
> > 	/* Trying MSI */
> >-	ret = pci_enable_msi(ha->pdev);
> >+	ret = pci_alloc_irq_vectors(ha->pdev, 1, 1, PCI_IRQ_MSI);
> > 	if (!ret) {
> 
> Since pci_alloc_irq_vectors returns a negative error code upon error,
> This should be if (ret).

Fixes, thanks.

> Similarly, driver load fails here as pci_alloc_irq_vectors returns correct
> num of vectors.
> Hence this should be, if (ret < 0).

Also fixed.

The new version is on it's way.

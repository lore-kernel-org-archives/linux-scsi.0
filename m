From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] be2iscsi: switch to pci_alloc_irq_vectors
Date: Thu, 30 Mar 2017 10:47:33 +0200
Message-ID: <20170330084733.GA11989@lst.de>
References: <1484324988-30962-1-git-send-email-hch@lst.de> <yq1lgu5gswf.fsf@oracle.com> <29f55cdbd89162f2885494cd7d0472db@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:56582 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753985AbdC3Irg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Mar 2017 04:47:36 -0400
Content-Disposition: inline
In-Reply-To: <29f55cdbd89162f2885494cd7d0472db@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Subramanian Seetharaman <subbu.seetharaman@broadcom.com>, Ketan Mukadam <ketan.mukadam@broadcom.com>, linux-scsi@vger.kernel.org

On Mon, Jan 23, 2017 at 09:41:45AM +0530, Jitendra Bhivare wrote:
> We will be taking this up along with some other changes in the same area.

Any progress on that? I'd like to get be2iscsi off the old MSI-X API
for 4.12.

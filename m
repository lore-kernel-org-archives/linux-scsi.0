From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] csiostor: switch to pci_alloc_irq_vectors
Date: Fri, 31 Mar 2017 08:55:27 +0200
Message-ID: <20170331065527.GA3024@lst.de>
References: <1484325046-31032-1-git-send-email-hch@lst.de> <yq1h94tgsvd.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:33358 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752942AbdCaGz3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 31 Mar 2017 02:55:29 -0400
Content-Disposition: inline
In-Reply-To: <yq1h94tgsvd.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, hariprasad@chelsio.com, praveenm@chelsio.com

On Fri, Jan 20, 2017 at 07:27:02PM -0500, Martin K. Petersen wrote:
> >>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:
> 
> Christoph> And get automatic MSI-X affinity for free.
> 
> Chelsio folks: Please review and test!

ping!

From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V4 2/2] scsi: ufshcd-pci: Add Intel CNL support
Date: Wed, 7 Jun 2017 06:16:25 -0700
Message-ID: <20170607131625.GB18252@infradead.org>
References: <1496748931-17162-1-git-send-email-adrian.hunter@intel.com>
 <1496748931-17162-3-git-send-email-adrian.hunter@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:42769 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751664AbdFGNQ2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2017 09:16:28 -0400
Content-Disposition: inline
In-Reply-To: <1496748931-17162-3-git-send-email-adrian.hunter@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Subhash Jadavani <subhashj@codeaurora.org>, Santosh Yaragnavi <santosh.sy@samsung.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Szymon Mielczarek <szymonx.mielczarek@intel.com>, Michal Potomski <michalx.potomski@intel.com>, Grzegorz Janca <grzegorz.janca@intel.com>, Joao Pinto <Joao.Pinto@synopsys.com>

On Tue, Jun 06, 2017 at 02:35:31PM +0300, Adrian Hunter wrote:
> Add PCI id and variant ops for Intel CNL UFS host controller.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

It would be great if we could fold tc-dwc-g210-pci into ufshcd-pci the
same way.

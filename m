From: Varun Prakash <varun@chelsio.com>
Subject: Re: [PATCH] csiostor: switch to pci_alloc_irq_vectors
Date: Thu, 6 Apr 2017 20:56:07 +0530
Message-ID: <20170406152606.GA1646@chelsio.com>
References: <1484325046-31032-1-git-send-email-hch@lst.de>
 <yq1h94tgsvd.fsf@oracle.com>
 <20170331065527.GA3024@lst.de>
 <20170403145124.GA1743@chelsio.com>
 <20170404064614.GA9275@lst.de>
 <20170404081943.GA1665@chelsio.com>
 <20170405062656.GA26470@lst.de>
 <20170405153933.GA1912@chelsio.com>
 <20170406075858.GA32019@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:6078 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932662AbdDFP0P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2017 11:26:15 -0400
Content-Disposition: inline
In-Reply-To: <20170406075858.GA32019@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, Apr 06, 2017 at 09:58:58AM +0200, Christoph Hellwig wrote:
> Ok, the version below simplify skip the function split entirely:
> 
> ---
> From 7c9ca58f1d8cf53b42f14a51e02d0f3d0f12ab45 Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Thu, 12 Jan 2017 11:17:29 +0100
> Subject: csiostor: switch to pci_alloc_irq_vectors
> 
> And get automatic MSI-X affinity for free.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/csiostor/csio_hw.h  |   1 -
>  drivers/scsi/csiostor/csio_isr.c | 128 ++++++++++++++-------------------------
>  2 files changed, 47 insertions(+), 82 deletions(-)
>

Looks good.

Acked-by: Varun Prakash <varun@chelsio.com>

From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RESEND] aacraid: Fix 2T+ drives on SmartIOC-2000
Date: Fri, 15 Sep 2017 11:01:15 -0700
Message-ID: <20170915180115.GB24045@infradead.org>
References: <20170915170428.15237-1-david.carroll@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:41284 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751599AbdIOSBS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2017 14:01:18 -0400
Content-Disposition: inline
In-Reply-To: <20170915170428.15237-1-david.carroll@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Carroll <david.carroll@microsemi.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, aacraid@microsemi.com, Scott Benesh <scott.benesh@microsemi.com>, Brian King <brking@linux.vnet.ibm.com>, stable@vger.kernel.org

> +		if ((le32_to_cpu(dresp->status) == ST_OK) &&
> +			(le32_to_cpu(dresp->mnt[0].vol) != CT_NONE)) {
> +			_aac_probe_container2(context, fibptr);
> +			return;

		if (dresp->status == cpu_to_le32(ST_OK) &&
		    dresp->mnt[0].vol != cpu_to_le32(CT_NONE)) {

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] sd: Allow sd_print_sense_hdr to be called outside
	of sd.c
Date: Mon, 9 Jun 2008 03:06:50 -0400
Message-ID: <20080609070650.GA4770@infradead.org>
References: <yq1iqwml61r.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34041 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbYFIHGv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jun 2008 03:06:51 -0400
Content-Disposition: inline
In-Reply-To: <yq1iqwml61r.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Jun 06, 2008 at 03:25:20PM -0400, Martin K. Petersen wrote:
> +EXPORT_SYMBOL(sd_print_sense_hdr);

no need to export it, it should only be called from sd_mod.ko


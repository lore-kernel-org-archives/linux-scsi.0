From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi: lpfc: Replace pci_pool_alloc by pci_pool_zalloc
Date: Mon, 28 Nov 2016 11:21:26 +0100
Message-ID: <20161128102125.5zurgzgb4wpbotwp@linux-x5ow.site>
References: <20161128095237.GA30900@gnr743-HP-ZBook-15>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36715 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754384AbcK1KVd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Nov 2016 05:21:33 -0500
Content-Disposition: inline
In-Reply-To: <20161128095237.GA30900@gnr743-HP-ZBook-15>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Souptick Joarder <jrdr.linux@gmail.com>
Cc: james.smart@broadcom.com, dick.kennedy@broadcom.com, linux-scsi@vger.kernel.org

On Mon, Nov 28, 2016 at 03:22:37PM +0530, Souptick Joarder wrote:
> In lpfc_new_scsi_buf_s3() and lpfc_new_scsi_buf_s4() pci_pool_alloc
> followed by memset will be replaced by pci_pool_zalloc()
> 
> Signed-off-by: Souptick joarder <jrdr.linux@gmail.com>
> ---

Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

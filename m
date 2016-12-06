From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi: mvsas: Replace pci_pool_alloc by pci_pool_zalloc
Date: Tue, 6 Dec 2016 14:28:08 +0100
Message-ID: <20161206132808.GD4818@linux-x5ow.site>
References: <20161128112626.GA31859@gnr743-HP-ZBook-15>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46233 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752152AbcLFN2M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 6 Dec 2016 08:28:12 -0500
Content-Disposition: inline
In-Reply-To: <20161128112626.GA31859@gnr743-HP-ZBook-15>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Souptick Joarder <jrdr.linux@gmail.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, sahu.rameshwar73@gmail.com, linux-scsi@vger.kernel.org

On Mon, Nov 28, 2016 at 04:56:26PM +0530, Souptick Joarder wrote:
> Inside mvs_task_prep(), pci_pool_alloc() followed by memset will be
> replaced by pci_pool_zalloc()
> 
> Signed-off-by: Souptick joarder <jrdr.linux@gmail.com>
> ---

FWIW,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: sas: move scsi_remove_host call into
        sas_remove_host
Date: Fri, 21 Apr 2017 14:49:41 +0200
Message-ID: <20170421124941.GA24165@lst.de>
References: <20170421121141.20701-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:45701 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1038310AbdDUMtn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Apr 2017 08:49:43 -0400
Content-Disposition: inline
In-Reply-To: <20170421121141.20701-1-jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, James Bottomley <jejb@linux.vnet.ibm.com>, Jinpu Wang <jinpu.wang@profitbricks.com>, John Garry <john.garry@huawei.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

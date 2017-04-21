From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 0/5] Re-order scsi_remove_host and sas_remove_host in
 SAS HBA LLDDs
Date: Fri, 21 Apr 2017 13:22:23 +0200
Message-ID: <20170421112223.GL26346@linux-x5ow.site>
References: <cover.1492760075.git.jthumshirn@suse.de>
 <20170421111941.GA17971@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48781 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1038525AbdDULW0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Apr 2017 07:22:26 -0400
Content-Disposition: inline
In-Reply-To: <20170421111941.GA17971@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Jinpu Wang <jinpu.wang@profitbricks.com>, John Garry <john.garry@huawei.com>, tj@kernel.org

On Fri, Apr 21, 2017 at 01:19:41PM +0200, Christoph Hellwig wrote:
> 
> Any reason to not just make sas_remove_host call scsi_remove_host
> to ensure we get the ordering right?

No other than "haven't thought of it". But let me double check the LLDDs fist.

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

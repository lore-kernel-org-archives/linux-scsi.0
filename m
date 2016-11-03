From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 01/16] scsi: Get rid of struct fc_bsg_buffer
Date: Thu, 3 Nov 2016 08:15:10 -0700
Message-ID: <20161103151510.GA7404@infradead.org>
References: <cover.1476369687.git.jthumshirn@suse.de>
 <f3ec22a53e5165c8e57440e26dcc7b0dbb73800a.1476369687.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57968 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756911AbcKCPPO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Nov 2016 11:15:14 -0400
Content-Disposition: inline
In-Reply-To: <f3ec22a53e5165c8e57440e26dcc7b0dbb73800a.1476369687.git.jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>

On Thu, Oct 13, 2016 at 05:00:17PM +0200, Johannes Thumshirn wrote:
> struct fc_bsg_buffer is just a clone of struct bsg_buffer from bsg-lib,
> so use this one instead.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> Reviewed-by: Hannes Reinecke <hare@suse.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

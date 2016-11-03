From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 02/16] scsi: don't use fc_bsg_job::request and
 fc_bsg_job::reply directly
Date: Thu, 3 Nov 2016 08:17:51 -0700
Message-ID: <20161103151751.GD7404@infradead.org>
References: <cover.1476369687.git.jthumshirn@suse.de>
 <bbc682928173d64848ab0cbff689b1ad3d715fb7.1476369687.git.jthumshirn@suse.de>
 <ebc46cfa-0bee-aa71-ba0b-d7c86628df0c@linux.vnet.ibm.com>
 <20161014073821.qvkpjtwraqnwzzs3@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58956 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758086AbcKCPRy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Nov 2016 11:17:54 -0400
Content-Disposition: inline
In-Reply-To: <20161014073821.qvkpjtwraqnwzzs3@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Steffen Maier <maier@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Johannes Thumshirn <jth@kernel.org>, James Smart <james.smart@avagotech.com>, Dic

On Fri, Oct 14, 2016 at 09:38:21AM +0200, Johannes Thumshirn wrote:
> On Thu, Oct 13, 2016 at 05:55:11PM +0200, Steffen Maier wrote:
> > Hm, still behaves for me like I reported for v2:
> > http://marc.info/?l=linux-scsi&m=147637177902937&w=2
> 
> Hi Steffen,
> 
> Can you please try the following on top of 2/16?

How does this fit into the patch we're replying to?

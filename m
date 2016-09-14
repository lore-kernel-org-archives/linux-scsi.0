From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] sym53c8xx_2: use complete() instead complete_all()
Date: Wed, 14 Sep 2016 00:26:48 -0700
Message-ID: <20160914072648.GB17400@infradead.org>
References: <1473757130-14751-1-git-send-email-wagi@monom.org>
 <1473757130-14751-3-git-send-email-wagi@monom.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58154 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759965AbcINH0s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Sep 2016 03:26:48 -0400
Content-Disposition: inline
In-Reply-To: <1473757130-14751-3-git-send-email-wagi@monom.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Wagner <wagi@monom.org>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-kernel@vger.kernel.org, Daniel Wagner <daniel.wagner@bmw-carit.de>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

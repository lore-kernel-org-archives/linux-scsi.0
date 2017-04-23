From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: pmcraid: use normal copy_from_user
Date: Sun, 23 Apr 2017 01:28:56 -0700
Message-ID: <20170423082856.GA30869@infradead.org>
References: <20170420175549.3435196-1-arnd@arndb.de>
 <20170421220250.2427519-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38414 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1427967AbdDWI3N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Apr 2017 04:29:13 -0400
Content-Disposition: inline
In-Reply-To: <20170421220250.2427519-1-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Johannes Berg <johannes.berg@intel.com>, Baoyou Xie <baoyou.xie@linaro.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

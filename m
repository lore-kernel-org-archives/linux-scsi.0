From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 1/3] nvme_fc: create fc class and transport device
Date: Mon, 18 Sep 2017 09:13:30 -0700
Message-ID: <20170918161330.GC310@infradead.org>
References: <20170914173843.3195-1-jsmart2021@gmail.com>
 <20170914173843.3195-2-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:47106 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755847AbdIRQNb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Sep 2017 12:13:31 -0400
Content-Disposition: inline
In-Reply-To: <20170914173843.3195-2-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>
Cc: linux-nvme@lists.infradead.org, James Smart <james.smart@broadcom.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org

Looks ok,

although I really wish we could come up with some common FC code,
including making the existing FC drivers use more infrastructure
from libfc..

Reviewed-by: Christoph Hellwig <hch@lst.de>

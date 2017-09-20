From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 1/3] nvme_fc: create fc class and transport device
Date: Wed, 20 Sep 2017 10:50:18 -0700
Message-ID: <20170920175018.GA8962@infradead.org>
References: <20170914173843.3195-1-jsmart2021@gmail.com>
 <20170914173843.3195-2-jsmart2021@gmail.com>
 <20170918161330.GC310@infradead.org>
 <20170920103041.idkzk5kerewgv5yk@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:53323 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750938AbdITRuU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Sep 2017 13:50:20 -0400
Content-Disposition: inline
In-Reply-To: <20170920103041.idkzk5kerewgv5yk@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Smart <jsmart2021@gmail.com>, James Smart <james.smart@broadcom.com>, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org

On Wed, Sep 20, 2017 at 12:30:41PM +0200, Johannes Thumshirn wrote:
> the problem with libfc currently is it is made for fcoe, despite being named
> libfc.

Well, that's my point - we should be able to use more bits in a common
FC layer.  I don't really care about the exact name.

> The other hand it is hard-wired to FCP so bringing NVMe into it is a
> bit challanging, BTDT.

FC-NVMe layers on top of FCP.

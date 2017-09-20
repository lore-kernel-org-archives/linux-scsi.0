From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v3 1/3] nvme_fc: create fc class and transport device
Date: Wed, 20 Sep 2017 12:30:41 +0200
Message-ID: <20170920103041.idkzk5kerewgv5yk@linux-x5ow.site>
References: <20170914173843.3195-1-jsmart2021@gmail.com>
 <20170914173843.3195-2-jsmart2021@gmail.com>
 <20170918161330.GC310@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50464 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751693AbdITKao (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Sep 2017 06:30:44 -0400
Content-Disposition: inline
In-Reply-To: <20170918161330.GC310@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Smart <jsmart2021@gmail.com>, linux-nvme@lists.infradead.org, James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org

On Mon, Sep 18, 2017 at 09:13:30AM -0700, Christoph Hellwig wrote:
> Looks ok,
> 
> although I really wish we could come up with some common FC code,
> including making the existing FC drivers use more infrastructure
> from libfc..

the problem with libfc currently is it is made for fcoe, despite being named
libfc. The other hand it is hard-wired to FCP so bringing NVMe into it is a
bit challanging, BTDT.

It's not that it is impossible, it's just not something that can be done in a
day or two of hacking.

Anyways,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

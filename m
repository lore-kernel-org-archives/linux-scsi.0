From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v3 1/3] nvme_fc: create fc class and transport device
Date: Thu, 21 Sep 2017 07:16:15 +0200
Message-ID: <20170921051615.6fnmqktvuoi4smyr@linux-x5ow.site>
References: <20170914173843.3195-1-jsmart2021@gmail.com>
 <20170914173843.3195-2-jsmart2021@gmail.com>
 <20170918161330.GC310@infradead.org>
 <20170920103041.idkzk5kerewgv5yk@linux-x5ow.site>
 <20170920175018.GA8962@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36029 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750912AbdIUFQR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Sep 2017 01:16:17 -0400
Content-Disposition: inline
In-Reply-To: <20170920175018.GA8962@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Smart <jsmart2021@gmail.com>, James Smart <james.smart@broadcom.com>, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org

On Wed, Sep 20, 2017 at 10:50:18AM -0700, Christoph Hellwig wrote:
> On Wed, Sep 20, 2017 at 12:30:41PM +0200, Johannes Thumshirn wrote:
> > the problem with libfc currently is it is made for fcoe, despite being named
> > libfc.
> 
> Well, that's my point - we should be able to use more bits in a common
> FC layer.  I don't really care about the exact name.

Yes, that's on my long term TODO list, getting rid of the SKBs used internally
so ibmvfc can be switched over, allow the setting of the NVMe Type code (or
even arbitrary typecodes) yada, yada.  It'll benefit fnic, bnx2fc and qedfc as
well, but I haven't been able to do much in this regard. Hannes and I have
internal patchsets flying around solving the fist little bits for it but
they're far from completion.

Byte,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

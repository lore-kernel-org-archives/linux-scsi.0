From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] [Consult]: Can the coming Huawei scsi device handler
 be accepted in the scsi/device_handler
Date: Sat, 13 May 2017 00:37:26 -0700
Message-ID: <20170513073726.GA20048@infradead.org>
References: <a708085e-e9f0-3b5f-0290-00db8071a6b2@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:55670 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750935AbdEMHhd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 13 May 2017 03:37:33 -0400
Content-Disposition: inline
In-Reply-To: <a708085e-e9f0-3b5f-0290-00db8071a6b2@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guan Junxiong <guanjunxiong@huawei.com>
Cc: agk@redhat.com, snitzer@redhat.com, "Zouming (IT)" <zouming.zouming@huawei.com>, Yang Feng <philip.yang@huawei.com>, shenhong09@huawei.com, dm-devel@redhat.com, "Hege (A)" <hege09@huawei.com>, linux-scsi@vger.kernel.org

On Sat, May 13, 2017 at 12:07:04PM +0800, Guan Junxiong wrote:
> Hello,Alasdair and Mike:
>     I am going to add our vendor specific Huawei scsi device handler based on scsi_dh
> framework into the linux/drivers/scsi/device_handler directory.
>     Is it possible to be merged into the device handler list?

Any new device must support ALUA, other device handlers are legacy
only.

And btw, the right list for this is linux-scsi.

From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [PATCH 09/22] dm-crypt: Make use of the new sg_map helper in 4
 call sites
Date: Sat, 15 Apr 2017 11:47:00 -0600
Message-ID: <19b18d76-57fa-0a4f-252d-5d735105a159@deltatee.com>
References: <1492121135-4437-1-git-send-email-logang@deltatee.com>
 <1492121135-4437-10-git-send-email-logang@deltatee.com>
 <20170414083921.GC25471@lst.de>
 <302ae5ab-d515-5427-2e54-d58a9cdb8241@deltatee.com>
 <22703638-27a9-7dc5-5180-536f61661592@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:44437 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751582AbdDORr0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 15 Apr 2017 13:47:26 -0400
In-Reply-To: <22703638-27a9-7dc5-5180-536f61661592@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Milan Broz <gmazyland@gmail.com>, Christoph Hellwig <hch@lst.de>
Cc: Steve Wise <swise@opengridcomputing.com>, linux-nvme@lists.infradead.org, Stephen Bates <sbates@raithlin.com>, target-devel@vger.kernel.org, Sumit Semwal <sumit.semwal@linaro.org>, devel@driverdev.osuosl.org, rds-devel@oss.oracle.com, Sagi Grimberg <sagi@grimberg.me>, linux-scsi@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-rdma@vger.kernel.org, fcoe-devel@open-fcoe.org, Ross Zwisler <ross.zwisler@linux.intel.com>, open-iscsi@googlegroups.com, linux-media@vger.kernel.org, Ming Lin <ming.l@ssi.samsung.com>, intel-gfx@lists.freedesktop.org, sparmaintainer@unisys.com, linux-raid@vger.kernel.org, dri-devel@lists.freedesktop.org, Dan Williams <dan.j.williams@intel.com>, megaraidlinux.pdl@broadcom.com, Jens Axboe <axboe@kernel.dk>, linaro-mm-sig@

Thanks for the information Milan.

On 15/04/17 06:10 AM, Milan Broz wrote:
> I think your patch is ok (if it is just plain conversion), if it is
> really needed, we can switch to ahash later in follow-up patch.

Sounds good to me.

> p.s.
> there is a lot of lists on cc, but for this patch is missing dm-devel, dmcrypt changes
> need to go through Mike's tree (I added dm-devel to cc:)

Oh, sorry, I thought I had included all the lists. My hope however would
be to get the first patch merged and then re-send the remaining patches
to their respective maintainers. So that would have happened later. It's
hard to manage patches otherwise with such large distribution lists.

Logan

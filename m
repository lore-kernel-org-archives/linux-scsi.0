From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 3/3] scsi: libsas: initialize sas_phy status
        according to response of DISCOVER
Date: Thu, 4 Jan 2018 13:41:21 +0100
Message-ID: <20180104124121.GC6749@lst.de>
References: <20180104114741.37358-1-yanaijie@huawei.com> <20180104114741.37358-4-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48970 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752117AbeADMlW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 4 Jan 2018 07:41:22 -0500
Content-Disposition: inline
In-Reply-To: <20180104114741.37358-4-yanaijie@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, zhaohongjiang@huawei.com, miaoxie@huawei.com, hch@lst.de, hare@suse.com, chenxiang <chenxiang66@hisilicon.com>

On Thu, Jan 04, 2018 at 07:47:41PM +0800, Jason Yan wrote:
> +	phy->phy->enabled = (phy->linkrate == SAS_PHY_DISABLED) ? 0:1;

missing whitespaces around the ":, but this could just be simplified to:

	phy->phy->enabled = (phy->linkrate != SAS_PHY_DISABLED);

Otherwise this looks fine.

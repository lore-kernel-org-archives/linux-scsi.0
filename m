From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] nvme/scsi: Consider LBA format in IO splitting
 calculation
Date: Tue, 25 Apr 2017 10:57:57 -0700
Message-ID: <20170425175757.GB3575@infradead.org>
References: <20170425000243.2019-1-jonathan.derrick@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:55337 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1952304AbdDYR6G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Apr 2017 13:58:06 -0400
Content-Disposition: inline
In-Reply-To: <20170425000243.2019-1-jonathan.derrick@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jon Derrick <jonathan.derrick@intel.com>
Cc: axboe@fb.com, keith.busch@intel.com, sagi@grimberg.me, linux-scsi@vger.kernel.org, hch@infradead.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org

Applied to nvme-4.12.

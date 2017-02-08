From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 01/18] lpfc: Correct WQ creation for pagesize
Date: Wed, 8 Feb 2017 04:48:53 -0800
Message-ID: <20170208124853.GB23225@infradead.org>
References: <58990202.ppD+DnSRmfoY41ZK%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:47912 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751714AbdBHMt4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2017 07:49:56 -0500
Content-Disposition: inline
In-Reply-To: <58990202.ppD+DnSRmfoY41ZK%jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>
Cc: linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>


On Mon, Feb 06, 2017 at 03:08:50PM -0800, James Smart wrote:
> 
> Correct WQ creation for pagesize

Except that the (partial) subject should not be repeated in the body.

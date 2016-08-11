From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] nvme-fabrics: Add NVME FC Transport support to lpfc
Date: Thu, 11 Aug 2016 14:24:06 -0700
Message-ID: <20160811212406.GI18013@infradead.org>
References: <5792b920.7v71BUERlAKN8sK4%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53062 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932523AbcHKVYG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2016 17:24:06 -0400
Content-Disposition: inline
In-Reply-To: <5792b920.7v71BUERlAKN8sK4%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org

On Fri, Jul 22, 2016 at 05:24:00PM -0700, James Smart wrote:
> 
> This patchset adds NVME support to the lpfc FC driver.  It reworks
> the core driver for both NVME and SCSI protocol support, then adds the
> nvme-over-fabrics host and target interfaces which connect to the 
> NVME FC transport lower-level api.
> 
> Patches are cut against the linux-nvme for-4.8/drivers branch

Before reviewing the details:  what's the plan for merging this as we'll
have dependencies on both the SCSI and the block tree?

From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/5] nvme-fabrics: Add FC LLDD loopback driver to test FC
 host and target transport
Date: Thu, 11 Aug 2016 14:23:36 -0700
Message-ID: <20160811212336.GH18013@infradead.org>
References: <5792b91f.Lb5BdNQrSWnmgOYG%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52845 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbcHKVXh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2016 17:23:37 -0400
Content-Disposition: inline
In-Reply-To: <5792b91f.Lb5BdNQrSWnmgOYG%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org

On Fri, Jul 22, 2016 at 05:23:59PM -0700, James Smart wrote:
> 
> Add FC LLDD loopback driver to test FC host and target transport within
> nvme-fabrics
> 
> To aid in the development and testing of the lower-level api of the FC
> transport, this loopback driver has been created to act as if it were a
> FC hba driver supporting both the host interfaces as well as the target
> interfaces with the nvme FC transport.

A proper FC loop device should support SCSI and NVMe.  Any chance to
morph it into one that does both?

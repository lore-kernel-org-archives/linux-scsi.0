From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] mpt2sas: Remove acquisition of host_lock
Date: Wed, 6 Apr 2011 09:45:55 -0400
Message-ID: <20110406134555.GA21729@infradead.org>
References: <20110405214355.GQ4183@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46750 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896Ab1DFNp5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Apr 2011 09:45:57 -0400
Content-Disposition: inline
In-Reply-To: <20110405214355.GQ4183@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com

On Tue, Apr 05, 2011 at 05:43:55PM -0400, Matthew Wilcox wrote:
> 
> We can eliminate the use of the scsi command serial_number, as the race
> that the driver is checking for cannot happen.
> 
> Then the driver no longer needs to use the DEF_SCSI_QCMD() macro and no
> longer acquires the host_lock.  This improves performance substantially
> on high-IOPS workloads.


Looks fine.  Note that this somehow clashes with my patch to simply
remove the serial_number check from mpt2sas.  We could just drop my
smaller patch if this one gets in in a timely fashion.


From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/7] mpt3sas: Remove use of DEF_SCSI_QCMD
Date: Wed, 2 Apr 2014 03:41:15 -0700
Message-ID: <20140402104115.GB6510@infradead.org>
References: <cover.1395952569.git.matthew.r.wilcox@intel.com>
 <2ce8dda9284f463216f4c527d32fee497f9da3ac.1395952569.git.matthew.r.wilcox@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58571 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758143AbaDBKlP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Apr 2014 06:41:15 -0400
Content-Disposition: inline
In-Reply-To: <2ce8dda9284f463216f4c527d32fee497f9da3ac.1395952569.git.matthew.r.wilcox@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-scsi@vger.kernel.org, willy@linux.intel.com

On Thu, Mar 27, 2014 at 04:40:31PM -0400, Matthew Wilcox wrote:
> Removing the host_lock from the I/O submission path gives a huge
> scalability improvement.

This looks reasonable to me, but did you do a full audit that all state
is properly synchronized in the functions called from _scsih_qcmd_lck?

If so that should be stated in the patch description.


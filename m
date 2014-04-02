From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 2/7] mpt3sas: Remove use of DEF_SCSI_QCMD
Date: Wed, 2 Apr 2014 09:20:14 -0400
Message-ID: <20140402132014.GD5667@linux.intel.com>
References: <cover.1395952569.git.matthew.r.wilcox@intel.com>
 <2ce8dda9284f463216f4c527d32fee497f9da3ac.1395952569.git.matthew.r.wilcox@intel.com>
 <20140402104115.GB6510@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:5999 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758688AbaDBNWE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Apr 2014 09:22:04 -0400
Content-Disposition: inline
In-Reply-To: <20140402104115.GB6510@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-scsi@vger.kernel.org

On Wed, Apr 02, 2014 at 03:41:15AM -0700, Christoph Hellwig wrote:
> On Thu, Mar 27, 2014 at 04:40:31PM -0400, Matthew Wilcox wrote:
> > Removing the host_lock from the I/O submission path gives a huge
> > scalability improvement.
> 
> This looks reasonable to me, but did you do a full audit that all state
> is properly synchronized in the functions called from _scsih_qcmd_lck?
> 
> If so that should be stated in the patch description.

I did one for mpt2sas back in July 2011 when I first submitted this patch.
http://marc.info/?l=linux-scsi&m=130980763617589&w=2

I must confess to having not done so for this iteration.  The equivalent
to this patch has been in RHEL since 6.2, so I hope that gives us some
amount of confidence.


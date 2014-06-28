From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] Introduce XEN scsiback module
Date: Sat, 28 Jun 2014 11:09:53 -0700
Message-ID: <20140628180953.GA10820@infradead.org>
References: <1403879676-25431-1-git-send-email-jgross@suse.com>
 <1403879676-25431-4-git-send-email-jgross@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59602 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756410AbaF1SKA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Jun 2014 14:10:00 -0400
Content-Disposition: inline
In-Reply-To: <1403879676-25431-4-git-send-email-jgross@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgross@suse.com
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, xen-devel@lists.xen.org, target-devel@vger.kernel.org

On Fri, Jun 27, 2014 at 04:34:35PM +0200, jgross@suse.com wrote:
> From: Juergen Gross <jgross@suse.com>
> 
> Introduces the XEN pvSCSI backend. With pvSCSI it is possible for a XEN domU
> to issue SCSI commands to a SCSI LUN assigned to that domU. The SCSI commands
> are passed to the pvSCSI backend in a driver domain (usually Dom0) which is
> owner of the physical device. This allows e.g. to use SCSI tape drives in a
> XEN domU.

This should be written against the generic target core infrastructure
in drivers/target, instead of introducing another simplistic pass
through only SCSI target.

From: Christoph Hellwig <hch@infradead.org>
Subject: Re: SCSI core patches for kernel 3.12
Date: Wed, 2 Oct 2013 00:40:06 -0700
Message-ID: <20131002074006.GA8994@infradead.org>
References: <52135B99.2000102@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42425 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab3JBHkr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Oct 2013 03:40:47 -0400
Content-Disposition: inline
In-Reply-To: <52135B99.2000102@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, David Milburn <dmilburn@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

James, and comments on this?

On Tue, Aug 20, 2013 at 02:05:45PM +0200, Bart Van Assche wrote:
> This patch series consists of four patches that address device
> removal issues and three patches that improve performance of the
> SCSI mid-layer.
> 
> The individual patches are.
> 0001-Introduce-scsi_device_being_removed.patch
> 0002-Rework-scsi_internal_device_unblock.patch
> 0003-Avoid-re-enabling-I-O-after-the-transport-became-off.patch
> 0004-Disallow-changing-the-device-state-via-sysfs-into-de.patch
> 0005-Micro-optimize-scsi_request_fn.patch
> 0006-Rename-scsi_get_command-and-scsi_put_command.patch
> 0007-Micro-optimize-scsi_next_command.patch
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---

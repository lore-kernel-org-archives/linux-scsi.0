From: James Bottomley <jbottomley@parallels.com>
Subject: Re: SCSI core patches for kernel 3.12
Date: Wed, 2 Oct 2013 15:15:20 +0000
Message-ID: <1380726918.2081.43.camel@dabdike>
References: <52135B99.2000102@acm.org> <20131002074006.GA8994@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:50697 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050Ab3JBPQo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Oct 2013 11:16:44 -0400
In-Reply-To: <20131002074006.GA8994@infradead.org>
Content-Language: en-US
Content-ID: <397660E3A69B97489DCC58A52039A3F7@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bvanassche@acm.org>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, David Milburn <dmilburn@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

And I thought the world was ending when Linus started top posting ...

On Wed, 2013-10-02 at 00:40 -0700, Christoph Hellwig wrote:
> James, and comments on this?

You mean apart from the fact that it's a long series which seems to self
confess to providing not much value and therefore not rating itself high
on the review list?

So if I get the gist, the only real value is removing a pair of get/put
calls in the critical path, so produce a single patch doing that and it
will all go a lot faster than having to review seven code movement and
pointless rename patches.

James

> On Tue, Aug 20, 2013 at 02:05:45PM +0200, Bart Van Assche wrote:
> > This patch series consists of four patches that address device
> > removal issues and three patches that improve performance of the
> > SCSI mid-layer.
> > 
> > The individual patches are.
> > 0001-Introduce-scsi_device_being_removed.patch
> > 0002-Rework-scsi_internal_device_unblock.patch
> > 0003-Avoid-re-enabling-I-O-after-the-transport-became-off.patch
> > 0004-Disallow-changing-the-device-state-via-sysfs-into-de.patch
> > 0005-Micro-optimize-scsi_request_fn.patch
> > 0006-Rename-scsi_get_command-and-scsi_put_command.patch
> > 0007-Micro-optimize-scsi_next_command.patch
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> ---end quoted text---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] scsi: Implement 'ZBC' device type
Date: Mon, 2 Jun 2014 01:39:19 -0700
Message-ID: <20140602083919.GA31170@infradead.org>
References: <1401692478-23557-1-git-send-email-hare@suse.de>
 <1401692478-23557-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48618 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbaFBIjU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 04:39:20 -0400
Content-Disposition: inline
In-Reply-To: <1401692478-23557-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Mon, Jun 02, 2014 at 09:01:18AM +0200, Hannes Reinecke wrote:
> ZBC (zoned block command aka 'SMR drives') devices will have
> a new device type 0x14 assigned by T10. So add the necessary
> mappings to sd.c and make it an alias for ATA ZAC devices.

The libata changes should defintively be a separate one, the sd changes
probably as well.

But I'm uneasy with adding anything like this for now, for one the specs
aren't even anywhere close to done, and second attaching ZBC devices
in general doesn't sound like a very smart idea, we really need a
strategy for the sequential required zones first.

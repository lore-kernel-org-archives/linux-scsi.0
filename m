From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/6] scsi: remove a useless get/put_device pair in
 scsi_requeue_command
Date: Wed, 12 Feb 2014 07:58:51 -0800
Message-ID: <20140212155851.GC7587@infradead.org>
References: <20140206184306.997538898@bombadil.infradead.org>
 <20140206184418.178186483@bombadil.infradead.org>
 <52FB5DA8.5050602@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56279 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbaBLP6v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Feb 2014 10:58:51 -0500
Content-Disposition: inline
In-Reply-To: <52FB5DA8.5050602@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

On Wed, Feb 12, 2014 at 12:40:24PM +0100, Hannes Reinecke wrote:
> On 02/06/2014 07:43 PM, Christoph Hellwig wrote:
> > Avoid a spurious device get/put cycle by using scsi_put_command and folding
> > scsi_unprep_request into scsi_requeue_command.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> Makes one wonder why we didn't do this to start with.

Because we couldn't do it when the device get/put was hidden in the
scsi_get_command/scsi_put_command.


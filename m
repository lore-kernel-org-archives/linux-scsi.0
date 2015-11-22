From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] scsi_transport_fc: Introduce scsi_host_{get,put}()
Date: Sun, 22 Nov 2015 07:03:57 -0800
Message-ID: <20151122150357.GA22575@infradead.org>
References: <564F910E.9070306@sandisk.com>
 <564F9190.5090103@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58474 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbbKVPEE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Nov 2015 10:04:04 -0500
Content-Disposition: inline
In-Reply-To: <564F9190.5090103@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Smart <james.smart@emulex.com>

On Fri, Nov 20, 2015 at 01:33:04PM -0800, Bart Van Assche wrote:
> Use scsi_host_{get,put}() instead of open-coding these functions.
> Compile-tested only.

s/Introdue/use/ in the subject?

Otherwise this looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

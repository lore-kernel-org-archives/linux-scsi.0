From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] scsi_dh_alua: Fix a recently introduced deadlock
Date: Tue, 29 Mar 2016 00:34:19 -0700
Message-ID: <20160329073419.GB8568@infradead.org>
References: <56F9740A.4060100@sandisk.com>
 <56F9746C.40101@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40542 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbcC2HeW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Mar 2016 03:34:22 -0400
Content-Disposition: inline
In-Reply-To: <56F9746C.40101@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

This indeed looks like the only place where we took pg->lock without
disabling irqs.

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/7] Micro-optimize scsi_request_fn()
Date: Sun, 1 Sep 2013 09:50:21 -0700
Message-ID: <20130901165021.GE4344@infradead.org>
References: <52135B99.2000102@acm.org>
 <52135C72.6070304@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59131 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757811Ab3IAQu3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Sep 2013 12:50:29 -0400
Content-Disposition: inline
In-Reply-To: <52135C72.6070304@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, David Milburn <dmilburn@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

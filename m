From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/7] Avoid re-enabling I/O after the transport became
 offline
Date: Sun, 1 Sep 2013 09:46:09 -0700
Message-ID: <20130901164609.GC4344@infradead.org>
References: <52135B99.2000102@acm.org>
 <52135C26.3060700@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59112 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822Ab3IAQqP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Sep 2013 12:46:15 -0400
Content-Disposition: inline
In-Reply-To: <52135C26.3060700@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, David Milburn <dmilburn@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

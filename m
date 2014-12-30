From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi_scan: Send TEST UNIT READY to LUN0 before LUN
 scanning
Date: Tue, 30 Dec 2014 04:09:36 -0800
Message-ID: <20141230120936.GC32187@infradead.org>
References: <1417711162-102950-1-git-send-email-hare@suse.de>
 <1417738774.8998.21.camel@parallels.com>
 <5481FC30.1090801@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37246 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbaL3MJk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Dec 2014 07:09:40 -0500
Content-Disposition: inline
In-Reply-To: <5481FC30.1090801@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Matthias.Roessler@ts.fujitsu.com" <Matthias.Roessler@ts.fujitsu.com>

Can you resend a version with the small updates pointed out by
James?  I'd rather get the full UA handling, but it seems like that will
take longer, so I'd rather get something in to get the Fujitsu arrays
working ASAP.

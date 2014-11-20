From: Christoph Hellwig <hch@infradead.org>
Subject: Re: split ->change_queue_depth
Date: Wed, 19 Nov 2014 22:13:45 -0800
Message-ID: <20141120061345.GA26083@infradead.org>
References: <1415901546-8006-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42787 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaKTGNu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Nov 2014 01:13:50 -0500
Content-Disposition: inline
In-Reply-To: <1415901546-8006-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, James Smart <james.smart@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>

Any chance to get some reviews for this series?  I'd like to get it in
for the 3.19 window to avoid two related API changes in two consecutive
releases.


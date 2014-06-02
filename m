From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCHv3 0/6]  Support 64-bit LUNs
Date: Mon, 2 Jun 2014 01:15:41 -0700
Message-ID: <20140602081541.GA24684@infradead.org>
References: <1401526878-119472-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35340 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbaFBIPo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 04:15:44 -0400
Content-Disposition: inline
In-Reply-To: <1401526878-119472-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org

Do we have any good testcases for this, especially the scsilun_to_int
change?  Can we export big enough luns from the target core or
scsi_debug?  If not I'd really like to see that support to ease testing.


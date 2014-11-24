From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv2 00/12] Re-implement am53c974 driver
Date: Mon, 24 Nov 2014 09:14:03 +0100
Message-ID: <20141124081403.GA18574@lst.de>
References: <1416573716-73890-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:35465 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753159AbaKXIOH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2014 03:14:07 -0500
Content-Disposition: inline
In-Reply-To: <1416573716-73890-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, "David S. Miller" <davem@davemloft.net>, linux-scsi@vger.kernel.org

I'm tempted to merge this into drivers-for-3.19 ASAP, any argument against
that?  Guennadi, do you have any additional hardware to Hannes one real and one
virtual adapter to test this new driver on before?

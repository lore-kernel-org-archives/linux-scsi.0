From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v1 Resend] mpt2sas: setpci reset kernel oops fix
Date: Wed, 8 Jul 2015 01:00:03 -0700
Message-ID: <20150708080003.GA5668@infradead.org>
References: <20150708054747.GA14777@nagalsi.ban.indi.seagate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39552 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934332AbbGHIAG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2015 04:00:06 -0400
Content-Disposition: inline
In-Reply-To: <20150708054747.GA14777@nagalsi.ban.indi.seagate.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nagarajkumar Narayanan <nagarajkumar.narayanan@seagate.com>
Cc: linux-scsi@vger.kernel.org, jthumshirn@suse.de, hch@infradead.org


On Wed, Jul 08, 2015 at 11:17:47AM +0530, Nagarajkumar Narayanan wrote:
> Note: pci_access_mutex is used only if nytro warpdrive cards 
> (ioc->is_warpdrive based on device id) are used
> as we could not test this case with other SAS2 HBA cards
> We can remove this check if this behaviour confirmed from other
> cards.

I don't see any downside of taking the lock, and conditional locking
like this is a always a bad sign.

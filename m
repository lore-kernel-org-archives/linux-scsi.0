From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCHv5 0/4] Support 64-bit LUNs
Date: Wed, 25 Jun 2014 08:00:52 -0700
Message-ID: <20140625150052.GA2339@infradead.org>
References: <1403702859-74437-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50871 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756662AbaFYPAy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jun 2014 11:00:54 -0400
Content-Disposition: inline
In-Reply-To: <1403702859-74437-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

Thanks Hannes,

I've applied this and the logging series to the core-for-3.17 branch.
Note that I will still rebase this branch to deal with whatever feedback
Rusty might have on the modparam changes.


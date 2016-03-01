From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] scsi_transport_fc: Implement 'async_user_scan'
	module parameter
Date: Tue, 1 Mar 2016 14:15:20 +0100
Message-ID: <20160301131520.GB7786@lst.de>
References: <1456127462-2817-1-git-send-email-hare@suse.de> <1456127462-2817-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:40477 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593AbcCANPW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2016 08:15:22 -0500
Content-Disposition: inline
In-Reply-To: <1456127462-2817-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jthumshirn@suse.com>, linux-scsi@vger.kernel.org

Bah.  Async scanning seems useful, but it shouldn't be a module option
that breaks exsiting users of the attribute, and it shouldn't be in
the FC transport class.

Just add a new async_scan attribute that works like scan, but works
asynchronously in the core.

Or figure out if we can overload the already parsed but ignored
junk argument in the scan attribute to accept an 'a' for async?

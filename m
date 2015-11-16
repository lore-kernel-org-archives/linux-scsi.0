From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] Restart list search after unlock in
	scsi_remove_target
Date: Mon, 16 Nov 2015 18:57:29 +0100
Message-ID: <20151116175729.GA1238@lst.de>
References: <5633E9F2.5080209@sandisk.com> <5633EA98.8050604@sandisk.com> <563A883C.9060501@sandisk.com> <1446677072.2216.30.camel@HansenPartnership.com> <563A92AE.5000605@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:52940 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488AbbKPR5a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Nov 2015 12:57:30 -0500
Content-Disposition: inline
In-Reply-To: <563A92AE.5000605@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Dan Williams <dan.j.williams@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Bart, can you resend your patch on top of 4.4-rc1?  I think we really
need it so we should get it into 4.4 and backport it to -stable.

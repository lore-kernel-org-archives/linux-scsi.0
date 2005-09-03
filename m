From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/7] zfcp: introduce eh_timed_out handler
Date: Sat, 3 Sep 2005 15:53:00 +0100
Message-ID: <20050903145300.GA20520@infradead.org>
References: <20050903123042.GA7902@lion28.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:42925 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751464AbVICOxB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 3 Sep 2005 10:53:01 -0400
Content-Disposition: inline
In-Reply-To: <20050903123042.GA7902@lion28.boeblingen.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Herrmann <aherrman@de.ibm.com>
Cc: James Bottomley <jejb@steeleye.com>, Linux SCSI <linux-scsi@vger.kernel.org>

On Sat, Sep 03, 2005 at 02:30:42PM +0200, Andreas Herrmann wrote:
> zfcp: introduce eh_timed_out handler
> 
> This handler is required to avoid offlined SCSI devices in a multipath
> setup if scsi commands time out on cable pulls lasting longer than 30
> seconds.

Please don't do this.  We have proper midlayer handling (plus FC transport
class wrappers) to handle that case without introducing a big mess in the
driver.  Please take a look at fc_remote_port_{block,unblock}


From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/13] hpsa update
Date: Thu, 20 Nov 2014 07:55:20 -0800
Message-ID: <20141120155520.GC26189@infradead.org>
References: <20141114231145.20808.76898.stgit@don-ProLiant-MicroServer-Gen8>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60402 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbaKTPz0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Nov 2014 10:55:26 -0500
Content-Disposition: inline
In-Reply-To: <20141114231145.20808.76898.stgit@don-ProLiant-MicroServer-Gen8>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>
Cc: hch@infradead.org, webb.scales@hp.com, james.bottomley@parallels.com, brace@pmcs.com, linux-scsi@vger.kernel.org

I've applied all patches to drivers-for-3.19.

If you could do me two favours:

 - please look into sparse endianess warnings.  This series introduces
   a few new ones, but given that the area around it was full of it
   I didn't pull it for that for now.
 - please review the various hpsa fixes Tomas Henzl sent over the last
   few weeks.

Thanks,
	Christoph

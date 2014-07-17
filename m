From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/10] sd: don't use scsi_setup_blk_pc_cmnd for write
 same requests
Date: Thu, 17 Jul 2014 08:29:54 -0700
Message-ID: <20140717152954.GA3146@infradead.org>
References: <1404048881-19526-1-git-send-email-hch@lst.de>
 <1404048881-19526-6-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57108 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933145AbaGQP3z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jul 2014 11:29:55 -0400
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red Hat Linux))
	id 1X7nd4-0001bG-VG
	for linux-scsi@vger.kernel.org; Thu, 17 Jul 2014 15:29:54 +0000
Content-Disposition: inline
In-Reply-To: <1404048881-19526-6-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Can I get a second review in addition to the one from Martin for this
one?  This is the last blocker for merging the series and pushing an
updated branch out!


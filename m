From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] drivers/scsi/aic7xxx/aic7xxx_osm.c: replace
 kmalloc/memset 0 by kzalloc
Date: Wed, 28 May 2014 03:42:40 -0700
Message-ID: <20140528104240.GH13542@infradead.org>
References: <1401214732-5422-1-git-send-email-fabf@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56962 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbaE1Kml (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 May 2014 06:42:41 -0400
Content-Disposition: inline
In-Reply-To: <1401214732-5422-1-git-send-email-fabf@skynet.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <JBottomley@parallels.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

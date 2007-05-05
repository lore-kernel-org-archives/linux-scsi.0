From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] remove long dead DMA_INT
Date: Sat, 5 May 2007 10:35:52 +0100
Message-ID: <20070505093552.GA9422@infradead.org>
References: <Pine.LNX.4.60.0705042255150.21060@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:52235 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423248AbXEEJfy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 May 2007 05:35:54 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0705042255150.21060@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On Fri, May 04, 2007 at 10:57:37PM +0200, Guennadi Liakhovetski wrote:
> DMA_INT code is disabled since 1998, remove it to prepare
> for further cleanup.

Yeah, go for killing that cruft :)


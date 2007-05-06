From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] tmscsim: remove bogus endianness conversions
Date: Sun, 6 May 2007 12:20:55 +0100
Message-ID: <20070506112055.GA1597@infradead.org>
References: <Pine.LNX.4.60.0705042257410.21060@poirot.grange> <20070505093751.GB9422@infradead.org> <Pine.LNX.4.60.0705052308460.9593@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:38685 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712AbXEFLU4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 May 2007 07:20:56 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0705052308460.9593@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On Sat, May 05, 2007 at 11:18:30PM +0200, Guennadi Liakhovetski wrote:
> Yeah, but these variables are not like that.

Sorry, I didn't mean to imply that.  This patch is obviously fine as-is.


From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH, 2.6] tmscsim - no internal command-queuing
Date: Thu, 19 Feb 2004 15:13:33 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040219151333.A24006@infradead.org>
References: <20040201111726.A14042@infradead.org> <Pine.LNX.4.44.0402032337230.3772-100000@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:7173 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S267395AbUBSPNl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Feb 2004 10:13:41 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0402032337230.3772-100000@poirot.grange>; from g.liakhovetski@gmx.de on Tue, Feb 03, 2004 at 11:41:43PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Kurt Garloff <kurt@garloff.de>

> Ouch. Whereas the rest are either rather intelligent things I didn't know
> about, or something I didn't want / dare to modify without a burning need,
> this is definitely just a plain simple bug - I did see it was a noop, and
> I did think at some point to preserve its consistency, until I forgot
> about it:-)

Kurt, do you have any opinion on those patches?  I'd love to see them going
in for 2.6.4


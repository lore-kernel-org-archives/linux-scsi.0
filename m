From: Christoph Hellwig <hch@infradead.org>
Subject: Re: TMSCSIM [2.6] (was: Re: [PATCH] Re: AMD 53c974 SCSI driver in 2.6)
Date: Mon, 24 Nov 2003 07:47:21 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031124074721.B29095@infradead.org>
References: <Pine.LNX.4.44.0311202354360.2876-100000@poirot.grange> <Pine.LNX.4.44.0311230024300.1354-100000@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:53509 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263647AbTKXHrW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2003 02:47:22 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0311230024300.1354-100000@poirot.grange>; from g.liakhovetski@gmx.de on Sun, Nov 23, 2003 at 12:27:32AM +0100
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

On Sun, Nov 23, 2003 at 12:27:32AM +0100, Guennadi Liakhovetski wrote:
> The appended patch is an attempt to fix the tmscsim driver for 2.6. Tested
> only on an on-board AM53C974 controller so far.

Patch looks good as far as I can see, of course there's lot of cleanup
potential, but let's have a working driver in mainline first..


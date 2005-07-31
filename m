From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 100% repeatable way to send firewire out to lunch permanently on 2.6.8.1
Date: Sun, 31 Jul 2005 18:59:46 +0100
Message-ID: <20050731175946.GA8511@infradead.org>
References: <Pine.LNX.4.44.0507310739320.13193-100000@sasami.anime.net> <42ED0AE6.7020300@s5r6.in-berlin.de> <42ED1073.7010004@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:40391 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261844AbVGaR7u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 31 Jul 2005 13:59:50 -0400
Content-Disposition: inline
In-Reply-To: <42ED1073.7010004@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net

On Sun, Jul 31, 2005 at 07:54:59PM +0200, Stefan Richter wrote:
> Well, the LLD can _try_ it, but it may go horribly wrong.

It seems to work nicely for everyone but sbp2..

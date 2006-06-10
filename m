From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Remove last page_address from dc395x.c
Date: Sat, 10 Jun 2006 14:40:42 +0100
Message-ID: <20060610134042.GA7764@infradead.org>
References: <Pine.LNX.4.60.0606092216460.5256@poirot.grange> <1149904465.3131.19.camel@laptopd505.fenrus.org> <20060610095038.GA20526@infradead.org> <Pine.LNX.4.60.0606101528170.3305@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:51848 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751071AbWFJNkp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jun 2006 09:40:45 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0606101528170.3305@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Christoph Hellwig <hch@infradead.org>, Arjan van de Ven <arjan@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, Jamie Lenehan <lenehan@twibble.org>, linux-scsi@vger.kernel.org

On Sat, Jun 10, 2006 at 03:29:58PM +0200, Guennadi Liakhovetski wrote:
> > > hmm I wonder if the non-use-sg case can ever happen?
> > > (and if that irq_save isn't leaking here)
> > 
> > It can still happen in when invoked through the EH code, but I plan to fix
> > that for 2.6.18.
> 
> "can happen" - you mean INQUIRY without sg (NOT irq_save leaking)?

Oh, that's a path only reached for INQUIRY commands.  No, there is no
chance to get non-sg commands for 2.6.17+


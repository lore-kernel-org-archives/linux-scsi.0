From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] normalize fixed and descriptor sense data
Date: Fri, 27 Aug 2004 16:52:44 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040827165244.A32542@infradead.org>
References: <412EF74A.1070106@torque.net> <20040827161800.A32040@infradead.org> <412F571A.8040607@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:63754 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S266289AbUH0Pwu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Aug 2004 11:52:50 -0400
Content-Disposition: inline
In-Reply-To: <412F571A.8040607@adaptec.com>; from luben_tuikov@adaptec.com on Fri, Aug 27, 2004 at 11:45:30AM -0400
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Christoph Hellwig <hch@infradead.org>, Douglas Gilbert <dougg@torque.net>, linux-scsi@vger.kernel.org

On Fri, Aug 27, 2004 at 11:45:30AM -0400, Luben Tuikov wrote:
> Christoph Hellwig wrote:
> > 
> > +struct scsi_sense_hd {     /* See SPC-3 section 4.5 */
> > 
> > maybe scsi_sense_desc insted?
> 
> Why, when it's neither in descriptor format nor in fixed
> format?
> 
> It is just a header of the _consolidated_ format
> of the sense data, thus the name used makes sense.

Umm, right, makes sense.  the _hd postfix still looks strange to me.
Either _hdr as standard short-notation for header or even better just
remove it.

> > Also I think this function should get a __ prefix and we should
> > add two small helpers that take a scsi_cmnd/scsi_request and use
> > the sense_buffer and len from it.
> 
> But it should be exported nevertheless, as LLDDs may like
> to use it.

Makes sense.


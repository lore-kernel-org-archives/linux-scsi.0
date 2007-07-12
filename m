From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: Data accessors more patches
Date: Fri, 13 Jul 2007 07:37:30 +0900
Message-ID: <20070712140354C.tomof@acm.org>
References: <468BE4CE.80402@panasas.com>
	<46962910.4060403@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mfo11.iij4u.or.jp ([210.138.174.81]:49193 "EHLO
	mfo11.iij4u.or.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090AbXGLWux (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jul 2007 18:50:53 -0400
In-Reply-To: <46962910.4060403@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.orgfujita.tomonori@lab.ntt.co.jp

From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Data accessors more patches
Date: Thu, 12 Jul 2007 16:13:52 +0300

> Boaz Harrosh wrote:
> > As a reply to this email I will send some more files
> > converted to new data accessors, and attempts of cleanups
> > of: !use_sg code path's, use of scsi_for_each_sg and use
> > of scsi_{,un}map_dma().
> > 
> > some of these files are in scsi-ml core but they can be converted
> > now, and are not at all dependent on implementation.
> > 
> > libata-scsi.c	- code will now work with scsi_sgtable but farther cleanup is needed.
> > scsi.c 		- some prints might as well use accessors now.
> > scsi_debug.c	- This is actually a scsi LLD. Normal conversion.
> > 
> > The rest of the converted files I will send in the following days
> > 
> > Boaz
> > 
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Tomo hi.
> 
> I would like your Signed-off-by: on all of these. Since you
> have more experience with these cleanups.

aha152x, ide-scsi and libata-scsi?

Well, when I tried to convert them, I thought that it would be better
to leave them to the maintainers. They look broken or too complicated.

I'd like to save 'just do grep and replace' and 'convert without
confidence' options.

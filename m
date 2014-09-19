From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 20/22] scsi: align logging messages
Date: Fri, 19 Sep 2014 04:35:00 -0700
Message-ID: <20140919113500.GA29869@infradead.org>
References: <1409247216-76074-1-git-send-email-hare@suse.de>
 <1409247216-76074-21-git-send-email-hare@suse.de>
 <20140831222556.GL16432@infradead.org>
 <94D0CD8314A33A4D9D801C0FE68B402958C2F65E@G9W0745.americas.hpqcorp.net>
 <20140906003403.GB18426@infradead.org>
 <94D0CD8314A33A4D9D801C0FE68B402958C8BDA3@G9W0745.americas.hpqcorp.net>
 <541BCC95.1010901@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38628 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028AbaISLfE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Sep 2014 07:35:04 -0400
Content-Disposition: inline
In-Reply-To: <541BCC95.1010901@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>

On Fri, Sep 19, 2014 at 08:26:29AM +0200, Hannes Reinecke wrote:
> I would rather use 'scmd->tag', as this should be a straight copy
> of scmd->request->tag, but we wouldn't need to reference the request
> when doing so.

Yes, for now scmd->tag is correct as drivers might not be using the
block level tagging.  Once we get rid of the legacy request path I
plan to entirely remove scmd->tag, though.

> But yeah, I was planning on doing the same, only I'd rather include
> it right a the start like
> 
> sd 2:0:0:3 [sdv] tag#1: abort scheduled

Sounds fine.

> and print out a mapping when I/O is submitted
> 
> sd 2:0:0:3 [sdv] tag#1: scmd 0xffff880420891470

I don't really see a need for that.

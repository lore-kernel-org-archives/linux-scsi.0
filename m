From: Christoph Hellwig <hch@infradead.org>
Subject: Re: lk 3.17-rc4 blk_mq large write problems
Date: Wed, 17 Sep 2014 10:04:38 -0700
Message-ID: <20140917170438.GA31473@infradead.org>
References: <540FCB96.8000606@interlog.com>
 <20140910154144.GA22296@infradead.org>
 <5410F3CB.8070400@interlog.com>
 <54110235.6000901@kernel.dk>
 <94D0CD8314A33A4D9D801C0FE68B402958C72114@G9W0745.americas.hpqcorp.net>
 <541134FF.40807@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33982 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587AbaIQREm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Sep 2014 13:04:42 -0400
Content-Disposition: inline
In-Reply-To: <541134FF.40807@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Jens Axboe <axboe@kernel.dk>, SCSI development list <linux-scsi@vger.kernel.org>

Doug,

can you test the latest for-linus branch in Jens' tree
(git://git.kernel.dk/linux-block).  It has a fix for the infinite
recursion with the FUA flag, and a lot of timeout handling fixes.


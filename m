From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] kill tmscsim ->proc_info
Date: Tue, 17 Aug 2004 18:48:24 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040817164824.GA17074@lst.de>
References: <20040817161858.GA16589@lst.de> <4122366E.1040204@yk.rim.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:42987 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S268341AbUHQQs0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Aug 2004 12:48:26 -0400
Content-Disposition: inline
In-Reply-To: <4122366E.1040204@yk.rim.or.jp>
List-Id: linux-scsi@vger.kernel.org
To: Chiaki <ishikawa@yk.rim.or.jp>
Cc: Christoph Hellwig <hch@lst.de>, g.liakhovetski@gmx.de, linux-scsi@vger.kernel.org

On Wed, Aug 18, 2004 at 01:46:38AM +0900, Chiaki wrote:
> Christoph Hellwig wrote:
> >hrrible code like all proc_info implementations and no really usefull
> >information.  We might want to add sysfs attributes if some users really
> >miss anything.
> >
> 
> Setting aside the horribleness of the code and suitability
> of the code for 2.6.x kernel,
> I found the information very useful when I did the debugging
> with tmscsim driver code with
> a rather obscure CD changer device and
> other odd SCSI devices.

What particular information?


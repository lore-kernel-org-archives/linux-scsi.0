From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] hptiop: backout ioctl mess
Date: Thu, 03 Aug 2006 13:02:30 +0200
Message-ID: <1154602970.2965.13.camel@laptopd505.fenrus.org>
References: <20060730171336.GA31646@lst.de>
	 <08ce01c6b44c$82b8ef70$1200a8c0@gmm>
	 <1154559337.2861.2.camel@laptopd505.fenrus.org>
	 <44D16D7D.7090705@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e-nvb.com ([69.27.17.200]:25817 "EHLO e-nvb.com")
	by vger.kernel.org with ESMTP id S932464AbWHCLDM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Aug 2006 07:03:12 -0400
In-Reply-To: <44D16D7D.7090705@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: HighPoint Linux Team <linux@highpoint-tech.com>, linux-scsi@vger.kernel.org, jejb@steeleye.com, Christoph Hellwig <hch@lst.de>

On Wed, 2006-08-02 at 23:29 -0400, Douglas Gilbert wrote:
> > It's quite possible that there is a generic way to do the same thing
> > already, or something that can easily be extended to do what you need...
> 
> Is the above generic enough?

obviously not since the semantics still don't make sense on a higher up
level.

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com


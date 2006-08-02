From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] hptiop: backout ioctl mess
Date: Thu, 03 Aug 2006 00:55:37 +0200
Message-ID: <1154559337.2861.2.camel@laptopd505.fenrus.org>
References: <20060730171336.GA31646@lst.de>
	 <08ce01c6b44c$82b8ef70$1200a8c0@gmm>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e-nvb.com ([69.27.17.200]:63132 "EHLO e-nvb.com")
	by vger.kernel.org with ESMTP id S1751286AbWHCCAA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2006 22:00:00 -0400
In-Reply-To: <08ce01c6b44c$82b8ef70$1200a8c0@gmm>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: HighPoint Linux Team <linux@highpoint-tech.com>
Cc: linux-scsi@vger.kernel.org, jejb@steeleye.com, Christoph Hellwig <hch@lst.de>

On Mon, 2006-07-31 at 10:53 +0800, HighPoint Linux Team wrote:
> Christoph Hellwig wrote:
> > The hptiop just got merged with a horrible amount of really bad ioctl
> > code that is against the standards for new scsi drivers.  This patch
> > backs it out (and fixes a small bug where scsi_add_host is called to
> > early).  We can re-add proper APIs once we agree on them.
> 
> What is the standard implemetation of private ioctls for scsi drivers?
> Thanks.

Hi,

the real answer is: try really hard to use generic ioctls for your
functionality. What exactly do you need private ioctls for?
It's quite possible that there is a generic way to do the same thing
already, or something that can easily be extended to do what you need...

Greetings,
   Arjan van de Ven
-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com


From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE]: version 2.00.3 megaraid driver for 2.4.x and 2.5.67 kernels
Date: Thu, 17 Apr 2003 13:57:19 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030417135719.A13189@infradead.org>
References: <20030417133820.A12503@infradead.org> <200304171252.h3HCqG909973@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.mvhi.com ([195.224.96.167]:39954 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261328AbTDQMp1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Apr 2003 08:45:27 -0400
Content-Disposition: inline
In-Reply-To: <200304171252.h3HCqG909973@devserv.devel.redhat.com>; from alan@redhat.com on Thu, Apr 17, 2003 at 08:52:16AM -0400
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mukker Atul <atulm@lsil.com>, "'James.Bottomley@steeleye.com'" <James.Bottomley@steeleye.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'linux-megaraid-devel@dell.com'" <linux-megaraid-devel@dell.com>, "'linux-megaraid-announce@dell.com'" <linux-megaraid-announce@dell.com>

On Thu, Apr 17, 2003 at 08:52:16AM -0400, Alan Cox wrote:
> a) megaraid always used a set of basic typedefs. Seems to be your personal
> view not general comment

At least Linus seems to share my opinion :)

> >     Do you really need this?  Why can you use
> >     struct device_driver->shutdown?
> 
> Not on 2.2

This is a 2.5-only driver (in fact a 2.5 only patch against a 2.4 driver)

> > 	return FALSE;
> > 
> >     Please don't use TRUE/FALSE but 1/0 directly.
> 
> TRUE/FALSE is IMHO perfectly clear

It's clear, but Linux kernel code avoids it usually.  I'm
currently getting rid of it in the scsi headers so it's a good idea
to avoid it in new drivers.


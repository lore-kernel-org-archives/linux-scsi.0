From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: [ANNOUNCE]: megaraid driver version 2.20.0.1, now 2.20.2.0
Date: Tue, 27 Jul 2004 19:10:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57033BC8C9@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:51617 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S266705AbUG0XLJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jul 2004 19:11:09 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Matt Domsch' <Matt_Domsch@dell.com>, "Mukker, Atul" <Atulm@lsil.com>
Cc: 'James Bottomley' <James.Bottomley@SteelEye.com>, 'Christoph Hellwig' <hch@infradead.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

> On Fri, Jul 23, 2004 at 06:02:49PM -0400, Mukker, Atul wrote:
> > All,
> > 
> > Here is the patch for the 2.20.2.0 as per suggestions made by James
> > Bottomley. The details are available in the changelog. As 
> usual, the driver
> > package with kernel patches, complete driver code, and this patch is
> > available for download from
> > 
> ftp://ftp.lsil.com/pub/linux-megaraid/drivers/version-2.20.2.0
/ as well.


Something else to clean up after inclusion: every instance of an
inline function is actually rendered as a full function call, because
the function is always used before it is defined.  Atul, please
re-arrange the code to eliminate the need for most (all) of the
function prototypes at the top of each file, and define (not just
declare with a prototype) each inline function before its first use.

Atul> Will do that sure 

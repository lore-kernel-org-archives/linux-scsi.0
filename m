From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [ANNOUNCE]: megaraid driver version 2.20.0.1
Date: 20 Jul 2004 16:56:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1090360566.1861.33.camel@mulgrave>
References: <0E3FA95632D6D047BA649F95DAB60E57033BC897@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:17586 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263019AbUGTV4P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2004 17:56:15 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57033BC897@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atulm@lsil.com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Tue, 2004-07-20 at 16:21, Mukker, Atul wrote:
> Is there a existing driver using this interface.

All the device drivers that use the transport class DV use it.  At the
moment, that's 53c700 and sym_2.

The philosophy for scsi drivers for a while has been to remove internal
queueing, which is why yours attracted my attention, so the question I
was asking is can you use these APIs instead of having to maintain this
internal queue?

> Also, are these two changes gating factor for the driver to be included in
> the kernel. I do not want to make driver releases too often, unless
> of-course there is a critical fix, since it reset the driver validation in
> our testing labs. I have marked this and the yield() fix for the next drop
> of the driver

Either the changes or a good explanation why they shouldn't be done,
yes.  External release cycles aren't a good reason to press for kernel
acceptance.

James



From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: [SUBJECT CHANGE]: megaraid unified driver version 2.20.0.0-al
	pha1
Date: Wed, 25 Feb 2004 15:41:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57033BC3E8@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:43137 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261444AbUBYUmO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Feb 2004 15:42:14 -0500
List-Id: linux-scsi@vger.kernel.org
To: 'Matt Domsch' <Matt_Domsch@dell.com>, 'Christoph Hellwig' <hch@infradead.org>, "Mukker, Atul" <Atulm@lsil.com>, 'Arjan van de Ven' <arjanv@redhat.com>, 'James Bottomley' <James.Bottomley@SteelEye.com>, 'Paul Wagland' <paul@wagland.net>, Matthew Wilcox <willy@debian.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

> I agree with Christoph here.  megaraid is the only driver that I've
> worked with that does this device reordering thing;
Matt, you imply that driver should not do any device re-ordering? I will be
releasing a patch for the unified-alpha1 driver with this change shortly.

Thanks
-Atul Mukker

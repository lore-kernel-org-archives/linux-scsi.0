From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: [SUBJECT CHANGE]: megaraid unified driver version 2.20.0.0-al
	pha1
Date: Wed, 25 Feb 2004 18:05:43 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57033BC3EA@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: 'Matt Domsch' <Matt_Domsch@dell.com>, 'Christoph Hellwig' <hch@infradead.org>, 'Arjan van de Ven' <arjanv@redhat.com>, 'James Bottomley' <James.Bottomley@SteelEye.com>, 'Paul Wagland' <paul@wagland.net>, Matthew Wilcox <willy@debian.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

All,

Thanks a lot for the valuable feedback. The general consensus is against a
single driver for different class of controllers. This would put a strain on
our applications, which expect all the controllers to be exported from
single driver's private ioctl interface.

With multiple adapters, applications would need to open multiple handles.
This would somewhat complicate things for them. But keeping in line with
general expectations, we would fork the drivers for different class of
controllers now.

I have not yet gotten strong feelings against a single driver for lk 2.4 and
lk 2.6. If this is true, we would like to keep single driver for both
kernels - since lk 2.4 still has a big lifecycle.

For lk 2.6, the controllers would be detected PCI ordered and because of
existing lk 2.4 setups, driver would re-order the registration based on boot
controller.

Best Regards
-Atul Mukker
LSI Logic Corporation

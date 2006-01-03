From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Booting from or using a Compaq RA4100 Array
Date: Tue, 3 Jan 2006 05:34:24 -0700
Message-ID: <20060103123424.GJ19769@parisc-linux.org>
References: <1135801791.9541.12.camel@gateway.markschaefer.org> <1136168563.3768.3.camel@localhost.localdomain> <yq1oe2u2z6i.fsf@wilson.lab.mkp.net> <200601030851.30624@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:16805 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1750893AbWACMeY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Jan 2006 07:34:24 -0500
Content-Disposition: inline
In-Reply-To: <200601030851.30624@bilbo.math.uni-mannheim.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: "Martin K. Petersen" <mkp@mkp.net>, linux-scsi@vger.kernel.org

On Tue, Jan 03, 2006 at 08:51:30AM +0100, Rolf Eike Beer wrote:
> >HPFC-5000 is the original HP Tachyon design which my driver won't
> >support.  It doesn't have FCP support in hardware or anything.  My
> >driver only does TachLite.
> >
> >My aim is to support the following boards:
> >
> >HP A5156A	HPFC-5100 /2.0	(TL)
> >HP A5157A	HPFC-5100B/2.2	(TL) dual port
> >HP A5158A	HPFC-5100C/2.3	(TL)
> >HP A5158A	HPFC-5100D/3.0	(TL)
> >HP A6795A	HPFC-5200C/2.2	(XL2)
> >Compaq FC HBA   HPFC-5166A/1.2  (TS)
> 
> Ok, can you collect such a list of the "other" cards that your driver does not 
> support? And a list of PCI ids that match both lists?

You could make an effort here too.

> These are the devices supported by the original cpqfc driver:
> 
> #define PCI_DEVICE_ID_COMPAQ_TACHYON    0xa0fc
> #define PCI_DEVICE_ID_HP_TACHYON        0x1028
> #define PCI_DEVICE_ID_HP_TACHLITE       0x1029
> 
> I now own a Agilent HHBA-5121. What's that for a thing?

Plugging "Agilent HHBA-5121" into google gets me a PDF with the following text:

    At the heart of the HHBA-5121 is the HPFC-5166 Tachyon TS
    Fibre Channel Interface Controller IC.


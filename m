From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: Why are MegaRAID drivers mutually exclusive?
Date: Wed, 10 Nov 2004 17:21:00 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570562C194@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:39900 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262063AbUKJWVM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Nov 2004 17:21:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Matt Domsch' <Matt_Domsch@dell.com>, "Mukker, Atul" <Atulm@lsil.com>
Cc: "Bagalkote, Sreenivas" <sreenib@lsil.com>, 'Chris Adams' <cmadams@hiwaay.net>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

> How about you remove all the PCI IDs from the 2.00.3 driver 
> that the 2.20 driver handles, so that they're mutually 
> exclusive again?
That's a good suggestion, but still wouldn't take care of the 'apps do not
work with multiple drivers concern'. One conceivable option, and this is
just a suggestion :-), is to actually write a megaraid_{ioport|legacy}
driver as suggested by you earlier and let it stack under 2.20 mgmt module
and remove the legacy driver completely from the kernel. Hmm...

Thanks
-Atul Mukker

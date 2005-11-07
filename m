From: "Bagalkote, Sreenivas" <Sreenivas.Bagalkote@engenio.com>
Subject: RE: [PATCH resend] Allow both megaraid drivers to be built
Date: Mon, 7 Nov 2005 01:41:13 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57060CD30D@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:9202 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S964801AbVKGGlf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Nov 2005 01:41:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: 'James Bottomley' <James.Bottomley@SteelEye.com>, Daniel Drake <dsd@gentoo.org>, "Kolli, Neela Syam" <Neela.Kolli@engenio.com>, linux-scsi@vger.kernel.org, "Ju, Seokmann" <Seokmann.Ju@engenio.com>

>Note that the current situation is even worse for your customers, because
>the Kconfig subsystem only allows to build one driver at a time.  You
>don't notice that because all distributions patch that silly check out
>again.
>
>Can we at least agree on patching that out ASAP and leave two drivers
>handling the same ID (we have cases like that all over already) and then
>try to make some progress on removing ids from the old driver independent
>of that?

You mean, you want to allow both drivers to be built and loaded together,
even though they have overlapping ids?!

From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] aacraid 2.6: Support for new cards
Date: Thu, 16 Dec 2004 12:58:52 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458B87DC53@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:11987 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261963AbULPR6y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Dec 2004 12:58:54 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

They are reserved for future functionality (that is currently in the
Adaptec Branch of the driver).

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org] 
Sent: Thursday, December 16, 2004 12:04 PM
To: Mark Haverkamp
Cc: James Bottomley; linux-scsi; Salyzyn, Mark
Subject: Re: [PATCH] aacraid 2.6: Support for new cards

> +/*
> + * This adapter is a slave (no Firmware)
> + */
> +#define AAC_QUIRK_SLAVE 0x0004

This is set once but never cleared.

> +/*
> + * This adapter is a master.
> + */
> +#define AAC_QUIRK_MASTER 0x0008

And this one is completely unused.

